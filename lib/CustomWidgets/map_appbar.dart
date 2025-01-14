import 'package:flutter/material.dart';
import 'package:map_on_foot/constants.dart';

class BMFAppBar extends StatelessWidget implements PreferredSizeWidget {
  BMFAppBar({
    Key? key,
    this.title,
    this.titleStyle,
    this.backgroundColor,
    this.isBack = true,
    this.onBack,
    this.actions,
    this.bottom,
  }) : super(key: key);

  /// 标题
  final String? title;

  /// 标题Style
  final TextStyle? titleStyle;

  /// 背景色
  final Color? backgroundColor;

  /// 是否展示返回按钮
  final bool isBack;

  /// 返回按钮点击回调
  final VoidCallback? onBack;

  /// actions
  final List<Widget>? actions;

  /// 底部widget
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? 'title',
        style: titleStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: isBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBack ?? () {
                onBackDefault(context);
              })
          : null,
      actions: actions,
      backgroundColor:
          backgroundColor ?? Color(int.parse(Constants.actionBarColor)),
      elevation: 0,
      bottom: BMFAppBarBottom(child: bottom),
    );
  }

  void onBackDefault(BuildContext context) => Navigator.pop(context);
}

class BMFAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const BMFAppBarBottom({Key? key, this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          width: double.infinity,
          height: 0,
          color: Colors.white,
        ),
        child ?? SizedBox(height: 0),
      ]),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.child != null ? 47 : 1);
}
