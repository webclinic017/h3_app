import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductImage extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_image";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnProductId = "productId";
  static final String columnSpecId = "specId";
  static final String columnWidth = "width";
  static final String columnHeight = "height";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnLength = "length";
  static final String columnMimeType = "mimeType";
  static final String columnOrderNo = "orderNo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnModifyUser = "modifyUser";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,productId,specId,width,height,storageType,storageAddress,length,mimeType,orderNo,ext1,ext2,ext3,createDate,createUser,modifyDate,modifyUser  from pos_product_image;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_image(id,tenantId,productId,specId,width,height,storageType,storageAddress,length,mimeType,orderNo,ext1,ext2,ext3,createDate,createUser,modifyDate,modifyUser  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.productId,entity.specId,entity.width,entity.height,entity.storageType,entity.storageAddress,entity.length,entity.mimeType,entity.orderNo,entity.ext1,entity.ext2,entity.ext3,entity.createDate,entity.createUser,entity.modifyDate,entity.modifyUser ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_image set id= '%s',tenantId= '%s',productId= '%s',specId= '%s',width= '%s',height= '%s',storageType= '%s',storageAddress= '%s',length= '%s',mimeType= '%s',orderNo= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createDate= '%s',createUser= '%s',modifyDate= '%s',modifyUser= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.productId,this.specId,this.width,this.height,this.storageType,this.storageAddress,this.length,this.mimeType,this.orderNo,this.ext1,this.ext2,this.ext3,this.createDate,this.createUser,this.modifyDate,this.modifyUser ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_image;"
  ///字段名称
  String productId;
  String specId;
  int width;
  int height;
  int storageType;
  String storageAddress;
  String length;
  String mimeType;
  int orderNo;

  ///默认构造
  ProductImage();

  ///Map转实体对象
  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..productId = Convert.toStr(map[columnProductId])
      ..specId = Convert.toStr(map[columnSpecId])
      ..width = Convert.toInt(map[columnWidth])
      ..height = Convert.toInt(map[columnHeight])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..length = Convert.toStr(map[columnLength])
      ..mimeType = Convert.toStr(map[columnMimeType])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser]);
  }

  ///构建空对象
  factory ProductImage.newProductImage() {
    return ProductImage()
      ..id = ""
      ..tenantId = ""
      ..productId = ""
      ..specId = ""
      ..width = 0
      ..height = 0
      ..storageType = 0
      ..storageAddress = ""
      ..length = ""
      ..mimeType = ""
      ..orderNo = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..modifyDate = ""
      ..modifyUser = "";
  }

  ///复制新对象
  factory ProductImage.clone(ProductImage obj) {
    return ProductImage()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..productId = obj.productId
      ..specId = obj.specId
      ..width = obj.width
      ..height = obj.height
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..length = obj.length
      ..mimeType = obj.mimeType
      ..orderNo = obj.orderNo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createDate = obj.createDate
      ..createUser = obj.createUser
      ..modifyDate = obj.modifyDate
      ..modifyUser = obj.modifyUser;
  }

  ///转List集合
  static List<ProductImage> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductImage>();
    lists.forEach((map) => result.add(ProductImage.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnProductId: this.productId,
      columnSpecId: this.specId,
      columnWidth: this.width,
      columnHeight: this.height,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnLength: this.length,
      columnMimeType: this.mimeType,
      columnOrderNo: this.orderNo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
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
        productId,
        specId,
        width,
        height,
        storageType,
        storageAddress,
        length,
        mimeType,
        orderNo,
        ext1,
        ext2,
        ext3,
        createDate,
        createUser,
        modifyDate,
        modifyUser,
      ];
}
