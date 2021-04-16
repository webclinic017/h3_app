import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class WorkerRole extends BaseEntity {
  ///表名称
  static final String tableName = "pos_worker_role";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnUserId = "userId";
  static final String columnRoleId = "roleId";
  static final String columnDiscount = "discount";
  static final String columnFreeAmount = "freeAmount";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,userId,roleId,discount,freeAmount,createUser,createDate,modifyUser,modifyDate  from pos_worker_role;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_worker_role(id,tenantId,userId,roleId,discount,freeAmount,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.userId,entity.roleId,entity.discount,entity.freeAmount,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_worker_role set id= '%s',tenantId= '%s',userId= '%s',roleId= '%s',discount= '%s',freeAmount= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.userId,this.roleId,this.discount,this.freeAmount,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_worker_role;"
  ///字段名称
  String userId;
  String roleId;
  double discount;
  double freeAmount;

  ///默认构造
  WorkerRole();

  ///Map转实体对象
  factory WorkerRole.fromMap(Map<String, dynamic> map) {
    return WorkerRole()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..userId = Convert.toStr(map[columnUserId])
      ..roleId = Convert.toStr(map[columnRoleId])
      ..discount = Convert.toDouble(map[columnDiscount])
      ..freeAmount = Convert.toDouble(map[columnFreeAmount])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory WorkerRole.newWorkerRole() {
    return WorkerRole()
      ..id = ""
      ..tenantId = ""
      ..userId = ""
      ..roleId = ""
      ..discount = 0
      ..freeAmount = 0
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory WorkerRole.clone(WorkerRole obj) {
    return WorkerRole()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..userId = obj.userId
      ..roleId = obj.roleId
      ..discount = obj.discount
      ..freeAmount = obj.freeAmount
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<WorkerRole> toList(List<Map<String, dynamic>> lists) {
    var result = new List<WorkerRole>();
    lists.forEach((map) => result.add(WorkerRole.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnUserId: this.userId,
      columnRoleId: this.roleId,
      columnDiscount: this.discount,
      columnFreeAmount: this.freeAmount,
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
        roleId,
        discount,
        freeAmount,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
