import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';

///  多地图示例
class ShowMultiMapPage extends StatefulWidget {
  ShowMultiMapPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowMultiMapPageState createState() => _ShowMultiMapPageState();
}

class _ShowMultiMapPageState extends State<ShowMultiMapPage> {
  /// 地图1controller
  late BMFMapController _mapControllerOne;

  /// 地图2controller
  late BMFMapController _mapControllerTwo;

  bool _visible = false;

  /// 创建完成回调
  void _onBMFMapCreatedOne(BMFMapController controller) {
    _mapControllerOne = controller;

    /// 地图加载回调
    _mapControllerOne.setMapDidLoadCallback(callback: () {
      print('1MapDidLoad-地图加载回调');
      setState(() {
        _visible = true;
      });
    });
    _mapControllerOne.setMapDidFinishedRenderCallback(
        callback: (bool success) {
      print('1MapDidFinishedRenderd-地图绘制完成');
    });
    _mapControllerOne.setMapOnClickedMapBlankCallback(
        callback: (BMFCoordinate coordinate) {
      print('1${coordinate.toMap()}');
    });
  }

  void _onBMFMapCreatedTwo(BMFMapController controller) {
    _mapControllerTwo = controller;

    /// 地图加载回调
    _mapControllerTwo.setMapDidLoadCallback(callback: () {
      print('2MapDidLoad-地图加载回调');
      _mapControllerTwo.setCustomMapStyle('files/custom_map_config.sty', 0);
      _mapControllerTwo.setCustomMapStyleEnable(true);
    });
    _mapControllerTwo.setMapOnClickedMapBlankCallback(
        callback: (BMFCoordinate coordinate) {
      print('2${coordinate.toMap()}');
    });
    _mapControllerTwo.setMapDidFinishedRenderCallback(
        callback: (bool success) {
      print('2MapDidFinishedRenderd-地图绘制完成');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: '多地图示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Center(
            child: new Column(
          children: <Widget>[
            new Expanded(child: createMapOne()),
            new Expanded(
              child: Visibility(visible: _visible, child: createMapTwo()),
            ),
          ],
        )),
      ),
    );
  }

  Widget createMapOne() {
    if (Platform.isAndroid) {
      return BMFTextureMapWidget(
          onBMFMapCreated: (controller) {
            _onBMFMapCreatedOne(controller);
          },
          mapOptions: initMapOptions0());
    } else {
      return BMFMapWidget(
          onBMFMapCreated: (controller) {
            _onBMFMapCreatedOne(controller);
          },
          mapOptions: initMapOptions0());
    }
  }

  Widget createMapTwo() {
    if (Platform.isAndroid) {
      return BMFTextureMapWidget(
          onBMFMapCreated: (controller) {
            _onBMFMapCreatedTwo(controller);
          },
          mapOptions: initMapOptions1());
    } else {
      return BMFMapWidget(
          onBMFMapCreated: (controller) {
            _onBMFMapCreatedTwo(controller);
          },
          mapOptions: initMapOptions1());
    }
  }
}

/// 设置地图0参数
BMFMapOptions initMapOptions0() {
  BMFCoordinate center = BMFCoordinate(39.965, 116.404);
  BMFMapOptions mapOptions = BMFMapOptions(
      mapType: BMFMapType.Standard,
      zoomLevel: 15,
      maxZoomLevel: 21,
      minZoomLevel: 4,
      mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
      logoPosition: BMFLogoPosition.LeftBottom,
      center: center);
  return mapOptions;
}

/// 设置地图1参数
BMFMapOptions initMapOptions1() {
  BMFCoordinate center = BMFCoordinate(39.965, 116.404);
  BMFMapOptions mapOptions = BMFMapOptions(
      mapType: BMFMapType.Standard,
      zoomLevel: 15,
      maxZoomLevel: 21,
      minZoomLevel: 4,
      mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
      logoPosition: BMFLogoPosition.LeftBottom,
      center: center);
  return mapOptions;
}
