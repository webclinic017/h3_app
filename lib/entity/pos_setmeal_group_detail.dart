import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-26 08:50:59
class SetmealGroupDetail extends BaseEntity {
  ///表名称
  static final String tableName = "pos_setmeal_group_detail";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnGroupId = "groupId";
  static final String columnGroupNo = "groupNo";
  static final String columnProductId = "productId";
  static final String columnProductNo = "productNo";
  static final String columnProductName = "productName";
  static final String columnSpecId = "specId";
  static final String columnQuantity = "quantity";
  static final String columnSalePrice = "salePrice";
  static final String columnVipPrice = "vipPrice";
  static final String columnAddPrice = "addPrice";
  static final String columnIsDefault = "isDefault";
  static final String columnOrderNo = "orderNo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String groupId;
  String groupNo;
  String productId;
  String productNo;
  String productName;
  String specId;
  double quantity;
  double salePrice;
  double vipPrice;
  double addPrice;
  int isDefault;
  int orderNo;

  ///默认构造
  SetmealGroupDetail();

  ///Map转实体对象
  factory SetmealGroupDetail.fromMap(Map<String, dynamic> map) {
    return SetmealGroupDetail()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..groupId = Convert.toStr(map[columnGroupId])
      ..groupNo = Convert.toStr(map[columnGroupNo])
      ..productId = Convert.toStr(map[columnProductId])
      ..productNo = Convert.toStr(map[columnProductNo])
      ..productName = Convert.toStr(map[columnProductName])
      ..specId = Convert.toStr(map[columnSpecId])
      ..quantity = Convert.toDouble(map[columnQuantity])
      ..salePrice = Convert.toDouble(map[columnSalePrice])
      ..vipPrice = Convert.toDouble(map[columnVipPrice])
      ..addPrice = Convert.toDouble(map[columnAddPrice])
      ..isDefault = Convert.toInt(map[columnIsDefault])
      ..orderNo = Convert.toInt(map[columnOrderNo])
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
  factory SetmealGroupDetail.newSetmealGroupDetail() {
    return SetmealGroupDetail()
      ..id = "${IdWorkerUtils.getInstance().generate()}"
      ..tenantId = "${Global.instance.authc?.tenantId}"
      ..groupId = ""
      ..groupNo = ""
      ..productId = ""
      ..productNo = ""
      ..productName = ""
      ..specId = ""
      ..quantity = 0.0
      ..salePrice = 0.0
      ..vipPrice = 0.0
      ..addPrice = 0.0
      ..isDefault = 0
      ..orderNo = 0
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
  factory SetmealGroupDetail.clone(SetmealGroupDetail obj) {
    return SetmealGroupDetail()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..groupId = obj.groupId
      ..groupNo = obj.groupNo
      ..productId = obj.productId
      ..productNo = obj.productNo
      ..productName = obj.productName
      ..specId = obj.specId
      ..quantity = obj.quantity
      ..salePrice = obj.salePrice
      ..vipPrice = obj.vipPrice
      ..addPrice = obj.addPrice
      ..isDefault = obj.isDefault
      ..orderNo = obj.orderNo
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
      columnGroupId: this.groupId,
      columnGroupNo: this.groupNo,
      columnProductId: this.productId,
      columnProductNo: this.productNo,
      columnProductName: this.productName,
      columnSpecId: this.specId,
      columnQuantity: this.quantity,
      columnSalePrice: this.salePrice,
      columnVipPrice: this.vipPrice,
      columnAddPrice: this.addPrice,
      columnIsDefault: this.isDefault,
      columnOrderNo: this.orderNo,
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
  static List<SetmealGroupDetail> toList(List<Map<String, dynamic>> lists) {
    var result = new List<SetmealGroupDetail>();
    lists.forEach((map) => result.add(SetmealGroupDetail.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
