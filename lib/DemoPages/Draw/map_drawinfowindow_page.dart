import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/CustomWidgets/map_base_page_state.dart';

import '../../constants.dart';

/// infoWindow绘制示例
class DrawInfoWindowPage extends StatefulWidget {
  DrawInfoWindowPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawInfoWindowPageState createState() => _DrawInfoWindowPageState();
}

class _DrawInfoWindowPageState extends BMFBaseMapState<DrawInfoWindowPage> {
  /// 地图controller
  late BMFInfoWindow _bmfInfoWindow;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addInfoWindow();
    }

    /// 地图marker选中回调
    myMapController.setMapDidClickedInfoWindowCallback(
        callback: (BMFMarker marker) {
      BMFLog.d('mapDidSelectMarker--\n marker.id = ${marker.id}',
          tag: '_DrawInfoWindowPageState');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
            appBar: BMFAppBar(
              title: 'infoWindow示例',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            body: Stack(
                children: <Widget>[generateMap(), generateControlBar()])));
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
                _btnText,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onBtnPress();
              }),
        ],
      ),
    );
  }

  void onBtnPress() {
    if (_addState) {
      addInfoWindow();
    } else {
      removeInfoWindow();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addInfoWindow() {
    BMFInfoWindow infoWindow = BMFInfoWindow(
        image: 'resoures/control.png',
        coordinate: BMFCoordinate(39.928617, 116.40329),
        yOffset: 10,
        isAddWithBitmap: true);
    // bool result;
    myMapController.addInfoWindow(infoWindow);
    _bmfInfoWindow = infoWindow;
  }

  void removeInfoWindow() {
    myMapController.removeInfoWindow(_bmfInfoWindow);
  }
}
