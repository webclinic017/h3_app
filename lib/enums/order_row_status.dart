class OrderRowStatus {
  final String name;
  final String value;
  const OrderRowStatus._(this.name, this.value);

  static const None = OrderRowStatus._("None", "-1");
  //新增,点单过程中尚未保存
  static const New = OrderRowStatus._("新增", "0");
  //下单，保存并且下单成功
  static const Order = OrderRowStatus._("下单", "1");
  //保存，新增并且保存，尚未下单
  static const Save = OrderRowStatus._("保存", "2");

  factory OrderRowStatus.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderRowStatus.New;
        }
      case "1":
        {
          return OrderRowStatus.Order;
        }
      case "2":
        {
          return OrderRowStatus.Save;
        }
      default:
        {
          return OrderRowStatus.None;
        }
    }
  }

  factory OrderRowStatus.fromName(String name) {
    switch (name) {
      case "新增":
        {
          return OrderRowStatus.New;
        }
      case "保存":
        {
          return OrderRowStatus.Save;
        }
      case "下单":
        {
          return OrderRowStatus.Order;
        }
      default:
        {
          return OrderRowStatus.None;
        }
    }
  }
}
