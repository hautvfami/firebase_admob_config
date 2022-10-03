import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class BaseConfig {
  @JsonKey(defaultValue: false)
  bool enable;
  @JsonKey(defaultValue: '')
  String adUnitIdAndroid;
  @JsonKey(defaultValue: '')
  String adUnitIdIos;

  @mustCallSuper
  BaseConfig({
    this.enable = false,
    this.adUnitIdAndroid = '',
    this.adUnitIdIos = '',
  });

  String get adUnitId => Platform.isAndroid ? adUnitIdAndroid : adUnitIdIos;
}
