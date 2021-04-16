import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductSpec extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_spec";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnProductId = "productId";
  static final String columnSpecNo = "specNo";
  static final String columnSpecification = "specification";
  static final String columnPurPrice = "purPrice";
  static final String columnSalePrice = "salePrice";
  static final String columnMinPrice = "minPrice";
  static final String columnVipPrice = "vipPrice";
  static final String columnVipPrice2 = "vipPrice2";
  static final String columnVipPrice3 = "vipPrice3";
  static final String columnVipPrice4 = "vipPrice4";
  static final String columnVipPrice5 = "vipPrice5";
  static final String columnPostPrice = "postPrice";
  static final String columnBatchPrice = "batchPrice";
  static final String columnBatchPrice2 = "batchPrice2";
  static final String columnBatchPrice3 = "batchPrice3";
  static final String columnBatchPrice4 = "batchPrice4";
  static final String columnBatchPrice5 = "batchPrice5";
  static final String columnBatchPrice6 = "batchPrice6";
  static final String columnBatchPrice7 = "batchPrice7";
  static final String columnBatchPrice8 = "batchPrice8";
  static final String columnOtherPrice = "otherPrice";
  static final String columnPurchaseSpec = "purchaseSpec";
  static final String columnStatus = "status";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnIsDefault = "isDefault";
  static final String columnTopLimit = "topLimit";
  static final String columnLowerLimit = "lowerLimit";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,productId,specNo,specification,purPrice,salePrice,minPrice,vipPrice,vipPrice2,vipPrice3,vipPrice4,vipPrice5,postPrice,batchPrice,batchPrice2,batchPrice3,batchPrice4,batchPrice5,batchPrice6,batchPrice7,batchPrice8,otherPrice,purchaseSpec,status,storageType,storageAddress,deleteFlag,isDefault,topLimit,lowerLimit,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_product_spec;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_spec(id,tenantId,productId,specNo,specification,purPrice,salePrice,minPrice,vipPrice,vipPrice2,vipPrice3,vipPrice4,vipPrice5,postPrice,batchPrice,batchPrice2,batchPrice3,batchPrice4,batchPrice5,batchPrice6,batchPrice7,batchPrice8,otherPrice,purchaseSpec,status,storageType,storageAddress,deleteFlag,isDefault,topLimit,lowerLimit,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.productId,entity.specNo,entity.specification,entity.purPrice,entity.salePrice,entity.minPrice,entity.vipPrice,entity.vipPrice2,entity.vipPrice3,entity.vipPrice4,entity.vipPrice5,entity.postPrice,entity.batchPrice,entity.batchPrice2,entity.batchPrice3,entity.batchPrice4,entity.batchPrice5,entity.batchPrice6,entity.batchPrice7,entity.batchPrice8,entity.otherPrice,entity.purchaseSpec,entity.status,entity.storageType,entity.storageAddress,entity.deleteFlag,entity.isDefault,entity.topLimit,entity.lowerLimit,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_spec set id= '%s',tenantId= '%s',productId= '%s',specNo= '%s',specification= '%s',purPrice= '%s',salePrice= '%s',minPrice= '%s',vipPrice= '%s',vipPrice2= '%s',vipPrice3= '%s',vipPrice4= '%s',vipPrice5= '%s',postPrice= '%s',batchPrice= '%s',batchPrice2= '%s',batchPrice3= '%s',batchPrice4= '%s',batchPrice5= '%s',batchPrice6= '%s',batchPrice7= '%s',batchPrice8= '%s',otherPrice= '%s',purchaseSpec= '%s',status= '%s',storageType= '%s',storageAddress= '%s',deleteFlag= '%s',isDefault= '%s',topLimit= '%s',lowerLimit= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.productId,this.specNo,this.specification,this.purPrice,this.salePrice,this.minPrice,this.vipPrice,this.vipPrice2,this.vipPrice3,this.vipPrice4,this.vipPrice5,this.postPrice,this.batchPrice,this.batchPrice2,this.batchPrice3,this.batchPrice4,this.batchPrice5,this.batchPrice6,this.batchPrice7,this.batchPrice8,this.otherPrice,this.purchaseSpec,this.status,this.storageType,this.storageAddress,this.deleteFlag,this.isDefault,this.topLimit,this.lowerLimit,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_spec;"
  ///字段名称
  String productId;
  String specNo;
  String specification;
  double purPrice;
  double salePrice;
  double minPrice;
  double vipPrice;
  double vipPrice2;
  double vipPrice3;
  double vipPrice4;
  double vipPrice5;
  double postPrice;
  double batchPrice;
  double batchPrice2;
  double batchPrice3;
  double batchPrice4;
  double batchPrice5;
  double batchPrice6;
  double batchPrice7;
  double batchPrice8;
  double otherPrice;
  double purchaseSpec;
  int status;
  int storageType;
  String storageAddress;
  int deleteFlag;
  int isDefault;
  double topLimit;
  double lowerLimit;

  ///默认构造
  ProductSpec();

  ///Map转实体对象
  factory ProductSpec.fromMap(Map<String, dynamic> map) {
    return ProductSpec()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..productId = Convert.toStr(map[columnProductId])
      ..specNo = Convert.toStr(map[columnSpecNo])
      ..specification = Convert.toStr(map[columnSpecification])
      ..purPrice = Convert.toDouble(map[columnPurPrice])
      ..salePrice = Convert.toDouble(map[columnSalePrice])
      ..minPrice = Convert.toDouble(map[columnMinPrice])
      ..vipPrice = Convert.toDouble(map[columnVipPrice])
      ..vipPrice2 = Convert.toDouble(map[columnVipPrice2])
      ..vipPrice3 = Convert.toDouble(map[columnVipPrice3])
      ..vipPrice4 = Convert.toDouble(map[columnVipPrice4])
      ..vipPrice5 = Convert.toDouble(map[columnVipPrice5])
      ..postPrice = Convert.toDouble(map[columnPostPrice])
      ..batchPrice = Convert.toDouble(map[columnBatchPrice])
      ..batchPrice2 = Convert.toDouble(map[columnBatchPrice2])
      ..batchPrice3 = Convert.toDouble(map[columnBatchPrice3])
      ..batchPrice4 = Convert.toDouble(map[columnBatchPrice4])
      ..batchPrice5 = Convert.toDouble(map[columnBatchPrice5])
      ..batchPrice6 = Convert.toDouble(map[columnBatchPrice6])
      ..batchPrice7 = Convert.toDouble(map[columnBatchPrice7])
      ..batchPrice8 = Convert.toDouble(map[columnBatchPrice8])
      ..otherPrice = Convert.toDouble(map[columnOtherPrice])
      ..purchaseSpec = Convert.toDouble(map[columnPurchaseSpec])
      ..status = Convert.toInt(map[columnStatus])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..isDefault = Convert.toInt(map[columnIsDefault])
      ..topLimit = Convert.toDouble(map[columnTopLimit])
      ..lowerLimit = Convert.toDouble(map[columnLowerLimit])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ProductSpec.newProductSpec() {
    return ProductSpec()
      ..id = ""
      ..tenantId = ""
      ..productId = ""
      ..specNo = ""
      ..specification = ""
      ..purPrice = 0
      ..salePrice = 0
      ..minPrice = 0
      ..vipPrice = 0
      ..vipPrice2 = 0
      ..vipPrice3 = 0
      ..vipPrice4 = 0
      ..vipPrice5 = 0
      ..postPrice = 0
      ..batchPrice = 0
      ..batchPrice2 = 0
      ..batchPrice3 = 0
      ..batchPrice4 = 0
      ..batchPrice5 = 0
      ..batchPrice6 = 0
      ..batchPrice7 = 0
      ..batchPrice8 = 0
      ..otherPrice = 0
      ..purchaseSpec = 0
      ..status = 0
      ..storageType = 0
      ..storageAddress = ""
      ..deleteFlag = 0
      ..isDefault = 0
      ..topLimit = 0
      ..lowerLimit = 0
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
  factory ProductSpec.clone(ProductSpec obj) {
    return ProductSpec()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..productId = obj.productId
      ..specNo = obj.specNo
      ..specification = obj.specification
      ..purPrice = obj.purPrice
      ..salePrice = obj.salePrice
      ..minPrice = obj.minPrice
      ..vipPrice = obj.vipPrice
      ..vipPrice2 = obj.vipPrice2
      ..vipPrice3 = obj.vipPrice3
      ..vipPrice4 = obj.vipPrice4
      ..vipPrice5 = obj.vipPrice5
      ..postPrice = obj.postPrice
      ..batchPrice = obj.batchPrice
      ..batchPrice2 = obj.batchPrice2
      ..batchPrice3 = obj.batchPrice3
      ..batchPrice4 = obj.batchPrice4
      ..batchPrice5 = obj.batchPrice5
      ..batchPrice6 = obj.batchPrice6
      ..batchPrice7 = obj.batchPrice7
      ..batchPrice8 = obj.batchPrice8
      ..otherPrice = obj.otherPrice
      ..purchaseSpec = obj.purchaseSpec
      ..status = obj.status
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..deleteFlag = obj.deleteFlag
      ..isDefault = obj.isDefault
      ..topLimit = obj.topLimit
      ..lowerLimit = obj.lowerLimit
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ProductSpec> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductSpec>();
    lists.forEach((map) => result.add(ProductSpec.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnProductId: this.productId,
      columnSpecNo: this.specNo,
      columnSpecification: this.specification,
      columnPurPrice: this.purPrice,
      columnSalePrice: this.salePrice,
      columnMinPrice: this.minPrice,
      columnVipPrice: this.vipPrice,
      columnVipPrice2: this.vipPrice2,
      columnVipPrice3: this.vipPrice3,
      columnVipPrice4: this.vipPrice4,
      columnVipPrice5: this.vipPrice5,
      columnPostPrice: this.postPrice,
      columnBatchPrice: this.batchPrice,
      columnBatchPrice2: this.batchPrice2,
      columnBatchPrice3: this.batchPrice3,
      columnBatchPrice4: this.batchPrice4,
      columnBatchPrice5: this.batchPrice5,
      columnBatchPrice6: this.batchPrice6,
      columnBatchPrice7: this.batchPrice7,
      columnBatchPrice8: this.batchPrice8,
      columnOtherPrice: this.otherPrice,
      columnPurchaseSpec: this.purchaseSpec,
      columnStatus: this.status,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnDeleteFlag: this.deleteFlag,
      columnIsDefault: this.isDefault,
      columnTopLimit: this.topLimit,
      columnLowerLimit: this.lowerLimit,
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
        productId,
        specNo,
        specification,
        purPrice,
        salePrice,
        minPrice,
        vipPrice,
        vipPrice2,
        vipPrice3,
        vipPrice4,
        vipPrice5,
        postPrice,
        batchPrice,
        batchPrice2,
        batchPrice3,
        batchPrice4,
        batchPrice5,
        batchPrice6,
        batchPrice7,
        batchPrice8,
        otherPrice,
        purchaseSpec,
        status,
        storageType,
        storageAddress,
        deleteFlag,
        isDefault,
        topLimit,
        lowerLimit,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
