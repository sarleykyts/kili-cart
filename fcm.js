const admin = require('firebase-admin');
const config = require('../config');

let initialized = false;

function initFirebase() {
  if (initialized) return;
  if (config.firebase.privateKey && config.firebase.clientEmail) {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: config.firebase.projectId,
        clientEmail: config.firebase.clientEmail,
        privateKey: config.firebase.privateKey,
      }),
    });
  }
  initialized = true;
}

async function sendPush(fcmToken, title, body, data = {}) {
  initFirebase();
  if (!admin.apps.length) {
    console.log('[FCM] Firebase not configured. Would send:', { title, body, data });
    return { skipped: true };
  }
  try {
    const message = {
      token: fcmToken,
      notification: { title, body },
      data: { ...data, click_action: 'FLUTTER_NOTIFICATION_CLICK' },
      android: { priority: 'high', notification: { channelId: 'flash_sales' } },
      apns: { payload: { aps: { sound: 'default' } } },
    };
    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
  } catch (err) {
    console.error('[FCM] Error sending push:', err.message);
    return { success: false, error: err.message };
  }
}

async function sendPushToMany(tokens, title, body, data = {}) {
  const results = [];
  for (const token of tokens) {
    results.push(await sendPush(token, title, body, data));
  }
  return results;
}

module.exports = { sendPush, sendPushToMany, initFirebase };
