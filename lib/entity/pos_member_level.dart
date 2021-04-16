import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class MemberLevel extends BaseEntity {
  ///表名称
  static final String tableName = "pos_member_level";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnLevel = "level";
  static final String columnDiscountWay = "discountWay";
  static final String columnDiscount = "discount";
  static final String columnValidDays = "validDays";
  static final String columnUpgradRuleType = "upgradRuleType";
  static final String columnUpgradValue = "upgradValue";
  static final String columnDownFlag = "downFlag";
  static final String columnConditions = "conditions";
  static final String columnPrerogative = "prerogative";
  static final String columnDescription = "description";
  static final String columnDefaultFlag = "defaultFlag";
  static final String columnEnable = "enable";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,no,name,level,discountWay,discount,validDays,upgradRuleType,upgradValue,downFlag,conditions,prerogative,description,defaultFlag,enable,deleteFlag,createUser,createDate,modifyUser,modifyDate  from pos_member_level;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_member_level(id,tenantId,no,name,level,discountWay,discount,validDays,upgradRuleType,upgradValue,downFlag,conditions,prerogative,description,defaultFlag,enable,deleteFlag,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.no,entity.name,entity.level,entity.discountWay,entity.discount,entity.validDays,entity.upgradRuleType,entity.upgradValue,entity.downFlag,entity.conditions,entity.prerogative,entity.description,entity.defaultFlag,entity.enable,entity.deleteFlag,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_member_level set id= '%s',tenantId= '%s',no= '%s',name= '%s',level= '%s',discountWay= '%s',discount= '%s',validDays= '%s',upgradRuleType= '%s',upgradValue= '%s',downFlag= '%s',conditions= '%s',prerogative= '%s',description= '%s',defaultFlag= '%s',enable= '%s',deleteFlag= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.no,this.name,this.level,this.discountWay,this.discount,this.validDays,this.upgradRuleType,this.upgradValue,this.downFlag,this.conditions,this.prerogative,this.description,this.defaultFlag,this.enable,this.deleteFlag,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_member_level;"
  ///字段名称
  String no;
  String name;
  int level;
  int discountWay;
  double discount;
  int validDays;
  int upgradRuleType;
  double upgradValue;
  int downFlag;
  String conditions;
  String prerogative;
  String description;
  int defaultFlag;
  int enable;
  int deleteFlag;

  ///默认构造
  MemberLevel();

  ///Map转实体对象
  factory MemberLevel.fromMap(Map<String, dynamic> map) {
    return MemberLevel()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..level = Convert.toInt(map[columnLevel])
      ..discountWay = Convert.toInt(map[columnDiscountWay])
      ..discount = Convert.toDouble(map[columnDiscount])
      ..validDays = Convert.toInt(map[columnValidDays])
      ..upgradRuleType = Convert.toInt(map[columnUpgradRuleType])
      ..upgradValue = Convert.toDouble(map[columnUpgradValue])
      ..downFlag = Convert.toInt(map[columnDownFlag])
      ..conditions = Convert.toStr(map[columnConditions])
      ..prerogative = Convert.toStr(map[columnPrerogative])
      ..description = Convert.toStr(map[columnDescription])
      ..defaultFlag = Convert.toInt(map[columnDefaultFlag])
      ..enable = Convert.toInt(map[columnEnable])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory MemberLevel.newMemberLevel() {
    return MemberLevel()
      ..id = ""
      ..tenantId = ""
      ..no = ""
      ..name = ""
      ..level = 0
      ..discountWay = 0
      ..discount = 0
      ..validDays = 0
      ..upgradRuleType = 0
      ..upgradValue = 0
      ..downFlag = 0
      ..conditions = ""
      ..prerogative = ""
      ..description = ""
      ..defaultFlag = 0
      ..enable = 0
      ..deleteFlag = 0
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory MemberLevel.clone(MemberLevel obj) {
    return MemberLevel()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..no = obj.no
      ..name = obj.name
      ..level = obj.level
      ..discountWay = obj.discountWay
      ..discount = obj.discount
      ..validDays = obj.validDays
      ..upgradRuleType = obj.upgradRuleType
      ..upgradValue = obj.upgradValue
      ..downFlag = obj.downFlag
      ..conditions = obj.conditions
      ..prerogative = obj.prerogative
      ..description = obj.description
      ..defaultFlag = obj.defaultFlag
      ..enable = obj.enable
      ..deleteFlag = obj.deleteFlag
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<MemberLevel> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MemberLevel>();
    lists.forEach((map) => result.add(MemberLevel.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnName: this.name,
      columnLevel: this.level,
      columnDiscountWay: this.discountWay,
      columnDiscount: this.discount,
      columnValidDays: this.validDays,
      columnUpgradRuleType: this.upgradRuleType,
      columnUpgradValue: this.upgradValue,
      columnDownFlag: this.downFlag,
      columnConditions: this.conditions,
      columnPrerogative: this.prerogative,
      columnDescription: this.description,
      columnDefaultFlag: this.defaultFlag,
      columnEnable: this.enable,
      columnDeleteFlag: this.deleteFlag,
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
        no,
        name,
        level,
        discountWay,
        discount,
        validDays,
        upgradRuleType,
        upgradValue,
        downFlag,
        conditions,
        prerogative,
        description,
        defaultFlag,
        enable,
        deleteFlag,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
