import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/rewarded_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppRewardedInterstitialAd {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  RewardedConfig config;

  bool _isLoading = false;

  AppRewardedInterstitialAd.setup({required this.config}) {
    _loadAds();
  }

  factory AppRewardedInterstitialAd.fromKey({required String configKey}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = RewardedConfig.fromJson(json);
      return AppRewardedInterstitialAd.setup(config: config);
    } catch (e, st) {
      log('', name: 'RewardedInterstitialAd.fromKey', error: e, stackTrace: st);
      return AppRewardedInterstitialAd.setup(config: RewardedConfig());
    }
  }

  void _loadAds() {
    if (!config.enable || _isLoading) return;
    _isLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: config.adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ads) {
          _rewardedInterstitialAd = ads;
          _isLoading = false;
          log('AppRewardAd loaded', name: 'AdMob');
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _rewardedInterstitialAd = null;
          log('AppRewardAd load fail', name: 'AdMob');
        },
      ),
    );
  }

  void show({required OnUserEarnedRewardCallback onUserEarnedReward}) {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedInterstitialAd = null;
          _loadAds();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _rewardedInterstitialAd = null;
          _loadAds();
        },
      );

      _rewardedInterstitialAd!.show(onUserEarnedReward: onUserEarnedReward);
      _rewardedInterstitialAd = null;
    }
  }
}
