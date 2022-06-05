import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'interstitial_config.g.dart';

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
