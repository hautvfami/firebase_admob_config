// ignore_for_file: slash_for_doc_comments, constant_identifier_names

import 'package:firebase_admob_config/models/base_config.dart';
import 'package:json_annotation/json_annotation.dart';

import 'native_ad_type.dart';

part 'native_config.g.dart';

/**
    example:
    ```dart
    key: "native_ad"
    value: {
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/6300978111",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/2934735716",
    "type": "ADS_MEDIUM",//ADS_SMALL
    "position": null,
    "distance": null,
    "width": 300,
    "height": 250
    }
    ```
 **/

@JsonSerializable(fieldRename: FieldRename.snake)
class NativeConfig extends BaseConfig {
  @JsonKey(defaultValue: 0)
  final int position;
  final int? distance;
  final int? width;
  final int? height;
  final NativeAdType type;

  NativeConfig({
    bool enable = false,
    String adUnitIdAndroid = '',
    String adUnitIdIos = '',
    this.position = 0,
    this.distance,
    this.width,
    this.height,
    this.type = NativeAdType.ADS_MEDIUM,
  }) : super(
          enable: enable,
          adUnitIdAndroid: adUnitIdAndroid,
          adUnitIdIos: adUnitIdIos,
        );

  factory NativeConfig.fromJson(Map<String, dynamic> json) =>
      _$NativeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NativeConfigToJson(this);
}
