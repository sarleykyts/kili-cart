const mongoose = require('mongoose');

const priceHistorySchema = new mongoose.Schema(
  {
    product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true, index: true },
    price: { type: Number, required: true },
    isOnFlashSale: { type: Boolean, default: false },
    discountPercent: { type: Number, default: 0 },
  },
  { timestamps: true }
);

module.exports = mongoose.model('PriceHistory', priceHistorySchema);
