import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ShiftLog extends BaseEntity {
  ///表名称
  static final String tableName = "pos_shift_log";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStatus = "status";
  static final String columnStoreId = "storeId";
  static final String columnStoreNo = "storeNo";
  static final String columnWorkerId = "workerId";
  static final String columnWorkerNo = "workerNo";
  static final String columnWorkerName = "workerName";
  static final String columnPlanId = "planId";
  static final String columnName = "name";
  static final String columnNo = "no";
  static final String columnStartTime = "startTime";
  static final String columnFirstDealTime = "firstDealTime";
  static final String columnEndDealTime = "endDealTime";
  static final String columnShiftTime = "shiftTime";
  static final String columnPosNo = "posNo";
  static final String columnAcceptWorkerNo = "acceptWorkerNo";
  static final String columnImprest = "imprest";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,status,storeId,storeNo,workerId,workerNo,workerName,planId,name,no,startTime,firstDealTime,endDealTime,shiftTime,posNo,acceptWorkerNo,imprest,createUser,createDate,modifyUser,modifyDate  from pos_shift_log;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_shift_log(id,tenantId,status,storeId,storeNo,workerId,workerNo,workerName,planId,name,no,startTime,firstDealTime,endDealTime,shiftTime,posNo,acceptWorkerNo,imprest,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.status,entity.storeId,entity.storeNo,entity.workerId,entity.workerNo,entity.workerName,entity.planId,entity.name,entity.no,entity.startTime,entity.firstDealTime,entity.endDealTime,entity.shiftTime,entity.posNo,entity.acceptWorkerNo,entity.imprest,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_shift_log set id= '%s',tenantId= '%s',status= '%s',storeId= '%s',storeNo= '%s',workerId= '%s',workerNo= '%s',workerName= '%s',planId= '%s',name= '%s',no= '%s',startTime= '%s',firstDealTime= '%s',endDealTime= '%s',shiftTime= '%s',posNo= '%s',acceptWorkerNo= '%s',imprest= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.status,this.storeId,this.storeNo,this.workerId,this.workerNo,this.workerName,this.planId,this.name,this.no,this.startTime,this.firstDealTime,this.endDealTime,this.shiftTime,this.posNo,this.acceptWorkerNo,this.imprest,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_shift_log;"
  ///字段名称
  int status;
  String storeId;
  String storeNo;
  String workerId;
  String workerNo;
  String workerName;
  String planId;
  String name;
  String no;
  String startTime;
  String firstDealTime;
  String endDealTime;
  String shiftTime;
  String posNo;
  String acceptWorkerNo;
  double imprest;

  ///默认构造
  ShiftLog();

  ///Map转实体对象
  factory ShiftLog.fromMap(Map<String, dynamic> map) {
    return ShiftLog()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..status = Convert.toInt(map[columnStatus])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..workerId = Convert.toStr(map[columnWorkerId])
      ..workerNo = Convert.toStr(map[columnWorkerNo])
      ..workerName = Convert.toStr(map[columnWorkerName])
      ..planId = Convert.toStr(map[columnPlanId])
      ..name = Convert.toStr(map[columnName])
      ..no = Convert.toStr(map[columnNo])
      ..startTime = Convert.toStr(map[columnStartTime])
      ..firstDealTime = Convert.toStr(map[columnFirstDealTime])
      ..endDealTime = Convert.toStr(map[columnEndDealTime])
      ..shiftTime = Convert.toStr(map[columnShiftTime])
      ..posNo = Convert.toStr(map[columnPosNo])
      ..acceptWorkerNo = Convert.toStr(map[columnAcceptWorkerNo])
      ..imprest = Convert.toDouble(map[columnImprest])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ShiftLog.newShiftLog() {
    return ShiftLog()
      ..id = ""
      ..tenantId = ""
      ..status = 0
      ..storeId = ""
      ..storeNo = ""
      ..workerId = ""
      ..workerNo = ""
      ..workerName = ""
      ..planId = ""
      ..name = ""
      ..no = ""
      ..startTime = ""
      ..firstDealTime = ""
      ..endDealTime = ""
      ..shiftTime = ""
      ..posNo = ""
      ..acceptWorkerNo = ""
      ..imprest = 0
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory ShiftLog.clone(ShiftLog obj) {
    return ShiftLog()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..status = obj.status
      ..storeId = obj.storeId
      ..storeNo = obj.storeNo
      ..workerId = obj.workerId
      ..workerNo = obj.workerNo
      ..workerName = obj.workerName
      ..planId = obj.planId
      ..name = obj.name
      ..no = obj.no
      ..startTime = obj.startTime
      ..firstDealTime = obj.firstDealTime
      ..endDealTime = obj.endDealTime
      ..shiftTime = obj.shiftTime
      ..posNo = obj.posNo
      ..acceptWorkerNo = obj.acceptWorkerNo
      ..imprest = obj.imprest
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ShiftLog> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ShiftLog>();
    lists.forEach((map) => result.add(ShiftLog.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStatus: this.status,
      columnStoreId: this.storeId,
      columnStoreNo: this.storeNo,
      columnWorkerId: this.workerId,
      columnWorkerNo: this.workerNo,
      columnWorkerName: this.workerName,
      columnPlanId: this.planId,
      columnName: this.name,
      columnNo: this.no,
      columnStartTime: this.startTime,
      columnFirstDealTime: this.firstDealTime,
      columnEndDealTime: this.endDealTime,
      columnShiftTime: this.shiftTime,
      columnPosNo: this.posNo,
      columnAcceptWorkerNo: this.acceptWorkerNo,
      columnImprest: this.imprest,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }

  ///重写
  @override
  List<Object> get props => [
        id,
        tenantId,
        status,
        storeId,
        storeNo,
        workerId,
        workerNo,
        workerName,
        planId,
        name,
        no,
        startTime,
        firstDealTime,
        endDealTime,
        shiftTime,
        posNo,
        acceptWorkerNo,
        imprest,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
