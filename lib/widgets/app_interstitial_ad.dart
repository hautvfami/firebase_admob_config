import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/models.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Handler for InterstitialAd
///
class AppInterstitialAd {
  InterstitialAd? _interstitialAd;
  InterstitialConfig config;

  int _failTimes = 0;
  int _requestedTimes = 0;
  bool _isLoading = false;

  AppInterstitialAd.setup({required this.config, VoidCallback? doNext}) {
    _requestedTimes = config.initRequestTime;
    run(doNext);
  }

  /// Setup InterstitialAd handle by key from firebase remote config
  /// [configKey] is key of config you save in firebase remote config
  factory AppInterstitialAd.fromKey({required String configKey}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = InterstitialConfig.fromJson(json);
      return AppInterstitialAd.setup(config: config);
    } catch (e, st) {
      log('', name: 'AppInterstitialAd.fromKey', error: e, stackTrace: st);
      return AppInterstitialAd.setup(config: InterstitialConfig());
    }
  }

  void _loadAd() {
    if (!config.enable || _failTimes == config.failTimeToStop || _isLoading) {
      return;
    }
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: config.adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _failTimes = 0;
          _isLoading = false;
          _interstitialAd = ad;
          log('InterstitialAd loaded', name: 'AdMob');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _failTimes++;
          _isLoading = false;
          _interstitialAd = null;
          log('', error: error, stackTrace: StackTrace.current);
        },
      ),
    );
  }

  /// Show full screen loaded ads
  void show({VoidCallback? doNext}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          _requestedTimes = 0;
          doNext?.call();
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('InterstitialAd.dismissed $ad', name: 'AdMob');
          ad.dispose();
          _interstitialAd = null;
          _loadAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('InterstitialAd.failedShow $ad', error: error, name: 'AdMob');
          doNext?.call();
          ad.dispose();
          _interstitialAd = null;
        },
        onAdImpression: (ad) => log(
          'InterstitialAd.impression $ad',
          name: 'AdMob',
        ),
      );
      _interstitialAd!.show();
    } else {
      doNext?.call();
    }
  }

  /// Load or show FullScreen ads then call onNext
  void run([VoidCallback? doNext]) {
    log('InterstitialAd.run', name: 'AdMob');
    _requestedTimes++;
    if (_interstitialAd == null) {
      _loadAd();
      doNext?.call();
    } else if (_requestedTimes >= config.requestTimeToShow) {
      show(doNext: doNext);
    } else {
      doNext?.call();
    }
  }
}
