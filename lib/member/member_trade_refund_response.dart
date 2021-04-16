import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class MemberTradeRefundResponse {
  /// 状态 1成功
  int status = 0;

  ///状态描述
  String msg = "";

  /// 退款凭证号
  String refundVoucherNo = "";

  /// 凭证号
  String voucherNo = "";

  /// 订单号
  String tradeNo = "";

  /// 会员ID
  String memberId = "";

  /// 手机号
  String mobile = "";

  /// 会员卡号
  String cardNo = "";

  /// 卡面号
  String cardFaceNo = "";

  /// 会员姓名
  String name = "";

  /// 支付前余额
  int preAmount = 0;

  /// 支付金额
  int totalAmount = 0;

  /// 支付后余额
  int aftAmount = 0;

  /// 变动前积分余额
  int prePoint = 0;

  /// 积分值
  int pointValue = 0;

  /// 变动后积分余额
  int aftPoint = 0;

  /// 消费时间
  String consumeDate = "";

  /// 备注
  String memo = "";

  MemberTradeRefundResponse();

  factory MemberTradeRefundResponse.fromJson(Map<String, dynamic> json) {
    return MemberTradeRefundResponse()
      ..status = Convert.toInt(json['status'])
      ..msg = Convert.toStr(json['msg'])
      ..refundVoucherNo = Convert.toStr(json['refundVoucherNo'])
      ..voucherNo = Convert.toStr(json['voucherNo'])
      ..tradeNo = Convert.toStr(json['tradeNo'])
      ..memberId = Convert.toStr(json['memberId'])
      ..mobile = Convert.toStr(json['mobile'])
      ..cardNo = Convert.toStr(json['cardNo'])
      ..cardFaceNo = Convert.toStr(json['cardFaceNo'])
      ..name = Convert.toStr(json['name'])
      ..preAmount = Convert.toInt(json['preAmount'])
      ..totalAmount = Convert.toInt(json['totalAmount'])
      ..aftAmount = Convert.toInt(json['aftAmount'])
      ..prePoint = Convert.toInt(json['prePoint'])
      ..pointValue = Convert.toInt(json['pointValue'])
      ..aftPoint = Convert.toInt(json['aftPoint'])
      ..consumeDate = Convert.toStr(json['consumeDate'])
      ..memo = Convert.toStr(json['memo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['refundVoucherNo'] = this.refundVoucherNo;
    data['voucherNo'] = this.voucherNo;
    data['tradeNo'] = this.tradeNo;
    data['memberId'] = this.memberId;
    data['mobile'] = this.mobile;
    data['cardNo'] = this.cardNo;
    data['cardFaceNo'] = this.cardFaceNo;
    data['name'] = this.name;
    data['preAmount'] = this.preAmount;
    data['totalAmount'] = this.totalAmount;
    data['aftAmount'] = this.aftAmount;
    data['prePoint'] = this.prePoint;
    data['pointValue'] = this.pointValue;
    data['aftPoint'] = this.aftPoint;
    data['consumeDate'] = this.consumeDate;
    data['memo'] = this.memo;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
