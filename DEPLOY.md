# KiliCart - Free APK Build Instructions (No Computer Needed)

This guide shows you how to build your real Android APK for free using GitHub Actions. You only need your Android phone and a web browser.

## What you need
- An Android phone with internet
- A web browser (Chrome, Firefox, etc.)
- About 15 minutes

## Step 1: Create a GitHub account (free)
1. Open your phone browser and go to: **github.com**
2. Tap **Sign up** and create a free account
3. Verify your email

## Step 2: Create a new repository
1. After logging in, tap the **+** icon (top right) → **New repository**
2. Repository name: `kilicart`
3. Set it to **Public** (required for free GitHub Actions)
4. Tap **Create repository**

## Step 3: Upload the project files
1. On your repository page, tap **uploading an existing file**
2. Upload **all files** from the `kilicart` folder on your phone:
   - `backend/` folder (all files inside)
   - `kilicart_app/` folder (all files inside)
   - `.github/` folder (all files inside)
   - `.gitignore`
   - `README.md`
3. Tap **Commit changes** at the bottom

## Step 4: Start the build
1. Tap the **Actions** tab at the top of your repository
2. You'll see "Build KiliCart APK" on the left
3. Tap it, then tap **Run workflow** → **Run workflow** (green button)
4. Wait 5–10 minutes for the build to finish

## Step 5: Download your APK
1. When the build shows a green checkmark (✅), tap it
2. Tap **kilicart-apk** under "Artifacts"
3. The file `app-release.apk` will download to your phone
4. Open the file and tap **Install** (you may need to enable "Install from unknown sources" in your phone settings)

## Step 6: Configure your backend (optional)
The app will work in offline mode without a backend. To enable cloud sync and flash-sale notifications:

1. Deploy the backend for free on **Render** (render.com) or **Railway** (railway.app)
2. Get your backend URL (e.g., `https://kilicart.onrender.com`)
3. In your GitHub repository, edit `kilicart_app/lib/core/config/app_config.dart`
4. Change `defaultValue: 'http://10.0.2.2:5000'` to your backend URL
5. Commit the change — the APK will rebuild automatically

## Cost
- GitHub account: **Free**
- GitHub Actions (public repos): **Free** (2,000 minutes/month)
- APK artifact storage: **Free** (7 days)
- Render/Railway backend: **Free tier available**

## Troubleshooting
- **Build fails?** Make sure you uploaded ALL files including the `.github/` folder
- **Can't install APK?** Go to Android Settings → Security → Enable "Install from unknown apps" for your browser
- **App won't open?** Make sure you downloaded the `.apk` file, not the source code

## Support
If you get stuck, copy any error message and ask for help. The project is fully configured — you just need to upload and click "Run workflow."
