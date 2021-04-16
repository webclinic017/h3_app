//订单来源
class OrderStatus {
  final String name;
  final String value;
  const OrderStatus._(this.name, this.value);

  static const None = OrderStatus._("None", "-1");
  // 等待支付
  static const WaitForPayment = OrderStatus._("等待支付", "0");
  //已支付
  static const Paid = OrderStatus._("已支付", "1");
  //已退单
  static const ChargeBack = OrderStatus._("已退单", "2");
  //已取消
  static const Canceled = OrderStatus._("已取消", "3");
  //已完成
  static const Completed = OrderStatus._("已完成", "4");
  //部分退款
  static const Rebates = OrderStatus._("部分退款", "5");

  factory OrderStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderStatus.WaitForPayment;
        }
      case "1":
        {
          return OrderStatus.Paid;
        }
      case "2":
        {
          return OrderStatus.ChargeBack;
        }
      case "3":
        {
          return OrderStatus.Canceled;
        }
      case "4":
        {
          return OrderStatus.Completed;
        }
      case "5":
        {
          return OrderStatus.Rebates;
        }
      default:
        {
          return OrderStatus.None;
        }
    }
  }

  factory OrderStatus.fromName(String name) {
    switch (name) {
      case "等待支付":
        {
          return OrderStatus.WaitForPayment;
        }
      case "已支付":
        {
          return OrderStatus.Paid;
        }
      case "已退单":
        {
          return OrderStatus.ChargeBack;
        }
      case "已取消":
        {
          return OrderStatus.Canceled;
        }
      case "已完成":
        {
          return OrderStatus.Completed;
        }
      case "部分退款":
        {
          return OrderStatus.Rebates;
        }
      default:
        {
          return OrderStatus.None;
        }
    }
  }
}
