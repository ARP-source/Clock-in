import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // Singleton pattern
  static final AdHelper _instance = AdHelper._internal();
  factory AdHelper() => _instance;
  AdHelper._internal();

  // Platform check
  static bool get isAdSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  // Production Ad Unit IDs
  
  // Timer Screen Banner
  static String get timerScreenBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3320263037367557/7149271743';
    } else if (Platform.isIOS) {
      // iOS Test Banner ID (Replace when you create iOS ad unit)
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }
  
  // Stats Screen Banner
  static String get statsScreenBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3320263037367557/6766128364';
    } else if (Platform.isIOS) {
      // iOS Test Banner ID (Replace when you create iOS ad unit)
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }
  
  // Generic Banner (for backward compatibility)
  static String get bannerAdUnitId => timerScreenBannerAdUnitId;

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // Android Test Interstitial ID
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // iOS Test Interstitial ID
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // Android Test Rewarded ID
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      // iOS Test Rewarded ID
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    return '';
  }

  // Initialize AdMob
  static Future<void> initialize() async {
    if (!isAdSupported) {
      print('AdMob not supported on this platform');
      return;
    }
    
    await MobileAds.instance.initialize();
    print('AdMob initialized successfully');
  }

  // Create Banner Ad
  static BannerAd createBannerAd({
    String? adUnitId,
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: adUnitId ?? bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) => print('Banner ad opened'),
        onAdClosed: (ad) => print('Banner ad closed'),
      ),
    );
  }

  // Create Interstitial Ad
  static Future<InterstitialAd?> createInterstitialAd() async {
    if (!isAdSupported) return null;

    InterstitialAd? interstitialAd;
    
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          print('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );

    return interstitialAd;
  }

  // Create Rewarded Ad
  static Future<RewardedAd?> createRewardedAd() async {
    if (!isAdSupported) return null;

    RewardedAd? rewardedAd;
    
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          print('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );

    return rewardedAd;
  }
}
