import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class BaseParameter extends BaseEntity {
  ///表名称
  static final String tableName = "pos_base_parameter";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnParentId = "parentId";
  static final String columnCode = "code";
  static final String columnName = "name";
  static final String columnMemo = "memo";
  static final String columnOrderNo = "orderNo";
  static final String columnEnabled = "enabled";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,parentId,code,name,memo,orderNo,enabled,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_base_parameter;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_base_parameter(id,tenantId,parentId,code,name,memo,orderNo,enabled,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.parentId,entity.code,entity.name,entity.memo,entity.orderNo,entity.enabled,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_base_parameter set id= '%s',tenantId= '%s',parentId= '%s',code= '%s',name= '%s',memo= '%s',orderNo= '%s',enabled= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.parentId,this.code,this.name,this.memo,this.orderNo,this.enabled,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_base_parameter;"
  ///字段名称
  String parentId;
  String code;
  String name;
  String memo;
  int orderNo;
  int enabled;

  ///默认构造
  BaseParameter();

  ///Map转实体对象
  factory BaseParameter.fromMap(Map<String, dynamic> map) {
    return BaseParameter()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..parentId = Convert.toStr(map[columnParentId])
      ..code = Convert.toStr(map[columnCode])
      ..name = Convert.toStr(map[columnName])
      ..memo = Convert.toStr(map[columnMemo])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..enabled = Convert.toInt(map[columnEnabled])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory BaseParameter.newBaseParameter() {
    return BaseParameter()
      ..id = ""
      ..tenantId = ""
      ..parentId = ""
      ..code = ""
      ..name = ""
      ..memo = ""
      ..orderNo = 0
      ..enabled = 0
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
  factory BaseParameter.clone(BaseParameter obj) {
    return BaseParameter()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..parentId = obj.parentId
      ..code = obj.code
      ..name = obj.name
      ..memo = obj.memo
      ..orderNo = obj.orderNo
      ..enabled = obj.enabled
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<BaseParameter> toList(List<Map<String, dynamic>> lists) {
    var result = new List<BaseParameter>();
    lists.forEach((map) => result.add(BaseParameter.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnParentId: this.parentId,
      columnCode: this.code,
      columnName: this.name,
      columnMemo: this.memo,
      columnOrderNo: this.orderNo,
      columnEnabled: this.enabled,
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
        parentId,
        code,
        name,
        memo,
        orderNo,
        enabled,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
