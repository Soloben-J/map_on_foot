import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/CustomWidgets/map_base_page_state.dart';

import '../../constants.dart';

class DrawGradientCirclePage extends StatefulWidget {
  DrawGradientCirclePage({Key? key}) : super(key: key);

  @override
  _DrawGradientCirclePage createState() => _DrawGradientCirclePage();
}

class _DrawGradientCirclePage extends BMFBaseMapState<DrawGradientCirclePage> {
  late BMFGradientCircle _gradientCircle;
  late bool _addState = false;
  late String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    _addGradientCircle();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "渐变圆",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            generateMap(),
            generateControlBar(),
          ],
        ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text(
              _btnText,
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            onPressed: () {
              onBtnPress();
            },
          )
        ],
      ),
    );
  }

  void _addGradientCircle() {
    /// 构造渐变圆
    _gradientCircle = BMFGradientCircle(
      center: BMFCoordinate(39.965, 116.404),
      radius: 5000,
      width: 5,
      strokeColor: Colors.green,
      centerColor: Colors.blue,
      colorWeight: 0.3,
      radiusWeight: 0.5,
      sideColor: Colors.red,
      lineDashType: BMFLineDashType.LineDashTypeNone,
    );
    myMapController.addGradientCircle(_gradientCircle);
  }

  void _removeGradientCircle() {
    myMapController.removeOverlay(_gradientCircle.id);
  }

  void onBtnPress() {
    if (_addState) {
      _addGradientCircle();
    } else {
      _removeGradientCircle();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }
}
