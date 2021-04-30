import 'dart:collection';

import 'package:barcode_scan/model/scan_options.dart';
// import 'package:h3_app/blocs/assistant_bloc.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sprintf/sprintf.dart';

import 'blocs/app_bloc.dart';
import 'blocs/authc_bloc.dart';
// import 'blocs/cashier_bloc.dart';
// import 'blocs/download_bloc.dart';
// import 'blocs/login_bloc.dart';
// import 'blocs/maling_bloc.dart';
// import 'blocs/printer_bloc.dart';
import 'blocs/register_bloc.dart';
// import 'blocs/shift_bloc.dart';
import 'blocs/sys_init_bloc.dart';
// import 'blocs/table_bloc.dart';
// import 'blocs/table_cashier_bloc.dart';
// import 'blocs/trade_bloc.dart';
import 'entity/pos_authc.dart';
import 'entity/pos_config.dart';
import 'entity/pos_shift_log.dart';
import 'entity/pos_store_info.dart';
import 'entity/pos_worker.dart';
import 'i18n/i18n.dart';
// import 'keyboards/keyboard.dart';
import 'logger/logger.dart';
import 'order/order_utils.dart';

///全局BLOC
List<BlocProvider> globalProviders = [
  BlocProvider<AppBloc>(create: (BuildContext context) => AppBloc()),
  // BlocProvider<KeyboardBloc>(create: (BuildContext context) => KeyboardBloc()),
  BlocProvider<AuthcBloc>(create: (BuildContext context) => AuthcBloc()),
  BlocProvider<RegisterBloc>(create: (BuildContext context) => RegisterBloc()),
  // BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
  // BlocProvider<DownloadBloc>(create: (BuildContext context) => DownloadBloc()),
  // BlocProvider<CashierBloc>(create: (BuildContext context) => CashierBloc()),
  // BlocProvider<MalingBloc>(create: (BuildContext context) => MalingBloc()),
  // BlocProvider<TradeBloc>(create: (BuildContext context) => TradeBloc()),
  // BlocProvider<PrinterBloc>(create: (BuildContext context) => PrinterBloc()),
  BlocProvider<SysInitBloc>(create: (BuildContext context) => SysInitBloc()),
  // BlocProvider<TableBloc>(create: (BuildContext context) => TableBloc()),
  // BlocProvider<TableCashierBloc>(create: (BuildContext context) => TableCashierBloc()),
  // BlocProvider<AssistantBloc>(create: (BuildContext context) => AssistantBloc()),
  // BlocProvider<ShiftBloc>(create: (BuildContext context) => ShiftBloc()),
];

/// List of languages codes that the app will support
/// https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
const supportedLocalCodes = ["zh_CN", "en_US", "zh_TW"];
final supportedLocales = supportedLocalCodes.map<Locale>((code) {
  var arr = code.split("_");
  return Locale.fromSubtags(languageCode: arr[0], countryCode: arr[1]);
}).toList();

/// A callback provided by [MaterialApp] that lets you
/// specify which locales you plan to support by returning them.
Locale loadSupportedLocals(locale, supportedLocales) {
  if (locale == null) {
    return supportedLocales.first;
  }

  for (final supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode &&
        supportedLocale.countryCode == locale.countryCode) {
      return supportedLocale;
    }
  }

  return supportedLocales.first;
}

/// Internationalized apps that require translations for one of the
/// locales listed in [GlobalMaterialLocalizations] should specify
/// this parameter and list the [supportedLocales] that the
/// application can handle.
List<LocalizationsDelegate> get localizationsDelegates {
  return [
    const AppLocalizationsDelegate(),
    const FallbackCupertinoLocalizationsDelegate(),
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

ScanOptions scanOptions = ScanOptions(
  strings: {
    "cancel": "取消",
    "flash_on": "轻点照亮",
    "flash_off": "轻点关闭",
  },
);

class Global {
  // 工厂模式
  factory Global() => _getInstance();
  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    if (_instance == null) {
      _instance = Global._internal();
    }
    return _instance;
  }

  ///是否联机,连接到公网的标识
  bool online = true;

  ///点菜宝联机标识
  bool onlineByAssistant = true;

  ///全局参数缓存
  Map<String, dynamic> _globalConfig;

  ///门店POS注册认证
  Authc authc;

  ///当前登录的收银员
  Worker worker;

  ///当前程序的版本
  String appVersion = "0.0.0";

  Global._internal() {
    FLogger.debug("初始化Global对象");

    loadConfig().whenComplete(() => print("初始化成功"));
  }

  ///加载系统全局参数
  Future<void> loadConfig() async {
    if (_globalConfig == null) {
      _globalConfig = new Map<String, dynamic>();
    }
    _globalConfig.clear();

    List<Config> lists = await _initConfig();
    lists.forEach((f) {
      _globalConfig[f.keys] = f.values;
    });

    FLogger.info("加载本地配置参数成功,共${_globalConfig.length}项配置参数");
  }

  Future<List<Config>> _initConfig() async {
    List<Config> result;
    try {
      String sql =
          "select id, tenantId, `group`, keys, initValue, `values`,clouds, createUser, createDate, modifyUser, modifyDate from pos_config";
      var db = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await db.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        result = Config.toList(lists);
      }
    } catch (e, stack) {
      FLogger.error("加载本地参数异常:" + e.toString());
    }

    if (result == null) {
      result = <Config>[];
    }

    return result;
  }

  ///获取系统抹零设置配置参数
  Future<Tuple2<bool, String>> saveConfig(
      String group, String keys, String initValue, String values) async {
    bool result = true;
    String message = "参数更新成功";
    try {
      var queues = new Queue<String>();

      //是否启用抹零的SQL
      String template =
          "REPLACE INTO pos_config(id,tenantId,`group`,keys,initValue,`values`,createUser,createDate,modifyUser,modifyDate)VALUES('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');";
      var sql = sprintf(template, [
        IdWorkerUtils.getInstance().generate().toString(),
        Global.instance.authc.tenantId,
        group,
        keys,
        initValue,
        values,
        Constants.DEFAULT_CREATE_USER,
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
        Constants.DEFAULT_MODIFY_USER,
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
      ]);
      queues.add(sql);

      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
        } catch (e) {
          FLogger.error("保存参数异常:" + e.toString());
        }
      });
    } catch (e, stack) {
      result = false;
      message = "参数更新异常";
      FLogger.error("更新配置参数发生异常:" + e.toString());
    } finally {
      reloadConfig();
    }
    return Tuple2<bool, String>(result, message);
  }

  Future<void> reloadConfig() async {
    if (_globalConfig == null) {
      _globalConfig = new Map<String, dynamic>();
    }
    _globalConfig.clear();

    List<Config> lists = await _initConfig();
    lists.forEach((f) {
      _globalConfig[f.keys] = f.values;
    });

    FLogger.info("加载本地配置参数成功,共${_globalConfig.length}项配置参数");
  }

  //加载配置参数，返回Bool类型
  bool globalConfigBoolValue(String keys, {bool defaultValue = false}) {
    if (this._globalConfig.containsKey(keys)) {
      String value = this._globalConfig[keys];

      return "1" == value;
    } else {
      return defaultValue;
    }
  }

  ///加载配置参数，返回String类型
  String globalConfigStringValue(String keys, {String defaultValue = ""}) {
    if (this._globalConfig.containsKey(keys)) {
      return this._globalConfig[keys];
    } else {
      return defaultValue;
    }
  }

  /// 开启抹零时,微信、支付宝、储值卡、银行卡、扫码付为实款实收
  bool payRealAmount() {
    // bool result = false;
    // //抹零开关是否开启
    // var malingEnable = Global.Instance.GlobalConfigBoolValue(ConfigConstant.MALING_ENABLE);
    // //(结账时，以下支付方式为实款实收：微信、支付宝、储值卡、银行卡、扫码付)开关是否开启
    // var payRealAmount = Global.Instance.GlobalConfigBoolValue(ConfigConstant.PAY_REAL_AMOUNT_EXCEPT_CASH, false);
    // if(malingEnable && payRealAmount)
    // {
    //   result = true;
    // }
    // return result;

    return true;
  }

  ///当前班次
  ShiftLog _shift;
  Future<ShiftLog> getShiftLog() async {
    if (_shift != null) {
      print("缓存加载班次信息>>>>>${_shift.toString()}");
      return Future.value(_shift);
    }

    try {
      String sql =
          "select * from pos_shift_log where status = 0 and storeId = '${authc.storeId}' and workerId = '${worker.id}' and posNo = '${authc.posNo}'";
      var db = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await db.rawQuery(sql);
      if (lists != null && lists.length > 0) {
        _shift = ShiftLog.fromMap(lists[0]);
      }

      if (_shift == null) {
        var batchNo = await OrderUtils.instance.generateBatchNo();

        _shift = new ShiftLog();
        _shift.id = IdWorkerUtils.getInstance().generate().toString();
        _shift.tenantId = Global.instance.authc.tenantId;
        _shift.status = 0;
        _shift.storeId = Global.instance.authc.storeId;
        _shift.storeNo = Global.instance.authc.storeNo;
        _shift.workerId = Global.instance.worker.id;
        _shift.workerNo = Global.instance.worker.no;
        _shift.workerName = Global.instance.worker.name;
        _shift.planId = "";
        _shift.name = "默认班次";
        _shift.no = batchNo.item3;
        _shift.startTime =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
        _shift.posNo = Global.instance.authc.posNo;
        _shift.imprest = 0;
        _shift.createDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
        _shift.createUser = Global.instance.worker.no;

        await db.transaction((txn) async {
          await txn.insert(ShiftLog.tableName, _shift.toMap());
        });
      }
    } catch (e) {
      FLogger.error("加载班次信息异常:" + e.toString());
    }

    print("首次加载班次信息>>>>>${_shift.toString()}");

    return _shift;
  }

  ///当前门店信息
  StoreInfo _store;
  Future<StoreInfo> getStoreInfo() async {
    if (_store != null) {
      print("缓存加载门店信息>>>>>${_store.toString()}");
      return Future.value(_store);
    }

    try {
      String sql = "select * from pos_store_info where id = '${authc.storeId}'";
      var db = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await db.rawQuery(sql);
      if (lists != null && lists.length > 0) {
        _store = StoreInfo.fromMap(lists[0]);
      }
    } catch (e) {
      FLogger.error("加载门店信息异常:" + e.toString());
    }

    return _store;
  }

  int _lastPayNoSuffix = 0;
  int get getNextPayNoSuffix {
    if (this._lastPayNoSuffix == 9) {
      this._lastPayNoSuffix = 0;
    } else {
      this._lastPayNoSuffix++;
    }

    return this._lastPayNoSuffix;
  }

  String _lastPayNo = "";
  String nextPayNoSuffix(String payNo) {
    if (payNo == this._lastPayNo) {
      if (this._lastPayNoSuffix == 9) {
        this._lastPayNoSuffix = 0;
      } else {
        this._lastPayNoSuffix++;
      }
      return this._lastPayNoSuffix.toString();
    } else {
      this._lastPayNoSuffix = 0;
      this._lastPayNo = payNo;
    }
    return "";
  }
}

class TextStyles {
  static TextStyle getTextStyle(
      {Color color = Colors.black,
      double fontSize = 18,
      TextDecoration decoration = TextDecoration.none,
      FontWeight fontWeight = FontWeight.normal,
      double letterSpacing = 0,
      double wordSpacing = 0}) {
    return TextStyle(
      decoration: decoration,
      fontFamily: 'Alibaba PuHuiTi',
      fontSize: Constants.getAdapterFontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );
  }
}
