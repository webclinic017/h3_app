import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-26 08:50:59
class PromotionProduct extends BaseEntity {
  ///表名称
  static final String tableName = "pos_promotion_product";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnPromotionId = "promotionId";
  static final String columnPromotionSn = "promotionSn";
  static final String columnProductId = "productId";
  static final String columnSpecId = "specId";
  static final String columnLowerAmountLimit = "lowerAmountLimit";
  static final String columnLowerQuantityLimit = "lowerQuantityLimit";
  static final String columnSpecialPrice = "specialPrice";
  static final String columnDiscount = "discount";
  static final String columnAmount = "amount";
  static final String columnOrderNumLimit = "orderNumLimit";
  static final String columnGiftProNumLimit = "giftProNumLimit";
  static final String columnGiftProAmountLimit = "giftProAmountLimit";
  static final String columnGroupNo = "groupNo";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String promotionId;
  String promotionSn;
  String productId;
  String specId;
  double lowerAmountLimit;
  double lowerQuantityLimit;
  double specialPrice;
  double discount;
  double amount;
  double orderNumLimit;
  double giftProNumLimit;
  double giftProAmountLimit;
  String groupNo;

  ///默认构造
  PromotionProduct();

  ///Map转实体对象
  factory PromotionProduct.fromMap(Map<String, dynamic> map) {
    return PromotionProduct()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..promotionId = Convert.toStr(map[columnPromotionId])
      ..promotionSn = Convert.toStr(map[columnPromotionSn])
      ..productId = Convert.toStr(map[columnProductId])
      ..specId = Convert.toStr(map[columnSpecId])
      ..lowerAmountLimit = Convert.toDouble(map[columnLowerAmountLimit])
      ..lowerQuantityLimit = Convert.toDouble(map[columnLowerQuantityLimit])
      ..specialPrice = Convert.toDouble(map[columnSpecialPrice])
      ..discount = Convert.toDouble(map[columnDiscount])
      ..amount = Convert.toDouble(map[columnAmount])
      ..orderNumLimit = Convert.toDouble(map[columnOrderNumLimit])
      ..giftProNumLimit = Convert.toDouble(map[columnGiftProNumLimit])
      ..giftProAmountLimit = Convert.toDouble(map[columnGiftProAmountLimit])
      ..groupNo = Convert.toStr(map[columnGroupNo])
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
  factory PromotionProduct.newPromotionProduct() {
    return PromotionProduct()
      ..id = "${IdWorkerUtils.getInstance().generate()}"
      ..tenantId = "${Global.instance.authc?.tenantId}"
      ..promotionId = ""
      ..promotionSn = ""
      ..productId = ""
      ..specId = ""
      ..lowerAmountLimit = 0.0
      ..lowerQuantityLimit = 0.0
      ..specialPrice = 0.0
      ..discount = 0.0
      ..amount = 0.0
      ..orderNumLimit = 0.0
      ..giftProNumLimit = 0.0
      ..giftProAmountLimit = 0.0
      ..groupNo = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = Constants.DEFAULT_MODIFY_USER
      ..modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
  }

  ///复制新对象
  factory PromotionProduct.clone(PromotionProduct obj) {
    return PromotionProduct()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..promotionId = obj.promotionId
      ..promotionSn = obj.promotionSn
      ..productId = obj.productId
      ..specId = obj.specId
      ..lowerAmountLimit = obj.lowerAmountLimit
      ..lowerQuantityLimit = obj.lowerQuantityLimit
      ..specialPrice = obj.specialPrice
      ..discount = obj.discount
      ..amount = obj.amount
      ..orderNumLimit = obj.orderNumLimit
      ..giftProNumLimit = obj.giftProNumLimit
      ..giftProAmountLimit = obj.giftProAmountLimit
      ..groupNo = obj.groupNo
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
      columnPromotionId: this.promotionId,
      columnPromotionSn: this.promotionSn,
      columnProductId: this.productId,
      columnSpecId: this.specId,
      columnLowerAmountLimit: this.lowerAmountLimit,
      columnLowerQuantityLimit: this.lowerQuantityLimit,
      columnSpecialPrice: this.specialPrice,
      columnDiscount: this.discount,
      columnAmount: this.amount,
      columnOrderNumLimit: this.orderNumLimit,
      columnGiftProNumLimit: this.giftProNumLimit,
      columnGiftProAmountLimit: this.giftProAmountLimit,
      columnGroupNo: this.groupNo,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
    };
    return map;
  }

  ///Map转List对象
  static List<PromotionProduct> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PromotionProduct>();
    lists.forEach((map) => result.add(PromotionProduct.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
