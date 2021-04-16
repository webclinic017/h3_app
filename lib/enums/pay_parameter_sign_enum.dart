class PayParameterSignEnum {
  final String name;
  final String value;

  const PayParameterSignEnum._(this.name, this.value);

  static const None = PayParameterSignEnum._("None", "0");

  //支付宝子商户
  static const SubAlipay = PayParameterSignEnum._("subalipay", "1");
  //微信子商户
  static const SubWxpay = PayParameterSignEnum._("subwxpay", "2");
  //乐刷支付
  static const LeshuaPay = PayParameterSignEnum._("leshuapay", "7");

  //扫呗支付
  static const SaobeiPay = PayParameterSignEnum._("sbpay", "4");

  //江西农商银行 小呗聚合支付
  static const XiaobeiPay = PayParameterSignEnum._("baifutongpay", "5");

  factory PayParameterSignEnum.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return PayParameterSignEnum.SubAlipay;
        }
      case "2":
        {
          return PayParameterSignEnum.SubWxpay;
        }
      case "4":
        {
          return PayParameterSignEnum.SaobeiPay;
        }
      case "5":
        {
          return PayParameterSignEnum.XiaobeiPay;
        }
      case "7":
        {
          return PayParameterSignEnum.LeshuaPay;
        }
      default:
        {
          return PayParameterSignEnum.None;
        }
    }
  }

  factory PayParameterSignEnum.fromName(String name) {
    switch (name) {
      case "subalipay":
        {
          return PayParameterSignEnum.SubAlipay;
        }
      case "subwxpay":
        {
          return PayParameterSignEnum.SubWxpay;
        }
      case "sbpay":
        {
          return PayParameterSignEnum.SaobeiPay;
        }
      case "leshuapay":
        {
          return PayParameterSignEnum.LeshuaPay;
        }
      case "baifutongpay": //小呗出行用的支付，数据库从存储的sign=baifutongpay
        {
          return PayParameterSignEnum.XiaobeiPay;
        }
      default:
        {
          return PayParameterSignEnum.None;
        }
    }
  }

  String toFriendlyName() {
    switch (this.name) {
      case "subalipay":
        {
          return "支付宝";
        }
      case "subwxpay":
        {
          return "微信";
        }
      default:
        {
          return "巨为PAY";
        }
    }
  }
}
