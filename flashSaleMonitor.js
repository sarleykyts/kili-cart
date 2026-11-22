const mongoose = require('mongoose');
const config = require('../config');
const { fetchFlashSales } = require('../services/scraper');
const { sendPushToMany, initFirebase } = require('../services/fcm');
const Product = require('../models/Product');
const PriceHistory = require('../models/PriceHistory');
const User = require('../models/User');

let workerInterval = null;
let isRunning = false;

const init = () => {
  initFirebase();
};

const matchAndNotify = async (flashSales) => {
  try {
    // Build a map of product URL -> flash sale info
    const saleMap = new Map();
    for (const sale of flashSales) {
      saleMap.set(sale.url.toLowerCase(), sale);
    }

    // Find all active (non-archived) wishlist products
    const products = await Product.find({ isArchived: false }).populate('user');
    const priceHistories = [];

    for (const product of products) {
      const sale = saleMap.get(product.url.toLowerCase());
      const wasOnFlash = product.isOnFlashSale;
      const wasPrice = product.currentPrice;

      let isOnFlash = false;
      let discountPercent = 0;
      let flashEndsAt = null;
      let newPrice = product.currentPrice;

      if (sale) {
        isOnFlash = true;
        discountPercent = sale.discountPercent || 0;
        flashEndsAt = sale.endsAt ? new Date(sale.endsAt) : null;
        newPrice = sale.price != null ? sale.price : product.currentPrice;
      }

      // Detect price drop
      let priceDropped = false;
      if (newPrice < wasPrice && wasPrice > 0) {
        const dropPct = ((wasPrice - newPrice) / wasPrice) * 100;
        if (dropPct >= config.priceDropThresholdPercent) {
          priceDropped = true;
        }
      }

      // Update product
      product.isOnFlashSale = isOnFlash;
      product.discountPercent = discountPercent;
      product.flashSaleEndsAt = flashEndsAt;
      product.currentPrice = newPrice;
      product.updatedAt = new Date();
      await product.save();

      // Record price history
      priceHistories.push({
        product: product._id,
        price: newPrice,
        isOnFlashSale: isOnFlash,
        discountPercent,
      });

      // Notify user if newly on flash sale or significant price drop
      const user = product.user;
      if (!user) continue;

      const fcmToken = user.fcmToken;
      if (!fcmToken) continue;

      const notifications = [];
      if (isOnFlash && !wasOnFlash) {
        notifications.push({
          token: fcmToken,
          title: '🔥 Flash Sale Alert!',
          body: `"${product.title}" is now on flash sale for ${product.currency} ${newPrice}`,
          data: { type: 'flash_sale', productId: product._id.toString(), url: product.url },
        });
      }
      if (priceDropped) {
        notifications.push({
          token: fcmToken,
          title: '💰 Price Drop!',
          body: `"${product.title}" dropped to ${product.currency} ${newPrice}`,
          data: { type: 'price_drop', productId: product._id.toString(), url: product.url },
        });
      }

      if (notifications.length > 0) {
        await sendPushToMany(notifications);
      }
    }

    if (priceHistories.length > 0) {
      await PriceHistory.insertMany(priceHistories);
    }

    return { checked: products.length, onSale: flashSales.length };
  } catch (err) {
    console.error('[WORKER] matchAndNotify error:', err);
    throw err;
  }
};

const runCycle = async () => {
  if (isRunning) return;
  isRunning = true;
  try {
    const flashSales = await fetchFlashSales();
    const result = await matchAndNotify(flashSales);
    console.log(`[WORKER] Cycle complete: ${JSON.stringify(result)}`);
  } catch (err) {
    console.error('[WORKER] Cycle error:', err.message);
  } finally {
    isRunning = false;
  }
};

const startFlashSaleWorker = () => {
  init();
  // Run immediately, then on interval
  runCycle();
  workerInterval = setInterval(runCycle, config.workerIntervalMs);
  console.log(`[WORKER] Scheduled every ${config.workerIntervalMs / 1000 / 60} minutes`);
};

const stopFlashSaleWorker = () => {
  if (workerInterval) {
    clearInterval(workerInterval);
    workerInterval = null;
  }
};

module.exports = { startFlashSaleWorker, stopFlashSaleWorker, runCycle };
