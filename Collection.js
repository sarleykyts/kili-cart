const mongoose = require('mongoose');

const collectionSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    name: { type: String, required: true, trim: true },
    color: { type: String, default: '#FF6B00' },
    isDefault: { type: Boolean, default: false },
    productCount: { type: Number, default: 0 },
  },
  { timestamps: true }
);

collectionSchema.index({ user: 1, isDefault: 1 });

module.exports = mongoose.model('Collection', collectionSchema);
