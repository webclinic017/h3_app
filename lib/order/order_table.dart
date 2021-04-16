import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:flutter/material.dart';
import '../entity/base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-29 16:36:47
@immutable
class OrderTable extends BaseEntity {
  ///表名称,zhangy 2020-10-29 注释，字段生成重复
  //static final String tableName = "pos_order_table";
  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnOrderId = "orderId";
  static final String columnTradeNo = "tradeNo";
  static final String columnTableId = "tableId";
  static final String columnTableNo = "tableNo";
  static final String columnTableName = "tableName";
  static final String columnTypeId = "typeId";
  static final String columnTypeNo = "typeNo";
  static final String columnTypeName = "typeName";
  static final String columnAreaId = "areaId";
  static final String columnAreaNo = "areaNo";
  static final String columnAreaName = "areaName";
  static final String columnTableStatus = "tableStatus";
  static final String columnOpenTime = "openTime";
  static final String columnOpenUser = "openUser";
  static final String columnTableNumber = "tableNumber";
  static final String columnSerialNo = "serialNo";
  static final String columnTableAction = "tableAction";
  static final String columnPeople = "people";
  static final String columnExcessFlag = "excessFlag";
  static final String columnTotalAmount = "totalAmount";
  static final String columnTotalQuantity = "totalQuantity";
  static final String columnDiscountAmount = "discountAmount";
  static final String columnTotalRefund = "totalRefund";
  static final String columnTotalRefundAmount = "totalRefundAmount";
  static final String columnTotalGive = "totalGive";
  static final String columnTotalGiveAmount = "totalGiveAmount";
  static final String columnDiscountRate = "discountRate";
  static final String columnReceivableAmount = "receivableAmount";
  static final String columnPaidAmount = "paidAmount";
  static final String columnMalingAmount = "malingAmount";
  static final String columnMaxOrderNo = "maxOrderNo";
  static final String columnMasterTable = "masterTable";
  static final String columnPerCapitaAmount = "perCapitaAmount";
  static final String columnPosNo = "posNo";
  static final String columnPayNo = "payNo";
  static final String columnFinishDate = "finishDate";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String orderId;
  String tradeNo;
  String tableId;
  String tableNo;
  String tableName;
  String typeId;
  String typeNo;
  String typeName;
  String areaId;
  String areaNo;
  String areaName;
  int tableStatus;
  String openTime;
  String openUser;
  int tableNumber;
  String serialNo;
  int tableAction;
  int people;
  int excessFlag;
  double totalAmount;
  double totalQuantity;
  double discountAmount;
  double totalRefund;
  double totalRefundAmount;
  double totalGive;
  double totalGiveAmount;
  double discountRate;
  double receivableAmount;
  double paidAmount;
  double malingAmount;
  int maxOrderNo;
  int masterTable;
  double perCapitaAmount;
  String posNo;
  String payNo;
  String finishDate;

  //--------------------------新增部分------------------------
  ///zhangy 2020-11-08 Add 桌台已经下单的数量
  static final String columnPlaceOrders = "placeOrders";
  double placeOrders;
  //---------------------------------------------------------

  ///默认构造
  OrderTable();

  ///Map转实体对象
  factory OrderTable.fromMap(Map<String, dynamic> map) {
    return OrderTable()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..orderId = Convert.toStr(map[columnOrderId])
      ..tradeNo = Convert.toStr(map[columnTradeNo])
      ..tableId = Convert.toStr(map[columnTableId])
      ..tableNo = Convert.toStr(map[columnTableNo])
      ..tableName = Convert.toStr(map[columnTableName])
      ..typeId = Convert.toStr(map[columnTypeId])
      ..typeNo = Convert.toStr(map[columnTypeNo])
      ..typeName = Convert.toStr(map[columnTypeName])
      ..areaId = Convert.toStr(map[columnAreaId])
      ..areaNo = Convert.toStr(map[columnAreaNo])
      ..areaName = Convert.toStr(map[columnAreaName])
      ..tableStatus = Convert.toInt(map[columnTableStatus])
      ..openTime = Convert.toStr(map[columnOpenTime])
      ..openUser = Convert.toStr(map[columnOpenUser])
      ..tableNumber = Convert.toInt(map[columnTableNumber])
      ..serialNo = Convert.toStr(map[columnSerialNo])
      ..tableAction = Convert.toInt(map[columnTableAction])
      ..people = Convert.toInt(map[columnPeople])
      ..excessFlag = Convert.toInt(map[columnExcessFlag])
      ..totalAmount = Convert.toDouble(map[columnTotalAmount])
      ..totalQuantity = Convert.toDouble(map[columnTotalQuantity])
      ..discountAmount = Convert.toDouble(map[columnDiscountAmount])
      ..totalRefund = Convert.toDouble(map[columnTotalRefund])
      ..totalRefundAmount = Convert.toDouble(map[columnTotalRefundAmount])
      ..totalGive = Convert.toDouble(map[columnTotalGive])
      ..totalGiveAmount = Convert.toDouble(map[columnTotalGiveAmount])
      ..discountRate = Convert.toDouble(map[columnDiscountRate])
      ..receivableAmount = Convert.toDouble(map[columnReceivableAmount])
      ..paidAmount = Convert.toDouble(map[columnPaidAmount])
      ..malingAmount = Convert.toDouble(map[columnMalingAmount])
      ..maxOrderNo = Convert.toInt(map[columnMaxOrderNo])
      ..masterTable = Convert.toInt(map[columnMasterTable])
      ..perCapitaAmount = Convert.toDouble(map[columnPerCapitaAmount])
      ..posNo = Convert.toStr(map[columnPosNo])
      ..payNo = Convert.toStr(map[columnPayNo])
      ..finishDate = Convert.toStr(map[columnFinishDate])
      ..ext1 = Convert.toStr(map[columnExt1], "")
      ..ext2 = Convert.toStr(map[columnExt2], "")
      ..ext3 = Convert.toStr(map[columnExt3], "")
      ..createUser =
          Convert.toStr(map[columnCreateUser], Constants.DEFAULT_CREATE_USER)
      ..createDate = Convert.toStr(map[columnCreateDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..modifyUser =
          Convert.toStr(map[columnModifyUser], Constants.DEFAULT_MODIFY_USER)
      ..modifyDate = Convert.toStr(map[columnModifyDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..placeOrders = Convert.toDouble(map[columnPlaceOrders]);
  }

  ///构建空对象
  factory OrderTable.newOrderTable() {
    return OrderTable()
      ..id = "${IdWorkerUtils.getInstance().generate()}"
      ..tenantId = "${Global.instance.authc?.tenantId}"
      ..orderId = ""
      ..tradeNo = ""
      ..tableId = ""
      ..tableNo = ""
      ..tableName = ""
      ..typeId = ""
      ..typeNo = ""
      ..typeName = ""
      ..areaId = ""
      ..areaNo = ""
      ..areaName = ""
      ..tableStatus = 0
      ..openTime = ""
      ..openUser = ""
      ..tableNumber = 0
      ..serialNo = ""
      ..tableAction = 0
      ..people = 0
      ..excessFlag = 0
      ..totalAmount = 0.0
      ..totalQuantity = 0.0
      ..discountAmount = 0.0
      ..totalRefund = 0.0
      ..totalRefundAmount = 0.0
      ..totalGive = 0.0
      ..totalGiveAmount = 0.0
      ..discountRate = 0.0
      ..receivableAmount = 0.0
      ..paidAmount = 0.0
      ..malingAmount = 0.0
      ..maxOrderNo = 0
      ..masterTable = 0
      ..perCapitaAmount = 0.0
      ..posNo = ""
      ..payNo = ""
      ..finishDate = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = Constants.DEFAULT_MODIFY_USER
      ..modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..placeOrders = 0;
  }

  ///复制新对象
  factory OrderTable.clone(OrderTable obj) {
    return OrderTable()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..orderId = obj.orderId
      ..tradeNo = obj.tradeNo
      ..tableId = obj.tableId
      ..tableNo = obj.tableNo
      ..tableName = obj.tableName
      ..typeId = obj.typeId
      ..typeNo = obj.typeNo
      ..typeName = obj.typeName
      ..areaId = obj.areaId
      ..areaNo = obj.areaNo
      ..areaName = obj.areaName
      ..tableStatus = obj.tableStatus
      ..openTime = obj.openTime
      ..openUser = obj.openUser
      ..tableNumber = obj.tableNumber
      ..serialNo = obj.serialNo
      ..tableAction = obj.tableAction
      ..people = obj.people
      ..excessFlag = obj.excessFlag
      ..totalAmount = obj.totalAmount
      ..totalQuantity = obj.totalQuantity
      ..discountAmount = obj.discountAmount
      ..totalRefund = obj.totalRefund
      ..totalRefundAmount = obj.totalRefundAmount
      ..totalGive = obj.totalGive
      ..totalGiveAmount = obj.totalGiveAmount
      ..discountRate = obj.discountRate
      ..receivableAmount = obj.receivableAmount
      ..paidAmount = obj.paidAmount
      ..malingAmount = obj.malingAmount
      ..maxOrderNo = obj.maxOrderNo
      ..masterTable = obj.masterTable
      ..perCapitaAmount = obj.perCapitaAmount
      ..posNo = obj.posNo
      ..payNo = obj.payNo
      ..finishDate = obj.finishDate
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..placeOrders = obj.placeOrders;
  }

  ///实体对象转Map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnOrderId: this.orderId,
      columnTradeNo: this.tradeNo,
      columnTableId: this.tableId,
      columnTableNo: this.tableNo,
      columnTableName: this.tableName,
      columnTypeId: this.typeId,
      columnTypeNo: this.typeNo,
      columnTypeName: this.typeName,
      columnAreaId: this.areaId,
      columnAreaNo: this.areaNo,
      columnAreaName: this.areaName,
      columnTableStatus: this.tableStatus,
      columnOpenTime: this.openTime,
      columnOpenUser: this.openUser,
      columnTableNumber: this.tableNumber,
      columnSerialNo: this.serialNo,
      columnTableAction: this.tableAction,
      columnPeople: this.people,
      columnExcessFlag: this.excessFlag,
      columnTotalAmount: this.totalAmount,
      columnTotalQuantity: this.totalQuantity,
      columnDiscountAmount: this.discountAmount,
      columnTotalRefund: this.totalRefund,
      columnTotalRefundAmount: this.totalRefundAmount,
      columnTotalGive: this.totalGive,
      columnTotalGiveAmount: this.totalGiveAmount,
      columnDiscountRate: this.discountRate,
      columnReceivableAmount: this.receivableAmount,
      columnPaidAmount: this.paidAmount,
      columnMalingAmount: this.malingAmount,
      columnMaxOrderNo: this.maxOrderNo,
      columnMasterTable: this.masterTable,
      columnPerCapitaAmount: this.perCapitaAmount,
      columnPosNo: this.posNo,
      columnPayNo: this.payNo,
      columnFinishDate: this.finishDate,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnPlaceOrders: this.placeOrders,
    };
    return map;
  }

  ///Map转List对象
  static List<OrderTable> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderTable>();
    lists.forEach((map) => result.add(OrderTable.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
