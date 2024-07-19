import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/CustomWidgets/map_base_page_state.dart';
import 'package:map_on_foot/constants.dart';
import 'dart:ui' as ui;

/// marker绘制示例
class DrawClusterMarkerPage extends StatefulWidget {
  DrawClusterMarkerPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawClusterMarkerPageState createState() => _DrawClusterMarkerPageState();
}

class _DrawClusterMarkerPageState
    extends BMFBaseMapState<DrawClusterMarkerPage> {
  late List<BMFClusterInfo?> clusters;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) async {
    super.onBMFMapCreated(controller);

    /// 随机获取100个经纬度点
    List<BMFClusterInfo> clusterInfoList = [];
    BMFCoordinate coordinate = BMFCoordinate(39.915, 116.404);
    for (int i = 0; i < 100; i++) {
      Random random = Random();
      double lat = coordinate.latitude + (random.nextInt(100) * 0.001);
      double lon = coordinate.longitude + (random.nextInt(100) * 0.001);

      String imagePath = 'resoures/icon_mark.png';
      Uint8List imageBytes = await imageToUint8List(imagePath);

      BMFCoordinate coord = BMFCoordinate(lat, lon);
      clusterInfoList.add(
          new BMFClusterInfo.iconData(coordinate: coord, iconData: imageBytes));
    }

    /// 设置聚合点最大距离
    bool res1 = await myMapController
        .setClusterMaxDistanceInDP(Platform.isIOS ? 200 : 100);
    print('最大距离设置结果：$res1');

    /// 设置聚合点的经纬度
    bool res = await myMapController.setClusterCoordinates(clusterInfoList);
    print('点聚合设置结果：$res');

    /// 如果需要首次展示地图时就展示聚合点，就需要调用onRefreshClusters
    if (Platform.isIOS) {
      /// 获取地图状态
      BMFMapStatus? status = await myMapController.getMapStatus();

      /// 根据当前的level刷新聚合点
      onRefreshClusters(status!);
    }

    /// 点聚合的点击事件
    /// andriod 独有 iOS暂不支持
    myMapController.setMapClusterClickCallback(
        callback: (List<BMFClusterInfo> clusterList, int size) {
      for (BMFClusterInfo item in clusterList) {
        print('setMapClusterClickCallback--\n item = ${item.toMap()}');
      }
      print('setMapClusterClickCallback--\n size = $size');
    });

    myMapController.setMapClusterItemClickCallback(
        callback: (BMFClusterInfo cluster) {
      print('setMapClusterItemClickCallback--\n cluster = ${cluster.toMap()}');
    });

    /// 地图状态改变回调
    myMapController.setMapRegionDidChangeCallback(
        callback: (BMFMapStatus status) async {
      print('mapRegionDidChange--\n');
      if (Platform.isIOS) {
        /// 根据当前的level刷新聚合点
        onRefreshClusters(status);
      }
    });
  }

  /// 刷新点聚合
  void onRefreshClusters(BMFMapStatus status) async {
    /// 根据当前的level获取聚合点列表
    clusters =
        await myMapController.getClusterOnZoomLevel(status.fLevel!.toInt());

    List<BMFClusterInfo> clusterInfos = [];
    for (BMFClusterInfo? item in clusters) {
      if (item == null) {
        continue;
      }
      int size = item.size!;

      /// 自定义聚合点样式
      if (size > 1) {
        CircularTextWidget text = CircularTextWidget(
          text: '$size',
          radius: 60.0,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        // 将Widget转换为图像
        Uint8List? imageBytes = await widgetToImage(text);
        clusterInfos.add(new BMFClusterInfo.iconData(
            coordinate: item.coordinate, iconData: imageBytes, size: size));
      } else {
        clusterInfos.add(new BMFClusterInfo.icon(
            coordinate: item.coordinate,
            icon: 'resoures/icon_end.png',
            size: size));
      }
    }

    /// 刷新聚合点
    bool res = await myMapController.refreshClusters(clusterInfos);
    print('refreshClusters--\n res = $res');
  }

  /// 图片转byte
  Future<Uint8List> imageToUint8List(String imagePath) async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    return Uint8List.view(imageBytes.buffer);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
          appBar: generateAppBar(),
          body: Stack(children: <Widget>[
            generateMap(),
            generateControlBar(),
          ])),
    );
  }

  BMFAppBar generateAppBar() {
    return BMFAppBar(
        title: '聚合marker示例',
        onBack: () {
          Navigator.pop(context);
        });
  }

  /// 创建地图
  @override
  Container generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: initMapOptions(),
      ),
    );
  }

  @override
  Widget generateControlBar() {
    return Container(
      width: screenSize.width,
      height: 60,
      color: Color(int.parse(Constants.controlBarColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
              style: ButtonStyle(backgroundColor: defaultBtnBgColor),
              child: Text(
                '删除大头针',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onBtnPress();
              }),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: defaultBtnBgColor),
              child: Text(
                '更新大头针',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onUpdate();
              }),
        ],
      ),
    );
  }

  void onUpdate() async {
    List<BMFClusterInfo> clusterInfoList = [];
    BMFCoordinate coordinate = BMFCoordinate(39.915, 116.404);
    for (int i = 0; i < 30; ++i) {
      Random random = Random();
      double lat = coordinate.latitude + (random.nextInt(100) * 0.001);
      double lon = coordinate.longitude + (random.nextInt(100) * 0.001);

      String imagePath = 'resoures/route_detail_start.png';

      BMFCoordinate coord = BMFCoordinate(lat, lon);
      clusterInfoList
          .add(new BMFClusterInfo.icon(coordinate: coord, icon: imagePath));
    }

    bool res = await myMapController.updateClusters(clusterInfoList);
    print('点聚合设置结果：$res');

    if (Platform.isIOS && res) {
      BMFMapStatus? status = await myMapController.getMapStatus();
      // 根据当前的level刷新聚合点
      onRefreshClusters(status!);
    }
  }

  void onBtnPress() {
    myMapController.cleanCluster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Future<Uint8List> widgetToImage(
    Widget widget, {
    Alignment alignment = Alignment.center,
    Size size = const Size(140, 140),
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0,
  }) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      configuration: ViewConfiguration(
        // size: size,
        devicePixelRatio: devicePixelRatio,
      ),
      view: WidgetsBinding.instance.platformDispatcher.views.first,
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr, // 设置适当的阅读方向
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes!;
  }
}

class CircularTextWidget extends StatelessWidget {
  final String text;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  CircularTextWidget({
    required this.text,
    required this.radius,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
