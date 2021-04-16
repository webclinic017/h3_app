// import 'package:h3_app/blocs/cashier_bloc.dart';
// import 'package:h3_app/pages/table_page.dart';

class OrderTableAction {
  final String name;
  final int value;
  const OrderTableAction._(this.name, this.value);

  static const None = OrderTableAction._("None", 0);
  //开台
  static const Open = OrderTableAction._("开台", 1);
  //消台
  static const Cancel =
      OrderTableAction._("消台", 2); //zhangy 2020-10-31 Edit 消台这个动作可以不要，统一并入清台操作
  //并台
  static const Merge = OrderTableAction._("并台", 3);
  //清台
  static const Clear = OrderTableAction._("清台", 4);
  //转台
  static const Transfer = OrderTableAction._("转台", 5);

  factory OrderTableAction.fromValue(int value) {
    switch ("$value") {
      case "1":
        {
          return OrderTableAction.Open;
        }
      case "2":
        {
          return OrderTableAction.Cancel;
        }
      case "3":
        {
          return OrderTableAction.Merge;
        }
      case "4":
        {
          return OrderTableAction.Clear;
        }
      case "5":
        {
          return OrderTableAction.Transfer;
        }
      default:
        {
          return OrderTableAction.None;
        }
    }
  }

  factory OrderTableAction.fromName(String name) {
    switch (name) {
      case "开台":
        {
          return OrderTableAction.Open;
        }
      case "消台":
        {
          return OrderTableAction.Cancel;
        }
      case "并台":
        {
          return OrderTableAction.Merge;
        }
      case "清台":
        {
          return OrderTableAction.Clear;
        }
      case "转台":
        {
          return OrderTableAction.Transfer;
        }
      default:
        {
          return OrderTableAction.None;
        }
    }
  }
}
