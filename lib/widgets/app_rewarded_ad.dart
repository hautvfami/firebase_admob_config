import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/rewarded_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppRewardedAd {
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  RewardedConfig config;

  bool _isLoading = false;

  AppRewardedAd.setup({required this.config}) {
    _loadAds();
  }

  factory AppRewardedAd.fromKey({required String configKey}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = RewardedConfig.fromJson(json);
      return AppRewardedAd.setup(config: config);
    } catch (e, st) {
      log('', name: 'AppRewardAd.fromKey', error: e, stackTrace: st);
      return AppRewardedAd.setup(config: RewardedConfig());
    }
  }

  void _loadAds() {
    if (!config.enable || _isLoading) return;
    _isLoading = true;

    if (config.isInterstitial) {
      RewardedInterstitialAd.load(
        adUnitId: config.adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ads) {
            _rewardedInterstitialAd = ads;
            _isLoading = false;
            log('AppRewardInterstitialAd loaded', name: 'AdMob');
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            _rewardedInterstitialAd = null;
            log('AppRewardInterstitialAd load fail', name: 'AdMob');
          },
        ),
      );
    } else {
      RewardedAd.load(
        adUnitId: config.adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ads) {
            _rewardedAd = ads;
            _isLoading = false;
            log('AppRewardAd loaded', name: 'AdMob');
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            _rewardedAd = null;
            log('AppRewardAd load fail', name: 'AdMob');
          },
        ),
      );
    }
  }

  void show({required OnUserEarnedRewardCallback onUserEarnedReward}) {
    if (config.isInterstitial) {
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
    } else {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {},
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _rewardedAd = null;
            _loadAds();
          },
          onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
            _rewardedAd = null;
            _loadAds();
          },
        );

        _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
        _rewardedAd = null;
      }
    }
  }
}
