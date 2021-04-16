import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class MakeInfo extends BaseEntity {
  ///表名称
  static final String tableName = "pos_make_info";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnCategoryId = "categoryId";
  static final String columnDescription = "description";
  static final String columnSpell = "spell";
  static final String columnAddPrice = "addPrice";
  static final String columnQtyFlag = "qtyFlag";
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
  static final String columnPrvFlag = "prvFlag";

  ///------------------添加的虚拟列---------------
  //类型:0口味,1做法
  static final String columnCategoryType = "categoryType";
  static final String columnCategoryColor = "categoryColor";
  static final String columnIsRadio = "isRadio";

  ///字段名称
  String no;
  String categoryId;
  String description;
  String spell;
  double addPrice;
  int qtyFlag;
  String orderNo;
  String color;
  int deleteFlag;
  int prvFlag;
  int categoryType;
  String categoryColor;
  int isRadio;

  ///默认构造
  MakeInfo();

  ///Map转实体对象
  factory MakeInfo.fromMap(Map<String, dynamic> map) {
    return MakeInfo()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..no = Convert.toStr(map[columnNo])
      ..categoryId = Convert.toStr(map[columnCategoryId])
      ..description = Convert.toStr(map[columnDescription])
      ..spell = Convert.toStr(map[columnSpell])
      ..addPrice = Convert.toDouble(map[columnAddPrice])
      ..qtyFlag = Convert.toInt(map[columnQtyFlag])
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
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..prvFlag = Convert.toInt(map[columnPrvFlag])
      ..categoryType = Convert.toInt(map[columnCategoryType])
      ..categoryColor = Convert.toStr(map[columnCategoryColor])
      ..isRadio = Convert.toInt(map[columnIsRadio]);
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnCategoryId: this.categoryId,
      columnDescription: this.description,
      columnSpell: this.spell,
      columnAddPrice: this.addPrice,
      columnQtyFlag: this.qtyFlag,
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
      columnPrvFlag: this.prvFlag,
    };

    //虚拟列，如果有值则JSON
    if (categoryType != null) {
      map[columnCategoryType] = this.categoryType;
    }
    if (categoryColor != null) {
      map[columnCategoryColor] = this.categoryColor;
    }
    if (isRadio != null) {
      map[columnIsRadio] = this.isRadio;
    }
    return map;
  }

  static List<MakeInfo> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MakeInfo>();
    lists.forEach((map) => result.add(MakeInfo.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
