import 'dart:collection';

import 'package:h3_app/entity/pos_shift_log.dart';
import 'package:h3_app/entity/pos_shiftover_ticket.dart';
import 'package:h3_app/entity/pos_shiftover_ticket_cash.dart';
import 'package:h3_app/entity/pos_shiftover_ticket_pay.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:sprintf/sprintf.dart';

import 'order_utils.dart';

class ShiftUtils {
  // 工厂模式
  factory ShiftUtils() => _getInstance();

  static ShiftUtils get instance => _getInstance();
  static ShiftUtils _instance;

  static ShiftUtils _getInstance() {
    if (_instance == null) {
      _instance = new ShiftUtils._internal();
    }
    return _instance;
  }

  ShiftUtils._internal();

  Future<Tuple3<bool, String, ShiftoverTicket>> saveShiftLog(
      ShiftLog shiftLog,
      List<ShiftoverTicketPay> orderPayList,
      ShiftoverTicketCash cashPayDetail,
      double shiftAmount,
      String memo) async {
    bool result = false;
    String message = "";
    ShiftoverTicket entity;
    try {
      var shiftTime =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

      var queues = new Queue<String>();

      //交班日志表的数据更新
      shiftLog.shiftTime = shiftTime;
      shiftLog.acceptWorkerNo = Global.instance.worker.no;
      shiftLog.status = 1;
      shiftLog.modifyUser = Global.instance.worker.no;
      shiftLog.modifyDate = shiftTime;

      //更新交班信息表
      queues.add(
          "update pos_shift_log set firstDealTime='${shiftLog.firstDealTime}',endDealTime='${shiftLog.endDealTime}',shiftTime='${shiftLog.shiftTime}',acceptWorkerNo='${shiftLog.acceptWorkerNo}',status='${shiftLog.status}',modifyDate='${shiftLog.modifyDate}',modifyUser='${shiftLog.modifyUser}' where id = '${shiftLog.id}';");

      entity = new ShiftoverTicket();
      entity.id = "${IdWorkerUtils.getInstance().generate()}";
      entity.tenantId = Global.instance.authc.tenantId;
      var shiftNoResult = await OrderUtils.instance.generateShiftNo();
      entity.no = shiftNoResult.item3;
      entity.storeId = shiftLog.storeId;
      entity.storeNo = shiftLog.storeNo;
      entity.storeName = Global.instance.authc.storeName;
      entity.workId = shiftLog.workerId;
      entity.workNo = shiftLog.workerNo;
      entity.workName = shiftLog.workerName;
      entity.shiftId = shiftLog.id;
      entity.shiftNo = shiftLog.no;
      entity.shiftName = shiftLog.name;
      entity.datetimeBegin = shiftLog.startTime;
      entity.firstDealTime = shiftLog.firstDealTime;
      entity.endDealTime = shiftLog.endDealTime;
      entity.datetimeShift = shiftTime;
      //ticket.dateShift = ;
      entity.acceptWorkerNo = Global.instance.worker.no;
      entity.posNo = shiftLog.posNo;
      entity.memo = memo;
      entity.shiftAmount = shiftAmount;
      entity.imprest = shiftLog.imprest ?? 0;
      entity.shiftBlindFlag = 0;
      entity.handsMoney = 0.0; //盲交缴款金额

      entity.diffMoney = 0; //盲交计算差异
      entity.deviceIp = await DeviceUtils.instance.getIpAddress();
      entity.deviceMac = await DeviceUtils.instance.getSerialId();
      entity.deviceName = await DeviceUtils.instance.getMode();
      entity.uploadStatus = 0;
      entity.createUser = Global.instance.worker.no;
      entity.createDate = shiftTime;

      entity.ext1 = "";
      entity.ext2 = "";
      entity.ext3 = "";
      entity.modifyUser = Global.instance.worker.no;
      entity.modifyDate = shiftTime;

      String ticketSql = sprintf(
          "insert into pos_shiftover_ticket(id,tenantId,no,storeId,storeNo,storeName,workId,workNo,workName,shiftId,shiftNo,shiftName,datetimeBegin,firstDealTime,endDealTime,datetimeShift,acceptWorkerNo,posNo,memo,shiftAmount,imprest,shiftBlindFlag,handsMoney,diffMoney,deviceName,deviceMac,deviceIp,uploadStatus,uploadErrors,uploadCode,uploadMessage,uploadTime,serverId,ext1,ext2,ext3,createDate,createUser,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');",
          [
            entity.id,
            entity.tenantId,
            entity.no,
            entity.storeId,
            entity.storeNo,
            entity.storeName,
            entity.workId,
            entity.workNo,
            entity.workName,
            entity.shiftId,
            entity.shiftNo,
            entity.shiftName,
            entity.datetimeBegin,
            entity.firstDealTime,
            entity.endDealTime,
            entity.datetimeShift,
            entity.acceptWorkerNo,
            entity.posNo,
            entity.memo,
            entity.shiftAmount,
            entity.imprest,
            entity.shiftBlindFlag,
            entity.handsMoney,
            entity.diffMoney,
            entity.deviceName,
            entity.deviceMac,
            entity.deviceIp,
            entity.uploadStatus,
            entity.uploadErrors,
            entity.uploadCode,
            entity.uploadMessage,
            entity.uploadTime,
            entity.serverId,
            entity.ext1,
            entity.ext2,
            entity.ext3,
            entity.createDate,
            entity.createUser,
            entity.modifyUser,
            entity.modifyDate,
          ]);

      queues.add(ticketSql);

      // pos销售支付汇总
      if (orderPayList != null && orderPayList.length > 0) {
        for (var x in orderPayList) {
          x.businessType =
              "0"; //ShiftBusinessType.POS销售;// 0-pos销售 1-微店销售 2-会员退卡 10-充值
          x.id = IdWorkerUtils.getInstance().generate().toString();
          x.tenantId = Global.instance.authc.tenantId;
          x.ticketId = entity.id;
          x.shiftId = entity.shiftId;
          x.shiftNo = entity.shiftNo;
          x.shiftName = entity.shiftName;
          x.storeId = entity.storeId;
          x.storeNo = entity.storeNo;
          x.storeName = entity.storeName;
          x.createDate = shiftTime;
          x.createUser = Global.instance.worker.no;

          x.ext1 = "";
          x.ext2 = "";
          x.ext3 = "";
          x.modifyUser = Global.instance.worker.no;
          x.modifyDate = shiftTime;

          String orderPayTemplate =
              "insert into pos_shiftover_ticket_pay(id,tenantId,ticketId,storeId,storeNo,storeName,shiftId,shiftNo,shiftName,businessType,payModeNo,payModeName,quantity,amount,ext1,ext2,ext3,createDate,createUser,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');";
          String orderPaySql = sprintf(orderPayTemplate, [
            x.id,
            x.tenantId,
            x.ticketId,
            x.storeId,
            x.storeNo,
            x.storeName,
            x.shiftId,
            x.shiftNo,
            x.shiftName,
            x.businessType,
            x.payModeNo,
            x.payModeName,
            x.quantity,
            x.amount,
            x.ext1,
            x.ext2,
            x.ext3,
            x.createDate,
            x.createUser,
            x.modifyUser,
            x.modifyDate,
          ]);

          queues.add(orderPaySql);
        }

        entity.pays = orderPayList;
      }

      //cash
      cashPayDetail.id = "${IdWorkerUtils.getInstance().generate()}";
      cashPayDetail.tenantId = Global.instance.authc.tenantId;
      cashPayDetail.ticketId = entity.id;
      cashPayDetail.shiftId = entity.shiftId;
      cashPayDetail.shiftNo = entity.shiftNo;
      cashPayDetail.shiftName = entity.shiftName;
      cashPayDetail.storeId = entity.storeId;
      cashPayDetail.storeNo = entity.storeNo;
      cashPayDetail.storeName = entity.storeName;
      cashPayDetail.createDate = shiftTime;
      cashPayDetail.createUser = Global.instance.worker.no;
      cashPayDetail.ext1 = "";
      cashPayDetail.ext2 = "";
      cashPayDetail.ext3 = "";
      cashPayDetail.modifyUser = Global.instance.worker.no;
      cashPayDetail.modifyDate = shiftTime;

      entity.ticketCash = cashPayDetail;

      String cashPayTemplate =
          "insert into pos_shiftover_ticket_cash(id,tenantId,ticketId,storeId,storeNo,storeName,shiftId,shiftNo,shiftName,consumeCash,consumeCashRefund,cardRechargeCash,cardCashRefund,noTransCashIn,noTransCashOut,timesCashRecharge,imprest,totalCash,plusCashRecharge,ext1,ext2,ext3,createDate,createUser,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s');";
      String cashPaySql = sprintf(cashPayTemplate, [
        cashPayDetail.id,
        cashPayDetail.tenantId,
        cashPayDetail.ticketId,
        cashPayDetail.storeId,
        cashPayDetail.storeNo,
        cashPayDetail.storeName,
        cashPayDetail.shiftId,
        cashPayDetail.shiftNo,
        cashPayDetail.shiftName,
        cashPayDetail.consumeCash,
        cashPayDetail.consumeCashRefund,
        cashPayDetail.cardRechargeCash,
        cashPayDetail.cardCashRefund,
        cashPayDetail.noTransCashIn,
        cashPayDetail.noTransCashOut,
        cashPayDetail.timesCashRecharge,
        cashPayDetail.imprest,
        cashPayDetail.totalCash,
        cashPayDetail.plusCashRecharge,
        cashPayDetail.ext1,
        cashPayDetail.ext2,
        cashPayDetail.ext3,
        cashPayDetail.createDate,
        cashPayDetail.createUser,
        cashPayDetail.modifyUser,
        cashPayDetail.modifyDate,
      ]);

      queues.add(cashPaySql);

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("交班发生异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "交班失败...";
      } else {
        result = true;
        message = "交班成功...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存交班信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple3(result, message, entity);
  }
}
