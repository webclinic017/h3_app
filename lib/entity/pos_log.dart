import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class Log extends BaseEntity {
  ///表名称
  static final String tableName = "pos_log";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreNo = "storeNo";
  static final String columnPosNo = "posNo";
  static final String columnWorkerNo = "workerNo";
  static final String columnAuthNo = "authNo";
  static final String columnAction = "action";
  static final String columnModule = "module";
  static final String columnTradeNo = "tradeNo";
  static final String columnProductNo = "productNo";
  static final String columnSpecId = "specId";
  static final String columnMemo = "memo";
  static final String columnAmount = "amount";
  static final String columnUploadStatus = "uploadStatus";
  static final String columnServerId = "serverId";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnStoreId = "storeId";
  static final String columnWorkerName = "workerName";
  static final String columnProductName = "productName";
  static final String columnSpecName = "specName";
  static final String columnStoreName = "storeName";
  static final String columnUploadErrors = "uploadErrors";
  static final String columnUploadMessage = "uploadMessage";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,storeNo,posNo,workerNo,authNo,action,module,tradeNo,productNo,specId,memo,amount,uploadStatus,serverId,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,storeId,workerName,productName,specName,storeName,uploadErrors,uploadMessage  from pos_log;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_log(id,tenantId,storeNo,posNo,workerNo,authNo,action,module,tradeNo,productNo,specId,memo,amount,uploadStatus,serverId,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,storeId,workerName,productName,specName,storeName,uploadErrors,uploadMessage  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.storeNo,entity.posNo,entity.workerNo,entity.authNo,entity.action,entity.module,entity.tradeNo,entity.productNo,entity.specId,entity.memo,entity.amount,entity.uploadStatus,entity.serverId,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate,entity.storeId,entity.workerName,entity.productName,entity.specName,entity.storeName,entity.uploadErrors,entity.uploadMessage ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_log set id= '%s',tenantId= '%s',storeNo= '%s',posNo= '%s',workerNo= '%s',authNo= '%s',action= '%s',module= '%s',tradeNo= '%s',productNo= '%s',specId= '%s',memo= '%s',amount= '%s',uploadStatus= '%s',serverId= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s',storeId= '%s',workerName= '%s',productName= '%s',specName= '%s',storeName= '%s',uploadErrors= '%s',uploadMessage= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.storeNo,this.posNo,this.workerNo,this.authNo,this.action,this.module,this.tradeNo,this.productNo,this.specId,this.memo,this.amount,this.uploadStatus,this.serverId,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate,this.storeId,this.workerName,this.productName,this.specName,this.storeName,this.uploadErrors,this.uploadMessage ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_log;"
  ///字段名称
  String storeNo;
  String posNo;
  String workerNo;
  String authNo;
  String action;
  String module;
  String tradeNo;
  String productNo;
  String specId;
  String memo;
  double amount;
  int uploadStatus;
  String serverId;
  String storeId;
  String workerName;
  String productName;
  String specName;
  String storeName;
  int uploadErrors;
  String uploadMessage;

  ///默认构造
  Log();

  ///Map转实体对象
  factory Log.fromMap(Map<String, dynamic> map) {
    return Log()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..posNo = Convert.toStr(map[columnPosNo])
      ..workerNo = Convert.toStr(map[columnWorkerNo])
      ..authNo = Convert.toStr(map[columnAuthNo])
      ..action = Convert.toStr(map[columnAction])
      ..module = Convert.toStr(map[columnModule])
      ..tradeNo = Convert.toStr(map[columnTradeNo])
      ..productNo = Convert.toStr(map[columnProductNo])
      ..specId = Convert.toStr(map[columnSpecId])
      ..memo = Convert.toStr(map[columnMemo])
      ..amount = Convert.toDouble(map[columnAmount])
      ..uploadStatus = Convert.toInt(map[columnUploadStatus])
      ..serverId = Convert.toStr(map[columnServerId])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..workerName = Convert.toStr(map[columnWorkerName])
      ..productName = Convert.toStr(map[columnProductName])
      ..specName = Convert.toStr(map[columnSpecName])
      ..storeName = Convert.toStr(map[columnStoreName])
      ..uploadErrors = Convert.toInt(map[columnUploadErrors])
      ..uploadMessage = Convert.toStr(map[columnUploadMessage]);
  }

  ///构建空对象
  factory Log.newLog() {
    return Log()
      ..id = ""
      ..tenantId = ""
      ..storeNo = ""
      ..posNo = ""
      ..workerNo = ""
      ..authNo = ""
      ..action = ""
      ..module = ""
      ..tradeNo = ""
      ..productNo = ""
      ..specId = ""
      ..memo = ""
      ..amount = 0
      ..uploadStatus = 0
      ..serverId = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..storeId = ""
      ..workerName = ""
      ..productName = ""
      ..specName = ""
      ..storeName = ""
      ..uploadErrors = 0
      ..uploadMessage = "";
  }

  ///复制新对象
  factory Log.clone(Log obj) {
    return Log()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..storeNo = obj.storeNo
      ..posNo = obj.posNo
      ..workerNo = obj.workerNo
      ..authNo = obj.authNo
      ..action = obj.action
      ..module = obj.module
      ..tradeNo = obj.tradeNo
      ..productNo = obj.productNo
      ..specId = obj.specId
      ..memo = obj.memo
      ..amount = obj.amount
      ..uploadStatus = obj.uploadStatus
      ..serverId = obj.serverId
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..storeId = obj.storeId
      ..workerName = obj.workerName
      ..productName = obj.productName
      ..specName = obj.specName
      ..storeName = obj.storeName
      ..uploadErrors = obj.uploadErrors
      ..uploadMessage = obj.uploadMessage;
  }

  ///转List集合
  static List<Log> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Log>();
    lists.forEach((map) => result.add(Log.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreNo: this.storeNo,
      columnPosNo: this.posNo,
      columnWorkerNo: this.workerNo,
      columnAuthNo: this.authNo,
      columnAction: this.action,
      columnModule: this.module,
      columnTradeNo: this.tradeNo,
      columnProductNo: this.productNo,
      columnSpecId: this.specId,
      columnMemo: this.memo,
      columnAmount: this.amount,
      columnUploadStatus: this.uploadStatus,
      columnServerId: this.serverId,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnStoreId: this.storeId,
      columnWorkerName: this.workerName,
      columnProductName: this.productName,
      columnSpecName: this.specName,
      columnStoreName: this.storeName,
      columnUploadErrors: this.uploadErrors,
      columnUploadMessage: this.uploadMessage,
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
        storeNo,
        posNo,
        workerNo,
        authNo,
        action,
        module,
        tradeNo,
        productNo,
        specId,
        memo,
        amount,
        uploadStatus,
        serverId,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
        storeId,
        workerName,
        productName,
        specName,
        storeName,
        uploadErrors,
        uploadMessage,
      ];
}
