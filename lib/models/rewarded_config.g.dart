// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewarded_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardedConfig _$RewardedConfigFromJson(Map<String, dynamic> json) =>
    RewardedConfig(
      enable: json['enable'] as bool? ?? false,
      adUnitIdIos: json['ad_unit_id_ios'] as String? ?? '',
      adUnitIdAndroid: json['ad_unit_id_android'] as String? ?? '',
      isInterstitial: json['is_interstitial'] as bool? ?? false,
    );

Map<String, dynamic> _$RewardedConfigToJson(RewardedConfig instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'ad_unit_id_android': instance.adUnitIdAndroid,
      'ad_unit_id_ios': instance.adUnitIdIos,
      'is_interstitial': instance.isInterstitial,
    };
