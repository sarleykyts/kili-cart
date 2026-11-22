require('dotenv').config();
const app = require('./app');
const config = require('./config');
const mongoose = require('mongoose');
const { startFlashSaleWorker } = require('./workers/flashSaleMonitor');

const startServer = async () => {
  try {
    await mongoose.connect(config.mongodbUri, {
      autoIndex: true,
    });
    console.log('[DB] MongoDB connected');

    // Start background flash-sale monitoring worker
    startFlashSaleWorker();
    console.log('[WORKER] Flash-sale monitor started');

    app.listen(config.port, () => {
      console.log(`[SERVER] KiliCart API running on http://localhost:${config.port}`);
      console.log(`[ENV] ${config.nodeEnv}`);
    });
  } catch (err) {
    console.error('[FATAL] Failed to start server:', err.message);
    process.exit(1);
  }
};

startServer();

process.on('unhandledRejection', (err) => {
  console.error('[UNHANDLED REJECTION]', err);
  process.exit(1);
});
