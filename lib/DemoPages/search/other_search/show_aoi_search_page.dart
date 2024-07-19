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

class ShowAOISearchPage extends StatefulWidget {
  @override
  _ShowAOISearchPageState createState() => _ShowAOISearchPageState();
}

class _ShowAOISearchPageState extends BMFBaseMapState<ShowAOISearchPage> {
  final _latController = TextEditingController(text: "40.014966");
  final _lonController = TextEditingController(text: "116.308977");

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BMFAppBar(
        title: '地图AOI检索',
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  generateMap(),
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
    /// 多个经纬度之间以 ; 号分割
    /// 经纬度类型必须为 bd09ll
    /// eg: 116.31380,40.07445;116.31087,40.07361
    String coordinate = _lonController.text +
        "," +
        _latController.text +
        ";116.307958,40.056466";
    BMFAOISearchOption option = BMFAOISearchOption(locations: coordinate);

    /// 检索对象
    BMFAOISearch aoiSearch = BMFAOISearch();

    /// 注册检索回调
    aoiSearch.onGetAOISearchResult(callback: _onAOISearchResult);

    /// 发起检索
    bool result = await aoiSearch.aoiSearch(option);

    if (result) {
      print("发起检索成功");
    } else {
      print("发起检索失败");
    }
  }

  /// 检索回调
  void _onAOISearchResult(
      BMFAOISearchResult result, BMFSearchErrorCode errorCode) {
    if (errorCode != BMFSearchErrorCode.NO_ERROR) {
      var error = "检索失败" + "errorCode:${errorCode.toString()}";
      showToast(context, error);
      print(error);
      return;
    }

    myMapController.updateMapOptions(BMFMapOptions(
        center: BMFCoordinate(double.parse(_latController.text),
            double.parse(_lonController.text)),
        zoomLevel: 18));

    for (var element in result.aoiInfoList!) {
      BMFEncodeGeoPolygon polygon = BMFEncodeGeoPolygon(
        width: 8,
        encodedGeoPoints: element.paths as String,
        encodePointType: BMFEncodePointType.EncodePointTypeAOI,
        strokeColor: Colors.brown,
        fillColor: Colors.indigo,
        clickable: true,
      );
      myMapController.addPolygon(polygon!);
    }
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
