import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class AdvertCaption extends BaseEntity {
  ///表名称
  static final String tableName = "pos_advert_caption";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnName = "name";
  static final String columnContent = "content";
  static final String columnIsEnable = "isEnable";
  static final String columnOrderNo = "orderNo";
  static final String columnIsDelete = "isDelete";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,storeId,name,content,isEnable,orderNo,isDelete,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_advert_caption;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_advert_caption(id,tenantId,storeId,name,content,isEnable,orderNo,isDelete,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.storeId,entity.name,entity.content,entity.isEnable,entity.orderNo,entity.isDelete,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_advert_caption set id= '%s',tenantId= '%s',storeId= '%s',name= '%s',content= '%s',isEnable= '%s',orderNo= '%s',isDelete= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.storeId,this.name,this.content,this.isEnable,this.orderNo,this.isDelete,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_advert_caption;"
  ///字段名称
  String storeId;
  String name;
  String content;
  int isEnable;
  int orderNo;
  int isDelete;

  ///默认构造
  AdvertCaption();

  ///Map转实体对象
  factory AdvertCaption.fromMap(Map<String, dynamic> map) {
    return AdvertCaption()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..name = Convert.toStr(map[columnName])
      ..content = Convert.toStr(map[columnContent])
      ..isEnable = Convert.toInt(map[columnIsEnable])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..isDelete = Convert.toInt(map[columnIsDelete])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory AdvertCaption.newAdvertCaption() {
    return AdvertCaption()
      ..id = ""
      ..tenantId = ""
      ..storeId = ""
      ..name = ""
      ..content = ""
      ..isEnable = 0
      ..orderNo = 0
      ..isDelete = 0
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
  factory AdvertCaption.clone(AdvertCaption obj) {
    return AdvertCaption()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..storeId = obj.storeId
      ..name = obj.name
      ..content = obj.content
      ..isEnable = obj.isEnable
      ..orderNo = obj.orderNo
      ..isDelete = obj.isDelete
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<AdvertCaption> toList(List<Map<String, dynamic>> lists) {
    var result = new List<AdvertCaption>();
    lists.forEach((map) => result.add(AdvertCaption.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnName: this.name,
      columnContent: this.content,
      columnIsEnable: this.isEnable,
      columnOrderNo: this.orderNo,
      columnIsDelete: this.isDelete,
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
        storeId,
        name,
        content,
        isEnable,
        orderNo,
        isDelete,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
