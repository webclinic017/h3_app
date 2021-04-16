class PrintTicketEnum {
  final String name;
  final String value;

  const PrintTicketEnum._(this.name, this.value);

  static const None = PrintTicketEnum._("None", "0");

  static const Statement = PrintTicketEnum._("结账单", "1");

  static const ShiftOrder = PrintTicketEnum._("交班单", "2");

  factory PrintTicketEnum.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return PrintTicketEnum.Statement;
        }
      case "2":
        {
          return PrintTicketEnum.ShiftOrder;
        }
      default:
        {
          return PrintTicketEnum.None;
        }
    }
  }

  factory PrintTicketEnum.fromName(String name) {
    switch (name) {
      case "结账单":
        {
          return PrintTicketEnum.Statement;
        }
      case "交班单":
        {
          return PrintTicketEnum.ShiftOrder;
        }
      default:
        {
          return PrintTicketEnum.None;
        }
    }
  }
}
