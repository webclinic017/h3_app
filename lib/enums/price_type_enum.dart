class PriceTypeEnum {
  final String name;
  final String value;
  const PriceTypeEnum._(this.name, this.value);

  //零售价
  static const SalePrice = PriceTypeEnum._("零售价", "0");
  //会员价
  static const MemberPrice = PriceTypeEnum._("会员价", "1");

  factory PriceTypeEnum.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return PriceTypeEnum.SalePrice;
        }
      case "1":
        {
          return PriceTypeEnum.MemberPrice;
        }
      default:
        {
          return PriceTypeEnum.SalePrice;
        }
    }
  }

  factory PriceTypeEnum.fromName(String name) {
    switch (name) {
      case "零售价":
        {
          return PriceTypeEnum.SalePrice;
        }
      case "会员价":
        {
          return PriceTypeEnum.MemberPrice;
        }

      default:
        {
          return PriceTypeEnum.SalePrice;
        }
    }
  }
}
