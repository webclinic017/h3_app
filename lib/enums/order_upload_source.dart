class OrderUploadSource {
  final String name;
  final int value;
  const OrderUploadSource._(this.name, this.value);

  // 快餐
  static const FastFood = OrderUploadSource._("快餐", 0);
  // 中餐
  static const ChineseFood = OrderUploadSource._("中餐", 1);

  factory OrderUploadSource.fromValue(int value) {
    switch ("$value") {
      case "0":
        {
          return OrderUploadSource.FastFood;
        }
      case "1":
        {
          return OrderUploadSource.ChineseFood;
        }
      default:
        {
          return OrderUploadSource.FastFood;
        }
    }
  }

  factory OrderUploadSource.fromName(String name) {
    switch (name) {
      case "快餐":
        {
          return OrderUploadSource.FastFood;
        }
      case "中餐":
        {
          return OrderUploadSource.ChineseFood;
        }
      default:
        {
          return OrderUploadSource.FastFood;
        }
    }
  }
}
