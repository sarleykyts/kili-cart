const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { body, validationResult } = require('express-validator');
const config = require('../config');
const User = require('../models/User');

function signToken(user) {
  return jwt.sign({ userId: user._id.toString(), deviceId: user.deviceId }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn,
  });
}

router.post(
  '/register',
  [
    body('email').optional().isEmail().normalizeEmail(),
    body('deviceId').notEmpty().withMessage('deviceId is required'),
    body('name').optional().trim(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const { email, deviceId, name, password } = req.body;

    let user;
    if (email) {
      user = await User.findOne({ email });
      if (user) return res.status(409).json({ error: 'Email already registered' });
      const passwordHash = password ? await bcrypt.hash(password, 10) : '';
      user = await User.create({ email, deviceId, name: name || '', passwordHash, isAnonymous: false });
    } else {
      user = await User.findOne({ deviceId, isAnonymous: true });
      if (!user) {
        user = await User.create({ deviceId, name: name || '', isAnonymous: true });
      }
    }

    const token = signToken(user);
    res.json({ token, user: { id: user._id, email: user.email, name: user.name, isAnonymous: user.isAnonymous, theme: user.theme } });
  }
);

router.post('/login', async (req, res) => {
  const { email, password, deviceId } = req.body;
  const user = await User.findOne({ email }).select('+passwordHash');
  if (!user) return res.status(401).json({ error: 'Invalid credentials' });
  if (password && !(await bcrypt.compare(password, user.passwordHash))) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  if (deviceId) user.deviceId = deviceId;
  await user.save();
  const token = signToken(user);
  res.json({ token, user: { id: user._id, email: user.email, name: user.name, isAnonymous: user.isAnonymous, theme: user.theme } });
});

router.post('/fcm-token', async (req, res) => {
  const { deviceId, fcmToken } = req.body;
  if (!deviceId || !fcmToken) return res.status(400).json({ error: 'deviceId and fcmToken required' });
  await User.findOneAndUpdate({ deviceId }, { fcmToken }, { upsert: true, setDefaultsOnInsert: true });
  res.json({ success: true });
});

router.get('/me', async (req, res) => {
  const { deviceId } = req.query;
  const user = deviceId ? await User.findOne({ deviceId }) : null;
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json({ user: { id: user._id, email: user.email, name: user.name, isAnonymous: user.isAnonymous, theme: user.theme, notificationsEnabled: user.notificationsEnabled, targetPriceAlerts: user.targetPriceAlerts } });
});

router.patch('/settings', async (req, res) => {
  const { deviceId, theme, notificationsEnabled, targetPriceAlerts, name } = req.body;
  const update = {};
  if (theme) update.theme = theme;
  if (notificationsEnabled !== undefined) update.notificationsEnabled = notificationsEnabled;
  if (targetPriceAlerts !== undefined) update.targetPriceAlerts = targetPriceAlerts;
  if (name) update.name = name;
  const user = await User.findOneAndUpdate({ deviceId }, update, { new: true });
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json({ user: { id: user._id, theme: user.theme, notificationsEnabled: user.notificationsEnabled, targetPriceAlerts: user.targetPriceAlerts, name: user.name } });
});

module.exports = router;
