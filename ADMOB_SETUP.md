# Google AdMob Setup Guide for Clock-in App

## ⚠️ Important Platform Note

**Google AdMob is only supported on mobile platforms:**
- ✅ Android
- ✅ iOS
- ❌ Windows (not supported)
- ❌ macOS (not supported)
- ❌ Linux (not supported)

The app is currently configured to gracefully handle this - ads will only show on Android/iOS builds.

---

## 📋 Prerequisites

1. **Google AdMob Account**
   - Go to [https://admob.google.com](https://admob.google.com)
   - Sign in with your Google account
   - Complete the account setup

2. **Create AdMob App**
   - In AdMob console, click "Apps" → "Add App"
   - Select platform (Android/iOS)
   - Enter app name: "Clock-in" or "FocusTrophy"
   - Get your **App ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`)

---

## 🤖 Android Setup

### Step 1: Update AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Add the following inside the `<application>` tag:

```xml
<application>
    <!-- ... existing code ... -->
    
    <!-- AdMob App ID -->
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
    
</application>
```

Replace `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY` with your actual AdMob App ID.

### Step 2: Update build.gradle (if needed)

File: `android/app/build.gradle`

Ensure minimum SDK version is 21 or higher:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // AdMob requires minimum 21
        targetSdkVersion 33
    }
}
```

---

## 🍎 iOS Setup

### Step 1: Update Info.plist

File: `ios/Runner/Info.plist`

Add the following before the closing `</dict>` tag:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>

<!-- Optional: For better ad performance -->
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cstr6suwn9.skadnetwork</string>
    </dict>
    <!-- Add more SKAdNetwork IDs as needed -->
</array>
```

Replace `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY` with your actual AdMob App ID.

### Step 2: Update Podfile (if needed)

File: `ios/Podfile`

Ensure platform version is iOS 12.0 or higher:

```ruby
platform :ios, '12.0'
```

Then run:
```bash
cd ios
pod install
cd ..
```

---

## 🎯 Create Ad Units in AdMob Console

### 1. Banner Ad Unit
- In AdMob console, go to your app
- Click "Ad units" → "Add ad unit"
- Select "Banner"
- Name: "Timer Screen Banner" or "Stats Screen Banner"
- Copy the **Ad Unit ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY`)

### 2. Interstitial Ad Unit (Optional)
- Select "Interstitial"
- Name: "Session Complete Interstitial"
- Copy the **Ad Unit ID**

### 3. Rewarded Ad Unit (Optional)
- Select "Rewarded"
- Name: "Remove Penalty Reward"
- Copy the **Ad Unit ID**

---

## 🔧 Update Ad Unit IDs in Code

File: `lib/core/services/ad_helper.dart`

Replace the test IDs with your real Ad Unit IDs:

```dart
static String get bannerAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Your Android Banner ID
  } else if (Platform.isIOS) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ'; // Your iOS Banner ID
  }
  return '';
}

static String get interstitialAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA'; // Your Android Interstitial ID
  } else if (Platform.isIOS) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB'; // Your iOS Interstitial ID
  }
  return '';
}

static String get rewardedAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/CCCCCCCCCC'; // Your Android Rewarded ID
  } else if (Platform.isIOS) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/DDDDDDDDDD'; // Your iOS Rewarded ID
  }
  return '';
}
```

---

## 🧪 Testing Ads

### Using Test Ads (Current Setup)

The app is currently configured with **Google's official test ad IDs**. These are safe to use during development and will show test ads.

**Test Ad Unit IDs (already in code):**
- Android Banner: `ca-app-pub-3940256099942544/6300978111`
- iOS Banner: `ca-app-pub-3940256099942544/2934735716`
- Android Interstitial: `ca-app-pub-3940256099942544/1033173712`
- iOS Interstitial: `ca-app-pub-3940256099942544/4411468910`

### Testing on Real Device

1. **Build for Android:**
   ```bash
   flutter build apk --debug
   # or
   flutter run -d <android-device-id>
   ```

2. **Build for iOS:**
   ```bash
   flutter build ios --debug
   # or
   flutter run -d <ios-device-id>
   ```

3. **Verify Ads Load:**
   - Navigate to Timer Screen → Banner ad should appear at bottom
   - Navigate to Stats Screen → Banner ad should appear at bottom
   - Check console for "AdMob initialized successfully" message

---

## 📍 Where Ads Are Displayed

### Current Implementation:

1. **Timer Screen** (`lib/features/timer/timer_screen.dart`)
   - Banner ad at the bottom of the screen
   - Shows during active timer sessions

2. **Stats Screen** (`lib/features/stats/modern_stats_screen.dart`)
   - Banner ad at the bottom after all statistics
   - Shows when viewing session history

### Ad Widget:
- Component: `BannerAdWidget` (`lib/shared/widgets/banner_ad_widget.dart`)
- Auto-loads on supported platforms
- Shows loading indicator while ad loads
- Gracefully hides on unsupported platforms (Windows/macOS/Linux)

---

## 🚀 Building for Production

### Before Publishing:

1. **Replace Test IDs** with your real Ad Unit IDs in `ad_helper.dart`

2. **Update App IDs** in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

3. **Build Release Version:**

   **Android:**
   ```bash
   flutter build apk --release
   # or for app bundle (recommended for Play Store)
   flutter build appbundle --release
   ```

   **iOS:**
   ```bash
   flutter build ios --release
   ```

4. **Test on Real Devices** before publishing

---

## 💰 Monetization Strategy

### Current Setup:
- **Banner Ads**: Non-intrusive, always visible on Timer and Stats screens
- **Free Tier**: All users see ads

### Future Enhancements:

1. **Interstitial Ads**
   - Show after completing a study session
   - Show after viewing stats for extended time

2. **Rewarded Ads**
   - Watch ad to remove penalties
   - Watch ad to unlock premium features temporarily

3. **Premium Subscription** (Remove Ads)
   - Use `PremiumStatusBloc` to check subscription status
   - Hide ads for premium users
   - Already scaffolded in the code

---

## 🔍 Troubleshooting

### Ads Not Showing

1. **Check Platform:**
   - Ensure you're testing on Android or iOS (not Windows/macOS/Linux)

2. **Check Console Logs:**
   - Look for "AdMob initialized successfully"
   - Look for "Banner ad loaded" or error messages

3. **Verify App ID:**
   - Ensure App ID is correctly set in AndroidManifest.xml / Info.plist
   - Format should be: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`

4. **Check Internet Connection:**
   - Ads require active internet connection

5. **Wait for Ad Inventory:**
   - New AdMob accounts may take time to fill ad requests
   - Test ads should work immediately

### Common Errors

**"Ad failed to load: 3"**
- No ad inventory available
- Use test ad IDs during development

**"Ad failed to load: 0"**
- Network error
- Check internet connection

**"Ad failed to load: 1"**
- Invalid Ad Unit ID
- Verify IDs in ad_helper.dart

---

## 📊 Monitoring Ad Performance

1. **AdMob Console:**
   - Go to [https://admob.google.com](https://admob.google.com)
   - View earnings, impressions, click-through rates
   - Analyze performance by ad unit

2. **Key Metrics:**
   - **Impressions**: Number of times ads were shown
   - **Clicks**: Number of ad clicks
   - **CTR**: Click-through rate
   - **eCPM**: Effective cost per thousand impressions
   - **Revenue**: Total earnings

---

## 📝 Compliance & Privacy

### GDPR/CCPA Compliance

For EU/California users, you need to:

1. **Add Consent Form** (UMP SDK):
   ```yaml
   # Add to pubspec.yaml
   google_mobile_ads: ^3.1.0
   ```

2. **Request Consent:**
   ```dart
   // In main.dart before initializing ads
   final params = ConsentRequestParameters();
   ConsentInformation.instance.requestConsentInfoUpdate(
     params,
     () async {
       // Consent info updated
       if (await ConsentInformation.instance.isConsentFormAvailable()) {
         // Load and show consent form
       }
     },
     (error) {
       // Handle error
     },
   );
   ```

3. **Privacy Policy:**
   - Create a privacy policy
   - Host it online
   - Link it in your app and store listings

---

## ✅ Checklist Before Launch

- [ ] Created AdMob account
- [ ] Created AdMob app for Android/iOS
- [ ] Created Banner ad units
- [ ] Updated AndroidManifest.xml with App ID
- [ ] Updated Info.plist with App ID
- [ ] Replaced test ad IDs with real ad IDs
- [ ] Tested ads on real Android device
- [ ] Tested ads on real iOS device
- [ ] Implemented consent form (if targeting EU/CA)
- [ ] Created and linked privacy policy
- [ ] Verified ads show correctly in production build

---

## 🆘 Support

- **AdMob Help Center**: [https://support.google.com/admob](https://support.google.com/admob)
- **Flutter AdMob Plugin**: [https://pub.dev/packages/google_mobile_ads](https://pub.dev/packages/google_mobile_ads)
- **AdMob Community**: [https://groups.google.com/g/google-admob-ads-sdk](https://groups.google.com/g/google-admob-ads-sdk)

---

**Last Updated**: December 22, 2025
**AdMob SDK Version**: 3.1.0
**Flutter Version**: 3.0+
