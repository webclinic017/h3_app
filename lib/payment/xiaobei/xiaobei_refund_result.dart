import 'package:h3_app/utils/converts.dart';

class XiaobeiRefundResult {
  /// 返回错误码，为 0 表示没有错误
  String errcode = "";

  /// 返回错误提示
  String msg = "";

  ///系统退款订单号
  String ord_no = "";

  ///商户流水号（从 1 开始自增长不重复）
  int ord_mct_id = 0;

  ///门店流水号（从 1 开始自增长不重复）
  int ord_shop_id = 0;

  ///退款金额
  int trade_amount = 0;

  ///系统原始订单号
  String original_ord_no = "";

  ///状态(1 成功，其它值为不成功)
  int status = 0;

  ///支付通道优惠金额
  int trade_discout_amount = 0;

  ///完成时间（以收单机构为准）
  String trade_time = "";

  ///币种，默认 CNY
  String ord_currency = "";

  ///币种符号
  String currency_sign = "";

  XiaobeiRefundResult();

  factory XiaobeiRefundResult.fromRefundJson(
      String errcode, String msg, Map<String, dynamic> map) {
    return XiaobeiRefundResult()
      ..errcode = errcode
      ..msg = msg
      ..ord_no = Convert.toStr(map["ord_no"], "")
      ..ord_mct_id = Convert.toInt(map["ord_mct_id"])
      ..ord_shop_id = Convert.toInt(map["ord_shop_id"])
      ..trade_amount = Convert.toInt(map["trade_amount"])
      ..trade_discout_amount = Convert.toInt(map["trade_discout_amount"])
      ..original_ord_no = Convert.toStr(map["original_ord_no"], "")
      ..trade_time = Convert.toStr(map["trade_time"], "")
      ..status = Convert.toInt(map["status"])
      ..ord_currency = Convert.toStr(map["ord_currency"], "")
      ..currency_sign = Convert.toStr(map["currency_sign"], "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "errcode": this.errcode,
      "msg": this.msg,
      "ord_no": this.ord_no,
      "ord_mct_id": this.ord_mct_id,
      "ord_shop_id": this.ord_shop_id,
      "trade_amount ": this.trade_amount,
      "trade_discout_amount": this.trade_discout_amount,
      "original_ord_no": this.original_ord_no,
      "trade_time": this.trade_time,
      "status": this.status,
      "ord_currency": this.ord_currency,
      "currency_sign": this.currency_sign,
    };

    return map;
  }
}
