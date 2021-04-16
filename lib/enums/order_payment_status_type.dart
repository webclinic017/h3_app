//订单支付状态
class OrderPaymentStatus {
  final String name;
  final String value;
  OrderPaymentStatus._(this.name, this.value);

  static final None = OrderPaymentStatus._("None", "-1");
  //未付款
  static final NonPayment = OrderPaymentStatus._("未付款", "0");
  //已支付
  static final Paid = OrderPaymentStatus._("已支付", "1");
  //部分付款
  static final PartPayment = OrderPaymentStatus._("部分付款", "2");
  //付款失败
  static final PaymentFailed = OrderPaymentStatus._("付款失败", "3");

  factory OrderPaymentStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderPaymentStatus.NonPayment;
        }
      case "1":
        {
          return OrderPaymentStatus.Paid;
        }
      case "2":
        {
          return OrderPaymentStatus.PartPayment;
        }
      case "3":
        {
          return OrderPaymentStatus.PaymentFailed;
        }
      default:
        {
          return OrderPaymentStatus.None;
        }
    }
  }

  factory OrderPaymentStatus.fromName(String name) {
    switch (name) {
      case "未付款":
        {
          return OrderPaymentStatus.NonPayment;
        }
      case "已支付":
        {
          return OrderPaymentStatus.Paid;
        }
      case "部分付款":
        {
          return OrderPaymentStatus.PartPayment;
        }
      case "付款失败":
        {
          return OrderPaymentStatus.PaymentFailed;
        }
      default:
        {
          return OrderPaymentStatus.None;
        }
    }
  }
}
