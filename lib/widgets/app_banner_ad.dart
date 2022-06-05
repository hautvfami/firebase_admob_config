import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/models.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppBannerAd extends StatefulWidget {
  final BannerConfig config;

  const AppBannerAd({Key? key, required this.config}) : super(key: key);

  factory AppBannerAd.fromJson(Map<String, dynamic>? json) {
    final _config = BannerConfig.fromJson(json ?? {});
    return AppBannerAd(config: _config);
  }

  factory AppBannerAd.fromKey({required String configKey}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = BannerConfig.fromJson(json);
      return AppBannerAd(config: config);
    } catch (e, st) {
      log('', name: 'AppBannerAd.fromKey', error: e, stackTrace: st);
      return AppBannerAd(config: BannerConfig());
    }
  }

  @override
  _AppBannerAdState createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? bannerAd;
  bool adLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.config.enable) {
      bannerAd = BannerAd(
        adUnitId: widget.config.adUnitId ?? '',
        size: widget.config.adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() {
            adLoaded = true;
          }),
          onAdFailedToLoad: (_, error) => _.dispose(),
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = this.bannerAd;
    if (adLoaded && bannerAd != null) {
      return SizedBox(
        height: widget.config.adSize.height.toDouble(),
        child: AdWidget(ad: bannerAd),
      );
    }
    return const SizedBox();
  }
}
