import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductPlus extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_plus";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnTicketId = "ticketId";
  static final String columnTicketNo = "ticketNo";
  static final String columnProductId = "productId";
  static final String columnProductNo = "productNo";
  static final String columnProductName = "productName";
  static final String columnVipPrice = "vipPrice";
  static final String columnSalePrice = "salePrice";
  static final String columnPlusDiscount = "plusDiscount";
  static final String columnPlusPrice = "plusPrice";
  static final String columnDescription = "description";
  static final String columnSpecId = "specId";
  static final String columnSpecName = "specName";
  static final String columnValidStartDate = "validStartDate";
  static final String columnValidendDate = "validendDate";
  static final String columnSubNo = "subNo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,ticketId,ticketNo,productId,productNo,productName,vipPrice,salePrice,plusDiscount,plusPrice,description,specId,specName,validStartDate,validendDate,subNo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_product_plus;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_plus(id,tenantId,ticketId,ticketNo,productId,productNo,productName,vipPrice,salePrice,plusDiscount,plusPrice,description,specId,specName,validStartDate,validendDate,subNo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.ticketId,entity.ticketNo,entity.productId,entity.productNo,entity.productName,entity.vipPrice,entity.salePrice,entity.plusDiscount,entity.plusPrice,entity.description,entity.specId,entity.specName,entity.validStartDate,entity.validendDate,entity.subNo,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_plus set id= '%s',tenantId= '%s',ticketId= '%s',ticketNo= '%s',productId= '%s',productNo= '%s',productName= '%s',vipPrice= '%s',salePrice= '%s',plusDiscount= '%s',plusPrice= '%s',description= '%s',specId= '%s',specName= '%s',validStartDate= '%s',validendDate= '%s',subNo= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.ticketId,this.ticketNo,this.productId,this.productNo,this.productName,this.vipPrice,this.salePrice,this.plusDiscount,this.plusPrice,this.description,this.specId,this.specName,this.validStartDate,this.validendDate,this.subNo,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_plus;"
  ///字段名称
  String ticketId;
  String ticketNo;
  String productId;
  String productNo;
  String productName;
  double vipPrice;
  double salePrice;
  double plusDiscount;
  double plusPrice;
  String description;
  String specId;
  String specName;
  String validStartDate;
  String validendDate;
  String subNo;

  ///默认构造
  ProductPlus();

  ///Map转实体对象
  factory ProductPlus.fromMap(Map<String, dynamic> map) {
    return ProductPlus()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..ticketId = Convert.toStr(map[columnTicketId])
      ..ticketNo = Convert.toStr(map[columnTicketNo])
      ..productId = Convert.toStr(map[columnProductId])
      ..productNo = Convert.toStr(map[columnProductNo])
      ..productName = Convert.toStr(map[columnProductName])
      ..vipPrice = Convert.toDouble(map[columnVipPrice])
      ..salePrice = Convert.toDouble(map[columnSalePrice])
      ..plusDiscount = Convert.toDouble(map[columnPlusDiscount])
      ..plusPrice = Convert.toDouble(map[columnPlusPrice])
      ..description = Convert.toStr(map[columnDescription])
      ..specId = Convert.toStr(map[columnSpecId])
      ..specName = Convert.toStr(map[columnSpecName])
      ..validStartDate = Convert.toStr(map[columnValidStartDate])
      ..validendDate = Convert.toStr(map[columnValidendDate])
      ..subNo = Convert.toStr(map[columnSubNo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ProductPlus.newProductPlus() {
    return ProductPlus()
      ..id = ""
      ..tenantId = ""
      ..ticketId = ""
      ..ticketNo = ""
      ..productId = ""
      ..productNo = ""
      ..productName = ""
      ..vipPrice = 0
      ..salePrice = 0
      ..plusDiscount = 0
      ..plusPrice = 0
      ..description = ""
      ..specId = ""
      ..specName = ""
      ..validStartDate = ""
      ..validendDate = ""
      ..subNo = ""
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
  factory ProductPlus.clone(ProductPlus obj) {
    return ProductPlus()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..ticketId = obj.ticketId
      ..ticketNo = obj.ticketNo
      ..productId = obj.productId
      ..productNo = obj.productNo
      ..productName = obj.productName
      ..vipPrice = obj.vipPrice
      ..salePrice = obj.salePrice
      ..plusDiscount = obj.plusDiscount
      ..plusPrice = obj.plusPrice
      ..description = obj.description
      ..specId = obj.specId
      ..specName = obj.specName
      ..validStartDate = obj.validStartDate
      ..validendDate = obj.validendDate
      ..subNo = obj.subNo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ProductPlus> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductPlus>();
    lists.forEach((map) => result.add(ProductPlus.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnTicketId: this.ticketId,
      columnTicketNo: this.ticketNo,
      columnProductId: this.productId,
      columnProductNo: this.productNo,
      columnProductName: this.productName,
      columnVipPrice: this.vipPrice,
      columnSalePrice: this.salePrice,
      columnPlusDiscount: this.plusDiscount,
      columnPlusPrice: this.plusPrice,
      columnDescription: this.description,
      columnSpecId: this.specId,
      columnSpecName: this.specName,
      columnValidStartDate: this.validStartDate,
      columnValidendDate: this.validendDate,
      columnSubNo: this.subNo,
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
        ticketId,
        ticketNo,
        productId,
        productNo,
        productName,
        vipPrice,
        salePrice,
        plusDiscount,
        plusPrice,
        description,
        specId,
        specName,
        validStartDate,
        validendDate,
        subNo,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
