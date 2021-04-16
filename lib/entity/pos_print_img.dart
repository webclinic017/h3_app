import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class PrintImg extends BaseEntity {
  ///表名称
  static final String tableName = "pos_print_img";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnStoreNo = "storeNo";
  static final String columnName = "name";
  static final String columnType = "type";
  static final String columnWidth = "width";
  static final String columnHeight = "height";
  static final String columnIsEnable = "isEnable";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnIsDelete = "isDelete";
  static final String columnDescription = "description";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,storeId,storeNo,name,type,width,height,isEnable,storageType,storageAddress,isDelete,description,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_print_img;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_print_img(id,tenantId,storeId,storeNo,name,type,width,height,isEnable,storageType,storageAddress,isDelete,description,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.storeId,entity.storeNo,entity.name,entity.type,entity.width,entity.height,entity.isEnable,entity.storageType,entity.storageAddress,entity.isDelete,entity.description,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_print_img set id= '%s',tenantId= '%s',storeId= '%s',storeNo= '%s',name= '%s',type= '%s',width= '%s',height= '%s',isEnable= '%s',storageType= '%s',storageAddress= '%s',isDelete= '%s',description= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.storeId,this.storeNo,this.name,this.type,this.width,this.height,this.isEnable,this.storageType,this.storageAddress,this.isDelete,this.description,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_print_img;"
  ///字段名称
  String storeId;
  String storeNo;
  String name;
  int type;
  int width;
  int height;
  int isEnable;
  int storageType;
  String storageAddress;
  int isDelete;
  String description;

  ///默认构造
  PrintImg();

  ///Map转实体对象
  factory PrintImg.fromMap(Map<String, dynamic> map) {
    return PrintImg()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..storeNo = Convert.toStr(map[columnStoreNo])
      ..name = Convert.toStr(map[columnName])
      ..type = Convert.toInt(map[columnType])
      ..width = Convert.toInt(map[columnWidth])
      ..height = Convert.toInt(map[columnHeight])
      ..isEnable = Convert.toInt(map[columnIsEnable])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..isDelete = Convert.toInt(map[columnIsDelete])
      ..description = Convert.toStr(map[columnDescription])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory PrintImg.newPrintImg() {
    return PrintImg()
      ..id = ""
      ..tenantId = ""
      ..storeId = ""
      ..storeNo = ""
      ..name = ""
      ..type = 0
      ..width = 0
      ..height = 0
      ..isEnable = 0
      ..storageType = 0
      ..storageAddress = ""
      ..isDelete = 0
      ..description = ""
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
  factory PrintImg.clone(PrintImg obj) {
    return PrintImg()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..storeId = obj.storeId
      ..storeNo = obj.storeNo
      ..name = obj.name
      ..type = obj.type
      ..width = obj.width
      ..height = obj.height
      ..isEnable = obj.isEnable
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..isDelete = obj.isDelete
      ..description = obj.description
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<PrintImg> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PrintImg>();
    lists.forEach((map) => result.add(PrintImg.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnStoreNo: this.storeNo,
      columnName: this.name,
      columnType: this.type,
      columnWidth: this.width,
      columnHeight: this.height,
      columnIsEnable: this.isEnable,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnIsDelete: this.isDelete,
      columnDescription: this.description,
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
        storeNo,
        name,
        type,
        width,
        height,
        isEnable,
        storageType,
        storageAddress,
        isDelete,
        description,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
