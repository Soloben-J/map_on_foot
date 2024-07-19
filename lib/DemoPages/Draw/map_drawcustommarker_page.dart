import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/CustomWidgets/map_base_page_state.dart';
import 'dart:ui' as ui;

/// marker绘制示例
class DrawCustomMarkerPage extends StatefulWidget {
  DrawCustomMarkerPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawCustomMarkerPageState createState() => _DrawCustomMarkerPageState();
}

class _DrawCustomMarkerPageState extends BMFBaseMapState<DrawCustomMarkerPage> {
  /// 地图controller
  late BMFMarker _marker;
  late BMFMarker _paopaoMarker;
  List<BMFMarker>? _markers = [];

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    addMarker();

    /// 地图marker选中回调
    myMapController.setMaptDidSelectMarkerCallback(
        callback: (BMFMarker marker) {
      print('mapDidSelectMarker--\n');

      setState(() {
        addPaopaoMarker();
      });
    });

    /// 地图marker取消选中回调
    myMapController.setMapDidDeselectMarkerCallback(
        callback: (BMFMarker marker) {
      print('mapDidDeselectMarker');
      if (marker == _marker && _markers!.contains(_paopaoMarker)) {
        myMapController.removeMarker(_paopaoMarker);
        _markers!.remove(_paopaoMarker);
      }
    });

    /// 地图marker点击回调
    myMapController.setMapClickedMarkerCallback(callback: (BMFMarker marker) {
      print('mapClickedMarker--\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 预加载图片
    precacheImage(AssetImage('resoures/icon_paopao.png'), context);

    return MaterialApp(
      home: Scaffold(
          appBar: generateAppBar(),
          body: Stack(children: <Widget>[
            generateMap(),
          ])),
    );
  }

  /// 添加自定义widget的Marker作为marker弹窗
  void addPaopaoMarker() async {
    if (_markers!.isNotEmpty) {
      myMapController.removeMarker(_paopaoMarker);
      _markers?.remove(_paopaoMarker);
    }

    // 将Widget转换为图像
    Uint8List? imageBytes =
        await widgetToImage(CustomPaoPaoWidget(title: '自定义widget'));

    _paopaoMarker = BMFMarker.iconData(
        position: _marker.position,
        canShowCallout: false,
        centerOffset: BMFPoint(0, -50), // 设置marker偏移量可以作为弹窗
        iconData: imageBytes);
    myMapController.addMarker(_paopaoMarker);
    _markers?.add(_paopaoMarker);
  }

  /// 添加Marker
  void addMarker() async {
    String imagePath = 'resoures/icon_start.png';

    Uint8List imageBytes = await imageToUint8List(imagePath);
    BMFMarker marker = BMFMarker.iconData(
        position: BMFCoordinate(39.917215, 116.380341),
        title: 'flutterMaker',
        subtitle: 'test',
        canShowCallout: false,
        identifier: 'flutter_marker',
        iconData: imageBytes);
    myMapController.addMarker(marker);
    _marker = marker;
  }

  Future<Uint8List> imageToUint8List(String imagePath) async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    return Uint8List.view(imageBytes.buffer);
  }

  BMFAppBar generateAppBar() {
    return BMFAppBar(
        title: '自定义widget to marker示例',
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
  void dispose() {
    super.dispose();
  }

  static Future<Uint8List> widgetToImage(
    Widget widget, {
    Alignment alignment = Alignment.center,
    Size size = const Size(300, 130),
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

class CustomPaoPaoWidget extends StatelessWidget {
  final String title;

  CustomPaoPaoWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 130,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'resoures/icon_paopao.png', // 图片的路径
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
