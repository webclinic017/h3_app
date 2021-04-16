import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class KdsPlanProduct extends BaseEntity {
  ///表名称
  static final String tableName = "pos_kds_plan_product";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnProductId = "productId";
  static final String columnChuxianFlag = "chuxianFlag";
  static final String columnChuxian = "chuxian";
  static final String columnChuxianTime = "chuxianTime";
  static final String columnChupinFlag = "chupinFlag";
  static final String columnChupin = "chupin";
  static final String columnChupinTime = "chupinTime";
  static final String columnLabelFlag = "labelFlag";
  static final String columnLabelValue = "labelValue";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String storeId;
  String productId;
  int chuxianFlag;
  String chuxian;
  int chuxianTime;
  int chupinFlag;
  String chupin;
  int chupinTime;
  int labelFlag;
  String labelValue;

  ///默认构造
  KdsPlanProduct();

  ///Map转实体对象
  factory KdsPlanProduct.fromMap(Map<String, dynamic> map) {
    return KdsPlanProduct()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..storeId = Convert.toStr(map[columnStoreId])
      ..productId = Convert.toStr(map[columnProductId])
      ..chuxianFlag = Convert.toInt(map[columnChuxianFlag])
      ..chuxian = Convert.toStr(map[columnChuxian])
      ..chuxianTime = Convert.toInt(map[columnChuxianTime])
      ..chupinFlag = Convert.toInt(map[columnChupinFlag])
      ..chupin = Convert.toStr(map[columnChupin])
      ..chupinTime = Convert.toInt(map[columnChupinTime])
      ..labelFlag = Convert.toInt(map[columnLabelFlag])
      ..labelValue = Convert.toStr(map[columnLabelValue])
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

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnProductId: this.productId,
      columnChuxianFlag: this.chuxianFlag,
      columnChuxian: this.chuxian,
      columnChuxianTime: this.chuxianTime,
      columnChupinFlag: this.chupinFlag,
      columnChupin: this.chupin,
      columnChupinTime: this.chupinTime,
      columnLabelFlag: this.labelFlag,
      columnLabelValue: this.labelValue,
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

  static List<KdsPlanProduct> toList(List<Map<String, dynamic>> lists) {
    var result = new List<KdsPlanProduct>();
    lists.forEach((map) => result.add(KdsPlanProduct.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
