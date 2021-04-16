import 'dart:convert';
import 'package:h3_app/entity/pos_shiftover_ticket_cash.dart';
import 'package:h3_app/entity/pos_shiftover_ticket_pay.dart';
import 'package:h3_app/utils/converts.dart';
import 'base_entity.dart';

class ShiftoverTicket extends BaseEntity {
  ///表名称
  static final String tableName = "pos_shiftover_ticket";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnStoreId = "storeId";
  static final String columnStoreNo = "storeNo";
  static final String columnStoreName = "storeName";
  static final String columnWorkId = "workId";
  static final String columnWorkNo = "workNo";
  static final String columnWorkName = "workName";
  static final String columnShiftId = "shiftId";
  static final String columnShiftNo = "shiftNo";
  static final String columnShiftName = "shiftName";
  static final String columnDatetimeBegin = "datetimeBegin";
  static final String columnFirstDealTime = "firstDealTime";
  static final String columnEndDealTime = "endDealTime";
  static final String columnDatetimeShift = "datetimeShift";
  static final String columnAcceptWorkerNo = "acceptWorkerNo";
  static final String columnPosNo = "posNo";
  static final String columnMemo = "memo";
  static final String columnShiftAmount = "shiftAmount";
  static final String columnImprest = "imprest";
  static final String columnShiftBlindFlag = "shiftBlindFlag";
  static final String columnHandsMoney = "handsMoney";
  static final String columnDiffMoney = "diffMoney";
  static final String columnDeviceName = "deviceName";
  static final String columnDeviceMac = "deviceMac";
  static final String columnDeviceIp = "deviceIp";
  static final String columnUploadStatus = "uploadStatus";
  static final String columnUploadErrors = "uploadErrors";
  static final String columnUploadCode = "uploadCode";
  static final String columnUploadMessage = "uploadMessage";
  static final String columnUploadTime = "uploadTime";
  static final String columnServerId = "serverId";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String no;
  String storeId;
  String storeNo;
  String storeName;
  String workId;
  String workNo;
  String workName;
  String shiftId;
  String shiftNo;
  String shiftName;
  String datetimeBegin;
  String firstDealTime;
  String endDealTime;
  String datetimeShift;
  String acceptWorkerNo;
  String posNo;
  String memo;
  double shiftAmount;
  double imprest;
  int shiftBlindFlag;
  double handsMoney;
  double diffMoney;
  String deviceName;
  String deviceMac;
  String deviceIp;
  int uploadStatus;
  int uploadErrors;
  String uploadCode;
  String uploadMessage;
  String uploadTime;
  String serverId;

  /// <summary>
  /// 现金明细
  /// </summary>
  ShiftoverTicketCash ticketCash;

  /// <summary>
  /// 支付汇总(以下几种的汇总)
  /// </summary>
  List<ShiftoverTicketPay> pays;

  ///默认构造
  ShiftoverTicket();

  ///Map转实体对象
  factory ShiftoverTicket.fromMap(Map<String, dynamic> map) {
    return ShiftoverTicket()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..storeName = Convert.toStr(map[columnStoreName])
      ..workId = Convert.toStr(map[columnWorkId])
      ..workNo = Convert.toStr(map[columnWorkNo])
      ..workName = Convert.toStr(map[columnWorkName])
      ..shiftId = Convert.toStr(map[columnShiftId])
      ..shiftNo = Convert.toStr(map[columnShiftNo])
      ..shiftName = Convert.toStr(map[columnShiftName])
      ..datetimeBegin = Convert.toStr(map[columnDatetimeBegin])
      ..firstDealTime = Convert.toStr(map[columnFirstDealTime])
      ..endDealTime = Convert.toStr(map[columnEndDealTime])
      ..datetimeShift = Convert.toStr(map[columnDatetimeShift])
      ..acceptWorkerNo = Convert.toStr(map[columnAcceptWorkerNo])
      ..posNo = Convert.toStr(map[columnPosNo])
      ..memo = Convert.toStr(map[columnMemo])
      ..shiftAmount = Convert.toDouble(map[columnShiftAmount])
      ..imprest = Convert.toDouble(map[columnImprest])
      ..shiftBlindFlag = Convert.toInt(map[columnShiftBlindFlag])
      ..handsMoney = Convert.toDouble(map[columnHandsMoney])
      ..diffMoney = Convert.toDouble(map[columnDiffMoney])
      ..deviceName = Convert.toStr(map[columnDeviceName])
      ..deviceMac = Convert.toStr(map[columnDeviceMac])
      ..deviceIp = Convert.toStr(map[columnDeviceIp])
      ..uploadStatus = Convert.toInt(map[columnUploadStatus])
      ..uploadErrors = Convert.toInt(map[columnUploadErrors])
      ..uploadCode = Convert.toStr(map[columnUploadCode])
      ..uploadMessage = Convert.toStr(map[columnUploadMessage])
      ..uploadTime = Convert.toStr(map[columnUploadTime])
      ..serverId = Convert.toStr(map[columnServerId])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnStoreId: this.storeId,
      columnStoreNo: this.storeNo,
      columnStoreName: this.storeName,
      columnWorkId: this.workId,
      columnWorkNo: this.workNo,
      columnWorkName: this.workName,
      columnShiftId: this.shiftId,
      columnShiftNo: this.shiftNo,
      columnShiftName: this.shiftName,
      columnDatetimeBegin: this.datetimeBegin,
      columnFirstDealTime: this.firstDealTime,
      columnEndDealTime: this.endDealTime,
      columnDatetimeShift: this.datetimeShift,
      columnAcceptWorkerNo: this.acceptWorkerNo,
      columnPosNo: this.posNo,
      columnMemo: this.memo,
      columnShiftAmount: this.shiftAmount,
      columnImprest: this.imprest,
      columnShiftBlindFlag: this.shiftBlindFlag,
      columnHandsMoney: this.handsMoney,
      columnDiffMoney: this.diffMoney,
      columnDeviceName: this.deviceName,
      columnDeviceMac: this.deviceMac,
      columnDeviceIp: this.deviceIp,
      columnUploadStatus: this.uploadStatus,
      columnUploadErrors: this.uploadErrors,
      columnUploadCode: this.uploadCode,
      columnUploadMessage: this.uploadMessage,
      columnUploadTime: this.uploadTime,
      columnServerId: this.serverId,
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
