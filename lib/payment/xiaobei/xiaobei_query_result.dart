import 'package:h3_app/utils/converts.dart';

class XiaobeiQueryResult {
  /// 返回错误码，为 0 表示没有错误
  String errcode = "";

  /// 返回错误提示
  String msg = "";

  ///收单机构名称
  String pmt_name = "";

  ///收单机构标签
  String pmt_tag = "";

  ///商户流水号（从 1 开始自增长不重复）
  int ord_mct_id = 0;

  ///门店流水号（从 1 开始自增长不重复）
  int ord_shop_id = 0;

  ///订单号
  String ord_no = "";

  ///订单类型（1 消费，2 辙单）
  int ord_type = 1;

  ///原始金额（以分为单位，没有小数点）
  int original_amount = 0;

  ///折扣金额（以分为单位，没有小数点）
  int discount_amount = 0;

  ///抹零金额（以分为单位，没有小数点）
  int ignore_amount = 0;

  ///支付通道交易号
  String trade_no = "";

  ///交易帐号（支付宝帐号、微信帐号等，某些收单机构没有此数据）
  String trade_account = "";

  ///实际交易金额（以分为单位，没有小数点）
  int trade_amount = 0;

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

  XiaobeiQueryResult();

  factory XiaobeiQueryResult.fromQueryJson(String errcode, String msg, Map<String, dynamic> map) {
    return XiaobeiQueryResult()
      ..errcode = errcode
      ..msg = msg
      ..pmt_name = Convert.toStr(map["pmt_name"], "")
      ..pmt_tag = Convert.toStr(map["pmt_tag"], "")
      ..ord_mct_id = Convert.toInt(map["ord_mct_id"])
      ..ord_shop_id = Convert.toInt(map["ord_shop_id"])
      ..ord_no = Convert.toStr(map["ord_no"], "")
      ..ord_type = Convert.toInt(map["ord_type"])
      ..original_amount = Convert.toInt(map["original_amount"])
      ..discount_amount = Convert.toInt(map["discount_amount"])
      ..ignore_amount = Convert.toInt(map["ignore_amount"])
      ..trade_account = Convert.toStr(map["trade_account"], "")
      ..trade_no = Convert.toStr(map["trade_no"])
      ..trade_amount = Convert.toInt(map["trade_amount"])
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
      "ord_type": this.ord_type,
      "original_amount": this.original_amount,
      "discount_amount": this.discount_amount,
      "ignore_amount": this.ignore_amount,
      "trade_account": this.trade_account,
      "trade_no": this.trade_no,
      "trade_amount": this.trade_amount,
      "trade_qrcode": this.trade_qrcode,
      "trade_pay_time": this.trade_pay_time,
      "status": this.status,
      "trade_result": this.trade_result,
      "out_no": this.out_no,
    };

    return map;
  }
}
