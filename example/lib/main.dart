import 'dart:convert';

import 'package:firebase_admob_config/firebase_admob_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupFirebaseRemoteConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
              //
              // InterstitialAd from Firebase Remote Config
              TextButton(
                onPressed: () => AppInterstitialAd.fromKey(
                  keyConfig: 'interstitial_ad',
                ),
                child: const Text('InterstitialAd'),
              ),
              //
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

final Map<String, dynamic> _defaultAdmobConfig = {
  'banner_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/6300978111",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/2934735716",
    "position": null,
    "distance": null,
    "width": null,
    "height": null
  }),
  'interstitial_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/1033173712",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/4411468910",
    "position": null,
    "distance": null,
    "width": null,
    "height": null
  })
};
