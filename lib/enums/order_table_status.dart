class OrderTableStatus {
  final String name;
  final int value;
  const OrderTableStatus._(this.name, this.value);

  static const All = OrderTableStatus._("全部", -1);
  // 空闲
  static const Free = OrderTableStatus._("空闲", 0);
  //在用
  static const Occupied = OrderTableStatus._("在用", 1);
  //预订
  static const Reservation = OrderTableStatus._("预订", 2);

  factory OrderTableStatus.fromValue(int value) {
    switch ("$value") {
      case "0":
        {
          return OrderTableStatus.Free;
        }
      case "1":
        {
          return OrderTableStatus.Occupied;
        }
      case "2":
        {
          return OrderTableStatus.Reservation;
        }
      default:
        {
          return OrderTableStatus.All;
        }
    }
  }

  factory OrderTableStatus.fromName(String name) {
    switch (name) {
      case "空闲":
        {
          return OrderTableStatus.Free;
        }
      case "在用":
        {
          return OrderTableStatus.Occupied;
        }
      case "预订":
        {
          return OrderTableStatus.Reservation;
        }

      default:
        {
          return OrderTableStatus.All;
        }
    }
  }
}
