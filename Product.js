const mongoose = require('mongoose');

const productSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    collection: { type: mongoose.Schema.Types.ObjectId, ref: 'Collection', index: true },
    title: { type: String, required: true, trim: true },
    url: { type: String, required: true, trim: true },
    imageUrl: { type: String, default: '' },
    currentPrice: { type: Number, default: 0 },
    originalPrice: { type: Number, default: 0 },
    currency: { type: String, default: 'KES' },
    discountPercent: { type: Number, default: 0 },
    isOnFlashSale: { type: Boolean, default: false },
    flashSaleEndsAt: { type: Date },
    targetPrice: { type: Number, default: 0 },
    isPurchased: { type: Boolean, default: false },
    isArchived: { type: Boolean, default: false },
    lastCheckedAt: { type: Date, default: Date.now },
    kilimallProductId: { type: String, index: true },
  },
  { timestamps: true }
);

productSchema.index({ user: 1, isArchived: 1, isPurchased: 1 });
productSchema.index({ user: 1, collection: 1 });

module.exports = mongoose.model('Product', productSchema);
