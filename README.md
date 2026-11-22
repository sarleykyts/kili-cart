# KiliCart

Smart wishlist & flash-sale tracker for Kilimall — full-stack mobile application.

## Architecture
- **Frontend**: Flutter (iOS & Android) — `kilicart_app/`
- **Backend**: Node.js + Express + MongoDB — `backend/`
- **Database**: MongoDB (local or MongoDB Atlas)
- **Jobs**: BullMQ (Redis) for flash-sale monitoring
- **Push**: Firebase Cloud Messaging (FCM)

## Build the APK (100% free, no computer needed)
See **DEPLOY.md** for step-by-step instructions to build your APK using GitHub Actions on your phone.

## Folder Structure
```
kilicart/
├── backend/              # Node.js API + workers
├── kilicart_app/         # Flutter mobile app
├── .github/workflows/    # GitHub Actions CI (builds APK)
├── .gitignore
├── DEPLOY.md             # Build instructions
└── README.md
```

## Backend Setup
See `backend/README.md` for API setup and environment variables.

## License
MIT