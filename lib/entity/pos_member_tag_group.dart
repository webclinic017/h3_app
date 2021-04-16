import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class MemberTagGroup extends BaseEntity {
  ///表名称
  static final String tableName = "pos_member_tag_group";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnOrderNo = "orderNo";
  static final String columnEnable = "enable";
  static final String columnDescription = "description";
  static final String columnDefaultFlag = "defaultFlag";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnModifyUser = "modifyUser";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,no,name,orderNo,enable,description,defaultFlag,deleteFlag,createDate,createUser,modifyDate,modifyUser  from pos_member_tag_group;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_member_tag_group(id,tenantId,no,name,orderNo,enable,description,defaultFlag,deleteFlag,createDate,createUser,modifyDate,modifyUser  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.no,entity.name,entity.orderNo,entity.enable,entity.description,entity.defaultFlag,entity.deleteFlag,entity.createDate,entity.createUser,entity.modifyDate,entity.modifyUser ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_member_tag_group set id= '%s',tenantId= '%s',no= '%s',name= '%s',orderNo= '%s',enable= '%s',description= '%s',defaultFlag= '%s',deleteFlag= '%s',createDate= '%s',createUser= '%s',modifyDate= '%s',modifyUser= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.no,this.name,this.orderNo,this.enable,this.description,this.defaultFlag,this.deleteFlag,this.createDate,this.createUser,this.modifyDate,this.modifyUser ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_member_tag_group;"
  ///字段名称
  String no;
  String name;
  int orderNo;
  int enable;
  String description;
  int defaultFlag;
  int deleteFlag;

  ///默认构造
  MemberTagGroup();

  ///Map转实体对象
  factory MemberTagGroup.fromMap(Map<String, dynamic> map) {
    return MemberTagGroup()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..orderNo = Convert.toInt(map[columnOrderNo])
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
  factory MemberTagGroup.newMemberTagGroup() {
    return MemberTagGroup()
      ..id = ""
      ..tenantId = ""
      ..no = ""
      ..name = ""
      ..orderNo = 0
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
  factory MemberTagGroup.clone(MemberTagGroup obj) {
    return MemberTagGroup()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..no = obj.no
      ..name = obj.name
      ..orderNo = obj.orderNo
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
  static List<MemberTagGroup> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MemberTagGroup>();
    lists.forEach((map) => result.add(MemberTagGroup.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnName: this.name,
      columnOrderNo: this.orderNo,
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
        no,
        name,
        orderNo,
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
