import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_config.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prevent loading the banner more than once.
    if (_bannerAd != null) {
      return;
    }

    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    final int width = MediaQuery.sizeOf(context).width.truncate();

    // Large anchored adaptive banner.
    final AdSize? size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (size == null) {
      debugPrint('Unable to determine banner ad size.');
      return;
    }

    final BannerAd banner = BannerAd(
      adUnitId: AdMobConfig.bannerId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });

          debugPrint('Banner ad loaded successfully.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner ad failed to load: $error');

          ad.dispose();

          if (!mounted) {
            return;
          }

          setState(() {
            _bannerAd = null;
            _isLoaded = false;
          });
        },
        onAdOpened: (Ad ad) {
          debugPrint('Banner ad opened.');
        },
        onAdClosed: (Ad ad) {
          debugPrint('Banner ad closed.');
        },
        onAdImpression: (Ad ad) {
          debugPrint('Banner ad impression recorded.');
        },
        onAdClicked: (Ad ad) {
          debugPrint('Banner ad clicked.');
        },
      ),
    );

    _bannerAd = banner;

    await banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final BannerAd banner = _bannerAd!;

    return SafeArea(
      top: false,
      child: SizedBox(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }
}
