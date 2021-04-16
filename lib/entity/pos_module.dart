import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class Module extends BaseEntity {
  ///表名称
  static final String tableName = "pos_module";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnArea = "area";
  static final String columnName = "name";
  static final String columnAlias = "alias";
  static final String columnKeycode = "keycode";
  static final String columnKeydata = "keydata";
  static final String columnColor1 = "color1";
  static final String columnColor2 = "color2";
  static final String columnColor3 = "color3";
  static final String columnColor4 = "color4";
  static final String columnFontSize = "fontSize";
  static final String columnShortcut = "shortcut";
  static final String columnOrderNo = "orderNo";
  static final String columnIcon = "icon";
  static final String columnEnable = "enable";
  static final String columnPermission = "permission";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate  from pos_module;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_module(id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.area,entity.name,entity.alias,entity.keycode,entity.keydata,entity.color1,entity.color2,entity.color3,entity.color4,entity.fontSize,entity.shortcut,entity.orderNo,entity.icon,entity.enable,entity.permission,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_module set id= '%s',tenantId= '%s',area= '%s',name= '%s',alias= '%s',keycode= '%s',keydata= '%s',color1= '%s',color2= '%s',color3= '%s',color4= '%s',fontSize= '%s',shortcut= '%s',orderNo= '%s',icon= '%s',enable= '%s',permission= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.area,this.name,this.alias,this.keycode,this.keydata,this.color1,this.color2,this.color3,this.color4,this.fontSize,this.shortcut,this.orderNo,this.icon,this.enable,this.permission,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_module;"
  ///字段名称
  String area;
  String name;
  String alias;
  String keycode;
  String keydata;
  String color1;
  String color2;
  String color3;
  String color4;
  String fontSize;
  String shortcut;
  int orderNo;
  String icon;
  int enable;
  String permission;

  ///默认构造
  Module();

  ///Map转实体对象
  factory Module.fromMap(Map<String, dynamic> map) {
    return Module()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..area = Convert.toStr(map[columnArea])
      ..name = Convert.toStr(map[columnName])
      ..alias = Convert.toStr(map[columnAlias])
      ..keycode = Convert.toStr(map[columnKeycode])
      ..keydata = Convert.toStr(map[columnKeydata])
      ..color1 = Convert.toStr(map[columnColor1])
      ..color2 = Convert.toStr(map[columnColor2])
      ..color3 = Convert.toStr(map[columnColor3])
      ..color4 = Convert.toStr(map[columnColor4])
      ..fontSize = Convert.toStr(map[columnFontSize])
      ..shortcut = Convert.toStr(map[columnShortcut])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..icon = Convert.toStr(map[columnIcon])
      ..enable = Convert.toInt(map[columnEnable])
      ..permission = Convert.toStr(map[columnPermission])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory Module.newModule() {
    return Module()
      ..id = ""
      ..tenantId = ""
      ..area = ""
      ..name = ""
      ..alias = ""
      ..keycode = ""
      ..keydata = ""
      ..color1 = ""
      ..color2 = ""
      ..color3 = ""
      ..color4 = ""
      ..fontSize = ""
      ..shortcut = ""
      ..orderNo = 0
      ..icon = ""
      ..enable = 0
      ..permission = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory Module.clone(Module obj) {
    return Module()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..area = obj.area
      ..name = obj.name
      ..alias = obj.alias
      ..keycode = obj.keycode
      ..keydata = obj.keydata
      ..color1 = obj.color1
      ..color2 = obj.color2
      ..color3 = obj.color3
      ..color4 = obj.color4
      ..fontSize = obj.fontSize
      ..shortcut = obj.shortcut
      ..orderNo = obj.orderNo
      ..icon = obj.icon
      ..enable = obj.enable
      ..permission = obj.permission
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<Module> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Module>();
    lists.forEach((map) => result.add(Module.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnArea: this.area,
      columnName: this.name,
      columnAlias: this.alias,
      columnKeycode: this.keycode,
      columnKeydata: this.keydata,
      columnColor1: this.color1,
      columnColor2: this.color2,
      columnColor3: this.color3,
      columnColor4: this.color4,
      columnFontSize: this.fontSize,
      columnShortcut: this.shortcut,
      columnOrderNo: this.orderNo,
      columnIcon: this.icon,
      columnEnable: this.enable,
      columnPermission: this.permission,
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
        area,
        name,
        alias,
        keycode,
        keydata,
        color1,
        color2,
        color3,
        color4,
        fontSize,
        shortcut,
        orderNo,
        icon,
        enable,
        permission,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
