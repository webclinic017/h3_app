import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/pos_store_table_area.dart';
import 'package:h3_app/entity/pos_store_table_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/order/order_table.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';

import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-29 16:36:47
class StoreTable extends BaseEntity {
  ///表名称
  static final String tableName = "pos_store_table";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnAreaId = "areaId";
  static final String columnTypeId = "typeId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnNumber = "number";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnAliasName = "aliasName";
  static final String columnDescription = "description";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String storeId;
  String areaId;
  String typeId;
  String no;
  String name;
  int number;
  int deleteFlag;
  String aliasName;
  String description;

  ///----------------------------zhangy 2020-10-29 Add 临时属性---------------
  StoreTableType tableType;
  StoreTableArea tableArea;
  OrderTable orderTable;

  ///-------------------------------------------------------------------------
  ///默认构造
  StoreTable();

  ///Map转实体对象
  factory StoreTable.fromMap(Map<String, dynamic> map) {
    return StoreTable()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..storeId = Convert.toStr(map[columnStoreId])
      ..areaId = Convert.toStr(map[columnAreaId])
      ..typeId = Convert.toStr(map[columnTypeId])
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..number = Convert.toInt(map[columnNumber])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..aliasName = Convert.toStr(map[columnAliasName])
      ..description = Convert.toStr(map[columnDescription])
      ..ext1 = Convert.toStr(map[columnExt1], "")
      ..ext2 = Convert.toStr(map[columnExt2], "")
      ..ext3 = Convert.toStr(map[columnExt3], "")
      ..createUser =
          Convert.toStr(map[columnCreateUser], Constants.DEFAULT_CREATE_USER)
      ..createDate = Convert.toStr(map[columnCreateDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..modifyUser =
          Convert.toStr(map[columnModifyUser], Constants.DEFAULT_MODIFY_USER)
      ..modifyDate = Convert.toStr(map[columnModifyDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"));
  }

  ///构建空对象
  factory StoreTable.newStoreTable() {
    return StoreTable()
      ..id = "${IdWorkerUtils.getInstance().generate()}"
      ..tenantId = "${Global.instance.authc?.tenantId}"
      ..storeId = ""
      ..areaId = ""
      ..typeId = ""
      ..no = ""
      ..name = ""
      ..number = 0
      ..deleteFlag = 0
      ..aliasName = ""
      ..description = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = Constants.DEFAULT_MODIFY_USER
      ..modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
  }

  ///复制新对象
  factory StoreTable.clone(StoreTable obj) {
    return StoreTable()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..storeId = obj.storeId
      ..areaId = obj.areaId
      ..typeId = obj.typeId
      ..no = obj.no
      ..name = obj.name
      ..number = obj.number
      ..deleteFlag = obj.deleteFlag
      ..aliasName = obj.aliasName
      ..description = obj.description
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..tableType = obj.tableType
      ..tableArea = obj.tableArea
      ..orderTable = obj.orderTable;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnAreaId: this.areaId,
      columnTypeId: this.typeId,
      columnNo: this.no,
      columnName: this.name,
      columnNumber: this.number,
      columnDeleteFlag: this.deleteFlag,
      columnAliasName: this.aliasName,
      columnDescription: this.description,
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

  ///Map转List对象
  static List<StoreTable> toList(List<Map<String, dynamic>> lists) {
    var result = new List<StoreTable>();
    lists.forEach((map) => result.add(StoreTable.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }

  @override
  List<Object> get props => [
        id,
        tenantId,
        storeId,
        areaId,
        typeId,
        no,
        name,
        number,
        deleteFlag,
        aliasName,
        description,
        ext1,
        ext2,
        ext3,
        createDate,
        createUser,
        modifyDate,
        modifyUser,
        this.orderTable,
        this.tableArea,
        this.tableType,
      ];
}
