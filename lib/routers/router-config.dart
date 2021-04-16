import 'package:fluro/fluro.dart';
import 'package:h3_app/routers/router_manager.dart';

abstract class RouterProvider {
  void initRouter(FluroRouter router);
}

class RouterConfig {
  static List<RouterProvider> _listRouter = [];
  static void configureRouter(FluroRouter router) {
    _listRouter.clear();

    _listRouter.add(RouterManager());
    // ignore: non_constant_identifier_names
    _listRouter.forEach((RouterProvider) {
      RouterProvider.initRouter(router);
    });
  }
}
