require('dotenv').config();

module.exports = {
  port: parseInt(process.env.PORT, 10) || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  apiBaseUrl: process.env.API_BASE_URL || 'http://localhost:5000',
  corsOrigin: process.env.CORS_ORIGIN || '*',
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/kilicart',
  jwtSecret: process.env.JWT_SECRET || 'dev-secret-change-me',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '30d',
  bcryptSaltRounds: parseInt(process.env.BCRYPT_SALT_ROUNDS, 10) || 12,
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY ? process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n') : undefined,
  },
  kilimall: {
    baseUrl: process.env.KILIMALL_BASE_URL || 'https://www.kilimall.co.ke',
    flashSalePath: process.env.KILIMALL_FLASH_SALE_PATH || '/flash-sale',
  },
  workerIntervalMs: parseInt(process.env.WORKER_INTERVAL_MS, 10) || 15 * 60 * 1000, // 15 min
  priceDropThresholdPercent: parseInt(process.env.PRICE_DROP_THRESHOLD_PERCENT, 10) || 10,
};
