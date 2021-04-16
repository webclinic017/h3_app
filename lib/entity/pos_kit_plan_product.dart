import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class KitPlanProduct extends BaseEntity {
  ///表名称
  static final String tableName = "pos_kit_plan_product";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnProductId = "productId";
  static final String columnChudaFlag = "chudaFlag";
  static final String columnChuda = "chuda";
  static final String columnChupinFlag = "chupinFlag";
  static final String columnChupin = "chupin";
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
  String productId;
  int chudaFlag;
  String chuda;
  int chupinFlag;
  String chupin;
  int labelFlag;
  String labelValue;

  ///默认构造
  KitPlanProduct();

  ///Map转实体对象
  factory KitPlanProduct.fromMap(Map<String, dynamic> map) {
    return KitPlanProduct()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..productId = Convert.toStr(map[columnProductId])
      ..chudaFlag = Convert.toInt(map[columnChudaFlag])
      ..chuda = Convert.toStr(map[columnChuda])
      ..chupinFlag = Convert.toInt(map[columnChupinFlag])
      ..chupin = Convert.toStr(map[columnChupin])
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
      columnProductId: this.productId,
      columnChudaFlag: this.chudaFlag,
      columnChuda: this.chuda,
      columnChupinFlag: this.chupinFlag,
      columnChupin: this.chupin,
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

  static List<KitPlanProduct> toList(List<Map<String, dynamic>> lists) {
    var result = new List<KitPlanProduct>();
    lists.forEach((map) => result.add(KitPlanProduct.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
