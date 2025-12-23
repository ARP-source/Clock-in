# Testing Clock-in App on Your Android Phone

## 🚀 Quick Start Guide

### Prerequisites
- Android phone with USB debugging enabled
- USB cable to connect phone to computer
- Flutter installed on your computer (already done ✅)

---

## 📱 Step 1: Enable Developer Options on Your Phone

1. **Open Settings** on your Android phone
2. **Scroll to "About phone"** (or "About device")
3. **Find "Build number"** (might be under "Software information")
4. **Tap "Build number" 7 times** rapidly
5. You'll see a message: "You are now a developer!"

---

## 🔓 Step 2: Enable USB Debugging

1. **Go back to Settings**
2. **Find "Developer options"** (usually near the bottom or in "System")
3. **Toggle "Developer options" ON**
4. **Enable "USB debugging"**
5. **Confirm** when prompted

---

## 🔌 Step 3: Connect Your Phone

1. **Connect your phone to computer** via USB cable
2. **On your phone**, you'll see a popup: "Allow USB debugging?"
3. **Check "Always allow from this computer"**
4. **Tap "Allow"**

---

## ✅ Step 4: Verify Connection

Open terminal/command prompt and run:

```bash
flutter devices
```

You should see output like:
```
Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 11 (API 30)
SM-G991U (mobile) • R5CR1234567 • android-arm64 • Android 13 (API 33)
```

Your phone will be listed with a device ID.

---

## 🏃 Step 5: Run the App

### Option A: Run in Debug Mode (Recommended for Testing)

```bash
cd C:\Clock-inp
flutter run
```

Flutter will automatically detect your phone and install the app.

### Option B: Run on Specific Device

If you have multiple devices:

```bash
flutter devices
# Copy your phone's device ID
flutter run -d <device-id>
```

Example:
```bash
flutter run -d R5CR1234567
```

---

## 📦 Step 6: Build APK for Installation

If you want to install the app without keeping it connected:

### Debug APK (for testing):
```bash
flutter build apk --debug
```

The APK will be at:
```
C:\Clock-inp\build\app\outputs\flutter-apk\app-debug.apk
```

### Release APK (for sharing):
```bash
flutter build apk --release
```

The APK will be at:
```
C:\Clock-inp\build\app\outputs\flutter-apk\app-release.apk
```

---

## 📲 Step 7: Install APK on Phone

### Method 1: Via USB
```bash
flutter install
```

### Method 2: Transfer APK File
1. Copy the APK file to your phone (via USB, email, or cloud)
2. On your phone, open the APK file
3. Tap "Install"
4. If prompted, allow "Install from unknown sources"

---

## 🎯 What to Test

Once the app is running on your phone:

### ✅ Core Features:
- [ ] Menu screen with particle background
- [ ] Navigate to Clocks screen
- [ ] Select a timer mode (Pomodoro, Efficiency, etc.)
- [ ] Create/select a subject
- [ ] Start timer and verify countdown works
- [ ] Pause/resume timer
- [ ] Complete a work session (see green flash + beep + vibrate)
- [ ] Complete a break session (see red flash + beep + vibrate)
- [ ] Check Stats screen with shimmer trophy
- [ ] View Focus Score chart

### 📱 Mobile-Specific:
- [ ] **Banner ads appear** at bottom of Timer screen
- [ ] **Banner ads appear** at bottom of Stats screen
- [ ] Haptic feedback on button taps
- [ ] Smooth page transitions
- [ ] App doesn't crash or freeze
- [ ] Performance is smooth (60fps)

---

## 🐛 Troubleshooting

### Phone Not Detected?

**Check USB Connection:**
```bash
adb devices
```

If empty, try:
1. Unplug and replug USB cable
2. Try a different USB cable
3. Try a different USB port
4. Restart ADB: `adb kill-server` then `adb start-server`

### "USB Debugging Not Authorized"?
- Revoke USB debugging authorizations in Developer options
- Reconnect phone and allow again

### App Won't Install?
- Uninstall any existing version first
- Check phone storage space
- Ensure USB debugging is enabled

### Ads Not Showing?
- **Normal!** Ads need internet connection
- Wait a few seconds for ads to load
- Check if phone has internet (WiFi or mobile data)
- Ads might take 10-30 seconds to appear first time

### App Crashes?
Check logs:
```bash
flutter logs
```

---

## 🔥 Hot Reload While Testing

While the app is running on your phone:

1. **Make code changes** in your editor
2. **Press `r` in terminal** for hot reload
3. **Press `R` in terminal** for hot restart
4. Changes appear instantly on your phone!

This is perfect for:
- Tweaking UI
- Adjusting colors
- Testing different layouts
- Fixing bugs

---

## 📊 Performance Testing

### Check Frame Rate:
```bash
flutter run --profile
```

### Enable Performance Overlay:
While app is running, press `P` in terminal to show performance overlay.

---

## 🎉 Success Checklist

- [ ] Phone connected and detected by Flutter
- [ ] App installed and running on phone
- [ ] All screens navigate smoothly
- [ ] Timer works correctly
- [ ] Ads appear on Timer and Stats screens
- [ ] Haptic feedback works
- [ ] Transition animations are smooth
- [ ] No crashes or freezes

---

## 📝 Notes

### First Time Setup:
- Initial build takes 2-5 minutes
- Subsequent runs are much faster (10-30 seconds)

### Debug vs Release:
- **Debug**: Larger app, includes debugging tools
- **Release**: Smaller, optimized, no debugging

### AdMob Testing:
- Real ads will show (not test ads)
- You'll see actual ad impressions in AdMob console
- Don't click your own ads repeatedly (against AdMob policy)

---

## 🚀 Quick Commands Reference

```bash
# Check connected devices
flutter devices

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Install app
flutter install

# View logs
flutter logs

# Hot reload (while running)
Press 'r' in terminal

# Hot restart (while running)
Press 'R' in terminal

# Quit
Press 'q' in terminal
```

---

## 🎯 Ready to Test!

Your app is fully configured with:
- ✅ Real AdMob ads
- ✅ All modern UI features
- ✅ Particle animations
- ✅ Smooth transitions
- ✅ Haptic feedback
- ✅ Audio/visual alerts

Connect your phone and run `flutter run` to start testing! 🎉

---

**Need Help?** Check Flutter documentation: https://docs.flutter.dev/deployment/android
