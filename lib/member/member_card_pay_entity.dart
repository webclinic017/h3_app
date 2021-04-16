import 'package:equatable/equatable.dart';

/// 会员卡支付实体类
class MemberCardPayEntity extends Equatable {
  /// 支付单号
  String tradeNo = "";

  /// 会员ID
  String memberId = "";

  /// 会员姓名
  String memberName = "";

  /// 手机号
  String mobile = "";

  /// 卡面号
  String cardFaceNo = "";

  /// 卡号
  String cardNo = "";

  /// 是否免密
  int isNoPwd = 0;

  /// 密码
  String passwd = "";

  /// 支付金额(分)
  int totalAmount = 0;

  /// 积分值(分)
  int pointValue = 0;

  /// 备注
  String memo = "";

  /// 付款状态
  String orderPaymentStatus = "";

  @override
  List<Object> get props => [
        this.tradeNo,
        this.memberId,
        this.memberName,
        this.mobile,
        this.cardFaceNo,
        this.cardNo,
        this.isNoPwd,
        this.passwd,
        this.totalAmount,
        this.pointValue,
        this.memo,
        this.orderPaymentStatus,
      ];
}
