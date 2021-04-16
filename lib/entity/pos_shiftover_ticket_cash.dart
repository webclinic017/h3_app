import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'base_entity.dart';

class ShiftoverTicketCash extends BaseEntity {
  ///表名称
  static final String tableName = "pos_shiftover_ticket_cash";

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
  static final String columnConsumeCash = "consumeCash";
  static final String columnConsumeCashRefund = "consumeCashRefund";
  static final String columnCardRechargeCash = "cardRechargeCash";
  static final String columnCardCashRefund = "cardCashRefund";
  static final String columnNoTransCashIn = "noTransCashIn";
  static final String columnNoTransCashOut = "noTransCashOut";
  static final String columnTimesCashRecharge = "timesCashRecharge";
  static final String columnImprest = "imprest";
  static final String columnTotalCash = "totalCash";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnPlusCashRecharge = "plusCashRecharge";
  static final String columnGiftCardSaleCash = "giftCardSaleCash";

  ///字段名称
  String ticketId;
  String storeId;
  String storeNo;
  String storeName;
  String shiftId;
  String shiftNo;
  String shiftName;
  double consumeCash;
  double consumeCashRefund;
  double cardRechargeCash;
  double cardCashRefund;
  double noTransCashIn;
  double noTransCashOut;
  double timesCashRecharge;
  double imprest;
  double totalCash;
  double plusCashRecharge;
  double giftCardSaleCash;

  ///默认构造
  ShiftoverTicketCash();

  ///Map转实体对象
  factory ShiftoverTicketCash.fromMap(Map<String, dynamic> map) {
    return ShiftoverTicketCash()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..ticketId = Convert.toStr(map[columnTicketId])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..storeName = Convert.toStr(map[columnStoreName])
      ..shiftId = Convert.toStr(map[columnShiftId])
      ..shiftNo = Convert.toStr(map[columnShiftNo])
      ..shiftName = Convert.toStr(map[columnShiftName])
      ..consumeCash = Convert.toDouble(map[columnConsumeCash])
      ..consumeCashRefund = Convert.toDouble(map[columnConsumeCashRefund])
      ..cardRechargeCash = Convert.toDouble(map[columnCardRechargeCash])
      ..cardCashRefund = Convert.toDouble(map[columnCardCashRefund])
      ..noTransCashIn = Convert.toDouble(map[columnNoTransCashIn])
      ..noTransCashOut = Convert.toDouble(map[columnNoTransCashOut])
      ..timesCashRecharge = Convert.toDouble(map[columnTimesCashRecharge])
      ..imprest = Convert.toDouble(map[columnImprest])
      ..totalCash = Convert.toDouble(map[columnTotalCash])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..plusCashRecharge = Convert.toDouble(map[columnPlusCashRecharge])
      ..giftCardSaleCash = Convert.toDouble(map[columnGiftCardSaleCash]);
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
      columnConsumeCash: this.consumeCash,
      columnConsumeCashRefund: this.consumeCashRefund,
      columnCardRechargeCash: this.cardRechargeCash,
      columnCardCashRefund: this.cardCashRefund,
      columnNoTransCashIn: this.noTransCashIn,
      columnNoTransCashOut: this.noTransCashOut,
      columnTimesCashRecharge: this.timesCashRecharge,
      columnImprest: this.imprest,
      columnTotalCash: this.totalCash,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnPlusCashRecharge: this.plusCashRecharge,
      columnGiftCardSaleCash: this.giftCardSaleCash,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
