import 'package:h3_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DialogUtils {
  static void init(BuildContext ctx) {
    setupLoadingWidget();
  }

  static void setupLoadingWidget() {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
    EasyLoading.instance.backgroundColor = Colors.grey[500];
    EasyLoading.instance.progressColor = Colors.black;
    EasyLoading.instance.textColor = Colors.black;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.wave;
    EasyLoading.instance.indicatorColor = Colors.blue;
    EasyLoading.instance.indicatorSize = 40.0;
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.instance.fontSize = Constants.getAdapterFontSize(24.0);
    EasyLoading.instance.textPadding = Constants.paddingOnly(top: 10.0);
    EasyLoading.instance.contentPadding =
        Constants.paddingSymmetric(vertical: 15.0, horizontal: 20.0);
  }

  ///确认对话框
  static YYDialog confirm(BuildContext context, String title, String info,
      Function ok, Function cancel,
      {double width = 400}) {
    return YYDialog().build(context)
      ..width = Constants.getAdapterWidth(width)
      ..borderRadius = 4.0
      ..barrierDismissible = false
      ..text(
        alignment: Alignment.center,
        padding: Constants.paddingAll(10.0),
        text: "$title",
        fontFamily: "Alibaba PuHuiTi",
        color: Colors.black,
        fontSize: Constants.getAdapterFontSize(32),
        fontWeight: FontWeight.bold,
      )
      ..divider()
      ..text(
        padding: Constants.paddingOnly(
            left: 18.0, right: 18.0, bottom: 32.0, top: 24.0),
        text: "$info",
        fontFamily: "Alibaba PuHuiTi",
        color: Colors.black,
        fontSize: Constants.getAdapterFontSize(32),
      )
      ..divider()
      ..doubleButton(
        padding: Constants.paddingAll(10),
        height: Constants.getAdapterHeight(80),
        gravity: Gravity.center,
        withDivider: true,
        isClickAutoDismiss: true,
        text1: "取消",
        fontFamily1: "Alibaba PuHuiTi",
        color1: Colors.deepPurpleAccent,
        fontSize1: Constants.getAdapterFontSize(32),
        fontWeight1: FontWeight.bold,
        onTap1: () {
          cancel();
        },
        text2: "确定",
        color2: Colors.deepPurpleAccent,
        fontFamily2: "Alibaba PuHuiTi",
        fontSize2: Constants.getAdapterFontSize(32),
        fontWeight2: FontWeight.bold,
        onTap2: () {
          ok();
        },
      )
      ..show();
  }

  ///通知对话框
  static YYDialog notify(
      BuildContext context, String title, String info, Function ok,
      {String buttonText = "确定", double width = 400}) {
    return YYDialog().build(context)
      ..width = Constants.getAdapterWidth(width)
      ..borderRadius = 4.0
      ..barrierDismissible = false
      ..text(
        alignment: Alignment.center,
        padding: Constants.paddingAll(10.0),
        text: "$title",
        fontFamily: "Alibaba PuHuiTi",
        color: Colors.black,
        fontSize: Constants.getAdapterFontSize(32),
        fontWeight: FontWeight.bold,
      )
      ..divider()
      ..text(
        padding: Constants.paddingOnly(
            left: 18.0, right: 18.0, bottom: 32.0, top: 24.0),
        text: "$info",
        fontFamily: "Alibaba PuHuiTi",
        color: Colors.black,
        fontSize: Constants.getAdapterFontSize(32),
      )
      ..divider()
      ..doubleButton(
        padding: Constants.paddingAll(0),
        height: Constants.getAdapterHeight(80),
        gravity: Gravity.right,
        withDivider: false,
        isClickAutoDismiss: true,
        text2: "$buttonText",
        color2: Colors.deepPurpleAccent,
        fontFamily2: "Alibaba PuHuiTi",
        fontSize2: Constants.getAdapterFontSize(32),
        fontWeight2: FontWeight.bold,
        onTap2: () {
          ok();
        },
      )
      ..show();
  }

  static YYDialog showDialog(BuildContext context, Widget child,
      {double width = 410,
      double height = 546,
      bool barrierDismissible = false}) {
    return YYDialog().build(context)
      ..width = Constants.getAdapterWidth(width)
      ..height = Constants.getAdapterHeight(height)
      ..margin = Constants.paddingAll(0)
      ..borderRadius = 0.0
      ..backgroundColor = Colors.transparent
      ..barrierColor = Color(0xFF000000).withOpacity(0.3)
      ..barrierDismissible = barrierDismissible
      ..widget(child)
      ..show();
  }
}
