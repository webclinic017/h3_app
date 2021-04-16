import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class ShiftoverTicketPay extends BaseEntity {
  ///表名称
  static final String tableName = "pos_shiftover_ticket_pay";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnTicketId = "ticketId";
  static final String columnStoreId = "storeId";
  static final String columnStoreNo = "storeNo";
  static final String columnStoreName = "storeName";
  static final String columnShiftId = "shiftId";
  static final String columnShiftNo = "shiftNo";
  static final String columnShiftName = "shiftName";
  static final String columnBusinessType = "businessType";
  static final String columnPayModeNo = "payModeNo";
  static final String columnPayModeName = "payModeName";
  static final String columnQuantity = "quantity";
  static final String columnAmount = "amount";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String ticketId;
  String storeId;
  String storeNo;
  String storeName;
  String shiftId;
  String shiftNo;
  String shiftName;
  String businessType;
  String payModeNo;
  String payModeName;
  int quantity;
  double amount;

  ///默认构造
  ShiftoverTicketPay();

  ///Map转实体对象
  factory ShiftoverTicketPay.fromMap(Map<String, dynamic> map) {
    return ShiftoverTicketPay()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..ticketId = Convert.toStr(map[columnTicketId])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..storeName = Convert.toStr(map[columnStoreName])
      ..shiftId = Convert.toStr(map[columnShiftId])
      ..shiftNo = Convert.toStr(map[columnShiftNo])
      ..shiftName = Convert.toStr(map[columnShiftName])
      ..businessType = Convert.toStr(map[columnBusinessType])
      ..payModeNo = Convert.toStr(map[columnPayModeNo])
      ..payModeName = Convert.toStr(map[columnPayModeName])
      ..quantity = Convert.toInt(map[columnQuantity])
      ..amount = Convert.toDouble(map[columnAmount])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///转List集合
  static List<ShiftoverTicketPay> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ShiftoverTicketPay>();
    lists.forEach((map) => result.add(ShiftoverTicketPay.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnTicketId: this.ticketId,
      columnStoreId: this.storeId,
      columnStoreNo: this.storeNo,
      columnStoreName: this.storeName,
      columnShiftId: this.shiftId,
      columnShiftNo: this.shiftNo,
      columnShiftName: this.shiftName,
      columnBusinessType: this.businessType,
      columnPayModeNo: this.payModeNo,
      columnPayModeName: this.payModeName,
      columnQuantity: this.quantity,
      columnAmount: this.amount,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
