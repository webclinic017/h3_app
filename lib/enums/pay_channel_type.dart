//订单来源
class PayChannelEnum {
  final String name;
  final String value;
  const PayChannelEnum._(this.name, this.value);

//无
  static const None = PayChannelEnum._("None", "-1");
  //原生支付
  static const ProtoPay = PayChannelEnum._("原生支付", "0");
  //富友支付
  static const FuyouPay = PayChannelEnum._("富友支付", "1");
  //扫呗支付
  static const SaobeiPay = PayChannelEnum._("扫呗支付", "2");
//江西农商行
  static const JCRCB = PayChannelEnum._("江西农商行", "3");
//建行支付
  static const CCB = PayChannelEnum._("建行支付", "4");

//乐刷支付
  static const LeshuaPay = PayChannelEnum._("乐刷支付", "5");
//浙江农信
  static const ZJRC = PayChannelEnum._("浙江农信", "6");
//农业银行
  static const ABC = PayChannelEnum._("农业银行", "7");

  factory PayChannelEnum.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PayChannelEnum.ProtoPay;
        }
      case "1":
        {
          return PayChannelEnum.FuyouPay;
        }
      case "2":
        {
          return PayChannelEnum.SaobeiPay;
        }
      case "3":
        {
          return PayChannelEnum.JCRCB;
        }
      case "4":
        {
          return PayChannelEnum.CCB;
        }
      case "5":
        {
          return PayChannelEnum.LeshuaPay;
        }
      case "6":
        {
          return PayChannelEnum.ZJRC;
        }
      case "7":
        {
          return PayChannelEnum.ABC;
        }
      default:
        {
          return PayChannelEnum.None;
        }
    }
  }

  factory PayChannelEnum.fromName(String name) {
    switch (name) {
      case "原生支付":
        {
          return PayChannelEnum.ProtoPay;
        }
      case "富友支付":
        {
          return PayChannelEnum.FuyouPay;
        }
      case "扫呗支付":
        {
          return PayChannelEnum.SaobeiPay;
        }
      case "江西农商行":
        {
          return PayChannelEnum.JCRCB;
        }
      case "建行支付":
        {
          return PayChannelEnum.CCB;
        }
      case "乐刷支付":
        {
          return PayChannelEnum.LeshuaPay;
        }
      case "浙江农信":
        {
          return PayChannelEnum.ZJRC;
        }
      case "农业银行":
        {
          return PayChannelEnum.ABC;
        }
      default:
        {
          return PayChannelEnum.None;
        }
    }
  }
}
