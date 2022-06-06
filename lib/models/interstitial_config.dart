import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'interstitial_config.g.dart';

/**
    example:
    ```dart
    key: "interstitial_ad"
    value: {
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/1033173712",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/4411468910",
    "request_time_to_show": 3,
    "fail_time_to_stop": 3,
    "init_request_time": 0
    }
    ```
 **/
@JsonSerializable(fieldRename: FieldRename.snake)
class InterstitialConfig {
  @JsonKey(defaultValue: false)
  final bool enable;
  @JsonKey(defaultValue: '')
  final String adUnitIdAndroid;
  @JsonKey(defaultValue: '')
  final String adUnitIdIos;
  @JsonKey(defaultValue: 10)
  final int requestTimeToShow;
  @JsonKey(defaultValue: 3)
  final int failTimeToStop;
  @JsonKey(defaultValue: 0)
  final int initRequestTime;

  InterstitialConfig({
    this.enable = false,
    this.adUnitIdAndroid = '',
    this.adUnitIdIos = '',
    this.requestTimeToShow = 10,
    this.failTimeToStop = 3,
    this.initRequestTime = 0,
  });

  String get adUnitId => Platform.isAndroid ? adUnitIdAndroid : adUnitIdIos;

  factory InterstitialConfig.fromJson(Map<String, dynamic> json) =>
      _$InterstitialConfigFromJson(json);

  Map<String, dynamic> toJson() => _$InterstitialConfigToJson(this);
}
