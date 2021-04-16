//订单支付状态
class OrderPointDealStatus {
  final String name;
  final String value;
  const OrderPointDealStatus._(this.name, this.value);

  //无需处理
  static const None = OrderPointDealStatus._("无需处理", "0");
  //已支付
  static const Processed = OrderPointDealStatus._("已处理", "1");
  //未处理
  static const Untreated = OrderPointDealStatus._("未处理", "2");
  //处理失败
  static const Failed = OrderPointDealStatus._("处理失败", "3");

  factory OrderPointDealStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderPointDealStatus.None;
        }
      case "1":
        {
          return OrderPointDealStatus.Processed;
        }
      case "2":
        {
          return OrderPointDealStatus.Untreated;
        }
      case "3":
        {
          return OrderPointDealStatus.Failed;
        }
      default:
        {
          return OrderPointDealStatus.None;
        }
    }
  }

  factory OrderPointDealStatus.fromName(String name) {
    switch (name) {
      case "无需处理":
        {
          return OrderPointDealStatus.None;
        }
      case "已处理":
        {
          return OrderPointDealStatus.Processed;
        }
      case "未处理":
        {
          return OrderPointDealStatus.Untreated;
        }
      case "处理失败":
        {
          return OrderPointDealStatus.Failed;
        }
      default:
        {
          return OrderPointDealStatus.None;
        }
    }
  }
}
