import 'dart:convert';

import 'package:h3_app/utils/converts.dart';
import 'package:xml_parser/xml_parser.dart';

class LeShuaQueryResult {
  //返回状态码: 0 - 成功，非0 - 失败。注：此字段是通信标识，业务状态要看result_code
  String resp_code = "";
  //错误描述: resp_code非0时返回
  String resp_msg = "";
  //业务结果: 0 - 成功，非0 - 失败
  String result_code = "";
  //错误码
  String error_code = "";
  //错误码描述
  String error_msg = "";

  //商户号: 由乐刷分配
  String merchant_id = "";
  //通道商户号: 微信、支付宝、QRC商户号
  String sub_merchant_id = "";
  //商户订单号：商户内部订单号
  String third_order_id = "";

  //随机字符串: 随机字符串
  String nonce_str = "";
  //签名: MD5签名结果
  String sign = "";
  //订单状态：
  String status = "";

  //乐刷订单号: 乐刷订单号
  String leshua_order_id = "";
  //支付类型:
  String pay_way = "";
  //支付完成时间：支付成功时才返回
  String pay_time = "";

  //银行类型: 使用银行卡支付以外的（如零钱）全部展示为others，使用银行卡支付的详见下方付款银行类型
  String bank_type = "";
  //用户openid:支付成功时才返回
  String openid = "";
  //微信、支付宝等订单号：支付成功时才返回
  String out_transaction_id = "";

  //用户子标识: 支付成功时才返回。微信：公众号APPID下用户唯一标识；支付宝：买家的支付宝用户ID
  String sub_openid = "";
  //附加数据：原样返回
  String attach = "";
  //交易类型：支付成功时才返回：MICROPAY-条码支付，NATIVE-原生扫码支付，JSAPI-公众号支付、服务窗支付，APP--app支付，H5Pay-支付支付，SmPgPay-小程序支付，JSAPIQuick-简易支付
  String trade_type = "";

  //通道订单号:
  String channel_order_id = "";
  //通道订单时间：
  String channel_datetime = "";
  //支付宝红包金额：支付成功时才返回，单位(分)
  String coupon = "";

  //应结算金额:实际结算金额，支付成功时才返回，单位(分)
  String settlement_amount = "";
  //折扣优惠金额：订单优惠金额，支付成功时才返回，单位(分)
  String discount_amount = "";
  //优惠详情：优惠详情说明：微信官网
  String promotion_detail = "";

  //活动标志：活动标志。WXLZ：微信绿洲；ZFBLH：支付宝蓝海
  String active_flag = "";
  //买家实付金额：微信、支付宝此值有效
  String buyer_pay_amount = "";

  LeShuaQueryResult();

  factory LeShuaQueryResult.fromXml(String xmlString) {
    Map<String, dynamic> map = new Map<String, dynamic>();

    XmlDocument document =
        XmlDocument.fromString(xmlString, parseCdataAsText: true);
    for (XmlNode child in document.root.children) {
      if (child is XmlElement) {
        map["${child.name}"] = "${XmlCdata.fromString(child.text).value}";
      }
    }

    return LeShuaQueryResult.fromJson(map);
  }

  factory LeShuaQueryResult.fromJson(Map<String, dynamic> map) {
    return LeShuaQueryResult()
      ..resp_code = Convert.toStr(map["resp_code"], "")
      ..resp_msg = Convert.toStr(map["resp_msg"], "")
      ..result_code = Convert.toStr(map["result_code"], "")
      ..error_code = Convert.toStr(map["error_code"], "")
      ..error_msg = Convert.toStr(map["error_msg"], "")
      ..merchant_id = Convert.toStr(map["merchant_id"], "")
      ..sub_merchant_id = Convert.toStr(map["sub_merchant_id"], "")
      ..third_order_id = Convert.toStr(map["third_order_id"], "")
      ..nonce_str = Convert.toStr(map["nonce_str"], "")
      ..sign = Convert.toStr(map["sign"], "")
      ..status = Convert.toStr(map["status"], "")
      ..leshua_order_id = Convert.toStr(map["leshua_order_id"], "")
      ..pay_way = Convert.toStr(map["pay_way"], "")
      ..pay_time = Convert.toStr(map["pay_time"], "")
      ..bank_type = Convert.toStr(map["bank_type"], "")
      ..openid = Convert.toStr(map["openid"], "")
      ..out_transaction_id = Convert.toStr(map["out_transaction_id"], "")
      ..sub_openid = Convert.toStr(map["sub_openid"], "")
      ..attach = Convert.toStr(map["attach"], "")
      ..trade_type = Convert.toStr(map["trade_type"], "")
      ..channel_order_id = Convert.toStr(map["channel_order_id"], "")
      ..channel_datetime = Convert.toStr(map["channel_datetime"], "")
      ..coupon = Convert.toStr(map["coupon"], "")
      ..settlement_amount = Convert.toStr(map["settlement_amount"], "")
      ..discount_amount = Convert.toStr(map["discount_amount"], "")
      ..promotion_detail = Convert.toStr(map["promotion_detail"], "")
      ..active_flag = Convert.toStr(map["active_flag"], "")
      ..buyer_pay_amount = Convert.toStr(map["buyer_pay_amount"], "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "resp_code": this.resp_code,
      "resp_msg": this.resp_msg,
      "result_code": this.result_code,
      "error_code": this.error_code,
      "error_msg": this.error_msg,
      "merchant_id ": this.merchant_id,
      "sub_merchant_id": this.sub_merchant_id,
      "third_order_id": this.third_order_id,
      "nonce_str": this.nonce_str,
      "sign": this.sign,
      "status": this.status,
      "leshua_order_id": this.leshua_order_id,
      "pay_way": this.pay_way,
      "pay_time": this.pay_time,
      "bank_type": this.bank_type,
      "openid": this.openid,
      "out_transaction_id": this.out_transaction_id,
      "sub_openid": this.sub_openid,
      "attach": this.attach,
      "trade_type": this.trade_type,
      "channel_order_id": this.channel_order_id,
      "channel_datetime": this.channel_datetime,
      "coupon": this.coupon,
      "settlement_amount": this.settlement_amount,
      "discount_amount": this.discount_amount,
      "promotion_detail": this.promotion_detail,
      "active_flag": this.active_flag,
      "buyer_pay_amount": this.buyer_pay_amount,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
