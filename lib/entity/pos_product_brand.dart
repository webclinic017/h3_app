import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductBrand extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_brand";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnName = "name";
  static final String columnReturnRate = "returnRate";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnOrderNo = "orderNo";
  static final String columnProducts = "products";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnBrandNo = "brandNo";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,name,returnRate,storageType,storageAddress,orderNo,products,deleteFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,brandNo  from pos_product_brand;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_brand(id,tenantId,name,returnRate,storageType,storageAddress,orderNo,products,deleteFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,brandNo  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.name,entity.returnRate,entity.storageType,entity.storageAddress,entity.orderNo,entity.products,entity.deleteFlag,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate,entity.brandNo ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_brand set id= '%s',tenantId= '%s',name= '%s',returnRate= '%s',storageType= '%s',storageAddress= '%s',orderNo= '%s',products= '%s',deleteFlag= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s',brandNo= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.name,this.returnRate,this.storageType,this.storageAddress,this.orderNo,this.products,this.deleteFlag,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate,this.brandNo ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_brand;"
  ///字段名称
  String name;
  int returnRate;
  int storageType;
  String storageAddress;
  int orderNo;
  int products;
  int deleteFlag;
  String brandNo;

  ///默认构造
  ProductBrand();

  ///Map转实体对象
  factory ProductBrand.fromMap(Map<String, dynamic> map) {
    return ProductBrand()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..name = Convert.toStr(map[columnName])
      ..returnRate = Convert.toInt(map[columnReturnRate])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..products = Convert.toInt(map[columnProducts])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..brandNo = Convert.toStr(map[columnBrandNo]);
  }

  ///构建空对象
  factory ProductBrand.newProductBrand() {
    return ProductBrand()
      ..id = ""
      ..tenantId = ""
      ..name = ""
      ..returnRate = 0
      ..storageType = 0
      ..storageAddress = ""
      ..orderNo = 0
      ..products = 0
      ..deleteFlag = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = ""
      ..modifyDate = ""
      ..brandNo = "";
  }

  ///复制新对象
  factory ProductBrand.clone(ProductBrand obj) {
    return ProductBrand()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..name = obj.name
      ..returnRate = obj.returnRate
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..orderNo = obj.orderNo
      ..products = obj.products
      ..deleteFlag = obj.deleteFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..brandNo = obj.brandNo;
  }

  ///转List集合
  static List<ProductBrand> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductBrand>();
    lists.forEach((map) => result.add(ProductBrand.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnName: this.name,
      columnReturnRate: this.returnRate,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnOrderNo: this.orderNo,
      columnProducts: this.products,
      columnDeleteFlag: this.deleteFlag,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnBrandNo: this.brandNo,
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
        name,
        returnRate,
        storageType,
        storageAddress,
        orderNo,
        products,
        deleteFlag,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
        brandNo,
      ];
}
