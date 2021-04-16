import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductContact extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_contact";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnMasterId = "masterId";
  static final String columnMasterSpecId = "masterSpecId";
  static final String columnSlaveId = "slaveId";
  static final String columnSlaveSpecId = "slaveSpecId";
  static final String columnSlaveNum = "slaveNum";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnOrderNo = "orderNo";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,masterId,masterSpecId,slaveId,slaveSpecId,slaveNum,deleteFlag,ext1,ext2,ext3,orderNo,createUser,createDate,modifyUser,modifyDate  from pos_product_contact;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_contact(id,tenantId,masterId,masterSpecId,slaveId,slaveSpecId,slaveNum,deleteFlag,ext1,ext2,ext3,orderNo,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.masterId,entity.masterSpecId,entity.slaveId,entity.slaveSpecId,entity.slaveNum,entity.deleteFlag,entity.ext1,entity.ext2,entity.ext3,entity.orderNo,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_contact set id= '%s',tenantId= '%s',masterId= '%s',masterSpecId= '%s',slaveId= '%s',slaveSpecId= '%s',slaveNum= '%s',deleteFlag= '%s',ext1= '%s',ext2= '%s',ext3= '%s',orderNo= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.masterId,this.masterSpecId,this.slaveId,this.slaveSpecId,this.slaveNum,this.deleteFlag,this.ext1,this.ext2,this.ext3,this.orderNo,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_contact;"
  ///字段名称
  String masterId;
  String masterSpecId;
  String slaveId;
  String slaveSpecId;
  double slaveNum;
  int deleteFlag;
  int orderNo;

  ///默认构造
  ProductContact();

  ///Map转实体对象
  factory ProductContact.fromMap(Map<String, dynamic> map) {
    return ProductContact()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..masterId = Convert.toStr(map[columnMasterId])
      ..masterSpecId = Convert.toStr(map[columnMasterSpecId])
      ..slaveId = Convert.toStr(map[columnSlaveId])
      ..slaveSpecId = Convert.toStr(map[columnSlaveSpecId])
      ..slaveNum = Convert.toDouble(map[columnSlaveNum])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ProductContact.newProductContact() {
    return ProductContact()
      ..id = ""
      ..tenantId = ""
      ..masterId = ""
      ..masterSpecId = ""
      ..slaveId = ""
      ..slaveSpecId = ""
      ..slaveNum = 0
      ..deleteFlag = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..orderNo = 0
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = "";
  }

  ///复制新对象
  factory ProductContact.clone(ProductContact obj) {
    return ProductContact()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..masterId = obj.masterId
      ..masterSpecId = obj.masterSpecId
      ..slaveId = obj.slaveId
      ..slaveSpecId = obj.slaveSpecId
      ..slaveNum = obj.slaveNum
      ..deleteFlag = obj.deleteFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..orderNo = obj.orderNo
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ProductContact> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductContact>();
    lists.forEach((map) => result.add(ProductContact.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnMasterId: this.masterId,
      columnMasterSpecId: this.masterSpecId,
      columnSlaveId: this.slaveId,
      columnSlaveSpecId: this.slaveSpecId,
      columnSlaveNum: this.slaveNum,
      columnDeleteFlag: this.deleteFlag,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnOrderNo: this.orderNo,
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
        masterId,
        masterSpecId,
        slaveId,
        slaveSpecId,
        slaveNum,
        deleteFlag,
        ext1,
        ext2,
        ext3,
        orderNo,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
