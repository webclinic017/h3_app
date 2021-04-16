import 'package:h3_app/utils/converts.dart';

class XiaobeiPaymentResult {
  /// 返回错误码，为 0 表示没有错误
  String errcode = "";

  /// 返回错误提示
  String msg = "";

  ///支付方式名称,如：微信支付
  String pmt_name = "";

  ///支付方式标签，如：Weixin
  String pmt_tag = "";

  ///商户流水号（从 1 开始自增长不重复）
  int ord_mct_id = 0;

  ///门店流水号（从 1 开始自增长不重复）
  int ord_shop_id = 0;

  ///系统订单号
  String ord_no = "";

  ///币种，默认 CNY
  String ord_currency = "";

  ///币种符号
  String currency_sign = "";

  ///支付通道交易号
  String trade_no = "";

  ///实际交易金额（以分为单位，没有小数点）
  int trade_amount = 0;

  ///优惠金额
  int trade_discout_amount = 0;

  ///交易帐号（支付宝帐号、微信帐号等，某些收单机构没有此数据）
  String trade_account = "";

  ///二维码字符串
  String trade_qrcode = "";

  ///付款完成时间（以收单机构为准）
  String trade_pay_time = "";

  ///订单状态（1 交易成功，2 待支付，4 已取消，9 等待用户输入密码确认）
  int status = 2;

  ///收单机构原始交易数据
  String trade_result = "";

  ///开发者流水号
  String out_no = "";

  XiaobeiPaymentResult();

  factory XiaobeiPaymentResult.fromPaymentJson(String errcode, String msg, Map<String, dynamic> map) {
    return XiaobeiPaymentResult()
      ..errcode = errcode
      ..msg = msg
      ..pmt_name = Convert.toStr(map["pmt_name"], "")
      ..pmt_tag = Convert.toStr(map["pmt_tag"], "")
      ..ord_mct_id = Convert.toInt(map["ord_mct_id"])
      ..ord_shop_id = Convert.toInt(map["ord_shop_id"])
      ..ord_no = Convert.toStr(map["ord_no"], "")
      ..ord_currency = Convert.toStr(map["ord_currency"], "")
      ..currency_sign = Convert.toStr(map["currency_sign"], "")
      ..trade_no = Convert.toStr(map["trade_no"], "")
      ..trade_amount = Convert.toInt(map["trade_amount"])
      ..trade_discout_amount = Convert.toInt(map["trade_discout_amount"])
      ..trade_account = Convert.toStr(map["trade_account"], "")
      ..trade_qrcode = Convert.toStr(map["trade_qrcode"], "")
      ..trade_pay_time = Convert.toStr(map["trade_pay_time"], "")
      ..status = Convert.toInt(map["status"])
      ..trade_result = Convert.toStr(map["trade_result"], "")
      ..out_no = Convert.toStr(map["out_no"], "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "errcode": this.errcode,
      "msg": this.msg,
      "pmt_name": this.pmt_name,
      "pmt_tag": this.pmt_tag,
      "ord_mct_id": this.ord_mct_id,
      "ord_shop_id ": this.ord_shop_id,
      "ord_no": this.ord_no,
      "ord_currency": this.ord_currency,
      "currency_sign": this.currency_sign,
      "trade_no": this.trade_no,
      "trade_amount": this.trade_amount,
      "trade_discout_amount": this.trade_discout_amount,
      "trade_account": this.trade_account,
      "trade_qrcode": this.trade_qrcode,
      "trade_pay_time": this.trade_pay_time,
      "status": this.status,
      "trade_result": this.trade_result,
      "out_no": this.out_no,
    };

    return map;
  }
}
