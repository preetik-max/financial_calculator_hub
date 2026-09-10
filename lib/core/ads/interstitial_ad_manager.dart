import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_config.dart';

class InterstitialAdManager {
  InterstitialAdManager._();

  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  static void load() {
    if (_interstitialAd != null || _isLoading) {
      return;
    }

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdMobConfig.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _interstitialAd = ad;

          debugPrint('Interstitial ad loaded.');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Interstitial ad shown.');
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('Interstitial ad dismissed.');

              ad.dispose();
              _interstitialAd = null;

              // Load the next ad.
              load();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial failed to show: $error');

              ad.dispose();
              _interstitialAd = null;

              load();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;

          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  static bool get isReady => _interstitialAd != null;

  static void show() {
    final ad = _interstitialAd;

    if (ad == null) {
      debugPrint('Interstitial is not ready.');

      load();
      return;
    }

    _interstitialAd = null;

    ad.show();
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
