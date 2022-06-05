import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/models.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppInterstitialAd {
  InterstitialAd? _interstitialAd;
  InterstitialConfig config;

  int _failTimes = 0;
  int _requestedTimes = 0;
  bool _isLoading = false;

  AppInterstitialAd.setup({required this.config}) {
    _requestedTimes = config.initRequestTime;
    run();
  }

  factory AppInterstitialAd.fromKey({required String keyConfig}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(keyConfig);
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
          log('InterstitialAd success', name: 'AdMob');
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

  void _show({VoidCallback? doNext}) {
    final interstitialAd = _interstitialAd;
    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          _requestedTimes = 0;
          doNext?.call();
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('onAdDismissedFullScreenContent. $ad', name: 'AdMob');
          ad.dispose();
          _interstitialAd = null;
          _loadAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('onAdFailedToShowFullScreenContent: $ad', error: error);
          doNext?.call();
          ad.dispose();
          _interstitialAd = null;
        },
        onAdImpression: (InterstitialAd ad) => log(
          'impression occurred. $ad',
          name: 'AdMob',
        ),
      );
      interstitialAd.show();
    } else {
      doNext?.call();
    }
  }

  // show or load then call onNext
  void run([VoidCallback? doNext]) {
    log('InterstitialAdHandler.run', name: 'AdMob');
    _requestedTimes++;
    if (_interstitialAd == null) {
      _loadAd();
      doNext?.call();
    } else if (_requestedTimes >= config.requestTimeToShow) {
      _show(doNext: doNext);
    } else {
      doNext?.call();
    }
  }
}
