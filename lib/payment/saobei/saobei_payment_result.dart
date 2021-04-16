import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class SaobeiPaymentResult {
  /// 响应码：01成功 ，02失败，响应码仅代表通信状态，不代表业务结果
  String return_code = "";

  /// 返回信息提示，“支付成功”，“支付中”，“请求受限”等
  String return_msg = "";

  /// 签名字符串,拼装所有传递参数，UTF-8编码，32位md5加密转换
  String key_sign = "";

  /// 业务结果：01成功 02失败 ，03支付中，99该条码暂不支持支付类型自动匹配
  String result_code = "";

  /// 请求类型，010微信，020 支付宝，060qq钱包，080京东钱包，090口碑，100翼支付，110银联二维码
  String pay_type = "";

  /// 商户名称
  String merchant_name = "";

  /// 商户号
  String merchant_no = "";

  /// 终端号
  String terminal_id = "";

  /// 终端流水号，商户系统的订单号，扫呗系统原样返回
  String terminal_trace = "";

  /// 终端交易时间，yyyyMMddHHmmss，全局统一时间格式
  String terminal_time = "";

  /// 金额，单位分
  String total_fee = "";

  /// 支付完成时间，yyyyMMddHHmmss，全局统一时间格式
  String end_time = "";

  /// 利楚唯一订单号
  String out_trade_no = "";

  /// 通道订单号，微信订单号、支付宝订单号等，返回时不参与签名
  String channel_trade_no = "";

  /// 银行渠道订单号，微信支付时显示在支付成功页面的条码，可用作扫码查询和扫码退款时匹配
  String channel_order_no = "";

  /// 付款方用户id，“微信openid”、“支付宝账户”、“qq号”等，返回时不参与签名
  String user_id = "";

  /// 附加数据,原样返回
  String attach = "";

  /// 口碑实收金额，pay_type为090时必填
  String receipt_fee = "";

  SaobeiPaymentResult();

  factory SaobeiPaymentResult.fromPaymentJson(Map<String, dynamic> map) {
    return SaobeiPaymentResult()
      ..return_code = Convert.toStr(map["return_code"], "")
      ..return_msg = Convert.toStr(map["return_msg"], "")
      ..key_sign = Convert.toStr(map["key_sign"], "")
      ..result_code = Convert.toStr(map["result_code"], "")
      ..pay_type = Convert.toStr(map["pay_type"], "")
      ..merchant_name = Convert.toStr(map["merchant_name"], "")
      ..merchant_no = Convert.toStr(map["merchant_no"], "")
      ..terminal_id = Convert.toStr(map["terminal_id"], "")
      ..terminal_trace = Convert.toStr(map["terminal_trace"], "")
      ..terminal_time = Convert.toStr(map["terminal_time"], "")
      ..total_fee = Convert.toStr(map["total_fee"], "")
      ..end_time = Convert.toStr(map["end_time"], "")
      ..out_trade_no = Convert.toStr(map["out_trade_no"], "")
      ..channel_trade_no = Convert.toStr(map["channel_trade_no"], "")
      ..channel_order_no = Convert.toStr(map["channel_order_no"], "")
      ..user_id = Convert.toStr(map["user_id"], "")
      ..attach = Convert.toStr(map["attach"], "")
      ..receipt_fee = Convert.toStr(map["receipt_fee"], "");
  }

  /// 退金额，单位分
  String refund_fee = "";

  /// 利楚唯一退单号
  String out_refund_no = "";

  /// 通道订单号，微信订单号、支付宝订单号等，返回时不参与签名
  String channel_refund_no = "";

  factory SaobeiPaymentResult.fromRefundJson(Map<String, dynamic> map) {
    return SaobeiPaymentResult()
      ..return_code = Convert.toStr(map["return_code"], "")
      ..return_msg = Convert.toStr(map["return_msg"], "")
      ..key_sign = Convert.toStr(map["key_sign"], "")
      ..result_code = Convert.toStr(map["result_code"], "")
      ..pay_type = Convert.toStr(map["pay_type"], "")
      ..merchant_name = Convert.toStr(map["merchant_name"], "")
      ..merchant_no = Convert.toStr(map["merchant_no"], "")
      ..terminal_id = Convert.toStr(map["terminal_id"], "")
      ..terminal_trace = Convert.toStr(map["terminal_trace"], "")
      ..terminal_time = Convert.toStr(map["terminal_time"], "")
      ..refund_fee = Convert.toStr(map["refund_fee"], "")
      ..end_time = Convert.toStr(map["end_time"], "")
      ..out_trade_no = Convert.toStr(map["out_trade_no"], "")
      ..out_refund_no = Convert.toStr(map["out_refund_no"], "")
      ..channel_refund_no = Convert.toStr(map["channel_refund_no"], "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "return_code": this.return_code,
      "return_msg": this.return_msg,
      "key_sign": this.key_sign,
      "result_code": this.result_code,
      "pay_type": this.pay_type,
      "merchant_name ": this.merchant_name,
      "merchant_no": this.merchant_no,
      "terminal_id": this.terminal_id,
      "terminal_trace": this.terminal_trace,
      "terminal_time": this.terminal_time,
      "total_fee": this.total_fee,
      "end_time": this.end_time,
      "out_trade_no": this.out_trade_no,
      "channel_trade_no": this.channel_trade_no,
      "channel_order_no": this.channel_order_no,
      "user_id": this.user_id,
      "attach": this.attach,
      "receipt_fee": this.receipt_fee,
      "refund_fee": this.refund_fee,
      "out_refund_no": this.out_refund_no,
      "channel_refund_no": this.channel_refund_no,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
