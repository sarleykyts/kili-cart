# KiliCart Backend

Node.js + Express + MongoDB API with background flash-sale monitoring worker.

## Tech Stack
- Express.js (REST API)
- MongoDB + Mongoose (database)
- JWT authentication (email/password + anonymous device ID)
- Firebase Admin (FCM push notifications)
- BullMQ-style interval worker (flash-sale scraping & matching)
- Axios + Cheerio (Kilimall scraping)
- express-rate-limit, helmet, compression (security/performance)

## Project Structure
```
backend/
  src/
    config/         - env config
    models/         - User, Product, Collection, PriceHistory
    middleware/     - auth (JWT)
    routes/         - auth, products, collections
    services/       - fcm (push), scraper (Kilimall)
    workers/        - flashSaleMonitor (background job)
    server.js       - entry point
    app.js          - Express app
  .env.example
  package.json
```

## Setup

### Prerequisites
- Node.js >= 18
- MongoDB (local or MongoDB Atlas)
- Firebase project (for FCM push notifications)

### Install
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your values
```

### Run
```bash
# Development (API + worker)
npm run dev          # starts API on :5000
npm run worker       # starts flash-sale monitor worker
```

### Environment Variables
| Variable | Description | Default |
|---|---|---|
| PORT | API port | 5000 |
| NODE_ENV | development/production | development |
| MONGODB_URI | MongoDB connection string | mongodb://localhost:27017/kilicart |
| JWT_SECRET | JWT signing secret | change-me |
| FIREBASE_* | Firebase service account credentials | - |
| KILIMALL_BASE_URL | Kilimall site URL | https://www.kilimall.co.ke |
| WORKER_INTERVAL_MS | Flash-sale poll interval | 900000 (15 min) |
| PRICE_DROP_THRESHOLD_PERCENT | Price drop alert threshold | 10 |

## API Endpoints

### Auth
- `POST /api/auth/register` - email/password or anonymous device registration
- `POST /api/auth/login` - login
- `POST /api/auth/anonymous` - anonymous device login
- `POST /api/auth/fcm-token` - save FCM device token
- `GET /api/auth/me` - current user
- `PATCH /api/auth/settings` - update theme, notifications, price alerts

### Products
- `GET /api/products?userId=...` - list wishlist products
- `POST /api/products` - add product
- `PATCH /api/products/:id` - update product (target price, purchased, etc.)
- `DELETE /api/products/:id` - delete product
- `PATCH /api/products/:id/purchase` - mark purchased
- `GET /api/products/export/:userId` - export wishlist (JSON)
- `POST /api/products/import` - import wishlist (JSON)

### Collections
- `GET /api/collections?userId=...` - list collections
- `POST /api/collections` - create collection
- `PATCH /api/collections/:id` - rename/update
- `DELETE /api/collections/:id` - delete
- `POST /api/collections/seed-defaults` - seed 6 default categories

## Deployment

### Render (recommended)
1. Connect GitHub repo to Render
2. Create Web Service: `npm start`
3. Add MongoDB Atlas database
4. Add environment variables from `.env.example`
5. Set `NODE_ENV=production`

### Railway
1. Connect GitHub repo
2. Add MongoDB service
3. Deploy with `npm start`
4. Add environment variables

### Docker
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "start"]
```

## Features
- [x] User auth (email/password + anonymous device)
- [x] Product CRUD (wishlist)
- [x] Collection CRUD (6 default categories seedable)
- [x] Flash-sale monitoring worker
- [x] Price-drop detection & alerts
- [x] FCM push notifications
- [x] Export/Import wishlist
- [x] Rate limiting, helmet, compression
- [x] Health check endpoint