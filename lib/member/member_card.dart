import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class MemberCard {
  /// 卡类型ID
  String cardTypeId = "";

  /// 卡类型编号
  String cardTypeNo = "";

  /// 卡类型名称
  String cardTypeName = "";

  /// 会员卡号
  String cardNo = "";

  /// 卡面号
  String cardFaceNo = "";

  /// 是否积分  0-否 1-是
  int isConsumePoint = 0;

  /// 是否储值  0-否 1-是
  int isStoredValue = 0;

  /// 手机号
  String mobile = "";

  /// 小额免密支付
  int isNoPwd = 0;

  /// 免密金额
  double npAmount = 0;

  /// 保底金额
  double baseAmount = 0;

  /// 总余额
  double totalAmount = 0;

  /// 实收剩余金额
  double globalAmount = 0;

  /// 赠送剩余金额
  double giftAmount = 0;

  /// 冻结余额
  double stageAmount = 0;

  /// 累计充值总金额
  double rechargeAmount = 0;

  /// 累计充值赠送金额
  double rechargeGiftAmount = 0;

  /// 累计消费总金额
  double consumeAmount = 0;

  /// 累计充值次数
  int rechargeCount = 0;

  /// 累计消费次数
  int consumeCount = 0;

  /// 挂账信誉额度
  double creditAmount = 0;

  /// 原卡号
  String oldCardNo = "";

  /// 状态
  int status = 0;

  /// 卡介质 1-电子卡 2-磁卡或条码卡 3-IC卡
  int cardMedium = 1;

  /// 0-新建 1-正常(开户)  2-预售  3-挂失 4-冻结  5--销户 10-转赠中
  String get statusDesc {
    var result = "";
    switch (this.status) {
      case 0:
        {
          result = "新建";
        }
        break;
      case 1:
        {
          result = "正常";
        }
        break;
      case 2:
        {
          result = "预售";
        }
        break;
      case 3:
        {
          result = "挂失";
        }
        break;
      case 4:
        {
          result = "冻结";
        }
        break;
      case 5:
        {
          result = "销户";
        }
        break;
      case 10:
        {
          result = "转赠中";
        }
        break;
      default:
        {
          result = "未定义";
        }
        break;
    }
    return result;
  }

  /// 开户门店编号
  String shopNo = "";

  /// 开户门店名称
  String shopName = "";

  /// 开户门店ID
  String shopId = "";

  /// 员工工号
  String workerNo = "";

  /// pos
  String posNo = "";

  /// 备注说明
  String description = "";

  /// 错误次数
  int countWrong = 0;

  /// 卡有效期
  String validDate = "";

  /// 限用次数
  int limitCount = 0;

  /// 来源标识
  String sourceSign = "";

  MemberCard();

  factory MemberCard.fromJson(Map<String, dynamic> json) {
    return MemberCard()
      ..baseAmount = Convert.toDouble(json['baseAmount'])
      ..cardMedium = Convert.toInt(json['cardMedium'])
      ..cardNo = Convert.toStr(json['cardNo'])
      ..cardTypeId = Convert.toStr(json['cardTypeId'])
      ..cardTypeName = Convert.toStr(json['cardTypeName'])
      ..cardTypeNo = Convert.toStr(json['cardTypeNo'])
      ..consumeAmount = Convert.toDouble(json['consumeAmount'])
      ..consumeCount = Convert.toInt(json['consumeCount'])
      ..creditAmount = Convert.toDouble(json['creditAmount'])
      ..giftAmount = Convert.toDouble(json['giftAmount'])
      ..globalAmount = Convert.toDouble(json['globalAmount'])
      ..isConsumePoint = Convert.toInt(json['isConsumePoint'])
      ..isNoPwd = Convert.toInt(json['isNoPwd'])
      ..isStoredValue = Convert.toInt(json['isStoredValue'])
      ..limitCount = Convert.toInt(json['limitCount'])
      ..mobile = Convert.toStr(json['mobile'])
      ..npAmount = Convert.toDouble(json['npAmount'])
      ..posNo = Convert.toStr(json['posNo'])
      ..rechargeAmount = Convert.toDouble(json['rechargeAmount'])
      ..rechargeCount = Convert.toInt(json['rechargeCount'])
      ..rechargeGiftAmount = Convert.toDouble(json['rechargeGiftAmount'])
      ..shopId = Convert.toStr(json['shopId'])
      ..shopName = Convert.toStr(json['shopName'])
      ..shopNo = Convert.toStr(json['shopNo'])
      ..sourceSign = Convert.toStr(json['sourceSign'])
      ..stageAmount = Convert.toDouble(json['stageAmount'])
      ..status = Convert.toInt(json['status'])
      ..totalAmount = Convert.toDouble(json['totalAmount'])
      ..validDate = Convert.toStr(json['validDate'])
      ..workerNo = Convert.toStr(json['workerNo'])
      ..description = Convert.toStr(json['description']);
  }

  static List<MemberCard> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MemberCard>();
    lists.forEach((map) => result.add(MemberCard.fromJson(map)));
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseAmount'] = this.baseAmount;
    data['cardMedium'] = this.cardMedium;
    data['cardNo'] = this.cardNo;
    data['cardTypeId'] = this.cardTypeId;
    data['cardTypeName'] = this.cardTypeName;
    data['cardTypeNo'] = this.cardTypeNo;
    data['consumeAmount'] = this.consumeAmount;
    data['consumeCount'] = this.consumeCount;
    data['creditAmount'] = this.creditAmount;
    data['giftAmount'] = this.giftAmount;
    data['globalAmount'] = this.globalAmount;
    data['isConsumePoint'] = this.isConsumePoint;
    data['isNoPwd'] = this.isNoPwd;
    data['isStoredValue'] = this.isStoredValue;
    data['limitCount'] = this.limitCount;
    data['mobile'] = this.mobile;
    data['npAmount'] = this.npAmount;
    data['posNo'] = this.posNo;
    data['rechargeAmount'] = this.rechargeAmount;
    data['rechargeCount'] = this.rechargeCount;
    data['rechargeGiftAmount'] = this.rechargeGiftAmount;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['shopNo'] = this.shopNo;
    data['sourceSign'] = this.sourceSign;
    data['stageAmount'] = this.stageAmount;
    data['status'] = this.status;
    data['totalAmount'] = this.totalAmount;
    data['validDate'] = this.validDate;
    data['workerNo'] = this.workerNo;
    data['description'] = this.description;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
