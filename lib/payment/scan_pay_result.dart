import 'dart:convert';

import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/enums/pay_channel_type.dart';
import 'package:h3_app/payment/saobei/saobei_payment_result.dart';
import 'package:h3_app/payment/saobei/saobei_query_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_payment_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_query_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_refund_result.dart';
import 'package:h3_app/utils/converts.dart';

import 'leshua/leshua_payment_result.dart';
import 'leshua/leshua_query_result.dart';
import 'leshua_pay_utils.dart';

class ScanPayResult {
  /// 是否支付成功
  bool success = false;

  /// 业务单号
  String tradeNo = "";

  /// 支付单号，收银系统单号
  String payNo = "";

  /// 收款金额
  double paidAmount = 0;

  /// 平台实付，和平台优惠配合使用
  double platformPaid = 0;

  /// 平台优惠金额
  double platformDiscount = 0;

  /// 支付方式
  String payType = "";

  /// 支付渠道
  PayChannelEnum payChannel = PayChannelEnum.None;

  /// 最终支付方订单号（微信、支付宝平台）
  String voucherNo = "";

  /// 中间渠道的订单号
  String channelNo = "";

  /// 是否关注公众账号
  int subscribe = 0;

  /// 支付银行、支付宝、微信使用的付款渠道
  String bankType = "";

  /// 用户,第三方支付账户
  String accountName = "";

  /// 平台返回状态
  String statusDesc = "";

  /// 支付时间
  String payTime = "";

  ScanPayResult();

  factory ScanPayResult.fromLeShuaPaymentResult(
      LeShuaPaymentResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.status == "2");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.third_order_id
      ..paidAmount = success ? Convert.toDouble(obj.settlement_amount) / 100 : 0
      ..platformPaid =
          success ? Convert.toDouble(obj.buyer_pay_amount) / 100 : 0
      ..platformDiscount =
          success ? Convert.toDouble(obj.discount_amount) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.LeshuaPay
      ..voucherNo = obj.out_transaction_id
      ..channelNo = obj.leshua_order_id
      ..subscribe = 0
      ..bankType = obj.bank_type
      ..accountName = obj.openid
      ..statusDesc = LeshuaPayUtils.getStatus(obj.status).item2
      ..payTime = obj.pay_time;
  }

  factory ScanPayResult.fromLeShuaQueryResult(
      LeShuaQueryResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.status == "2");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.third_order_id
      ..paidAmount = success ? Convert.toDouble(obj.settlement_amount) / 100 : 0
      ..platformPaid =
          success ? Convert.toDouble(obj.buyer_pay_amount) / 100 : 0
      ..platformDiscount =
          success ? Convert.toDouble(obj.discount_amount) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.LeshuaPay
      ..voucherNo = obj.out_transaction_id
      ..channelNo = obj.leshua_order_id
      ..subscribe = 0
      ..bankType = obj.bank_type
      ..accountName = obj.openid
      ..statusDesc = LeshuaPayUtils.getStatus(obj.status).item2
      ..payTime = obj.pay_time;
  }

  factory ScanPayResult.fromSaobeiPaymentResult(
      SaobeiPaymentResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.result_code == "01" || obj.result_code == "03");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.terminal_trace
      ..paidAmount = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..platformDiscount = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.SaobeiPay
      ..voucherNo = obj.channel_order_no
      ..channelNo = obj.channel_trade_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = obj.user_id
      ..statusDesc = obj.return_msg
      ..payTime = obj.terminal_time;
  }

  factory ScanPayResult.fromSaobeiQueryResult(
      SaobeiQueryResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.result_code == "01");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.terminal_trace
      ..paidAmount = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..platformDiscount = success ? Convert.toDouble(obj.total_fee) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.SaobeiPay
      ..voucherNo = obj.channel_order_no
      ..channelNo = obj.channel_trade_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = obj.user_id
      ..statusDesc = "${obj.return_msg}<${obj.trade_state}>"
      ..payTime = obj.terminal_time;
  }

  factory ScanPayResult.fromSaobeiRefundResult(
      SaobeiPaymentResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.result_code == "01" || obj.result_code == "03");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.terminal_trace
      ..paidAmount = success ? Convert.toDouble(obj.refund_fee) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.refund_fee) / 100 : 0
      ..platformDiscount = success ? Convert.toDouble(obj.refund_fee) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.SaobeiPay
      ..voucherNo = obj.channel_refund_no
      ..channelNo = obj.channel_refund_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = obj.user_id
      ..statusDesc = obj.return_msg
      ..payTime = obj.terminal_time;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "success": this.success,
      "tradeNo": this.tradeNo,
      "payNo": this.payNo,
      "paidAmount": this.paidAmount,
      "platformPaid": this.platformPaid,
      "platformDiscount ": this.platformDiscount,
      "payType": this.payType,
      "payChannel": payChannel.name,
      "voucherNo": this.voucherNo,
      "channelNo": this.channelNo,
      "subscribe": this.subscribe,
      "bankType": this.bankType,
      "accountName": this.accountName,
      "statusDesc": this.statusDesc,
      "payTime": this.payTime,
    };

    return map;
  }

  factory ScanPayResult.fromXiaobeiPaymentResult(
      XiaobeiPaymentResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.errcode == "0");

    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.out_no
      ..paidAmount = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformDiscount =
          success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.JCRCB
      ..voucherNo = obj.ord_no
      ..channelNo = obj.trade_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = obj.trade_account
      ..statusDesc = obj.msg
      ..payTime = obj.trade_pay_time;
  }

  factory ScanPayResult.fromXiaoaobeiQueryResult(
      XiaobeiQueryResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.errcode == "0");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.out_no
      ..paidAmount = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformDiscount =
          success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.JCRCB
      ..voucherNo = obj.ord_no
      ..channelNo = obj.trade_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = obj.trade_account
      ..statusDesc = obj.msg
      ..payTime = obj.trade_pay_time;
  }

  factory ScanPayResult.fromXiaobeiRefundResult(
      XiaobeiRefundResult obj, String tradeNo, PayMode payMode) {
    bool success = (obj.errcode == "0");
    return ScanPayResult()
      ..success = success
      ..tradeNo = tradeNo
      ..payNo = obj.ord_no
      ..paidAmount = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformPaid = success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..platformDiscount =
          success ? Convert.toDouble(obj.trade_amount) / 100 : 0
      ..payType = payMode.no /**这里需要支付方式编号*/
      ..payChannel = PayChannelEnum.JCRCB
      ..voucherNo = obj.ord_no
      ..channelNo = obj.original_ord_no
      ..subscribe = 0
      ..bankType = ""
      ..accountName = ""
      ..statusDesc = obj.msg
      ..payTime = obj.trade_time;
  }
  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
