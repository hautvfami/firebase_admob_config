import 'dart:convert';
import 'dart:developer';

import 'package:firebase_admob_config/models/models.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Widget where is show BannerAd
class AppBannerAd extends StatefulWidget {
  final BannerConfig config;
  final AdSize? size;

  const AppBannerAd({
    Key? key,
    required this.config,
    this.size,
  }) : super(key: key);

  factory AppBannerAd.fromJson(Map<String, dynamic>? json, {AdSize? size}) {
    final _config = BannerConfig.fromJson(json ?? {});
    return AppBannerAd(config: _config, size: size);
  }

  /// The BannerAd with config from Firebase Remote Config
  /// [configKey] is key you save config on firebase
  /// [size] is AdSize follow Google AdSize, if not provider [size], the widget
  /// will get [size] from remote config
  factory AppBannerAd.fromKey({required String configKey, AdSize? size}) {
    try {
      final data = FirebaseRemoteConfig.instance.getString(configKey);
      final json = jsonDecode(data);
      final config = BannerConfig.fromJson(json);
      return AppBannerAd(config: config, size: size);
    } catch (e, st) {
      log('', name: 'AppBannerAd.fromKey', error: e, stackTrace: st);
      return AppBannerAd(config: BannerConfig(), size: size);
    }
  }

  @override
  _AppBannerAdState createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? bannerAd;
  bool adLoaded = false;

  AdSize get size => widget.size ?? widget.config.adSize;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.config.enable) {
      dynamic dSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate(),
      );

      dSize ??= size;

      bannerAd = BannerAd(
        adUnitId: widget.config.adUnitId ?? '',
        size: dSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => adLoaded = true),
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
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd),
      );
    }
    return const SizedBox();
  }
}
