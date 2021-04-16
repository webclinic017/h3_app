import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class MemberTag extends BaseEntity {
  ///表名称
  static final String tableName = "pos_member_tag";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnGroupId = "groupId";
  static final String columnGroupNo = "groupNo";
  static final String columnName = "name";
  static final String columnNo = "no";
  static final String columnOrderNo = "orderNo";
  static final String columnColor = "color";
  static final String columnEnable = "enable";
  static final String columnDescription = "description";
  static final String columnDefaultFlag = "defaultFlag";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnModifyUser = "modifyUser";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,groupId,groupNo,name,no,orderNo,color,enable,description,defaultFlag,deleteFlag,createDate,createUser,modifyDate,modifyUser  from pos_member_tag;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_member_tag(id,tenantId,groupId,groupNo,name,no,orderNo,color,enable,description,defaultFlag,deleteFlag,createDate,createUser,modifyDate,modifyUser  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.groupId,entity.groupNo,entity.name,entity.no,entity.orderNo,entity.color,entity.enable,entity.description,entity.defaultFlag,entity.deleteFlag,entity.createDate,entity.createUser,entity.modifyDate,entity.modifyUser ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_member_tag set id= '%s',tenantId= '%s',groupId= '%s',groupNo= '%s',name= '%s',no= '%s',orderNo= '%s',color= '%s',enable= '%s',description= '%s',defaultFlag= '%s',deleteFlag= '%s',createDate= '%s',createUser= '%s',modifyDate= '%s',modifyUser= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.groupId,this.groupNo,this.name,this.no,this.orderNo,this.color,this.enable,this.description,this.defaultFlag,this.deleteFlag,this.createDate,this.createUser,this.modifyDate,this.modifyUser ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_member_tag;"
  ///字段名称
  String groupId;
  String groupNo;
  String name;
  String no;
  int orderNo;
  String color;
  int enable;
  String description;
  int defaultFlag;
  int deleteFlag;

  ///默认构造
  MemberTag();

  ///Map转实体对象
  factory MemberTag.fromMap(Map<String, dynamic> map) {
    return MemberTag()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..groupId = Convert.toStr(map[columnGroupId])
      ..groupNo = Convert.toStr(map[columnGroupNo])
      ..name = Convert.toStr(map[columnName])
      ..no = Convert.toStr(map[columnNo])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..color = Convert.toStr(map[columnColor])
      ..enable = Convert.toInt(map[columnEnable])
      ..description = Convert.toStr(map[columnDescription])
      ..defaultFlag = Convert.toInt(map[columnDefaultFlag])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser]);
  }

  ///构建空对象
  factory MemberTag.newMemberTag() {
    return MemberTag()
      ..id = ""
      ..tenantId = ""
      ..groupId = ""
      ..groupNo = ""
      ..name = ""
      ..no = ""
      ..orderNo = 0
      ..color = ""
      ..enable = 0
      ..description = ""
      ..defaultFlag = 0
      ..deleteFlag = 0
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..modifyDate = ""
      ..modifyUser = "";
  }

  ///复制新对象
  factory MemberTag.clone(MemberTag obj) {
    return MemberTag()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..groupId = obj.groupId
      ..groupNo = obj.groupNo
      ..name = obj.name
      ..no = obj.no
      ..orderNo = obj.orderNo
      ..color = obj.color
      ..enable = obj.enable
      ..description = obj.description
      ..defaultFlag = obj.defaultFlag
      ..deleteFlag = obj.deleteFlag
      ..createDate = obj.createDate
      ..createUser = obj.createUser
      ..modifyDate = obj.modifyDate
      ..modifyUser = obj.modifyUser;
  }

  ///转List集合
  static List<MemberTag> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MemberTag>();
    lists.forEach((map) => result.add(MemberTag.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnGroupId: this.groupId,
      columnGroupNo: this.groupNo,
      columnName: this.name,
      columnNo: this.no,
      columnOrderNo: this.orderNo,
      columnColor: this.color,
      columnEnable: this.enable,
      columnDescription: this.description,
      columnDefaultFlag: this.defaultFlag,
      columnDeleteFlag: this.deleteFlag,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyDate: this.modifyDate,
      columnModifyUser: this.modifyUser,
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
        groupId,
        groupNo,
        name,
        no,
        orderNo,
        color,
        enable,
        description,
        defaultFlag,
        deleteFlag,
        createDate,
        createUser,
        modifyDate,
        modifyUser,
      ];
}
