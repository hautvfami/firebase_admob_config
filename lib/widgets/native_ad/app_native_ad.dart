import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/firebase_admob_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Map<NativeAdType, double> _defaultAdHeight = {
  NativeAdType.ADS_MEDIUM: 150,
  NativeAdType.ADS_SMALL: 80,
};

class NativeAdController {
  final String adUnitId;
  final NativeAdType type;
  final AdEventCallback? onAdLoaded;
  final Function(Ad ad, LoadAdError error)? onAdFailedToLoad;
  final AdEventCallback? onAdOpened;
  final AdEventCallback? onAdClosed;
  final int? adHeight;

  NativeAdController({
    required this.adUnitId,
    this.type = NativeAdType.ADS_MEDIUM,
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onAdOpened,
    this.onAdClosed,
    this.adHeight,
  }) {
    _load();
  }

  factory NativeAdController.fromKey({required String configKey}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = NativeConfig.fromJson(json);
      return NativeAdController(
        adUnitId: config.adUnitId,
        adHeight: config.height,
        type: config.type,
        onAdOpened: (ad) {
          FirebaseAnalytics.instance.logEvent(
            name: 'ad_clicked',
            parameters: {
              // 'ad': ad.responseInfo?.loadedAdapterResponseInfo?.description
            },
          );
        },
      );
    } catch (e, st) {
      log('', name: 'AppBannerAd.fromKey', error: e, stackTrace: st);
      return NativeAdController(adUnitId: '');
    }
  }

  void _load() {
    _listener = NativeAdListener(
      onAdLoaded: (Ad ad) {
        adsLoad.complete(true);
        onAdLoaded?.call(ad);
        log('Native Ad loaded.', name: 'ADS');
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        adsLoad.complete(false);
        ad.dispose();
        onAdFailedToLoad?.call(ad, error);
        FirebaseAnalytics.instance.logEvent(name: 'ADS_FAILED');
        log('Ad failed to load: $error', name: 'ADS');
      },
      onAdOpened: (Ad ad) {
        onAdOpened?.call(ad);
        log('Ad opened.', name: 'ADS');
      },
      onAdClosed: (Ad ad) {
        onAdClosed?.call(ad);
        log('Ad closed.', name: 'ADS');
      },
      onAdImpression: (Ad ad) => log('Ad impression.', name: 'ADS'),
    );
    _myNative = NativeAd.fromAdManagerRequest(
      adUnitId: adUnitId,
      factoryId: type.name,
      listener: _listener!,
      adManagerRequest: const AdManagerAdRequest(),
    );
    _myNative?.load();
  }

  NativeAd? _myNative;
  NativeAdListener? _listener;
  Completer<bool> adsLoad = Completer();

  Widget get widget => SizedBox(
        height: adHeight?.toDouble() ?? height,
        child: AdWidget(ad: _myNative!),
      );

  Widget get animatedAdWidget {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: FutureBuilder<bool>(
        future: adsLoad.future,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == false) {
            return const SizedBox();
          }
          return SizedBox(
            height: adHeight?.toDouble() ?? height,
            child: AdWidget(ad: _myNative!),
          );
        },
      ),
    );
  }

  double? get height => _defaultAdHeight[type];

  void dispose() {
    _myNative?.dispose();
  }
}

//
// class AppNativeAd extends StatefulWidget {
//   final String adUnitId;
//   final NativeAdType type;
//   final AdEventCallback? onAdLoaded;
//   final Function(Ad ad, LoadAdError error)? onAdFailedToLoad;
//   final AdEventCallback? onAdOpened;
//   final AdEventCallback? onAdClosed;
//
//   const AppNativeAd({
//     Key? key,
//     required this.adUnitId,
//     this.type = NativeAdType.ADS_MEDIUM,
//     this.onAdLoaded,
//     this.onAdFailedToLoad,
//     this.onAdOpened,
//     this.onAdClosed,
//   }) : super(key: key);
//
//   @override
//   State<AppNativeAd> createState() => _AppNativeAdState();
// }
//
// class _AppNativeAdState extends State<AppNativeAd> {
//   NativeAd? myNative;
//   NativeAdListener? listener;
//   bool _isAdsLoaded = false;
//
//   @override
//   void dispose() {
//     myNative?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadNativeAds();
//   }
//
//   void _loadNativeAds() {
//     listener = NativeAdListener(
//       onAdLoaded: (Ad ad) {
//         _isAdsLoaded = true;
//         setState(() {});
//         widget.onAdLoaded?.call(ad);
//         log('Native Ad loaded.', name: 'ADS');
//       },
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         _isAdsLoaded = true;
//         ad.dispose();
//         widget.onAdFailedToLoad?.call(ad, error);
//         log('Ad failed to load: $error', name: 'ADS');
//       },
//       onAdOpened: (Ad ad) {
//         widget.onAdOpened?.call(ad);
//         log('Ad opened.', name: 'ADS');
//       },
//       onAdClosed: (Ad ad) {
//         widget.onAdClosed?.call(ad);
//         log('Ad closed.', name: 'ADS');
//       },
//       onAdImpression: (Ad ad) => log('Ad impression.', name: 'ADS'),
//     );
//     myNative = NativeAd.fromAdManagerRequest(
//       adUnitId: widget.adUnitId,
//       factoryId: widget.type.name,
//       listener: listener!,
//       adManagerRequest: const AdManagerAdRequest(),
//     );
//     myNative?.load();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSize(
//       duration: const Duration(milliseconds: 250),
//       child: _isAdsLoaded
//           ? SizedBox(height: height, child: AdWidget(ad: myNative!))
//           : const SizedBox(),
//     );
//   }
//
//   double? get height => adHeight[widget.type];
// }
