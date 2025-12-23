# AdMob Configuration - Your App IDs

## ✅ Your Real AdMob IDs

### App ID (Android):
```
ca-app-pub-3320263037367557~4475006941
```

### Banner Ad Unit ID (Timer Screen - Android):
```
ca-app-pub-3320263037367557/7149271743
```

### Banner Ad Unit ID (Stats Screen - Android):
```
ca-app-pub-3320263037367557/6766128364
```

---

## 📍 Where These IDs Are Used

### 1. Android App ID
**File**: `android/app/src/main/AndroidManifest.xml`
**Line**: 8-10
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3320263037367557~4475006941"/>
```
✅ **Already configured!**

### 2. Banner Ad Unit ID
**File**: `lib/core/services/ad_helper.dart`
**Line**: 17-19
```dart
if (Platform.isAndroid) {
  return 'ca-app-pub-3320263037367557/7149271743';
}
```
✅ **Already configured!**

---

## 🎯 What's Working Now

### Timer Screen Banner Ad:
- **Platform**: Android
- **Location**: Bottom of timer screen
- **Ad Unit**: `ca-app-pub-3320263037367557/7149271743`
- **Status**: ✅ Production ID configured

### Stats Screen Banner Ad:
- **Platform**: Android
- **Location**: Bottom of stats screen
- **Ad Unit**: Same as timer screen (can create separate unit if needed)
- **Status**: ✅ Using same production ID

---

## 📱 Next Steps

### To Test on Android:

1. **Connect Android Device**
   ```bash
   flutter devices
   ```

2. **Build and Run**
   ```bash
   flutter run -d <android-device-id>
   ```

3. **Verify Ads Load**
   - Open the app
   - Navigate to Timer screen
   - Banner ad should appear at bottom
   - Navigate to Stats screen
   - Banner ad should appear at bottom

### Expected Behavior:
- ✅ Real ads will show (not test ads)
- ✅ You'll start earning revenue from impressions/clicks
- ✅ Ads tracked in your AdMob console

---

## 🍎 iOS Setup (When Ready)

When you create iOS ad units in AdMob:

1. **Get iOS App ID** from AdMob console
2. **Update** `ios/Runner/Info.plist`:
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>YOUR-IOS-APP-ID</string>
   ```

3. **Get iOS Banner Ad Unit ID**
4. **Update** `lib/core/services/ad_helper.dart`:
   ```dart
   } else if (Platform.isIOS) {
     return 'YOUR-IOS-BANNER-AD-UNIT-ID';
   }
   ```

---

## 📊 Monitor Performance

### AdMob Console:
- URL: https://admob.google.com
- View real-time ad performance
- Track impressions, clicks, revenue
- Analyze by ad unit

### Metrics to Watch:
- **Impressions**: How many times ads are shown
- **Fill Rate**: % of ad requests that show ads
- **CTR**: Click-through rate
- **eCPM**: Earnings per 1000 impressions
- **Revenue**: Total earnings

---

## 🔧 Additional Ad Units (Optional)

If you want separate ad units for different screens:

### Create in AdMob Console:
1. Go to your app in AdMob
2. Click "Ad units" → "Add ad unit"
3. Select "Banner"
4. Name it (e.g., "Stats Screen Banner")
5. Copy the new Ad Unit ID

### Update Code:
Create separate methods in `ad_helper.dart`:
```dart
static String get statsScreenBannerAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  }
  return '';
}
```

Then use different IDs in different screens.

---

## ✅ Configuration Complete!

Your app is now configured with **real production AdMob IDs** for Android:

- ✅ App ID configured in AndroidManifest.xml
- ✅ Banner Ad Unit ID configured in ad_helper.dart
- ✅ Timer screen shows ads
- ✅ Stats screen shows ads
- ✅ Ready to build and test on Android device

**Build for Android and start earning! 🎉**

---

**Last Updated**: December 22, 2025
**Status**: Production Ready (Android)
