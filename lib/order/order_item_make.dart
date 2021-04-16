import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

class OrderItemMake {
  ///订单ID
  String id = "";

  ///租户编码
  String tenantId = "";

  ///订单Id
  String orderId = "";

  ///订单号
  String tradeNo = "";

  /// 行ID
  String itemId = "";

  /// 做法ID
  String makeId = "";

  /// 做法编号
  String code = "";

  /// 做法名称
  String name = "";

  /// 做法加价规则1 不加价  2固定加价  3 按数量加价
  int qtyFlag = 1;

  /// 数量
  double quantity = 1;

  /// 退数量
  double refundQuantity = 0;

  /// 售价
  double salePrice = 0;

  /// 折后售价
  double price = 0;

  /// 类型(0口味1加料)
  int type = 0;

  /// 是否单选(0否1是)
  int isRadio = 0;

  /// 做法单选或者多选情况下的标识，单选采用TypeId，多选采用detailId
  String group = "";

  /// 备注

  String description = "";

  /// 金额小计
  double amount = 0;

  /// 折扣金额
  double discountAmount = 0;

  /// 折扣率
  double discountRate = 0;

  /// 应收金额
  double receivableAmount = 0;

  /// 手写做法标识(0否1是)
  int hand = 0;

  /// 订单中的商品数量
  double itemQuantity = 0;

  /// 做法计价的基准数量 1单位数量对应的做法数量
  double baseQuantity = 0;

  /// 订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 扩展信息1
  String ext1 = "";

  /// 扩展信息2
  String ext2 = "";

  /// 扩展信息3
  String ext3 = "";

  ///创建人
  String createUser = Constants.DEFAULT_CREATE_USER;

  ///创建日期
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///修改人
  String modifyUser = Constants.DEFAULT_MODIFY_USER;

  ///修改日期
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 桌台ID
  String tableId = "";

  /// 桌台编号
  String tableNo = "";

  /// 桌台名称
  String tableName = "";

  ///默认构造
  OrderItemMake();

  factory OrderItemMake.newOrderItem() {
    return OrderItemMake()
      ..id = ""
      ..tenantId = ""
      ..orderId = ""
      ..tradeNo = ""
      ..itemId = ""
      ..makeId = ""
      ..code = ""
      ..name = ""
      ..qtyFlag = 1
      ..quantity = 1
      ..refundQuantity = 0
      ..salePrice = 0
      ..price = 0
      ..type = 0
      ..isRadio = 0
      ..group = ""
      ..description = ""
      ..amount = 0
      ..discountRate = 0
      ..discountAmount = 0
      ..receivableAmount = 0
      ..hand = 0
      ..itemQuantity = 0
      ..baseQuantity = 0
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..tableId = ""
      ..tableNo = ""
      ..tableName = "";
  }

  ///转List集合
  static List<OrderItemMake> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderItemMake>();
    lists.forEach((map) => result.add(OrderItemMake.fromJson(map)));
    return result;
  }

  factory OrderItemMake.fromJson(Map<String, dynamic> map) {
    return OrderItemMake()
      ..id = Convert.toStr(map["id"])
      ..tenantId = Convert.toStr(map["tenantId"])
      ..orderId = Convert.toStr(map["orderId"])
      ..tradeNo = Convert.toStr(map["tradeNo"])
      ..itemId = Convert.toStr(map["itemId"])
      ..makeId = Convert.toStr(map["makeId"])
      ..code = Convert.toStr(map["code"])
      ..name = Convert.toStr(map["name"])
      ..qtyFlag = Convert.toInt(map["qtyFlag"])
      ..quantity = Convert.toDouble(map["quantity"])
      ..refundQuantity = Convert.toDouble(map["refundQuantity"])
      ..salePrice = Convert.toDouble(map["salePrice"])
      ..price = Convert.toDouble(map["price"])
      ..type = Convert.toInt(map["type"])
      ..isRadio = Convert.toInt(map["isRadio"])
      ..group = Convert.toStr(map["group"])
      ..description = Convert.toStr(map["description"])
      ..amount = Convert.toDouble(map["amount"])
      ..discountAmount = Convert.toDouble(map["discountAmount"])
      ..discountRate = Convert.toDouble(map["discountRate"])
      ..receivableAmount = Convert.toDouble(map["receivableAmount"])
      ..hand = Convert.toInt(map["hand"])
      ..itemQuantity = Convert.toDouble(map["itemQuantity"])
      ..baseQuantity = Convert.toDouble(map["baseQuantity"])
      ..finishDate = Convert.toStr(map["finishDate"])
      ..ext1 = Convert.toStr(map["ext1"])
      ..ext2 = Convert.toStr(map["ext2"])
      ..ext3 = Convert.toStr(map["ext3"])
      ..createUser = Convert.toStr(map["createUser"])
      ..createDate = Convert.toStr(map["createDate"])
      ..modifyUser = Convert.toStr(map["modifyUser"])
      ..modifyDate = Convert.toStr(map["modifyDate"])
      ..tableId = Convert.toStr(map["tableId"])
      ..tableNo = Convert.toStr(map["tableNo"])
      ..tableName = Convert.toStr(map["tableName"]);
  }

  factory OrderItemMake.clone(OrderItemMake obj) {
    return OrderItemMake()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..orderId = obj.orderId
      ..tradeNo = obj.tradeNo
      ..itemId = obj.itemId
      ..makeId = obj.makeId
      ..code = obj.code
      ..name = obj.name
      ..qtyFlag = obj.qtyFlag
      ..name = obj.name
      ..quantity = obj.quantity
      ..refundQuantity = obj.refundQuantity
      ..salePrice = obj.salePrice
      ..price = obj.price
      ..type = obj.type
      ..isRadio = obj.isRadio
      ..group = obj.group
      ..description = obj.description
      ..amount = obj.amount
      ..discountAmount = obj.discountAmount
      ..discountRate = obj.discountRate
      ..receivableAmount = obj.receivableAmount
      ..hand = obj.hand
      ..itemQuantity = obj.itemQuantity
      ..baseQuantity = obj.baseQuantity
      ..finishDate = obj.finishDate
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..tableId = obj.tableId
      ..tableNo = obj.tableNo
      ..tableName = obj.tableName;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "tenantId": this.tenantId,
      "orderId": this.orderId,
      "tradeNo": this.tradeNo,
      "orderItemId": this.itemId,
      "makeId": this.makeId,
      "code": this.code,
      "name": this.name,
      "qtyFlag": this.qtyFlag,
      "quantity": this.quantity,
      "refundQuantity": this.refundQuantity,
      "price": this.price,
      "salePrice": this.salePrice,
      "type": this.type,
      "isRadio": this.isRadio,
      "group": this.group,
      "description": this.description,
      "amount": this.amount,
      "discountAmount": this.discountAmount,
      "discountRate": this.discountRate,
      "receivableAmount": this.receivableAmount,
      "hand": this.hand,
      "itemQuantity": this.itemQuantity,
      "baseQuantity": this.baseQuantity,
      "finishDate": this.finishDate,
      "ext1": this.ext1,
      "ext2": this.ext2,
      "ext3": this.ext3,
      "createUser": this.createUser,
      "createDate": this.createDate,
      "modifyUser": this.modifyUser,
      "modifyDate": this.modifyDate,
      "tableId": this.tableId,
      "tableNo": this.tableNo,
      "tableName": this.tableName,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
