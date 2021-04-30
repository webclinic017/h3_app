import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/routers/router_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* flutter_launcher_icons: ^0.8.1
  final List menus = [
    {
      // 'icon': CommunityMaterialIcons.cash_register,
      // 'color': '#00ACEE',
      // 'title': '快速收银',
      // 'route': RouterManager.CASHIER_PAGE
    },
    // {'icon': CommunityMaterialIcons.table_large, 'color': '#C4302B', 'title': '桌台开单', 'route': RouterManager.TABLE_PAGE},
    {
      // 'icon': CommunityMaterialIcons.food_fork_drink,
      // 'color': '#C4302B',
      // 'title': '点单助手',
      // 'route': RouterManager.TABLE_ASSISTANT_PAGE
    },
    {
      // 'icon': CommunityMaterialIcons.ticket_confirmation_outline,
      // 'color': '#25D366',
      // 'title': '销售流水',
      // 'route': RouterManager.TRADE_PAGE
    },
    {
      // 'icon': CommunityMaterialIcons.download,
      // 'color': '#EA4C89',
      // 'title': '下载数据',
      // 'route': RouterManager.DOWNLOAD_PAGE
    },
    {
      'icon': CommunityMaterialIcons.cog_outline,
      'color': '#0E76A8',
      'title': '参数设置',
      'route': RouterManager.SETTING_PAGE
    },
    {
      // 'icon': CommunityMaterialIcons.table_large,
      // 'color': '#C4302B',
      // 'title': '交班',
      // 'route': RouterManager.SHIFT_PAGE
    },
    {
      // 'icon': CommunityMaterialIcons.logout_variant,
      // 'color': '#C4302B',
      // 'title': '注销',
      // 'route': RouterManager.EMPTY_PAGE
    },
  ];
  @override
  void initState() {
    super.initState();
    initPlatfromState();

//dart_notification_center: ^1.0.0+1
    DartNotificationCenter.subscribe(
      channel: 'examples',
      observer: this,
      onNotification: (options) {
        print('Notified: $options');
      },
    );
    //back_button_interceptor: ^4.4.0
    //
    BackButtonInterceptor.add(backButtonInterceptor,
        zIndex: 2, name: "home_page_interceptor");
  }

  Future<void> initPlatfromState() async {
    if (!mounted) return;

//todo 初始化操作员权限
    var permission = await OrderUtils.instance.getProductExtList();
    //  await DevOptUtils.instance.startup();
  }

  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    var currentRoute = info.currentRoute(context);
    if (currentRoute == RouterManager.HOME_PAGE) {
      exitApp(context);
    }
    return false;
  }

  void exitApp(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
