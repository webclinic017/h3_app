import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class Version extends BaseEntity {
  ///表名称
  static final String tableName = "pos_version";

  ///列名称定义
  static final String columnId = "id";
  static final String columnAppVersion = "appVersion";
  static final String columnDbVersion = "dbVersion";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String appVersion;
  String dbVersion;

  ///默认构造
  Version();

  ///Map转实体对象
  factory Version.fromMap(Map<String, dynamic> map) {
    return Version()
      ..id = Convert.toStr(map[columnId])
      ..appVersion = Convert.toStr(map[columnAppVersion])
      ..dbVersion = Convert.toStr(map[columnDbVersion])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnAppVersion: this.appVersion,
      columnDbVersion: this.dbVersion,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
