//订单来源
class OrderPrintStatus {
  final String name;
  final String value;
  OrderPrintStatus._(this.name, this.value);

  //不打印
  static final None = OrderPrintStatus._("不打印", "-1");
  //等待打印
  static final Wait = OrderPrintStatus._("等待打印", "0");
  //打印完成
  static final Completed = OrderPrintStatus._("打印完成", "1");

  factory OrderPrintStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderPrintStatus.Wait;
        }
      case "1":
        {
          return OrderPrintStatus.Completed;
        }
      default:
        {
          return OrderPrintStatus.None;
        }
    }
  }

  factory OrderPrintStatus.fromName(String name) {
    switch (name) {
      case "等待打印":
        {
          return OrderPrintStatus.Wait;
        }
      case "打印完成":
        {
          return OrderPrintStatus.Completed;
        }
      default:
        {
          return OrderPrintStatus.None;
        }
    }
  }
}
