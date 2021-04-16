import 'package:fluro/fluro.dart';
import 'package:h3_app/pages/login_page.dart';
import 'package:h3_app/pages/setting_page.dart';
import 'package:h3_app/routers/router-config.dart';

class RouterManager implements RouterProvider {
  static const String REGISTER_PAGE = "/register";
  static const String LOGIN_PAGE = "/login";
  static const String SETTING_PAGE = "/setting";
  static const String SYS_INIT_PAGE = "/sysinit";
  @override
  void initRouter(FluroRouter router) {
    router.define(LOGIN_PAGE,
        handler: Handler(handlerFunc: (_, params) => LoginPage()));
    router.define(SETTING_PAGE,
        handler: Handler(handlerFunc: (_, params) => SettingPage()));
    // router.define(SYS_INIT_PAGE,
    //     handler: Handler(handlerFunc: (_, params) => SysInitPage()));
  }
}
