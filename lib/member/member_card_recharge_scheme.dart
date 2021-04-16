import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class MemberCardRechargeScheme {
  /// 充值方案ID
  String id = "";

  /// 租户编号
  String tenantId = "";

  /// 编号
  String no = "";

  /// 名称
  String name = "";

  /// 开始日期
  String startDate = "";

  /// 结束日期
  String endDate = "";

  /// 最低充值额度
  double minAmount = 0;

  /// 最高充值额度
  double maxAmount = 0;

  /// 是否线上
  int onlineFlag = 0;

  /// 是否手动录入金额
  int inputFlag = 0;

  /// pc手动录入
  int inputPcFlag = 0;

  /// app手动录入
  int inputAppFlag = 0;

  /// 充值标签
  String tags = "";

  /// 赠送金额返回方式
  int giftAmountReturnFlag = 0;

  /// 返还总月数
  int returnTotalMonths = 0;

  /// 返还利率
  double returnRate = 0;

  /// 到账日期
  int returnDay = 0;

  /// 赠送标识
  int giftFlag = 0;

  /// 备注
  String description = "";

  /// 优惠说明
  String discountDesc = "";

  /// 优惠描述
  String discountContent = "";

  /// 充值明细
  List<MemberCardRechargeSchemeDetail> detailList;

  MemberCardRechargeScheme();

  factory MemberCardRechargeScheme.fromJson(Map<String, dynamic> json) {
    return MemberCardRechargeScheme()
      ..description = Convert.toStr(json['description'])
      ..endDate = Convert.toStr(json['endDate'])
      ..giftAmountReturnFlag = Convert.toInt(json['giftAmountReturnFlag'])
      ..giftFlag = Convert.toInt(json['giftFlag'])
      ..id = Convert.toStr(json['id'])
      ..inputAppFlag = Convert.toInt(json['inputAppFlag'])
      ..inputFlag = Convert.toInt(json['inputFlag'])
      ..inputPcFlag = Convert.toInt(json['inputPcFlag'])
      ..maxAmount = Convert.toDouble(json['maxAmount'])
      ..minAmount = Convert.toDouble(json['minAmount'])
      ..name = Convert.toStr(json['name'])
      ..no = Convert.toStr(json['no'])
      ..onlineFlag = Convert.toInt(json['onlineFlag'])
      ..returnDay = Convert.toInt(json['returnDay'])
      ..returnRate = Convert.toDouble(json['returnRate'])
      ..returnTotalMonths = Convert.toInt(json['returnTotalMonths'])
      ..startDate = Convert.toStr(json['startDate'])
      ..tags = Convert.toStr(json['tags'])
      ..tenantId = Convert.toStr(json['tenantId'])
      ..detailList = json["detailList"] != null
          ? List<MemberCardRechargeSchemeDetail>.from(json["detailList"]
              .map((x) => MemberCardRechargeSchemeDetail.fromJson(x)))
          : <MemberCardRechargeSchemeDetail>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    if (this.detailList != null) {
      data['detailList'] = this.detailList.map((v) => v.toJson()).toList();
    }
    data['endDate'] = this.endDate;
    data['giftAmountReturnFlag'] = this.giftAmountReturnFlag;
    data['giftFlag'] = this.giftFlag;
    data['id'] = this.id;
    data['inputAppFlag'] = this.inputAppFlag;
    data['inputFlag'] = this.inputFlag;
    data['inputPcFlag'] = this.inputPcFlag;
    data['maxAmount'] = this.maxAmount;
    data['minAmount'] = this.minAmount;
    data['name'] = this.name;
    data['no'] = this.no;
    data['onlineFlag'] = this.onlineFlag;
    data['returnDay'] = this.returnDay;
    data['returnRate'] = this.returnRate;
    data['returnTotalMonths'] = this.returnTotalMonths;
    data['startDate'] = this.startDate;
    data['tags'] = this.tags;
    data['tenantId'] = this.tenantId;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

class MemberCardRechargeSchemeDetail {
  /// 是否赠送金额
  int giftAmountFlag = 0;

  /// 金额赠送值
  double giftAmountValue = 0;

  /// 起始金额
  double startAmount = 0;

  /// 是否赠送礼品
  int giftLpFlag = 0;

  /// 是否赠送积分
  int giftPointFlag = 0;

  /// 是否赠送卡券
  int giftCouponFlag = 0;

  /// 积分赠送类型  0 按固定积分值  1 按比例
  int giftPointType = 0;

  /// 积分赠送值
  double giftPointValue = 0;

  /// 赠送礼品内容
  String lpContent = "";

  /// 赠送礼品描述
  String lpContentDesc = "";

  /// 赠送卡券内容
  String giftCouponContent = "";

  /// 赠送卡券描述
  String giftCouponDesc = "";

  MemberCardRechargeSchemeDetail();

  factory MemberCardRechargeSchemeDetail.fromJson(Map<String, dynamic> json) {
    return MemberCardRechargeSchemeDetail()
      ..giftAmountFlag = Convert.toInt(json['giftAmountFlag'])
      ..giftAmountValue = Convert.toDouble(json['giftAmountValue'])
      ..giftCouponContent = Convert.toStr(json['giftCouponContent'])
      ..giftCouponDesc = Convert.toStr(json['giftCouponDesc'])
      ..giftCouponFlag = Convert.toInt(json['giftCouponFlag'])
      ..giftLpFlag = Convert.toInt(json['giftLpFlag'])
      ..giftPointFlag = Convert.toInt(json['giftPointFlag'])
      ..giftPointType = Convert.toInt(json['giftPointType'])
      ..giftPointValue = Convert.toDouble(json['giftPointValue'])
      ..lpContent = Convert.toStr(json['lpContent'])
      ..lpContentDesc = Convert.toStr(json['lpContentDesc'])
      ..startAmount = Convert.toDouble(json['startAmount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['giftAmountFlag'] = this.giftAmountFlag;
    data['giftAmountValue'] = this.giftAmountValue;
    data['giftCouponContent'] = this.giftCouponContent;
    data['giftCouponDesc'] = this.giftCouponDesc;
    data['giftCouponFlag'] = this.giftCouponFlag;
    data['giftLpFlag'] = this.giftLpFlag;
    data['giftPointFlag'] = this.giftPointFlag;
    data['giftPointType'] = this.giftPointType;
    data['giftPointValue'] = this.giftPointValue;
    data['lpContent'] = this.lpContent;
    data['lpContentDesc'] = this.lpContentDesc;
    data['startAmount'] = this.startAmount;
    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
