import 'dart:io';

import 'package:h3_app/constants.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/sql_constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'env_utils.dart';

class SqlUtils {
  // 工厂模式
  factory SqlUtils() => _getInstance();

  static SqlUtils get instance => _getInstance();
  static SqlUtils _instance;

  SqlUtils._internal() {
    // 初始化
  }

  static SqlUtils _getInstance() {
    if (_instance == null) {
      _instance = new SqlUtils._internal();
    }
    return _instance;
  }

  Database _database;

  Future<Database> open() async {
    if (_database == null) {
      _database = await _init();
    }

    return _database;
  }

  Future<Database> _init() async {
    await Sqflite.setDebugModeOn(EnvUtils.isDebug());

    String path = "${Constants.DATABASE_PATH}/${Constants.DATABASE_NAME}";
    if (Platform.isIOS) {
      var directory = await getApplicationDocumentsDirectory();
      path = "${directory.path}/${Constants.DATABASE_NAME}";
    }

    FLogger.debug("数据库存储路径:$path");

    var database = await openDatabase(path,
        version: 1, onConfigure: _onConfigure, onCreate: _onCreate);

    FLogger.debug("数据库打开状态:${database.isOpen}");

    return database;
  }

  /// Let's use FOREIGN KEY constraints
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _createTable(Batch batch) {
    SqlConstant.initTables.forEach((sql) => batch.execute(sql));
  }

  void _onCreate(Database db, int version) async {
    var batch = db.batch();
    _createTable(batch);
    await batch.commit();
  }
}
