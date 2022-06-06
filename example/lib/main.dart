import 'dart:convert';

import 'package:firebase_admob_config/firebase_admob_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupFirebaseRemoteConfig();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  //
  // Interstitial Ads from Firebase Remote Config
  final interstitialAd = AppInterstitialAd.fromKey(
    configKey: 'interstitial_ad',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Admob with Firebase Remote Config'),
              //
              // Banner Ads from Firebase Remote Config
              AppBannerAd.fromKey(configKey: 'banner_ad'),
              TextButton(
                child: const Text('Show InterstitialAd (2 taps)'),
                onPressed: () => interstitialAd.run(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Just setup Firebase remote config
Future<void> _setupFirebaseRemoteConfig() async {
  await Firebase.initializeApp();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 10),
  ));
  await remoteConfig.setDefaults(_defaultAdmobConfig);
}

/*
Config width, height by following ads size
 The standard banner (320x50) size.
 The large banner (320x100) size.
 The medium rectangle (300x250) size.
 The full banner (468x60) size.
 The leaderboard (728x90) size.
*/
final Map<String, dynamic> _defaultAdmobConfig = {
  'banner_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/6300978111",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/2934735716",
    "position": null,
    "distance": null,
    "width": 300,
    "height": 250
  }),
  'interstitial_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/1033173712",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/4411468910",
    "request_time_to_show": 3,
    "fail_time_to_stop": 3,
    "init_request_time": 0
  })
};
