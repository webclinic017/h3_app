import 'package:h3_app/logger/logger.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:h3_app/routers/router-config.dart';

class NavigatorUtils {
  static final NavigatorUtils instance = NavigatorUtils._internal();

  factory NavigatorUtils() => instance;

  final _router = FluroRouter();

  NavigatorUtils._internal() {
    ///注册路由
    RouterConfig.configureRouter(_router);
  }

  void register() {
    FLogger.info("初始化系统路由...");
  }

  void push(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.native}) {
    unfocus();
    _router.navigateTo(context, path,
        replace: replace, clearStack: clearStack, transition: transition);
  }

  pushResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.native}) {
    unfocus();
    _router
        .navigateTo(context, path,
            replace: replace, clearStack: clearStack, transition: transition)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  /// 返回
  void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  void goBackWithParams(BuildContext context, result) {
    unfocus();
    Navigator.pop(context, result);
  }

  void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 跳到WebView页
//  static goWebViewPage(BuildContext context, String title, String url){
//    //fluro 不支持传中文,需转换
//    push(context, '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
//  }
}
