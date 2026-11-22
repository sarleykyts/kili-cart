const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    email: { type: String, unique: true, sparse: true, lowercase: true, trim: true },
    passwordHash: { type: String, select: false },
    name: { type: String, trim: true, default: '' },
    deviceId: { type: String, index: true },
    isAnonymous: { type: Boolean, default: false },
    fcmToken: { type: String, select: false },
    theme: { type: String, enum: ['amoled', 'vintage'], default: 'vintage' },
    notificationsEnabled: { type: Boolean, default: true },
    targetPriceAlerts: { type: Boolean, default: true },
  },
  { timestamps: true }
);

userSchema.index({ email: 1 }, { unique: true, partialFilterExpression: { email: { $exists: true, $ne: null } } });

module.exports = mongoose.model('User', userSchema);
