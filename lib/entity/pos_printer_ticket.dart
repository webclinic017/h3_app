import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class PrinterTicket extends BaseEntity {
  ///表名称
  static final String tableName = "pos_printer_ticket";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnPrintTicket = "printTicket";
  static final String columnCopies = "copies";
  static final String columnPrinterId = "printerId";
  static final String columnPrinterName = "printerName";
  static final String columnPrinterType = "printerType";
  static final String columnOrderType = "orderType";
  static final String columnMemo = "memo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnPlanId = "planId";

  ///字段名称
  String printTicket;
  int copies;
  String printerId;
  String printerName;
  String printerType;
  String orderType;
  String memo;
  String planId;

  ///默认构造
  PrinterTicket();

  ///Map转实体对象
  factory PrinterTicket.fromMap(Map<String, dynamic> map) {
    return PrinterTicket()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..printTicket = Convert.toStr(map[columnPrintTicket])
      ..copies = Convert.toInt(map[columnCopies])
      ..printerId = Convert.toStr(map[columnPrinterId])
      ..printerName = Convert.toStr(map[columnPrinterName])
      ..printerType = Convert.toStr(map[columnPrinterType])
      ..orderType = Convert.toStr(map[columnOrderType])
      ..memo = Convert.toStr(map[columnMemo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..planId = Convert.toStr(map[columnPlanId]);
  }

  factory PrinterTicket.clone(PrinterTicket obj) {
    return PrinterTicket()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..printTicket = obj.printTicket
      ..copies = obj.copies
      ..printerId = obj.printerId
      ..printerName = obj.printerName
      ..printerType = obj.printerType
      ..orderType = obj.orderType
      ..memo = obj.memo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createDate = obj.createDate
      ..createUser = obj.createUser
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..planId = obj.planId;
  }

  factory PrinterTicket.newPrinterTicket() {
    return PrinterTicket()
      ..id = ""
      ..tenantId = ""
      ..printTicket = ""
      ..copies = 1
      ..printerId = ""
      ..printerName = ""
      ..printerType = ""
      ..orderType = ""
      ..memo = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..modifyUser = ""
      ..modifyDate = ""
      ..planId = "";
  }

  ///转List集合
  static List<PrinterTicket> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PrinterTicket>();
    lists.forEach((map) => result.add(PrinterTicket.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnPrintTicket: this.printTicket,
      columnCopies: this.copies,
      columnPrinterId: this.printerId,
      columnPrinterName: this.printerName,
      columnPrinterType: this.printerType,
      columnOrderType: this.orderType,
      columnMemo: this.memo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnPlanId: this.planId,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
