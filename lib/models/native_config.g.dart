// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'native_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NativeConfig _$NativeConfigFromJson(Map<String, dynamic> json) => NativeConfig(
      enable: json['enable'] as bool? ?? false,
      adUnitIdAndroid: json['ad_unit_id_android'] as String? ?? '',
      adUnitIdIos: json['ad_unit_id_ios'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      distance: json['distance'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      type: $enumDecodeNullable(_$NativeAdTypeEnumMap, json['type']) ??
          NativeAdType.ADS_MEDIUM,
    );

Map<String, dynamic> _$NativeConfigToJson(NativeConfig instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'ad_unit_id_android': instance.adUnitIdAndroid,
      'ad_unit_id_ios': instance.adUnitIdIos,
      'position': instance.position,
      'distance': instance.distance,
      'width': instance.width,
      'height': instance.height,
      'type': _$NativeAdTypeEnumMap[instance.type]!,
    };

const _$NativeAdTypeEnumMap = {
  NativeAdType.ADS_MEDIUM: 'ADS_MEDIUM',
  NativeAdType.ADS_SMALL: 'ADS_SMALL',
};
