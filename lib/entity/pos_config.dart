import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class Config extends BaseEntity {
  ///表名称
  static final String tableName = "pos_config";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnGroup = "group";
  static final String columnKeys = "keys";
  static final String columnInitValue = "initValue";
  static final String columnValues = "values";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,group,keys,initValue,values,createUser,createDate,modifyUser,modifyDate  from pos_config;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_config(id,tenantId,group,keys,initValue,values,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.group,entity.keys,entity.initValue,entity.values,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_config set id= '%s',tenantId= '%s',group= '%s',keys= '%s',initValue= '%s',values= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.group,this.keys,this.initValue,this.values,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_config;"
  ///字段名称
  String group;
  String keys;
  String initValue;
  String values;

  ///默认构造
  Config();

  ///Map转实体对象
  factory Config.fromMap(Map<String, dynamic> map) {
    return Config()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..group = Convert.toStr(map[columnGroup])
      ..keys = Convert.toStr(map[columnKeys])
      ..initValue = Convert.toStr(map[columnInitValue])
      ..values = Convert.toStr(map[columnValues])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory Config.newConfig() {
    return Config()
      ..id = ""
      ..tenantId = ""
      ..group = ""
      ..keys = ""
      ..initValue = ""
      ..values = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory Config.clone(Config obj) {
    return Config()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..group = obj.group
      ..keys = obj.keys
      ..initValue = obj.initValue
      ..values = obj.values
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<Config> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Config>();
    lists.forEach((map) => result.add(Config.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnGroup: this.group,
      columnKeys: this.keys,
      columnInitValue: this.initValue,
      columnValues: this.values,
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
        group,
        keys,
        initValue,
        values,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
