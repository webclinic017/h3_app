import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class ProductHotselling extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product_hotselling";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnProductId = "productId";
  static final String columnOrderNo = "orderNo";
  static final String columnLocalFlag = "localFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///SELECT语句模版
  ///static final String SELECT_SQL = "select id,tenantId,storeId,productId,orderNo,localFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  from pos_product_hotselling;";
  ///INSERT语句模版
  ///static final String INSERT_TEMPLATE_SQL = "insert into pos_product_hotselling(id,tenantId,storeId,productId,orderNo,localFlag,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate  ) values ( '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'  );
  ///static final String INSERT_SQL = sprintf(INSERT_TEMPLATE_SQL,[entity.id,entity.tenantId,entity.storeId,entity.productId,entity.orderNo,entity.localFlag,entity.ext1,entity.ext2,entity.ext3,entity.createUser,entity.createDate,entity.modifyUser,entity.modifyDate ]);
  ///UPDATE语句模版
  ///static final String UPDATE_TEMPLATE_SQL = "update pos_product_hotselling set id= '%s',tenantId= '%s',storeId= '%s',productId= '%s',orderNo= '%s',localFlag= '%s',ext1= '%s',ext2= '%s',ext3= '%s',createUser= '%s',createDate= '%s',modifyUser= '%s',modifyDate= '%s' ;
  ///static final String UPDATE_SQL = sprintf(UPDATE_TEMPLATE_SQL,[this.id,this.tenantId,this.storeId,this.productId,this.orderNo,this.localFlag,this.ext1,this.ext2,this.ext3,this.createUser,this.createDate,this.modifyUser,this.modifyDate ];
  ///DELETE语句模版
  ///static final String DELETE_TEMPLATE_SQL = "delete from pos_product_hotselling;"
  ///字段名称
  String storeId;
  String productId;
  int orderNo;
  int localFlag;

  ///默认构造
  ProductHotselling();

  ///Map转实体对象
  factory ProductHotselling.fromMap(Map<String, dynamic> map) {
    return ProductHotselling()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..storeId = Convert.toStr(map[columnStoreId])
      ..productId = Convert.toStr(map[columnProductId])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..localFlag = Convert.toInt(map[columnLocalFlag])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///构建空对象
  factory ProductHotselling.newProductHotselling() {
    return ProductHotselling()
      ..id = ""
      ..tenantId = ""
      ..storeId = ""
      ..productId = ""
      ..orderNo = 0
      ..localFlag = 0
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
  factory ProductHotselling.clone(ProductHotselling obj) {
    return ProductHotselling()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..storeId = obj.storeId
      ..productId = obj.productId
      ..orderNo = obj.orderNo
      ..localFlag = obj.localFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///转List集合
  static List<ProductHotselling> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductHotselling>();
    lists.forEach((map) => result.add(ProductHotselling.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnProductId: this.productId,
      columnOrderNo: this.orderNo,
      columnLocalFlag: this.localFlag,
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
        productId,
        orderNo,
        localFlag,
        ext1,
        ext2,
        ext3,
        createUser,
        createDate,
        modifyUser,
        modifyDate,
      ];
}
