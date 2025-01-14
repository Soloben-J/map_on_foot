import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:map_on_foot/CustomWidgets/function_item.widget.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_3dbuildings_page.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_heatmap_page.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_maptraffic_page.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_tilemap_page.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_userlocation_mode_page.dart';
import 'package:map_on_foot/DemoPages/LayerShow/show_userlocation_page.dart';

import '../../general/utils.dart';

/// 图层展示入口
class ShowLayerMapPage extends StatelessWidget {
  const ShowLayerMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BMFAppBar(
          title: '图层展示',
          isBack: false,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          FunctionItem(
            label: '自定义热力图示例',
            sublabel: '自定义热力图展示',
            target: ShowHeatMapPage(),
          ),
          generatePlatformizationItem(
              Platform.isIOS, '路况图示例', '路况图展示', ShowMapTrafficPage()),
          FunctionItem(
            label: '瓦片图示例',
            sublabel: '瓦片图展示',
            target: ShowTileMapPage(),
          ),
          FunctionItem(
            label: '3D建筑物地图示例',
            sublabel: '3D楼宇展示',
            target: Show3DBuildingsMapPage(),
          ),
          FunctionItem(
            label: '自定义定位图层示例',
            sublabel: '展示定位图层自定义样式的使用',
            target: ShowUserLoationPage(),
          ),
          FunctionItem(
            label: '定位模式示例',
            sublabel: '展示定位图层三种定位模式的使用',
            target: ShowUserLoationModePage(),
          ),
          FunctionItem(
            label: '路况图示例',
            sublabel: '路况图展示',
            target: ShowMapTrafficPage(),
          ),
        ])));
  }
}
