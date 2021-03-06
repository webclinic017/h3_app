// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:h3_app/pages/login_page.dart';
// import 'package:h3_app/utils/permission_utils.dart';
// import 'package:h3_app/utils/screen_utils.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'constants.dart';
// import 'global.dart';
// import 'utils/image_utils.dart';

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       builder: (BuildContext context, Widget child) {
//         return Material(
//           child: OKToast(
//             child: FlutterEasyLoading(
//               child: child,
//             ),
//           ),
//         );
//       },
//       home: PermissionWidget(),
//       // home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// ///?????????????????????????????????????????????
// class PermissionWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _PermissionWidgetState();
//   }
// }

// class _PermissionWidgetState extends State<PermissionWidget> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//   }

//   /// Initialize platform state.
//   Future<void> initPlatformState() async {
//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     //????????????????????????
//     ScreenUtils.init(context,
//         width: Constants.SCREEN_WIDTH,
//         height: Constants.SCREEN_HEIGHT,
//         allowFontScaling: true);

//     //????????????
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: _requiredPermissionUi(context),
//     );
//   }

//   ///??????????????????
//   Widget _requiredPermissionUi(BuildContext context) =>
//       FutureBuilder<List<SystemPermission>>(
//           future: PermissionUtils.requiredPermission(context),
//           builder: (BuildContext context,
//               AsyncSnapshot<List<SystemPermission>> snapshot) {
//             if (snapshot.hasData) {
//               //???????????????????????????
//               var lists = snapshot.data.where((obj) =>
//                   (obj.status == PermissionStatus.undetermined ||
//                       obj.status == PermissionStatus.denied ||
//                       obj.status == PermissionStatus.permanentlyDenied));
//               //????????????????????????????????????
//               if (lists != null && lists.length > 0) {
//                 return _showPermissionUi(snapshot.data);
//               }

//               // return Container(
//               //   color: Colors.green,
//               // );
//               return StartupWidget();
//             }
//             //????????????
//             return Center(
//               child: SpinKitWave(color: Constants.hexStringToColor("#7A73C7")),
//             );
//           });

//   Widget _showPermissionUi(List<SystemPermission> perms) => Container(
//         padding: Constants.paddingAll(0),
//         decoration: BoxDecoration(
//           color: Constants.hexStringToColor("#FFFFFF"),
//           image: DecorationImage(
//             image: AssetImage(
//                 ImageUtils.getImgPath("download/background", format: "jpg")),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Center(
//           child: Container(
//             padding: Constants.paddingSymmetric(vertical: 30, horizontal: 30),
//             width: Constants.getAdapterWidth(600),
//             height: Constants.getAdapterHeight(400),
//             decoration: ShapeDecoration(
//               color: Constants.hexStringToColor("#FFFFFF"),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(6.0),
//                 ),
//               ),
//             ),
//             child: ListView(
//               itemExtent: Constants.getAdapterHeight(100),
//               children: _permissionView(perms),
//             ),
//           ),
//         ),
//       );

//   List<Widget> _permissionView(List<SystemPermission> perms) {
//     return perms.map((obj) {
//       return SwitchListTile(
//         title: Text(
//           obj.title,
//           style: TextStyles.getTextStyle(
//               fontSize: 32, color: Constants.hexStringToColor("#333333")),
//         ),
//         value: obj.checked,
//         secondary: obj.icon,
//         onChanged: (bool value) {
//           _requestPermission(obj.perm);
//         },
//       );
//     }).toList();
//   }

//   //??????????????????
//   Future<void> _requestPermission(Permission permission) async {
//     final status = await permission.request();

//     if (status == PermissionStatus.permanentlyDenied) {
//       await openAppSettings();
//     }
//     setState(() {});
//   }
// }

// class StartupWidget extends StatefulWidget {
//   StartupWidget({Key key}) : super(key: key);

//   @override
//   _StartupWidgetState createState() => _StartupWidgetState();
// }

// class _StartupWidgetState extends State<StartupWidget> {

//   @override
//   Widget build(BuildContext context) {
//     return LoginPage();
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/pages/login_page.dart';
import 'package:h3_app/pages/register_page.dart';
import 'package:h3_app/routers/navigator_utils.dart';
import 'package:h3_app/utils/api_utils.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/dialog_utils.dart';
import 'package:h3_app/utils/image_utils.dart';
import 'package:h3_app/utils/permission_utils.dart';
import 'package:h3_app/utils/scheduler_utils.dart';
import 'package:h3_app/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'blocs/app_bloc.dart';
import 'blocs/authc_bloc.dart';
import 'i18n/i18n.dart';
import 'logger/logger.dart';

class MyApp extends StatefulWidget {
  final String route;
  MyApp({this.route});

  @override
  _MyAppState createState() => new _MyAppState(route: this.route);
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final String route;
  _MyAppState({this.route});

  @override
  void initState() {
    super.initState();

    initPlatformState();

    //???????????????
    NavigatorUtils.instance.register();

    WidgetsBinding.instance.addObserver(this);
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalProviders,
      child: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.theme.data,
          locale: state.locale,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          localeResolutionCallback: loadSupportedLocals,
          onGenerateTitle: (BuildContext context) {
            var local = AppLocalizations.of(context);
            assert(local != null);
            return "${local.appTitle}";
          },
          //????????????????????????
          localeListResolutionCallback: (deviceLocale, supportedLocales) {
            //??????????????????
            var locale = Locale("zh", "CN");
            if (deviceLocale != null && deviceLocale.length > 0) {
              var defaultLocale = deviceLocale[0];
              //???????????????????????????????????????????????????
              var adapterLocale = Locale.fromSubtags(
                  languageCode: defaultLocale.languageCode,
                  countryCode: defaultLocale.countryCode);
              if (supportedLocales.contains(adapterLocale)) {
                locale = adapterLocale;
              }
            }
            return locale;
          },
          builder: (BuildContext context, Widget child) {
            return Material(
              child: OKToast(
                child: FlutterEasyLoading(
                  child: child,
                ),
              ),
            );
          },
          home: RestartWidget(
            child: _widgetForRoute(this.route, context),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _widgetForRoute(String defaultRouteName, BuildContext context) {
    switch (defaultRouteName) {
      default:
        return PermissionWidget();
    }
  }
}

///?????????????????????????????????????????????
class PermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PermissionWidgetState();
  }
}

class _PermissionWidgetState extends State<PermissionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    //????????????????????????
    ScreenUtils.init(context,
        width: Constants.SCREEN_WIDTH,
        height: Constants.SCREEN_HEIGHT,
        allowFontScaling: true);

    //????????????
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _requiredPermissionUi(context),
    );
  }

  ///??????????????????
  Widget _requiredPermissionUi(BuildContext context) =>
      FutureBuilder<List<SystemPermission>>(
          future: PermissionUtils.requiredPermission(context),
          builder: (BuildContext context,
              AsyncSnapshot<List<SystemPermission>> snapshot) {
            if (snapshot.hasData) {
              //???????????????????????????
              var lists = snapshot.data.where((obj) =>
                  (obj.status == PermissionStatus.undetermined ||
                      obj.status == PermissionStatus.denied ||
                      obj.status == PermissionStatus.permanentlyDenied));
              //????????????????????????????????????
              if (lists != null && lists.length > 0) {
                return _showPermissionUi(snapshot.data);
              }
              return StartupWidget();
            }
            //????????????
            return Center(
              child: SpinKitWave(color: Constants.hexStringToColor("#7A73C7")),
            );
          });

  Widget _showPermissionUi(List<SystemPermission> perms) => Container(
        padding: Constants.paddingAll(0),
        decoration: BoxDecoration(
          color: Constants.hexStringToColor("#FFFFFF"),
          image: DecorationImage(
            image: AssetImage(
                ImageUtils.getImgPath("download/background", format: "jpg")),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            padding: Constants.paddingSymmetric(vertical: 30, horizontal: 30),
            width: Constants.getAdapterWidth(600),
            height: Constants.getAdapterHeight(400),
            decoration: ShapeDecoration(
              color: Constants.hexStringToColor("#FFFFFF"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
            ),
            child: ListView(
              itemExtent: Constants.getAdapterHeight(100),
              children: _permissionView(perms),
            ),
          ),
        ),
      );

  List<Widget> _permissionView(List<SystemPermission> perms) {
    return perms.map((obj) {
      return SwitchListTile(
        title: Text(
          obj.title,
          style: TextStyles.getTextStyle(
              fontSize: 32, color: Constants.hexStringToColor("#333333")),
        ),
        value: obj.checked,
        secondary: obj.icon,
        onChanged: (bool value) {
          _requestPermission(obj.perm);
        },
      );
    }).toList();
  }

  //??????????????????
  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
    setState(() {});
  }
}

class StartupWidget extends StatefulWidget {
  StartupWidget({Key key}) : super(key: key);

  @override
  _StartupWidgetState createState() => _StartupWidgetState();
}

class _StartupWidgetState extends State<StartupWidget> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //????????????????????????????????????
  AuthcBloc _authcBloc;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    //????????????????????????
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    this._authcBloc = BlocProvider.of<AuthcBloc>(context);
    assert(this._authcBloc != null);
    this._authcBloc.add(AuthcStarted());

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        FLogger.info("??????????????????:${result.toString()}");
        //??????????????????
        await OpenApiUtils.instance.isAvailable();
        break;
      case ConnectivityResult.none:
      default:
        FLogger.info("?????????????????????");
        Global.instance.online = false;
        break;
    }
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    ///???????????????????????????
    await _createLocalStorageDir();

    ///?????????????????????
    FLogger.updateConfig(
      printLevel: LoggerLevel.trace,
      fileLevel: LoggerLevel.trace,
      fileDirectory: Constants.LOGS_PATH,
      serverLevel: LoggerLevel.info,
      serverUrl: "https://pipeline.qiniu.com/v2/repos/estore_v6_logs/data",
    );

    ///?????????HTTP????????????
    await OpenApiUtils.instance.init();

    ///???????????????????????????
    Global.instance.online = await OpenApiUtils.instance.isAvailable();

    ///?????????????????????
    Global.instance.appVersion = await DeviceUtils.instance.getAppVersion();

    ///?????????????????????
    await SchedulerUtils.instance.init();

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    //?????????Loading?????????
    DialogUtils.init(context);

    return BlocBuilder<AuthcBloc, AuthcState>(
      cubit: this._authcBloc,
      builder: (BuildContext context, AuthcState state) {
        //???????????????????????????????????????
        if (state.status == AuthcStatus.Registed) {
          return LoginPage();
        }
        if (state.status == AuthcStatus.Unregisted) {
          // return RegisterPage();
          return LoginPage();
        }

        //????????????
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: SpinKitWave(color: Constants.hexStringToColor("#7A73C7")),
          ),
        );
      },
    );
  }

  Future<void> _createLocalStorageDir() async {
    //????????????
    final appPath = Directory(Constants.ANDROID_BASE_PATH);
    if (!(await appPath.exists())) {
      appPath.create(recursive: true);
    }

    //??????????????????
    final logPath = Directory(Constants.LOGS_PATH);
    if (!(await logPath.exists())) {
      logPath.create(recursive: true);
    }

    //?????????????????????
    final databasePath = Directory(Constants.DATABASE_PATH);
    if (!(await databasePath.exists())) {
      databasePath.create(recursive: true);
    }

    //??????????????????
    final imagePath = Directory(Constants.IMAGE_PATH);
    if (!(await imagePath.exists())) {
      imagePath.create(recursive: true);
    }

    //????????????
    final productImagePath = Directory(Constants.PRODUCT_IMAGE_PATH);
    if (!(await productImagePath.exists())) {
      productImagePath.create(recursive: true);
    }

    //??????????????????
    final printerImagePath = Directory(Constants.PRINTER_IMAGE_PATH);
    if (!(await printerImagePath.exists())) {
      printerImagePath.create(recursive: true);
    }

    //????????????
    final viceImagePath = Directory(Constants.VICE_IMAGE_PATH);
    if (!(await viceImagePath.exists())) {
      viceImagePath.create(recursive: true);
    }
  }
}

///????????????????????????????????????child Widget???????????????????????????APP????????????????????????????????????
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
