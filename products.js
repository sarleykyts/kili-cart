const express = require('express');
const router = express.Router();
const { body, param, query } = require('express-validator');
const Product = require('../models/Product');
const Collection = require('../models/Collection');

router.get('/', async (req, res) => {
  const { userId, collectionId, archived = 'false', purchased = 'false' } = req.query;
  const filter = {};
  if (userId) filter.user = userId;
  if (collectionId) filter.collection = collectionId;
  filter.isArchived = archived === 'true';
  filter.isPurchased = purchased === 'true';
  const products = await Product.find(filter).sort({ updatedAt: -1 });
  res.json({ products });
});

router.post(
  '/',
  [body('userId').notEmpty(), body('title').notEmpty(), body('url').notEmpty()],
  async (req, res) => {
    const { userId, collectionId, title, url, imageUrl, targetPrice } = req.body;
    const product = await Product.create({
      user: userId,
      collection: collectionId || null,
      title,
      url,
      imageUrl: imageUrl || '',
      targetPrice: targetPrice || 0,
    });
    res.status(201).json({ product });
  }
);

router.get('/:id', async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) return res.status(404).json({ error: 'Product not found' });
  res.json({ product });
});

router.patch(
  '/:id',
  [param('id').isMongoId()],
  async (req, res) => {
    const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!product) return res.status(404).json({ error: 'Product not found' });
    res.json({ product });
  }
);

router.delete('/:id', async (req, res) => {
  const product = await Product.findByIdAndDelete(req.params.id);
  if (!product) return res.status(404).json({ error: 'Product not found' });
  res.json({ success: true });
});

router.patch('/:id/purchase', async (req, res) => {
  const product = await Product.findByIdAndUpdate(req.params.id, { isPurchased: true }, { new: true });
  if (!product) return res.status(404).json({ error: 'Product not found' });
  res.json({ product });
});

router.get('/export/:userId', async (req, res) => {
  const products = await Product.find({ user: req.params.userId, isArchived: false });
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Content-Disposition', 'attachment; filename=kilicart-wishlist.json');
  res.json({ exportedAt: new Date(), products });
});

module.exports = router;
