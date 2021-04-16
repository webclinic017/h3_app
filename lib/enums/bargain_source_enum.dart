class BargainSourceEnum {
  final String name;
  final String value;

  const BargainSourceEnum._(this.name, this.value);

  static const ZeroPrice = BargainSourceEnum._("零价商品", "0");
  static const Price = BargainSourceEnum._("改价格", "1");
  static const Total = BargainSourceEnum._("改小计", "2");

  static Iterable<BargainSourceEnum> getValues() {
    return [ZeroPrice, Price, Total];
  }

  static List<String> getLabels() {
    return [Price.name, Total.name];
  }

  factory BargainSourceEnum.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return BargainSourceEnum.Price;
        }
      case "2":
        {
          return BargainSourceEnum.Total;
        }
      default:
        {
          return BargainSourceEnum.ZeroPrice;
        }
    }
  }

  factory BargainSourceEnum.fromName(String name) {
    switch (name) {
      case "改价格":
        {
          return BargainSourceEnum.Price;
        }
      case "改小计":
        {
          return BargainSourceEnum.Total;
        }
      default:
        {
          return BargainSourceEnum.ZeroPrice;
        }
    }
  }
}
