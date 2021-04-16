import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductCategory extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_category";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnParentId = "parentId";
  static final String columnName = "name";
  static final String columnCode = "code";
  static final String columnPath = "path";
  static final String columnCategoryType = "categoryType";
  static final String columnEnglish = "english";
  static final String columnReturnRate = "returnRate";
  static final String columnDescription = "description";
  static final String columnOrderNo = "orderNo";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnProducts = "products";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,parentId,name,code,path,categoryType,english,returnRate,description,orderNo,deleteFlag,products,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_product_category;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_category(id,tenantId,parentId,name,code,path,categoryType,english,returnRate,description,orderNo,deleteFlag,products,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.parentId,entity.name,entity.code,entity.path,entity.categoryType,entity.english,entity.returnRate,entity.description,entity.orderNo,entity.deleteFlag,entity.products,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_category set id= '%s',tenantId= '%s',parentId= '%s',name= '%s',code= '%s',path= '%s',categoryType= '%s',english= '%s',returnRate= '%s',description= '%s',orderNo= '%s',deleteFlag= '%s',products= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.parentId,this.name,this.code,this.path,this.categoryType,this.english,this.returnRate,this.description,this.orderNo,this.deleteFlag,this.products,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_category;"
  ///字段名称
  String parentId;
  String name;
  String code;
  String path;
  int categoryType;
  String english;
  int returnRate;
  String description;
  int orderNo;
  int deleteFlag;
  int products;

  ///默认构造
  ProductCategory();

  ///Map转实体对象
  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..parentId = Convert.toStr(map[columnParentId])
      ..name = Convert.toStr(map[columnName])
      ..code = Convert.toStr(map[columnCode])
      ..path = Convert.toStr(map[columnPath])
      ..categoryType = Convert.toInt(map[columnCategoryType])
      ..english = Convert.toStr(map[columnEnglish])
      ..returnRate = Convert.toInt(map[columnReturnRate])
      ..description = Convert.toStr(map[columnDescription])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..products = Convert.toInt(map[columnProducts])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ProductCategory.newProductCategory() {
    return ProductCategory()
      ..id = ""
      ..tenantId = ""
      ..parentId = ""
      ..name = ""
      ..code = ""
      ..path = ""
      ..categoryType = 0
      ..english = ""
      ..returnRate = 0
      ..description = ""
      ..orderNo = 0
      ..deleteFlag = 0
      ..products = 0
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
  factory ProductCategory.clone(ProductCategory obj) {
    return ProductCategory()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..parentId = obj.parentId
      ..name = obj.name
      ..code = obj.code
      ..path = obj.path
      ..categoryType = obj.categoryType
      ..english = obj.english
      ..returnRate = obj.returnRate
      ..description = obj.description
      ..orderNo = obj.orderNo
      ..deleteFlag = obj.deleteFlag
      ..products = obj.products
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ProductCategory> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductCategory>();
    lists.forEach((map) => result.add(ProductCategory.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnParentId: this.parentId,
      columnName: this.name,
      columnCode: this.code,
      columnPath: this.path,
      columnCategoryType: this.categoryType,
      columnEnglish: this.english,
      columnReturnRate: this.returnRate,
      columnDescription: this.description,
      columnOrderNo: this.orderNo,
      columnDeleteFlag: this.deleteFlag,
      columnProducts: this.products,
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
        name,
        code,
        path,
        categoryType,
        english,
        returnRate,
        description,
        orderNo,
        deleteFlag,
        products,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
