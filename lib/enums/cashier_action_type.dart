class CashierAction {
  final String name;
  final String value;
  const CashierAction._(this.name, this.value);

  static const None = CashierAction._("None", "0");
  //收银
  static const Cashier = CashierAction._("收银", "1");
  //退货
  static const Refund = CashierAction._("退货", "2");

  factory CashierAction.fromValue(String value) {
    switch (value) {
      case "1":
        {
          return CashierAction.Cashier;
        }
      case "2":
        {
          return CashierAction.Refund;
        }

      default:
        {
          return CashierAction.None;
        }
    }
  }

  factory CashierAction.fromName(String name) {
    switch (name) {
      case "收银":
        {
          return CashierAction.Cashier;
        }
      case "退货":
        {
          return CashierAction.Refund;
        }

      default:
        {
          return CashierAction.None;
        }
    }
  }
}
