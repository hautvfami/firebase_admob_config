import 'dart:developer';

import 'package:firebase_admob_config/models/models.dart';
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
          log('InterstitialAd success');
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
          log('onAdDismissedFullScreenContent. $ad');
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
        onAdImpression: (InterstitialAd ad) => log('impression occurred. $ad'),
      );
      interstitialAd.show();
    } else {
      doNext?.call();
    }
  }

  // show or load then call onNext
  void run([VoidCallback? doNext]) {
    log('InterstitialAdHandler.run', stackTrace: StackTrace.current);
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
