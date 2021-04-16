import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class MakeCategory extends BaseEntity {
  ///表名称
  static final String tableName = "pos_make_category";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnType = "type";
  static final String columnIsRadio = "isRadio";
  static final String columnOrderNo = "orderNo";
  static final String columnColor = "color";
  static final String columnDeleteFlag = "deleteFlag";
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
  int type;
  int isRadio;
  String orderNo;
  String color;
  int deleteFlag;

  ///默认构造
  MakeCategory();

  ///Map转实体对象
  factory MakeCategory.fromMap(Map<String, dynamic> map) {
    return MakeCategory()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..type = Convert.toInt(map[columnType])
      ..isRadio = Convert.toInt(map[columnIsRadio])
      ..orderNo = Convert.toStr(map[columnOrderNo])
      ..color = Convert.toStr(map[columnColor])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
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
      columnNo: this.no,
      columnName: this.name,
      columnType: this.type,
      columnIsRadio: this.isRadio,
      columnOrderNo: this.orderNo,
      columnColor: this.color,
      columnDeleteFlag: this.deleteFlag,
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

  static List<MakeCategory> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MakeCategory>();
    lists.forEach((map) => result.add(MakeCategory.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
