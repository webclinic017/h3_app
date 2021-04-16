import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class WorkerData extends BaseEntity {
  ///表名称
  static final String tableName = "pos_worker_data";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnWorkerId = "workerId";
  static final String columnType = "type";
  static final String columnGroupName = "groupName";
  static final String columnAuth = "auth";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,workerId,type,groupName,auth,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_worker_data;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_worker_data(id,tenantId,workerId,type,groupName,auth,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.workerId,entity.type,entity.groupName,entity.auth,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_worker_data set id= '%s',tenantId= '%s',workerId= '%s',type= '%s',groupName= '%s',auth= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.workerId,this.type,this.groupName,this.auth,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_worker_data;"
  ///字段名称
  String workerId;
  String type;
  String groupName;
  String auth;

  ///默认构造
  WorkerData();

  ///Map转实体对象
  factory WorkerData.fromMap(Map<String, dynamic> map) {
    return WorkerData()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..workerId = Convert.toStr(map[columnWorkerId])
      ..type = Convert.toStr(map[columnType])
      ..groupName = Convert.toStr(map[columnGroupName])
      ..auth = Convert.toStr(map[columnAuth])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory WorkerData.newWorkerData() {
    return WorkerData()
      ..id = ""
      ..tenantId = ""
      ..workerId = ""
      ..type = ""
      ..groupName = ""
      ..auth = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory WorkerData.clone(WorkerData obj) {
    return WorkerData()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..workerId = obj.workerId
      ..type = obj.type
      ..groupName = obj.groupName
      ..auth = obj.auth
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<WorkerData> toList(List<Map<String, dynamic>> lists) {
    var result = new List<WorkerData>();
    lists.forEach((map) => result.add(WorkerData.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnWorkerId: this.workerId,
      columnType: this.type,
      columnGroupName: this.groupName,
      columnAuth: this.auth,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
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
        workerId,
        type,
        groupName,
        auth,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
