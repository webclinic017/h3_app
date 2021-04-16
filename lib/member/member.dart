import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/entity/pos_member_level.dart';
import 'package:h3_app/entity/pos_member_tag.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:meta/meta.dart';
import 'member_card.dart';
import 'member_card_recharge_scheme.dart';
import 'member_elec_coupon.dart';
import 'member_times_count_project.dart';

@immutable
class Member extends Equatable {
  /// 会员ID
  String id = "";

  /// 租户ID
  String tenantId = "";

  /// 会员编号
  String no = "";

  /// 姓名
  String name = "";

  /// 性别
  int sex = 2;

  ///方便使用，非传输值
  String get sexDesc {
    if (this.sex == 0) {
      return "女";
    } else if (this.sex == 0) {
      return "男";
    } else {
      return "保密";
    }
  }

  /// 手机号
  String mobile = "";

  /// 联系电话
  String linkphone = "";

  /// 生日
  String birthday = "";

  /// 是否公历
  int solar = 1;

  /// 是否公历显示
  String get solarDesc {
    if (this.solar == 1) {
      return "公历";
    } else {
      return "农历";
    }
  }

  /// email
  String email = "";

  /// QQ
  String qq = "";

  /// 民族
  String nation = "";

  /// 家庭住址
  String address = "";

  /// 推荐人
  String referMemberId = "";

  /// 卡号
  String cardNo = "";

  /// 卡类型编号
  String cardTypeId = "";

  /// 会员头像
  String headImgUrl = "";

  /// 会员类型
  String memberTypeNo = "";

  /// 会员类型名称
  String memberTypeName = "";

  /// 会员等级Id
  String memberLevelId = "";

  /// 会员等级编号
  String memberLevelNo = "";

  /// 会员等级名称
  String memberLevelName = "";

  /// 会员等级
  MemberLevel memberLevel;

  /// 来源标识  pos weixin
  String sourceNo = "weixin";

  /// 证件类型编号
  String cryTypeNo = "";

  /// 证件类型名称
  String get cryTypeName {
    switch (this.cryTypeNo) {
      case "01":
        {
          return "身份证";
        }
        break;
      case "02":
        {
          return "驾照";
        }
        break;
      case "03":
        {
          return "军官证";
        }
        break;
      case "04":
        {
          return "护照";
        }
        break;
      case "05":
        {
          return "学生证";
        }
        break;
      case "06":
        {
          return "其他";
        }
        break;
      default:
        {
          return "";
        }
        break;
    }
  }

  /// 证件号码
  String cryNo = "";

  /// 登陆密码
  String password = "";

  /// 微信会员标识
  int wechatFlag = 0;

  /// 默认微信公众号标识
  String wid = "";

  /// 默认openId
  String openId = "";

  /// 门店ID
  String shopId = "";

  /// 门店编号
  String shopNo = "";

  /// 门店名称
  String shopName = "";

  /// pos
  String posNo = "";

  /// 员工工号
  String workerNo = "";

  /// 营业员
  String salesClerk = "";

  /// 挂账信誉额度
  double creditAmount = 0;

  /// 备注说明
  String description = "";

  /// 总余额
  double totalAmount = 0;

  /// 实收剩余金额
  double globalAmount = 0;

  /// 赠送剩余金额
  double giftAmount = 0;

  /// 冻结余额
  double stageAmount = 0;

  /// 总积分
  double totalPoint = 0;

  /// 累计充值总金额
  double rechargeAmount = 0;

  /// 累计赠送金额
  double rechargeGiftAmount = 0;

  /// 累计积分
  double grandTotalPoint = 0;

  /// 累计充值积分
  double rechargePoint = 0;

  /// 累计消费总金额
  double consumeAmount = 0;

  /// 累计消费积分
  double consumePoint = 0;

  /// 积分最大可抵扣金额
  double pointAmount = 0;

  /// 累计已用积分
  double usedPoint = 0;

  /// 累计充值次数
  int rechargeCount = 0;

  /// 累计消费次数
  int consumeCount = 0;

  /// 累计计次项目消费金额
  double jcConsumeAmount = 0;

  /// 累计计次项目次数
  int jcConsumeCount = 0;

  /// 积分有效期
  String pointValiditDate = "";

  /// 建档时间
  String joinTime = "";

  /// 最新消费时间
  String lastConsumeTime = "";

  /// 会员标签
  List<MemberTag> memberTagList = <MemberTag>[];

  /// 会员卡列表
  List<MemberCard> cardList = <MemberCard>[];

  /// 有效计次项目列表
  List<MemberTimesCountProject> timesCountProjectList =
      <MemberTimesCountProject>[];

  /// 优惠券
  List<MemberElecCoupon> couponList = <MemberElecCoupon>[];

  ///会员充值方案
  MemberCardRechargeScheme rechargeScheme;

  /// 默认、选中的卡
  MemberCard defaultCard;

  /// 识别方式
  int judgeCardType = 0;

  /// 是否免密  1：是；0：否
  int noPwd = 0;

  /// 免密金额
  double npAmount = 0;

  /// 是否plus会员
  int plus = 0;

  /// 是否购买过plus会员
  int plusRecord = 0;

  /// plus会员过期时间
  String plusEndDateStr = "";

  /// plus会员券累计优惠
  double plusCouponAmount = 0;

  /// plus会员价累计优惠
  double plusPriceDiscountAmount = 0;

  /// plus价商品累计购买金额
  double plusProductAmount = 0;

  /// 当月plus价格商品已购买金额
  double monthPlusAmount = 0;

  /// plus价格商品限购额度 0为不限额
  double consumptionQuota = 0;

  Member();

  ///配合取消会员使用，目前已知copyWith方法对空对象赋值问题
  factory Member.cancel() {
    return Member()..id = null;
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member()
      ..id = Convert.toStr(json["id"])
      ..tenantId = Convert.toStr(json['tenantId'])
      ..no = Convert.toStr(json["no"])
      ..name = Convert.toStr(json["name"])
      ..sex = Convert.toInt(json["sex"])
      ..cardNo = Convert.toStr(json['cardNo'])
      ..mobile = Convert.toStr(json['mobile'])
      ..address = Convert.toStr(json['address'])
      ..birthday = Convert.toStr(json['birthday'])
      ..shopId = Convert.toStr(json['shopId'])
      ..shopName = Convert.toStr(json['shopName'])
      ..shopNo = Convert.toStr(json['shopNo'])
      ..sourceNo = Convert.toStr(json['sourceNo'])
      ..cryNo = Convert.toStr(json['cryNo'])
      ..cryTypeNo = Convert.toStr(json['cryTypeNo'])
      ..description = Convert.toStr(json['description'])
      ..email = Convert.toStr(json['email'])
      ..headImgUrl = Convert.toStr(json['headimgurl'])
      ..noPwd = Convert.toInt(json['isNoPwd'])
      ..plus = Convert.toInt(json['isPlus'])
      ..plusRecord = Convert.toInt(json['isPlusRecord'])
      ..solar = Convert.toInt(json['isSolar'])
      ..linkphone = Convert.toStr(json['linkphone'])
      ..memberLevelName = Convert.toStr(json['memberLevelName'])
      ..memberLevelNo = Convert.toStr(json['memberLevelNo'])
      ..memberTypeName = Convert.toStr(json['memberTypeName'])
      ..memberTypeNo = Convert.toStr(json['memberTypeNo'])
      ..openId = Convert.toStr(json['openId'])
      ..password = Convert.toStr(json['password'])
      ..consumeAmount = Convert.toDouble(json['consumeAmount'])
      ..consumeCount = Convert.toInt(json['consumeCount'])
      ..consumePoint = Convert.toDouble(json['consumePoint'])
      ..consumptionQuota = Convert.toDouble(json['consumptionQuota'])
      ..creditAmount = Convert.toDouble(json['creditAmount'])
      ..giftAmount = Convert.toDouble(json['giftAmount'])
      ..globalAmount = Convert.toDouble(json['globalAmount'])
      ..grandTotalPoint = Convert.toDouble(json['grandTotalPoint'])
      ..monthPlusAmount = Convert.toDouble(json['monthPlusAmount'])
      ..npAmount = Convert.toDouble(json['npAmount'])
      ..plusCouponAmount = Convert.toDouble(json['plusCouponAmount'])
      ..plusPriceDiscountAmount = Convert.toDouble(
          json['plusPirceDiscountAmount']) //plusPirceDiscountAmount单词拼写错误，后台错的
      ..plusProductAmount = Convert.toDouble(json['plusProductAmount'])
      ..rechargeAmount = Convert.toDouble(json['rechargeAmount'])
      ..rechargeCount = Convert.toInt(json['rechargeCount'])
      ..rechargeGiftAmount = Convert.toDouble(json['rechargeGiftAmount'])
      ..rechargePoint = Convert.toDouble(json['rechargePoint'])
      ..referMemberId = Convert.toStr(json['referMemberId'])
      ..salesClerk = Convert.toStr(json['salesClerk'])
      ..stageAmount = Convert.toDouble(json['stageAmount'])
      ..jcConsumeAmount = Convert.toDouble(json['jcConsumeAmount'])
      ..jcConsumeCount = Convert.toInt(json['jcConsumeCount'])
      ..totalAmount = Convert.toDouble(json["totalAmount"])
      ..totalPoint = Convert.toDouble(json['totalPoint'])
      ..usedPoint = Convert.toDouble(json['usedPoint'])
      ..cardList = json["cardList"] != null
          ? List<MemberCard>.from(
              json["cardList"].map((x) => MemberCard.fromJson(x)))
          : <MemberCard>[]
      ..memberTagList = json["memberTagList"] != null
          ? List<MemberTag>.from(
              json["memberTagList"].map((x) => MemberTag.fromMap(x)))
          : <MemberTag>[]
      ..timesCountProjectList = json["timesCountProjectList"] != null
          ? List<MemberTimesCountProject>.from(json["timesCountProjectList"]
              .map((x) => MemberTimesCountProject.fromJson(x)))
          : <MemberTimesCountProject>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['birthday'] = this.birthday;
    if (this.cardList != null) {
      data['cardList'] = this.cardList.map((v) => v.toJson()).toList();
    }
    data['cardNo'] = this.cardNo;
    data['consumeAmount'] = this.consumeAmount;
    data['consumeCount'] = this.consumeCount;
    data['consumePoint'] = this.consumePoint;
    data['consumptionQuota'] = this.consumptionQuota;
    data['creditAmount'] = this.creditAmount;
    data['cryNo'] = this.cryNo;
    data['cryTypeNo'] = this.cryTypeNo;
    data['description'] = this.description;
    data['email'] = this.email;
    data['giftAmount'] = this.giftAmount;
    data['globalAmount'] = this.globalAmount;
    data['grandTotalPoint'] = this.grandTotalPoint;
    data['headimgurl'] = this.headImgUrl;
    data['id'] = this.id;
    data['isNoPwd'] = this.noPwd;
    data['isPlus'] = this.plus;
    data['isPlusRecord'] = this.plusRecord;
    data['isSolar'] = this.solar;
    data['jcConsumeAmount'] = this.jcConsumeAmount;
    data['jcConsumeCount'] = this.jcConsumeCount;
    data['linkphone'] = this.linkphone;
    data['memberLevelName'] = this.memberLevelName;
    data['memberLevelNo'] = this.memberLevelNo;
    if (this.memberTagList != null) {
      data['memberTagList'] = this.memberTagList.map((v) => v.toMap()).toList();
    }
    data['memberTypeName'] = this.memberTypeName;
    data['memberTypeNo'] = this.memberTypeNo;
    data['mobile'] = this.mobile;
    data['monthPlusAmount'] = this.monthPlusAmount;
    data['name'] = this.name;
    data['no'] = this.no;
    data['npAmount'] = this.npAmount;
    data['openId'] = this.openId;
    data['password'] = this.password;
    data['plusCouponAmount'] = this.plusCouponAmount;
    data['plusPirceDiscountAmount'] = this.plusPriceDiscountAmount;
    data['plusProductAmount'] = this.plusProductAmount;
    data['rechargeAmount'] = this.rechargeAmount;
    data['rechargeCount'] = this.rechargeCount;
    data['rechargeGiftAmount'] = this.rechargeGiftAmount;
    data['rechargePoint'] = this.rechargePoint;
    data['referMemberId'] = this.referMemberId;
    data['salesClerk'] = this.salesClerk;
    data['sex'] = this.sex;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['shopNo'] = this.shopNo;
    data['sourceNo'] = this.sourceNo;
    data['stageAmount'] = this.stageAmount;
    data['tenantId'] = this.tenantId;
    if (this.timesCountProjectList != null) {
      data['timesCountProjectList'] =
          this.timesCountProjectList.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
    data['totalPoint'] = this.totalPoint;
    data['usedPoint'] = this.usedPoint;

    if (this.rechargeScheme != null) {
      data['rechargeScheme'] = this.rechargeScheme;
    }

    data['couponList'] = this.couponList ?? <MemberElecCoupon>[];

    return data;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.id,
        this.tenantId,
        this.no,
        this.name,
        this.sex,
        this.cardNo,
        this.mobile,
        this.address,
        this.birthday,
        this.shopId,
        this.shopName,
        this.shopNo,
        this.sourceNo,
        this.cryNo,
        this.cryTypeNo,
        this.description,
        this.email,
        this.headImgUrl,
        this.noPwd,
        this.plus,
        this.plusRecord,
        this.solar,
        this.linkphone,
        this.memberLevelName,
        this.memberLevelNo,
        this.memberTypeName,
        this.memberTypeNo,
        this.openId,
        this.password,
        this.consumeAmount,
        this.consumeCount,
        this.consumePoint,
        this.consumptionQuota,
        this.creditAmount,
        this.giftAmount,
        this.globalAmount,
        this.grandTotalPoint,
        this.monthPlusAmount,
        this.npAmount,
        this.plusCouponAmount,
        this.plusPriceDiscountAmount,
        this.plusProductAmount,
        this.rechargeAmount,
        this.rechargeCount,
        this.rechargeGiftAmount,
        this.rechargePoint,
        this.referMemberId,
        this.salesClerk,
        this.stageAmount,
        this.jcConsumeAmount,
        this.jcConsumeCount,
        this.totalAmount,
        this.totalPoint,
        this.usedPoint,
        this.cardList,
        this.memberTagList,
        this.timesCountProjectList,
        this.couponList,
        this.rechargeScheme,
      ];
}
