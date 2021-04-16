import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-26 08:50:59
class SetmealGroup extends BaseEntity {
  ///表名称
  static final String tableName = "pos_setmeal_group";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnProductId = "productId";
  static final String columnProductName = "productName";
  static final String columnSpecId = "specId";
  static final String columnDetailNum = "detailNum";
  static final String columnChoseNum = "choseNum";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String no;
  String name;
  String productId;
  String productName;
  String specId;
  int detailNum;
  int choseNum;

  ///默认构造
  SetmealGroup();

  ///Map转实体对象
  factory SetmealGroup.fromMap(Map<String, dynamic> map) {
    return SetmealGroup()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..productId = Convert.toStr(map[columnProductId])
      ..productName = Convert.toStr(map[columnProductName])
      ..specId = Convert.toStr(map[columnSpecId])
      ..detailNum = Convert.toInt(map[columnDetailNum])
      ..choseNum = Convert.toInt(map[columnChoseNum])
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
  factory SetmealGroup.newSetmealGroup() {
    return SetmealGroup()
      ..id = "${IdWorkerUtils.getInstance().generate()}"
      ..tenantId = "${Global.instance.authc?.tenantId}"
      ..no = ""
      ..name = ""
      ..productId = ""
      ..productName = ""
      ..specId = ""
      ..detailNum = 0
      ..choseNum = 0
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
  factory SetmealGroup.clone(SetmealGroup obj) {
    return SetmealGroup()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..no = obj.no
      ..name = obj.name
      ..productId = obj.productId
      ..productName = obj.productName
      ..specId = obj.specId
      ..detailNum = obj.detailNum
      ..choseNum = obj.choseNum
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnName: this.name,
      columnProductId: this.productId,
      columnProductName: this.productName,
      columnSpecId: this.specId,
      columnDetailNum: this.detailNum,
      columnChoseNum: this.choseNum,
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
  static List<SetmealGroup> toList(List<Map<String, dynamic>> lists) {
    var result = new List<SetmealGroup>();
    lists.forEach((map) => result.add(SetmealGroup.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
