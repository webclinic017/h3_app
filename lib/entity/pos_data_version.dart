import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class DataVersion extends BaseEntity {
  ///表名称
  static final String tableName = "pos_data_version";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnName = "name";
  static final String columnDataType = "dataType";
  static final String columnVersion = "version";
  static final String columnDownloadFlag = "downloadFlag";
  static final String columnUpdateCount = "updateCount";
  static final String columnFinishFlag = "finishFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String name;
  String dataType;
  String version;
  int downloadFlag;
  int updateCount;
  int finishFlag;

  ///默认构造
  DataVersion();

  ///Map转实体对象
  factory DataVersion.fromMap(Map<String, dynamic> map) {
    return DataVersion()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..name = Convert.toStr(map[columnName])
      ..dataType = Convert.toStr(map[columnDataType])
      ..version = Convert.toStr(map[columnVersion])
      ..downloadFlag = Convert.toInt(map[columnDownloadFlag])
      ..updateCount = Convert.toInt(map[columnUpdateCount])
      ..finishFlag = Convert.toInt(map[columnFinishFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  static List<DataVersion> toList(List<Map<String, dynamic>> lists) {
    var result = new List<DataVersion>();
    lists.forEach((map) => result.add(DataVersion.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnName: this.name,
      columnDataType: this.dataType,
      columnVersion: this.version,
      columnDownloadFlag: this.downloadFlag,
      columnUpdateCount: this.updateCount,
      columnFinishFlag: this.finishFlag,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
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
