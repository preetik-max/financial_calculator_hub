class AdMobConfig {
  AdMobConfig._();

  // ============================================================
  // ENVIRONMENT
  // ============================================================
  //
  // true  = Development / Test Ads
  // false = Production / Real Ads
  //
  static const bool useTestAds = true;

  // ============================================================
  // ADMOB APPLICATION ID
  // ============================================================

  static const String appId = 'ca-app-pub-5326594432709782~3388272121';

  // ============================================================
  // PRODUCTION AD UNIT IDs
  // ============================================================

  static const String bannerAdUnitId = 'ca-app-pub-5326594432709782/9505339941';

  static const String interstitialAdUnitId =
      'ca-app-pub-5326594432709782/5566094938';

  static const String rewardedAdUnitId =
      'ca-app-pub-5326594432709782/6457288599';

  // ============================================================
  // GOOGLE TEST AD UNIT IDs
  // ============================================================

  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // ============================================================
  // ACTIVE AD UNIT IDs
  // ============================================================

  static String get bannerId =>
      useTestAds ? testBannerAdUnitId : bannerAdUnitId;

  static String get interstitialId =>
      useTestAds ? testInterstitialAdUnitId : interstitialAdUnitId;

  static String get rewardedId =>
      useTestAds ? testRewardedAdUnitId : rewardedAdUnitId;

  // ============================================================
  // ENVIRONMENT STATUS
  // ============================================================

  static String get environment => useTestAds ? 'DEVELOPMENT' : 'PRODUCTION';
}
