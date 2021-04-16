//订单来源
class OrderSource {
  final String name;
  final String value;
  const OrderSource._(this.name, this.value);

  static const None = OrderSource._("None", "-1");
  //收银台
  static const CashRegister = OrderSource._("收银台", "0");
  //自助收银机
  static const SelfServiceCash = OrderSource._("自助收银机", "1");
  //扫码购
  static const ScanGo = OrderSource._("扫码购", "2");
//网店
  static const OnlineStore = OrderSource._("网店", "20");
//拼团
  static const FightTheGroup = OrderSource._("拼团", "21");

//美团外卖
  static const MeituanTakeout = OrderSource._("美团外卖", "30");
//饿了么外卖
  static const ElemeTakeout = OrderSource._("饿了么外卖", "31");
//云称
  static const CloudScale = OrderSource._("云称", "40");

  //点菜宝
  static const AppTouch = OrderSource._("点菜宝", "3");

  factory OrderSource.fromValue(String value) {
    switch (value) {
      case "0":
        {
          return OrderSource.CashRegister;
        }
      case "1":
        {
          return OrderSource.SelfServiceCash;
        }
      case "2":
        {
          return OrderSource.ScanGo;
        }
      case "3":
        {
          return OrderSource.AppTouch;
        }
      case "20":
        {
          return OrderSource.OnlineStore;
        }
      case "21":
        {
          return OrderSource.FightTheGroup;
        }
      case "30":
        {
          return OrderSource.MeituanTakeout;
        }
      case "31":
        {
          return OrderSource.ElemeTakeout;
        }
      case "40":
        {
          return OrderSource.CloudScale;
        }
      default:
        {
          return OrderSource.None;
        }
    }
  }

  factory OrderSource.fromName(String name) {
    switch (name) {
      case "收银台":
        {
          return OrderSource.CashRegister;
        }
      case "自助收银机":
        {
          return OrderSource.SelfServiceCash;
        }
      case "扫码购":
        {
          return OrderSource.ScanGo;
        }
      case "网店":
        {
          return OrderSource.OnlineStore;
        }
      case "拼团":
        {
          return OrderSource.FightTheGroup;
        }
      case "美团外卖":
        {
          return OrderSource.MeituanTakeout;
        }
      case "饿了么外卖":
        {
          return OrderSource.ElemeTakeout;
        }
      case "云称":
        {
          return OrderSource.CloudScale;
        }
      case "点菜宝":
        {
          return OrderSource.AppTouch;
        }
      default:
        {
          return OrderSource.None;
        }
    }
  }

  @override
  String toString() {
    return this.value;
  }
}
