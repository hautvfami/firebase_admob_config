// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerConfig _$BannerConfigFromJson(Map<String, dynamic> json) {
  return BannerConfig(
    enable: json['enable'] as bool? ?? false,
    adUnitIdAndroid: json['ad_unit_id_android'] as String? ?? '',
    adUnitIdIos: json['ad_unit_id_ios'] as String? ?? '',
    position: json['position'] as int? ?? 0,
    distance: json['distance'] as int?,
    width: json['width'] as int?,
    height: json['height'] as int?,
  );
}

Map<String, dynamic> _$BannerConfigToJson(BannerConfig instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'ad_unit_id_android': instance.adUnitIdAndroid,
      'ad_unit_id_ios': instance.adUnitIdIos,
      'position': instance.position,
      'distance': instance.distance,
      'width': instance.width,
      'height': instance.height,
    };
