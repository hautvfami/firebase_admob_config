import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_config.g.dart';

/**
    example:
    ```dart
    key: "banner_ad"
    value: {
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/6300978111",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/2934735716",
    "position": null,
    "distance": null,
    "width": 300,
    "height": 250
    }
    ```
 **/
@JsonSerializable(fieldRename: FieldRename.snake)
class BannerConfig {
  @JsonKey(defaultValue: false)
  final bool enable;
  @JsonKey(defaultValue: '')
  final String adUnitIdAndroid;
  @JsonKey(defaultValue: '')
  final String adUnitIdIos;
  @JsonKey(defaultValue: 0)
  final int position;
  final int? distance;
  final int? width;
  final int? height;

  BannerConfig({
    this.enable = false,
    this.adUnitIdAndroid = '',
    this.adUnitIdIos = '',
    this.position = 0,
    this.distance,
    this.width,
    this.height,
  });

  AdSize get adSize => width == null || height == null
      ? AdSize.fullBanner
      : AdSize(width: width!, height: height!);

  String? get adUnitId => Platform.isAndroid ? adUnitIdAndroid : adUnitIdIos;

  factory BannerConfig.fromJson(Map<String, dynamic> json) =>
      _$BannerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BannerConfigToJson(this);
}
