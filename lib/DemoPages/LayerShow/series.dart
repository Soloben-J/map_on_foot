import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'dart:io' show Platform;

class SeriesLocationOptions {
  /// milliseconds 单位ms.,默认 1000 * 60 * 3；
  int? milliseconds;
  SeriesLocationOptions({this.milliseconds = 1000 * 60 * 3});
}

Future<void> seriesLocation() async {
  final LocationFlutterPlugin locationPlugin = LocationFlutterPlugin();

  /// 设置地图参数
  BaiduLocationAndroidOption initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
      locationMode: BMFLocationMode.hightAccuracy,
      isNeedAddress: true,
      isNeedAltitude: true,
      isNeedLocationPoiList: true,
      isNeedNewVersionRgc: true,
      isNeedLocationDescribe: true,
      openGps: true,
      // 设置发起定位请求的间隔，int类型，单位ms
      // 如果设置为0，则代表单次定位，即仅定位一次，默认为0
      coordType: BMFLocationCoordType.bd09ll,
    );
    return options;
  }

  BaiduLocationIOSOption initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
      coordType: BMFLocationCoordType.bd09ll,
      desiredAccuracy: BMFDesiredAccuracy.best,
      allowsBackgroundLocationUpdates: true,
      pausesLocationUpdatesAutomatically: false,
    );
    return options;
  }

  try {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    Map iosMap = initIOSOptions().getMap();
    Map androidMap = initAndroidOptions().getMap();
    await locationPlugin.prepareLoc(androidMap, iosMap);
    // 启动定位
    await locationPlugin.startLocation();
  } catch (e) {
    return;
  }
  // 定位回调
  if (Platform.isIOS) {
    locationPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      print('--持续定位中-- ${result.address}');
      // result为定位结果
      // 第二个参数先设置为 LocationFlutterPlugin() 避免外部影响
    });
  } else if (Platform.isAndroid) {
    locationPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      // result为定位结果
      // 第二个参数先设置为 LocationFlutterPlugin() 避免外部影响
    });
  }
}

class SeriesLocation {
  static const getSeriesLocationData = seriesLocation;
}
