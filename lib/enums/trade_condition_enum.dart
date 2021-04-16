class TradeConditionEnum {
  final String name;
  final int value;

  const TradeConditionEnum._(this.name, this.value);

  static const Today = TradeConditionEnum._("今日", 0);
  static const Yesterday = TradeConditionEnum._("昨天", 1);
  static const Nearly7Days = TradeConditionEnum._("近7天", 2);
  static const Nearly30Days = TradeConditionEnum._("近30天", 3);

  static Map<int, TradeConditionEnum> getValues() {
    Map<int, TradeConditionEnum> result = {
      0: Today,
      1: Yesterday,
      2: Nearly7Days,
      3: Nearly30Days,
    };
    return result;
  }

  static int getIndex(String name) {
    return TradeConditionEnum.getValues().keys.firstWhere((key) => (TradeConditionEnum.getValues()[key]) == TradeConditionEnum.fromName("$name"), orElse: () => 0);
  }

  factory TradeConditionEnum.fromValue(int value) {
    switch (value) {
      case 0:
        {
          return TradeConditionEnum.Today;
        }
      case 1:
        {
          return TradeConditionEnum.Yesterday;
        }
      case 2:
        {
          return TradeConditionEnum.Nearly7Days;
        }
      case 3:
        {
          return TradeConditionEnum.Nearly30Days;
        }
      default:
        {
          return TradeConditionEnum.Today;
        }
    }
  }

  factory TradeConditionEnum.fromName(String name) {
    switch (name) {
      case "今日":
        {
          return TradeConditionEnum.Today;
        }
      case "昨天":
        {
          return TradeConditionEnum.Yesterday;
        }
      case "近7天":
        {
          return TradeConditionEnum.Nearly7Days;
        }
      case "近30天":
        {
          return TradeConditionEnum.Nearly30Days;
        }
      default:
        {
          return TradeConditionEnum.Today;
        }
    }
  }
}
