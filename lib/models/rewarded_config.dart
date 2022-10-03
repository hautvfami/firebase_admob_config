import 'package:firebase_admob_config/models/base_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rewarded_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RewardedConfig extends BaseConfig {
  @JsonKey(defaultValue: false)
  final bool isInterstitial;

  RewardedConfig({
    bool enable = false,
    String adUnitIdIos = '',
    String adUnitIdAndroid = '',
    this.isInterstitial = false,
  }) : super(
          enable: enable,
          adUnitIdIos: adUnitIdIos,
          adUnitIdAndroid: adUnitIdAndroid,
        );

  factory RewardedConfig.fromJson(Map<String, dynamic> json) =>
      _$RewardedConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RewardedConfigToJson(this);
}
