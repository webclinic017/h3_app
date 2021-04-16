import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:meta/meta.dart';

@immutable
class OrderItemPay extends Equatable {
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

  /// 商品ID
  String productId = "";

  /// 规格ID
  String specId = "";

  /// 支付记录ID
  String payId = "";

  /// 付款方式编号
  String no = "";

  /// 付款方式名称
  String name = "";

  /// 券ID 方案ID
  String couponId = "";

  /// 每张唯一的号码
  String couponNo = "";

  /// 电子券来源(plus :plus会员 ，weixin:微信)
  String sourceSign = "";

  /// 券名称
  String couponName = "";

  /// 面值-代金券
  double faceAmount = 0;

  /// 分摊的券占用金额，比如满20元可用5元，这个字段就是分摊占用的20元，因为这个是要排除后才能够计算，剩余可用券金额
  double shareCouponLeastCost = 0;

  /// 分摊金额
  double shareAmount = 0;

  /// 退款金额
  double refundAmount = 0;

  /// 订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
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

  ///是否实收(0-否;1-是;)
  int incomeFlag = 0;

  OrderItemPay();

  factory OrderItemPay.newOrderItemPay() {
    return OrderItemPay()
      ..id = ""
      ..tenantId = ""
      ..orderId = ""
      ..tradeNo = ""
      ..itemId = ""
      ..productId = ""
      ..specId = ""
      ..payId = ""
      ..no = ""
      ..name = ""
      ..couponId = ""
      ..couponNo = ""
      ..sourceSign = ""
      ..couponName = ""
      ..faceAmount = 0
      ..shareCouponLeastCost = 0
      ..refundAmount = 0
      ..shareAmount = 0
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..incomeFlag = 0;
  }

  ///转List集合
  static List<OrderItemPay> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderItemPay>();
    lists.forEach((map) => result.add(OrderItemPay.fromJson(map)));
    return result;
  }

  factory OrderItemPay.fromJson(Map<String, dynamic> map) {
    return OrderItemPay()
      ..id = Convert.toStr(map["id"])
      ..tenantId = Convert.toStr(map["tenantId"])
      ..orderId = Convert.toStr(map["orderId"])
      ..tradeNo = Convert.toStr(map["tradeNo"])
      ..itemId = Convert.toStr(map["itemId"])
      ..productId = Convert.toStr(map["productId"])
      ..specId = Convert.toStr(map["specId"])
      ..payId = Convert.toStr(map["payId"])
      ..no = Convert.toStr(map["no"])
      ..name = Convert.toStr(map["name"])
      ..couponId = Convert.toStr(map["couponId"])
      ..couponNo = Convert.toStr(map["couponNo"])
      ..sourceSign = Convert.toStr(map["sourceSign"])
      ..couponName = Convert.toStr(map["couponName"])
      ..faceAmount = Convert.toDouble(map["faceAmount"])
      ..shareCouponLeastCost = Convert.toDouble(map["shareCouponLeastCost"])
      ..refundAmount =
          Convert.toDouble(map["ramount"]) //数据库列名的坑之一，没有用refundAmount
      ..shareAmount = Convert.toDouble(map["shareAmount"])
      ..finishDate = Convert.toStr(map["finishDate"])
      ..ext1 = Convert.toStr(map["ext1"])
      ..ext2 = Convert.toStr(map["ext2"])
      ..ext3 = Convert.toStr(map["ext3"])
      ..createUser = Convert.toStr(map["createUser"])
      ..createDate = Convert.toStr(map["createDate"])
      ..modifyUser = Convert.toStr(map["modifyUser"])
      ..modifyDate = Convert.toStr(map["modifyDate"])
      ..incomeFlag = Convert.toInt(map["incomeFlag"]);
  }

  factory OrderItemPay.clone(OrderItemPay obj) {
    return OrderItemPay()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..orderId = obj.orderId
      ..tradeNo = obj.tradeNo
      ..itemId = obj.itemId
      ..productId = obj.productId
      ..specId = obj.specId
      ..payId = obj.payId
      ..no = obj.no
      ..name = obj.name
      ..couponId = obj.couponId
      ..couponNo = obj.couponNo
      ..sourceSign = obj.sourceSign
      ..couponName = obj.couponName
      ..faceAmount = obj.faceAmount
      ..shareCouponLeastCost = obj.shareCouponLeastCost
      ..refundAmount = obj.refundAmount
      ..shareAmount = obj.shareAmount
      ..finishDate = obj.finishDate
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..incomeFlag = obj.incomeFlag;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "tenantId": this.tenantId,
      "orderId": this.orderId,
      "tradeNo": this.tradeNo,
      "itemId ": this.itemId,
      "productId": this.productId,
      "specId": this.specId,
      "payId": this.payId,
      "no": this.no,
      "name": this.name,
      "couponId": this.couponId,
      "couponNo": this.couponNo,
      "sourceSign": this.sourceSign,
      "couponName": this.couponName,
      "faceAmount": this.faceAmount,
      "shareCouponLeastCost": this.shareCouponLeastCost,
      "refundAmount": this.refundAmount,
      "shareAmount": this.shareAmount,
      "finishDate": this.finishDate,
      "ext1": this.ext1,
      "ext2": this.ext2,
      "ext3": this.ext3,
      "createUser": this.createUser,
      "createDate": this.createDate,
      "modifyUser": this.modifyUser,
      "modifyDate": this.modifyDate,
      "incomeFlag": this.incomeFlag,
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
        this.productId,
        this.specId,
        this.payId,
        this.no,
        this.name,
        this.couponId,
        this.couponNo,
        this.couponName,
        this.sourceSign,
        this.faceAmount,
        this.shareCouponLeastCost,
        this.shareAmount,
        this.refundAmount,
        this.finishDate,
        this.ext1,
        this.ext2,
        this.ext3,
        this.createUser,
        this.createDate,
        this.modifyUser,
        this.modifyDate,
        this.incomeFlag,
      ];
}
