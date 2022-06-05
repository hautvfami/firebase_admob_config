// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterstitialConfig _$InterstitialConfigFromJson(Map<String, dynamic> json) {
  return InterstitialConfig(
    enable: json['enable'] as bool? ?? false,
    adUnitIdAndroid: json['ad_unit_id_android'] as String? ?? '',
    adUnitIdIos: json['ad_unit_id_ios'] as String? ?? '',
    requestTimeToShow: json['request_time_to_show'] as int? ?? 10,
    failTimeToStop: json['fail_time_to_stop'] as int? ?? 3,
    initRequestTime: json['init_request_time'] as int? ?? 0,
  );
}

Map<String, dynamic> _$InterstitialConfigToJson(InterstitialConfig instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'ad_unit_id_android': instance.adUnitIdAndroid,
      'ad_unit_id_ios': instance.adUnitIdIos,
      'request_time_to_show': instance.requestTimeToShow,
      'fail_time_to_stop': instance.failTimeToStop,
      'init_request_time': instance.initRequestTime,
    };
