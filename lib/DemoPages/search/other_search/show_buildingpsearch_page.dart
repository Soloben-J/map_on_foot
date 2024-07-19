import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:map_on_foot/CustomWidgets/input_box.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/CustomWidgets/map_base_page_state.dart';
import 'package:map_on_foot/CustomWidgets/map_raised_button.dart';
import 'package:map_on_foot/CustomWidgets/search_btn.dart';
import 'package:map_on_foot/general/alert_dialog_utils.dart';

class ShowBuildingSearchPage extends StatefulWidget {
  @override
  _ShowBuildingSearchPageState createState() => _ShowBuildingSearchPageState();
}

class _ShowBuildingSearchPageState
    extends BMFBaseMapState<ShowBuildingSearchPage> {
  final _latController = TextEditingController(text: "22.81662");
  final _lonController = TextEditingController(text: "113.821001");
  late BMFPrismOverlay _prismOverlay;
  double tempFloorHeght = 1.0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BMFAppBar(
        title: '地图建筑物检索',
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  generateMap(),
                  Positioned(
                    top: 20.0,
                    left: 20,
                    child: BMFElevatedButton(
                      title: "+楼层",
                      onPressed: () => {
                        tempFloorHeght = tempFloorHeght + 2,
                        _prismOverlay.updateFloorHeight(tempFloorHeght),
                      },
                    ),
                  ),
                  Positioned(
                    top: 60.0,
                    left: 20,
                    child: BMFElevatedButton(
                      title: "-楼层",
                      onPressed: () => {
                        tempFloorHeght = tempFloorHeght - 2,
                        _prismOverlay.updateFloorHeight(tempFloorHeght),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _bottomSearchBar()
        ],
      ),
    );
  }

  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    controller.setPrismOverlayViewFloorAnimationDidEndCallback((prismOverlay) {
      print(prismOverlay.toMap());
    });
  }

  /// 检索
  void _onTapSearch() async {
    /// 检索参数
    BMFCoordinate coordinate = BMFCoordinate(
        double.parse(_latController.text), double.parse(_lonController.text));
    BMFBuildingSearchOption option =
        BMFBuildingSearchOption(location: coordinate);

    /// 检索对象
    BMFBuildingSearch buildingSearch = BMFBuildingSearch();

    /// 注册检索回调
    buildingSearch.onGetBuildingSearchResult(callback: _onBuildingSearchResult);

    /// 发起检索
    bool result = await buildingSearch.buildingSearch(option);

    if (result) {
      print("发起检索成功");
    } else {
      print("发起检索失败");
    }
  }

  /// 检索回调
  void _onBuildingSearchResult(
      BMFBuildingSearchResult result, BMFSearchErrorCode errorCode) {
    if (errorCode != BMFSearchErrorCode.NO_ERROR) {
      var error = "检索失败" + "errorCode:${errorCode.toString()}";
      showToast(context, error);
      print(error);
      return;
    }

    myMapController.updateMapOptions(BMFMapOptions(
        center: BMFCoordinate(double.parse(_latController.text),
            double.parse(_lonController.text)),
        zoomLevel: 19));

    /// 检索结果 alert msg
    Map resultMap = result.toMap();
    List<Map> buildingList = resultMap['buildingList'];
    late List<BMFOverlay> prismOverlays = [];
    buildingList.forEach((element) {
      print(element);
      BMFBuildInfo info = BMFBuildInfo(
          height: element['height'] as double,
          paths: element['paths'],
          center: BMFCoordinate.fromMap(element['center']),
          accuracy: element['accuracy'] as int);
      _prismOverlay = BMFPrismOverlay.buildingForColor(
          buildInfo: info,
          topFaceColor: Colors.red,
          sideFaceColor: Colors.blue,
          floorColor:
              info.height > 10 ? Colors.yellow : Color.fromARGB(0, 1, 1, 1),
          // floorSideTextureImage: info.height > 10
          //     ? 'resoures/map_route_turn_right_cross_road.png'
          //     : null,
          floorHeight: info.height > 10 ? tempFloorHeght : 0);
      myMapController.addPrismOverlay(_prismOverlay);
    });
  }

  /// search bar
  Widget _bottomSearchBar() {
    return SafeArea(
      child: Container(
        height: 75,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  BMFInputBox(
                    controller: _latController,
                    title: "纬度：",
                    placeholder: "输入纬度",
                  ),
                  BMFInputBox(
                    controller: _lonController,
                    title: "经度：",
                    placeholder: "输入经度",
                  ),
                ],
              ),
            ),
            BMFSearchBtn(
              height: 75,
              title: "搜索",
              padding: EdgeInsets.all(5),
              onTap: _onTapSearch,
            ),
          ],
        ),
      ),
    );
  }
}
