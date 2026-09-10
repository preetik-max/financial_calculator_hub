import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app.dart';
import 'core/ads/interstitial_ad_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();

  // Pre-load the first interstitial.
  InterstitialAdManager.load();

  runApp(const FinancialCalculatorHubApp());
}
