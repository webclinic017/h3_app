//点单明细的行数据类型
class OrderItemRowType {
  final String name;
  final String value;
  const OrderItemRowType._(this.name, this.value);

  static const None = OrderItemRowType._("None", "0");
  //普通
  static const Normal = OrderItemRowType._("普通", "1");
  //捆绑主
  static const Master = OrderItemRowType._("捆绑主", "2");
  //捆绑明
  static const Detail = OrderItemRowType._("捆绑明", "3");
  //套餐主
  static const SuitMaster = OrderItemRowType._("套餐主", "4");
  //套餐明
  static const SuitDetail = OrderItemRowType._("套餐明", "5");

  factory OrderItemRowType.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return OrderItemRowType.Normal;
        }
      case "2":
        {
          return OrderItemRowType.Master;
        }
      case "3":
        {
          return OrderItemRowType.Detail;
        }
      case "4":
        {
          return OrderItemRowType.SuitMaster;
        }
      case "5":
        {
          return OrderItemRowType.SuitDetail;
        }
      default:
        {
          return OrderItemRowType.None;
        }
    }
  }

  factory OrderItemRowType.fromName(String name) {
    switch (name) {
      case "普通":
        {
          return OrderItemRowType.Normal;
        }
      case "捆绑主":
        {
          return OrderItemRowType.Master;
        }
      case "捆绑明":
        {
          return OrderItemRowType.Detail;
        }
      case "套餐主":
        {
          return OrderItemRowType.SuitMaster;
        }
      case "套餐明":
        {
          return OrderItemRowType.SuitDetail;
        }
      default:
        {
          return OrderItemRowType.None;
        }
    }
  }
}
