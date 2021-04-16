import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/enums/promotion_type.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:meta/meta.dart';

@immutable
class OrderPromotion extends Equatable {
  ///订单ID
  String id = "";

  ///租户编码
  String tenantId = "";

  ///订单Id
  String orderId = "";

  ///订单号
  String tradeNo = "";

  /// 订单明细ID
  String itemId = "";

  /// 是否线上促销
  int onlineFlag = 0;

  /// 促销方案
  PromotionType promotionType = PromotionType.None;

  /// 促销原因
  String reason = "";

  /// 档期ID
  String scheduleId = "";

  /// 档期编号
  String scheduleSn = "";

  /// 促销方案ID
  String promotionId = "";

  /// 促销方案编号
  String promotionSn = "";

  /// 促销模式 D:折扣；T:特价；F：买满送；
  String promotionMode = "";

  /// 促销范围类型 A、全场；C、分类；B、品牌；P、商品；CAB、分类下的品牌；COB、分类或品牌；
  String scopeType = "";

  /// 促销方案名称
  String promotionPlan = "";

  /// 优惠前价格
  double price = 0;

  /// 优惠后价格
  double bargainPrice = 0;

  /// 优惠前的金额
  double amount = 0;

  /// 优惠金额
  double discountAmount = 0;

  /// 优惠后的金额
  double receivableAmount = 0;

  /// 优惠率
  double discountRate = 0;

  /// 是否启用该优惠
  int enabled = 0;

  /// 整单优惠分摊对应的关系
  String relationId = "";

  /// 券ID
  String couponId = "";

  /// 券号
  String couponNo = "";

  /// 电子券来源(plus :plus会员 ，weixin:微信)
  String sourceSign = "";

  /// 券名称
  String couponName = "";

  /// 订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 优惠截止时间(格式:yyyy-MM-dd HH:mm:ss)  做商品展示、加入购物车，判断商品特价使用，沒有入库
  String limitDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 扩展信息1
  String ext1 = "";

  /// 扩展信息2
  String ext2 = "";

  /// 扩展信息3
  String ext3 = "";

  ///创建人
  String createUser = Constants.DEFAULT_CREATE_USER;

  ///创建日期
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///修改人
  String modifyUser = Constants.DEFAULT_MODIFY_USER;

  ///修改日期
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 调整金额，用于单品议价、整单议价，为了达到想要的金额，这里存储之间的差额，
  /// 调整金额 = 本应分摊金额 - 实际分摊金额。在计算本行优惠金额的时候，需要+调整金额
  double adjustAmount = 0;

  OrderPromotion();

  factory OrderPromotion.newOrderPromotion() {
    return OrderPromotion()
      ..id = ""
      ..tenantId = ""
      ..orderId = ""
      ..tradeNo = ""
      ..itemId = ""
      ..onlineFlag = 0
      ..promotionType = PromotionType.None
      ..reason = ""
      ..scheduleId = ""
      ..scheduleSn = ""
      ..promotionId = ""
      ..promotionSn = ""
      ..promotionMode = ""
      ..scopeType = ""
      ..promotionPlan = ""
      ..price = 0
      ..bargainPrice = 0
      ..amount = 0
      ..discountAmount = 0
      ..receivableAmount = 0
      ..discountRate = 0
      ..enabled = 0
      ..relationId = ""
      ..couponId = ""
      ..couponNo = ""
      ..sourceSign = ""
      ..couponName = ""
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..limitDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..adjustAmount = 0;
  }

  ///转List集合
  static List<OrderPromotion> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderPromotion>();
    lists.forEach((map) => result.add(OrderPromotion.fromJson(map)));
    return result;
  }

  factory OrderPromotion.fromJson(Map<String, dynamic> map) {
    return OrderPromotion()
      ..id = Convert.toStr(map["id"])
      ..tenantId = Convert.toStr(map["tenantId"])
      ..orderId = Convert.toStr(map["orderId"])
      ..tradeNo = Convert.toStr(map["tradeNo"])
      ..itemId = Convert.toStr(map["itemId"])
      ..onlineFlag = Convert.toInt(map["onlineFlag"])
      ..promotionType =
          PromotionType.fromValue(Convert.toStr(map["promotionType"]))
      ..reason = Convert.toStr(map["reason"])
      ..scheduleId = Convert.toStr(map["scheduleId"])
      ..scheduleSn = Convert.toStr(map["scheduleSn"])
      ..promotionId = Convert.toStr(map["promotionId"])
      ..promotionSn = Convert.toStr(map["promotionSn"])
      ..promotionMode = Convert.toStr(map["promotionMode"])
      ..scopeType = Convert.toStr(map["scopeType"])
      ..promotionPlan = Convert.toStr(map["promotionPlan"])
      ..price = Convert.toDouble(map["price"])
      ..bargainPrice = Convert.toDouble(map["bargainPrice"])
      ..amount = Convert.toDouble(map["amount"])
      ..discountAmount = Convert.toDouble(map["discountAmount"])
      ..receivableAmount = Convert.toDouble(map["receivableAmount"])
      ..discountRate = Convert.toDouble(map["discountRate"])
      ..enabled = Convert.toInt(map["enabled"])
      ..relationId = Convert.toStr(map["relationId"])
      ..couponId = Convert.toStr(map["couponId"])
      ..couponNo = Convert.toStr(map["couponNo"])
      ..sourceSign = Convert.toStr(map["sourceSign"])
      ..couponName = Convert.toStr(map["couponName"])
      ..limitDate = Convert.toStr(map["limitDate"])
      ..finishDate = Convert.toStr(map["finishDate"])
      ..ext1 = Convert.toStr(map["ext1"])
      ..ext2 = Convert.toStr(map["ext2"])
      ..ext3 = Convert.toStr(map["ext3"])
      ..createUser = Convert.toStr(map["createUser"])
      ..createDate = Convert.toStr(map["createDate"])
      ..modifyUser = Convert.toStr(map["modifyUser"])
      ..modifyDate = Convert.toStr(map["modifyDate"]);
  }

  factory OrderPromotion.clone(OrderPromotion obj) {
    return OrderPromotion()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..orderId = obj.orderId
      ..tradeNo = obj.tradeNo
      ..itemId = obj.itemId
      ..onlineFlag = obj.onlineFlag
      ..promotionType = obj.promotionType
      ..reason = obj.reason
      ..scheduleId = obj.scheduleId
      ..scheduleSn = obj.scheduleSn
      ..promotionId = obj.promotionId
      ..promotionSn = obj.promotionSn
      ..promotionMode = obj.promotionMode
      ..scopeType = obj.scopeType
      ..promotionPlan = obj.promotionPlan
      ..price = obj.price
      ..bargainPrice = obj.bargainPrice
      ..amount = obj.amount
      ..discountAmount = obj.discountAmount
      ..receivableAmount = obj.receivableAmount
      ..discountRate = obj.discountRate
      ..enabled = obj.enabled
      ..relationId = obj.relationId
      ..couponId = obj.couponId
      ..couponNo = obj.couponNo
      ..sourceSign = obj.sourceSign
      ..couponName = obj.couponName
      ..limitDate = obj.limitDate
      ..finishDate = obj.finishDate
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..adjustAmount = obj.adjustAmount;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "tenantId": this.tenantId,
      "orderId": this.orderId,
      "tradeNo": this.tradeNo,
      "itemId ": this.itemId,
      "onlineFlag": this.onlineFlag,
      "promotionType": this.promotionType.value,
      "reason": this.reason,
      "scheduleId": this.scheduleId,
      "scheduleSn": this.scheduleSn,
      "promotionId": this.promotionId,
      "promotionSn": this.promotionSn,
      "promotionMode": this.promotionMode,
      "scopeType": this.scopeType,
      "promotionPlan": this.promotionPlan,
      "price": this.price,
      "bargainPrice": this.bargainPrice,
      "amount": this.amount,
      "discountAmount": this.discountAmount,
      "receivableAmount": this.receivableAmount,
      "discountRate": this.discountRate,
      "enabled": this.enabled,
      "relationId": this.relationId,
      "couponId": this.couponId,
      "couponNo": this.couponNo,
      "sourceSign": this.sourceSign,
      "couponName": this.couponName,
      "finishDate": this.finishDate,
      "limitDate": this.limitDate,
      "ext1": this.ext1,
      "ext2": this.ext2,
      "ext3": this.ext3,
      "createUser": this.createUser,
      "createDate": this.createDate,
      "modifyUser": this.modifyUser,
      "modifyDate": this.modifyDate,
      "adjustAmount": this.adjustAmount,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.id,
        this.tenantId,
        this.orderId,
        this.tradeNo,
        this.itemId,
        this.onlineFlag,
        this.promotionType,
        this.reason,
        this.scheduleId,
        this.scheduleSn,
        this.promotionId,
        this.promotionSn,
        this.promotionMode,
        this.scopeType,
        this.promotionPlan,
        this.price,
        this.bargainPrice,
        this.amount,
        this.discountAmount,
        this.receivableAmount,
        this.discountRate,
        this.enabled,
        this.relationId,
        this.couponId,
        this.couponNo,
        this.couponName,
        this.sourceSign,
        this.finishDate,
        this.limitDate,
        this.ext1,
        this.ext2,
        this.ext3,
        this.createUser,
        this.createDate,
        this.modifyUser,
        this.modifyDate,
        this.adjustAmount,
      ];
}
