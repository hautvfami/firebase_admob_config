import 'package:firebase_admob_config/models/base_config.dart';
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
class BannerConfig extends BaseConfig {
  @JsonKey(defaultValue: 0)
  final int position;
  final int? distance;
  final int? width;
  final int? height;

  BannerConfig({
    bool enable = false,
    String adUnitIdAndroid = '',
    String adUnitIdIos = '',
    this.position = 0,
    this.distance,
    this.width,
    this.height,
  }) : super(
          enable: enable,
          adUnitIdAndroid: adUnitIdAndroid,
          adUnitIdIos: adUnitIdIos,
        );

  AdSize get adSize => width == null || height == null
      ? AdSize.fullBanner
      : AdSize(width: width!, height: height!);

  factory BannerConfig.fromJson(Map<String, dynamic> json) =>
      _$BannerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BannerConfigToJson(this);
}
