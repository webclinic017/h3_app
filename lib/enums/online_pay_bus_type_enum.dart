class OnLinePayBusTypeEnum {
  final String name;
  final String value;

  const OnLinePayBusTypeEnum._(this.name, this.value);

  static const None = OnLinePayBusTypeEnum._("None", "-1");

  //销售
  static const Sale = OnLinePayBusTypeEnum._("销售", "0");
  //会员充值
  static const MemberRecharge = OnLinePayBusTypeEnum._("会员充值", "1");
  //销售退款
  static const SaleRefund = OnLinePayBusTypeEnum._("销售退款", "3");

//  销售 = 0,
//  会员充值 = 1,
//  消费积分独立充值 = 2,
//  销售退款 = 3,
//  消费积分独立退款 = 4,
//  会员计次充值 = 5,
//  购买PLUS会员 = 6,
//  会员小额充值 = 7,

  factory OnLinePayBusTypeEnum.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OnLinePayBusTypeEnum.Sale;
        }
      case "1":
        {
          return OnLinePayBusTypeEnum.MemberRecharge;
        }
      case "3":
        {
          return OnLinePayBusTypeEnum.SaleRefund;
        }
      default:
        {
          return OnLinePayBusTypeEnum.None;
        }
    }
  }

  factory OnLinePayBusTypeEnum.fromName(String name) {
    switch (name) {
      case "销售":
        {
          return OnLinePayBusTypeEnum.Sale;
        }
      case "会员充值":
        {
          return OnLinePayBusTypeEnum.MemberRecharge;
        }
      case "销售退款":
        {
          return OnLinePayBusTypeEnum.SaleRefund;
        }
      default:
        {
          return OnLinePayBusTypeEnum.None;
        }
    }
  }
}
