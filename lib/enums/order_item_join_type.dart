///订单项加入订单的方式
class OrderItemJoinType {
  final String name;
  final String value;

  const OrderItemJoinType._(this.name, this.value);

  static const None = OrderItemJoinType._("None", "0");
  //触摸
  static const Touch = OrderItemJoinType._("触摸", "1");
  //扫码
  static const ScanBarCode = OrderItemJoinType._("扫码", "2");
  //扫金额码
  static const ScanAmountCode = OrderItemJoinType._("扫金额码", "3");
  //扫数量码
  static const ScanQuantityCode = OrderItemJoinType._("扫数量码", "4");
  //系统自动添加
  static const Automatic = OrderItemJoinType._("系统自动添加", "5");

  factory OrderItemJoinType.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return OrderItemJoinType.Touch;
        }
      case "2":
        {
          return OrderItemJoinType.ScanBarCode;
        }
      case "3":
        {
          return OrderItemJoinType.ScanAmountCode;
        }
      case "4":
        {
          return OrderItemJoinType.ScanQuantityCode;
        }
      case "5":
        {
          return OrderItemJoinType.Automatic;
        }
      default:
        {
          return OrderItemJoinType.None;
        }
    }
  }

  factory OrderItemJoinType.fromName(String name) {
    switch (name) {
      case "触摸":
        {
          return OrderItemJoinType.Touch;
        }
      case "扫码":
        {
          return OrderItemJoinType.ScanBarCode;
        }
      case "扫金额码":
        {
          return OrderItemJoinType.ScanAmountCode;
        }
      case "扫数量码":
        {
          return OrderItemJoinType.ScanQuantityCode;
        }
      case "系统自动添加":
        {
          return OrderItemJoinType.Automatic;
        }
      default:
        {
          return OrderItemJoinType.None;
        }
    }
  }
}
