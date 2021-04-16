import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class WorkerModule extends BaseEntity {
  ///表名称
  static final String tableName = "pos_worker_module";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnUserId = "userId";
  static final String columnModuleNo = "moduleNo";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,userId,moduleNo,createUser,createDate,modifyUser,modifyDate  from pos_worker_module;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_worker_module(id,tenantId,userId,moduleNo,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.userId,entity.moduleNo,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_worker_module set id= '%s',tenantId= '%s',userId= '%s',moduleNo= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.userId,this.moduleNo,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_worker_module;"
  ///字段名称
  String userId;
  String moduleNo;

  ///默认构造
  WorkerModule();

  ///Map转实体对象
  factory WorkerModule.fromMap(Map<String, dynamic> map) {
    return WorkerModule()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..userId = Convert.toStr(map[columnUserId])
      ..moduleNo = Convert.toStr(map[columnModuleNo])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory WorkerModule.newWorkerModule() {
    return WorkerModule()
      ..id = ""
      ..tenantId = ""
      ..userId = ""
      ..moduleNo = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory WorkerModule.clone(WorkerModule obj) {
    return WorkerModule()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..userId = obj.userId
      ..moduleNo = obj.moduleNo
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<WorkerModule> toList(List<Map<String, dynamic>> lists) {
    var result = new List<WorkerModule>();
    lists.forEach((map) => result.add(WorkerModule.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnUserId: this.userId,
      columnModuleNo: this.moduleNo,
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
        userId,
        moduleNo,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
