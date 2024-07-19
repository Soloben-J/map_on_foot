import 'package:flutter/material.dart';
import 'package:map_on_foot/CustomWidgets/function_item.widget.dart';
import 'package:map_on_foot/CustomWidgets/map_appbar.dart';
import 'package:map_on_foot/DemoPages/Utils/create_share_page.dart';
import 'package:map_on_foot/DemoPages/Utils/open_baidumap_navipage.dart';

class FlutterBMFUtilsDemo extends StatelessWidget {
  const FlutterBMFUtilsDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BMFAppBar(
        title: '实用工具',
        isBack: false,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            FunctionItem(
                label: '调起百度地图客户端',
                sublabel: 'OpenBaiduMapNaviPage',
                target: OpenBaiduMapNaviPage()),
            FunctionItem(
                label: '短串分享',
                sublabel: 'MapCreateSharePage',
                target: MapCreateSharePage()),
          ],
        ),
      ),
    );
  }
}
