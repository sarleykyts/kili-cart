const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const Collection = require('../models/Collection');
const Product = require('../models/Product');

const DEFAULTS = ['Shoes', 'Clothes', 'Luxury', 'Bedroom', 'Kitchen', 'Bathroom'];

router.get('/', async (req, res) => {
  const { userId } = req.query;
  const filter = userId ? { user: userId } : {};
  const collections = await Collection.find(filter).sort({ isDefault: -1, name: 1 });
  res.json({ collections });
});

router.post(
  '/',
  [body('userId').notEmpty(), body('name').notEmpty().trim()],
  async (req, res) => {
    const { userId, name, color } = req.body;
    const collection = await Collection.create({ user: userId, name, color: color || '#FF6B00', isDefault: false });
    res.status(201).json({ collection });
  }
);

router.patch(
  '/:id',
  [param('id').isMongoId(), body('name').optional().trim()],
  async (req, res) => {
    const collection = await Collection.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!collection) return res.status(404).json({ error: 'Collection not found' });
    res.json({ collection });
  }
);

router.delete('/:id', async (req, res) => {
  const collection = await Collection.findByIdAndDelete(req.params.id);
  if (!collection) return res.status(404).json({ error: 'Collection not found' });
  await Product.updateMany({ collection: req.params.id }, { $unset: { collection: 1 } });
  res.json({ success: true });
});

router.post('/seed-defaults', async (req, res) => {
  const { userId } = req.body;
  if (!userId) return res.status(400).json({ error: 'userId required' });
  const existing = await Collection.countDocuments({ user: userId });
  if (existing > 0) return res.json({ message: 'Defaults already seeded' });
  const docs = DEFAULTS.map((name, i) => ({ user: userId, name, color: '#FF6B00', isDefault: true }));
  await Collection.insertMany(docs);
  res.json({ collections: docs });
});

module.exports = router;
