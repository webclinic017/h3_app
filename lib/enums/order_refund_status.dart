class OrderRefundStatus {
  final String name;
  final String value;
  const OrderRefundStatus._(this.name, this.value);

  //未退款
  static const NonRefund = OrderRefundStatus._("未退款", "0");
  //已退款
  static const Refund = OrderRefundStatus._("已退款", "1");
  //部分退款
  static const PartRefund = OrderRefundStatus._("部分退款", "2");

  factory OrderRefundStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderRefundStatus.NonRefund;
        }
      case "1":
        {
          return OrderRefundStatus.Refund;
        }
      case "2":
        {
          return OrderRefundStatus.PartRefund;
        }
      default:
        {
          return OrderRefundStatus.NonRefund;
        }
    }
  }

  factory OrderRefundStatus.fromName(String name) {
    switch (name) {
      case "未退款":
        {
          return OrderRefundStatus.NonRefund;
        }
      case "已退款":
        {
          return OrderRefundStatus.Refund;
        }
      case "部分退款":
        {
          return OrderRefundStatus.PartRefund;
        }
      default:
        {
          return OrderRefundStatus.NonRefund;
        }
    }
  }
}
