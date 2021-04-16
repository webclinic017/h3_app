import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:meta/meta.dart';

class OrderRefund extends Equatable {
  ///是否被选择
  bool selected = false;

  /// 订单明细ID
  String itemId = "";

  /// 退数量
  double refundQuantity = 0;

  /// 退单价
  double refundPrice = 0;

  /// 退金额
  double refundAmount = 0;

  ///最大退货量
  double maxRefundQuantity = 0;

  OrderRefund();

  factory OrderRefund.newOrderRefund() {
    return OrderRefund()
      ..selected = false
      ..itemId = ""
      ..refundQuantity = 0
      ..refundPrice = 0
      ..refundAmount = 0
      ..maxRefundQuantity = 0;
  }

  ///转List集合
  static List<OrderRefund> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderRefund>();
    lists.forEach((map) => result.add(OrderRefund.fromJson(map)));
    return result;
  }

  factory OrderRefund.fromJson(Map<String, dynamic> map) {
    return OrderRefund()
      ..selected = Convert.toBool(map["selected"])
      ..itemId = Convert.toStr(map["itemId"])
      ..refundQuantity = Convert.toDouble(map["refundQuantity"])
      ..refundPrice = Convert.toDouble(map["refundPrice"])
      ..refundAmount = Convert.toDouble(map["refundAmount"])
      ..maxRefundQuantity = Convert.toDouble(map["maxRefundQuantity"]);
  }

  factory OrderRefund.clone(OrderRefund obj) {
    return OrderRefund()
      ..selected = obj.selected
      ..itemId = obj.itemId
      ..refundQuantity = obj.refundQuantity
      ..refundPrice = obj.refundPrice
      ..refundAmount = obj.refundAmount
      ..maxRefundQuantity = obj.maxRefundQuantity;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "selected ": this.selected,
      "itemId ": this.itemId,
      "refundQuantity": this.refundQuantity,
      "refundPrice": this.refundPrice,
      "refundAmount": this.refundAmount,
      "maxRefundQuantity": this.maxRefundQuantity,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.selected,
        itemId,
        refundQuantity,
        refundAmount,
        maxRefundQuantity,
        this.refundPrice
      ];
}
