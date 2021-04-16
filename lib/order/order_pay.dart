import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/enums/order_payment_status_type.dart';
import 'package:h3_app/enums/pay_channel_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/member/member_elec_coupon.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:meta/meta.dart';

import 'order_object.dart';

@immutable
class OrderPay {
  ///订单ID
  String id = "";

  ///租户编码
  String tenantId = "";

  ///订单Id
  String orderId = "";

  ///订单号
  String tradeNo = "";

  ///行序号
  int orderNo = 1;

  ///原单号，退款单使用
  String orgPayId = "";

  ///付款方式编号
  String no = "";

  ///付款方式名称
  String name = "";

  ///券ID
  String couponId = "";

  ///每张券唯一的号码
  String couponNo = "";

  ///电子券来源(plus :plus会员 ，weixin:微信)
  String sourceSign = "";

  ///券名称
  String couponName = "";

  ///应收金额 当前订单应收金额
  double amount = 0;

  ///收银员录入金额
  double inputAmount = 0;

  ///面值-代金券
  double faceAmount = 0;

  ///实收金额
  double paidAmount = 0;

  ///退款金额
  double refundAmount = 0;

  ///溢收金额
  double overAmount = 0;

  ///找零金额
  double changeAmount = 0;

  ///券占用金额，比如满20元可用5元，这个字段就是占用的20元
  double couponLeastCost = 0;

  ///平台优惠
  double platformDiscount = 0;

  ///平台实付
  double platformPaid = 0;

  ///支付单号
  String payNo = "";

  ///预支付单号
  String prePayNo = "";

  ///渠道单号
  String channelNo = "";

  ///最终支付平台订单号
  String voucherNo = "";

  ///支付状态
  OrderPaymentStatus status = OrderPaymentStatus.None;

  ///支付状态描述
  String statusDesc = "";

  ///是否订阅微信公众号
  int subscribe = 0;

  ///用户是否确认输入密码
  int useConfirmed = 0;

  ///支付密码
  String password = "";

  ///平台用户名
  String accountName = "";

  ///付款银行
  String bankType = "";

  ///备注说明
  String memo = "";

  ///支付时间(格式:yyyy-MM-dd HH:mm:ss)
  String payTime =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///支付渠道 区分各种聚合支付、原生支付
  PayChannelEnum payChannel = PayChannelEnum.None;

  ///是否参与积分(0-否;1-是;)
  int pointFlag = 0;

  ///是否实收(0-否;1-是;)
  int incomeFlag = 0;

  ///付款卡号
  String cardNo = "";

  ///卡支付前余额
  double cardPreAmount = 0;

  ///刷卡后金额
  double cardAftAmount = 0;

  ///卡变动金额
  double cardChangeAmount = 0;

  ///卡支付前积分
  double cardPrePoint = 0;

  ///卡变动积分
  double cardChangePoint = 0;

  ///卡支付后积分
  double cardAftPoint = 0;

  ///会员卡手机号
  String memberMobileNo = "";

  ///会员ID
  String memberId = "";

  ///会员卡卡面号
  String cardFaceNo = "";

  ///积分兑换金额比例
  double pointAmountRate = 0;

  ///班次ID
  String shiftId = "";

  ///班次编号
  String shiftNo = "";

  ///班次名称
  String shiftName = "";

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

  /// 代金券
  MemberElecCoupon coupon;

  OrderPay();

  factory OrderPay.fromPayMode(OrderObject orderObject, PayMode payMode) {
    return OrderPay()
      ..id = IdWorkerUtils.getInstance().generate().toString()
      ..tenantId = Global.instance.authc?.tenantId
      ..orderId = orderObject.id
      ..tradeNo = orderObject.tradeNo
      ..orderNo = orderObject.pays.length + 1
      ..orgPayId = ""
      ..no = payMode.no
      ..name = payMode.name
      ..couponId = ""
      ..couponNo = ""
      ..couponName = ""
      ..sourceSign = Constants.TERMINAL_TYPE
      ..amount = 0
      ..inputAmount = 0
      ..faceAmount = 0
      ..paidAmount = 0
      ..refundAmount = 0
      ..overAmount = 0
      ..changeAmount = 0
      ..couponLeastCost = 0
      ..platformPaid = 0
      ..platformDiscount = 0
      ..payNo = ""
      ..prePayNo = ""
      ..channelNo = ""
      ..voucherNo = ""
      ..status = OrderPaymentStatus.NonPayment
      ..statusDesc = ""
      ..subscribe = 0
      ..useConfirmed = 0
      ..password = ""
      ..accountName = ""
      ..bankType = ""
      ..memo = ""
      ..payTime =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..payChannel = PayChannelEnum.None
      ..incomeFlag = payMode.incomeFlag
      ..pointFlag = payMode.pointFlag
      ..cardNo = ""
      ..cardPreAmount = 0
      ..cardAftAmount = 0
      ..cardChangeAmount = 0
      ..cardPrePoint = 0
      ..cardChangePoint = 0
      ..cardAftPoint = 0
      ..memberMobileNo = ""
      ..memberId = ""
      ..cardFaceNo = ""
      ..pointAmountRate = 0
      ..shiftId = orderObject.shiftId
      ..shiftNo = orderObject.shiftNo
      ..shiftName = orderObject.shiftName
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///转List集合
  static List<OrderPay> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderPay>();
    lists.forEach((map) => result.add(OrderPay.fromJson(map)));
    return result;
  }

  factory OrderPay.fromJson(Map<String, dynamic> map) {
    return OrderPay()
      ..id = Convert.toStr(map["id"])
      ..tenantId = Convert.toStr(map["tenantId"])
      ..orderId = Convert.toStr(map["orderId"])
      ..tradeNo = Convert.toStr(map["tradeNo"])
      ..orderNo = Convert.toInt(map["orderNo"])
      ..orgPayId = Convert.toStr(map["orgPayId"])
      ..no = Convert.toStr(map["no"])
      ..name = Convert.toStr(map["name"])
      ..couponId = Convert.toStr(map["couponId"])
      ..couponNo = Convert.toStr(map["couponNo"])
      ..sourceSign = Convert.toStr(map["sourceSign"])
      ..couponName = Convert.toStr(map["couponName"])
      ..amount = Convert.toDouble(map["amount"])
      ..inputAmount = Convert.toDouble(map["inputAmount"])
      ..faceAmount = Convert.toDouble(map["faceAmount"])
      ..paidAmount = Convert.toDouble(map["paidAmount"])
      ..refundAmount =
          Convert.toDouble(map["ramount"]) //数据库设计的坑，字段不是refundAmount
      ..overAmount = Convert.toDouble(map["overAmount"])
      ..changeAmount = Convert.toDouble(map["changeAmount"])
      ..couponLeastCost = Convert.toDouble(map["couponLeastCost"])
      ..platformDiscount = Convert.toDouble(map["platformDiscount"])
      ..platformPaid = Convert.toDouble(map["platformPaid"])
      ..payNo = Convert.toStr(map["payNo"])
      ..prePayNo = Convert.toStr(map["prePayNo"])
      ..channelNo = Convert.toStr(map["channelNo"])
      ..voucherNo = Convert.toStr(map["voucherNo"])
      ..status = OrderPaymentStatus.fromValue(Convert.toStr(map["status"]))
      ..statusDesc = Convert.toStr(map["statusDesc"])
      ..subscribe = Convert.toInt(map["subscribe"])
      ..useConfirmed = Convert.toInt(map["useConfirmed"])
      ..password = Convert.toStr(map["password"])
      ..accountName = Convert.toStr(map["accountName"])
      ..bankType = Convert.toStr(map["bankType"])
      ..payTime = Convert.toStr(map["payTime"])
      ..payChannel = PayChannelEnum.fromValue(Convert.toStr(map["payChannel"]))
      ..finishDate = Convert.toStr(map["finishDate"])
      ..pointFlag = Convert.toInt(map["pointFlag"])
      ..incomeFlag = Convert.toInt(map["incomeFlag"])
      ..cardNo = Convert.toStr(map["cardNo"])
      ..cardPreAmount = Convert.toDouble(map["cardPreAmount"])
      ..cardAftAmount = Convert.toDouble(map["cardAftAmount"])
      ..cardPrePoint = Convert.toDouble(map["cardPrePoint"])
      ..cardAftPoint = Convert.toDouble(map["cardAftPoint"])
      ..cardChangeAmount = Convert.toDouble(map["cardChangeAmount"])
      ..cardChangePoint = Convert.toDouble(map["cardChangePoint"])
      ..cardFaceNo = Convert.toStr(map["cardFaceNo"])
      ..memberId = Convert.toStr(map["memberId"])
      ..memberMobileNo = Convert.toStr(map["memberMobileNo"])
      ..pointAmountRate = Convert.toDouble(map["pointAmountRate"])
      ..shiftId = Convert.toStr(map["shiftId"])
      ..shiftNo = Convert.toStr(map["shiftNo"])
      ..shiftName = Convert.toStr(map["shiftName"])
      ..memo = Convert.toStr(map["memo"])
      ..ext1 = Convert.toStr(map["ext1"])
      ..ext2 = Convert.toStr(map["ext2"])
      ..ext3 = Convert.toStr(map["ext3"])
      ..createUser = Convert.toStr(map["createUser"])
      ..createDate = Convert.toStr(map["createDate"])
      ..modifyUser = Convert.toStr(map["modifyUser"])
      ..modifyDate = Convert.toStr(map["modifyDate"]);
  }

  factory OrderPay.clone(OrderPay obj) {
    return OrderPay()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..orderId = obj.orderId
      ..tradeNo = obj.tradeNo
      ..orderNo = obj.orderNo
      ..orgPayId = obj.orgPayId
      ..no = obj.no
      ..name = obj.name
      ..couponId = obj.couponId
      ..couponNo = obj.couponNo
      ..sourceSign = obj.sourceSign
      ..couponName = obj.couponName
      ..amount = obj.amount
      ..inputAmount = obj.inputAmount
      ..faceAmount = obj.faceAmount
      ..paidAmount = obj.paidAmount
      ..refundAmount = obj.refundAmount
      ..overAmount = obj.overAmount
      ..changeAmount = obj.changeAmount
      ..couponLeastCost = obj.couponLeastCost
      ..platformDiscount = obj.platformDiscount
      ..platformPaid = obj.platformPaid
      ..payNo = obj.payNo
      ..prePayNo = obj.prePayNo
      ..channelNo = obj.channelNo
      ..voucherNo = obj.voucherNo
      ..status = obj.status
      ..statusDesc = obj.statusDesc
      ..subscribe = obj.subscribe
      ..useConfirmed = obj.useConfirmed
      ..password = obj.password
      ..accountName = obj.accountName
      ..bankType = obj.bankType
      ..payTime = obj.payTime
      ..payChannel = obj.payChannel
      ..finishDate = obj.finishDate
      ..pointFlag = obj.pointFlag
      ..incomeFlag = obj.incomeFlag
      ..cardNo = obj.cardNo
      ..cardPreAmount = obj.cardPreAmount
      ..cardAftAmount = obj.cardAftAmount
      ..cardPrePoint = obj.cardPrePoint
      ..cardAftPoint = obj.cardAftPoint
      ..cardChangeAmount = obj.changeAmount
      ..cardChangePoint = obj.cardChangePoint
      ..cardFaceNo = obj.cardFaceNo
      ..memberId = obj.memberId
      ..memberMobileNo = obj.memberMobileNo
      ..pointAmountRate = obj.pointAmountRate
      ..shiftId = obj.shiftId
      ..shiftNo = obj.shiftNo
      ..shiftName = obj.shiftName
      ..memo = obj.memo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///构建空对象
  factory OrderPay.newOrderPay() {
    return OrderPay()
      ..id = ""
      ..tenantId = ""
      ..tradeNo = ""
      ..orderId = ""
      ..orgPayId = ""
      ..orderNo = 0
      ..no = ""
      ..name = ""
      ..amount = 0
      ..inputAmount = 0
      ..faceAmount = 0
      ..paidAmount = 0
      ..refundAmount = 0
      ..overAmount = 0
      ..changeAmount = 0
      ..platformDiscount = 0
      ..platformPaid = 0
      ..payNo = ""
      ..prePayNo = ""
      ..channelNo = ""
      ..voucherNo = ""
      ..status = OrderPaymentStatus.None
      ..statusDesc = ""
      ..payTime = ""
      ..finishDate = ""
      ..payChannel = PayChannelEnum.None
      ..incomeFlag = 0
      ..pointFlag = 0
      ..subscribe = 0
      ..useConfirmed = 0
      ..accountName = ""
      ..bankType = ""
      ..memo = ""
      ..cardNo = ""
      ..cardPreAmount = 0
      ..cardChangeAmount = 0
      ..cardAftAmount = 0
      ..cardPrePoint = 0
      ..cardChangePoint = 0
      ..cardAftPoint = 0
      ..memberMobileNo = ""
      ..cardFaceNo = ""
      ..pointAmountRate = 0
      ..shiftId = ""
      ..shiftNo = ""
      ..shiftName = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..couponId = ""
      ..couponNo = ""
      ..couponName = ""
      ..couponLeastCost = 0
      ..sourceSign = "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "tenantId": this.tenantId,
      "orderId": this.orderId,
      "tradeNo": this.tradeNo,
      "orderNo": this.orderNo,
      "orgPayId": this.orgPayId,
      "no": this.no,
      "name": this.name,
      "couponId": this.couponId,
      "couponNo": this.couponNo,
      "sourceSign": this.sourceSign,
      "couponName": this.couponName,
      "amount": this.amount,
      "inputAmount": this.inputAmount,
      "faceAmount": this.faceAmount,
      "paidAmount": this.paidAmount,
      "refundAmount": this.refundAmount,
      "overAmount": this.overAmount,
      "changeAmount": this.changeAmount,
      "couponLeastCost": this.couponLeastCost,
      "platformDiscount": this.platformDiscount,
      "platformPaid": this.platformPaid,
      "payNo": this.payNo,
      "prePayNo": this.prePayNo,
      "channelNo": this.channelNo,
      "voucherNo": this.voucherNo,
      "status": this.status.value,
      "statusDesc": this.statusDesc,
      "subscribe": this.subscribe,
      "useConfirmed": this.useConfirmed,
      "password": this.password,
      "accountName": this.accountName,
      "bankType": this.bankType,
      "memo": this.memo,
      "payTime": this.payTime,
      "finishDate": this.finishDate,
      "payChannel": this.payChannel.value,
      "pointFlag": this.pointFlag,
      "incomeFlag": this.incomeFlag,
      "cardNo": this.cardNo,
      "cardPreAmount": this.cardPreAmount,
      "cardAftAmount": this.cardAftAmount,
      "cardChangeAmount": this.cardChangeAmount,
      "cardPrePoint": this.cardPrePoint,
      "cardChangePoint": this.cardChangePoint,
      "cardAftPoint": this.cardAftPoint,
      "memberMobileNo": this.memberMobileNo,
      "memberId": this.memberId,
      "cardFaceNo": this.cardFaceNo,
      "pointAmountRate": this.pointAmountRate,
      "shiftId": this.shiftId,
      "shiftNo": this.shiftNo,
      "shiftName": this.shiftName,
      "ext1": this.ext1,
      "ext2": this.ext2,
      "ext3": this.ext3,
      "createUser": this.createUser,
      "createDate": this.createDate,
      "modifyUser": this.modifyUser,
      "modifyDate": this.modifyDate,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
