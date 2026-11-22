const axios = require('axios');
const cheerio = require('cheerio');
const config = require('../config');

const http = axios.create({
  baseURL: config.kilimall.baseUrl,
  timeout: 20000,
  headers: {
    'User-Agent':
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    'Accept-Language': 'en-US,en;q=0.9',
  },
});

async function fetchFlashSales() {
  try {
    const { data } = await http.get('/flash-sale');
    const $ = cheerio.load(data);
    const products = [];

    $('.flash-item, .product-item, .sale-item').each((i, el) => {
      const $el = $(el);
      const title = $el.find('.title, .product-name, h3').first().text().trim() || '';
      const url = $el.find('a').first().attr('href') || '';
      const imageUrl = $el.find('img').first().attr('src') || $el.find('img').first().attr('data-src') || '';
      const priceText = $el.find('.price, .current-price').first().text().trim();
      const originalText = $el.find('.original-price, .old-price').first().text().trim();

      const price = parsePrice(priceText);
      const originalPrice = parsePrice(originalText) || price;
      const discountPercent = originalPrice > 0 ? Math.round(((originalPrice - price) / originalPrice) * 100) : 0;

      const kilimallProductId = extractProductId(url);

      if (title && url) {
        products.push({
          title,
          url: url.startsWith('http') ? url : `${config.kilimall.baseUrl}${url}`,
          imageUrl,
          currentPrice: price,
          originalPrice,
          discountPercent,
          isOnFlashSale: true,
          kilimallProductId,
        });
      }
    });

    return products;
  } catch (err) {
    console.error('[Scraper] Error fetching flash sales:', err.message);
    return [];
  }
}

async function fetchProductDetails(url) {
  try {
    const { data } = await http.get(url);
    const $ = cheerio.load(data);
    return {
      title: $('h1.product-title, h1').first().text().trim() || '',
      imageUrl: $('.product-image img, .main-image img').first().attr('src') || '',
      currentPrice: parsePrice($('.price, .current-price').first().text()) || 0,
      originalPrice: parsePrice($('.original-price').first().text()) || 0,
    };
  } catch (err) {
    console.error('[Scraper] Error fetching product details:', err.message);
    return null;
  }
}

function parsePrice(text) {
  if (!text) return 0;
  const match = text.replace(/[^0-9.]/g, '');
  const val = parseFloat(match);
  return isNaN(val) ? 0 : val;
}

function extractProductId(url) {
  const match = url.match(/(\d{6,})/);
  return match ? match[1] : '';
}

module.exports = { fetchFlashSales, fetchProductDetails };
