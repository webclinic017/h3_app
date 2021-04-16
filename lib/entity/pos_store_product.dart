import 'dart:convert';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class StoreProduct extends BaseEntity {
  ///表名称
  static final String tableName = "pos_store_product";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnStoreId = "storeId";
  static final String columnProductId = "productId";
  static final String columnSpecId = "specId";
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
  static final String columnSupplierId = "supplierId";
  static final String columnStatus = "status";
  static final String columnTopLimit = "topLimit";
  static final String columnLowerLimit = "lowerLimit";
  static final String columnPurchaseDate = "purchaseDate";
  static final String columnLastDate = "lastDate";
  static final String columnPointFlag = "pointFlag";
  static final String columnForeGift = "foreGift";
  static final String columnForeDiscount = "foreDiscount";
  static final String columnStockFlag = "stockFlag";
  static final String columnForeBargain = "foreBargain";
  static final String columnBranchPrice = "branchPrice";
  static final String columnManagerType = "managerType";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnMallFlag = "mallFlag";

  ///字段名称
  String storeId;
  String productId;
  String specId;
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
  String supplierId;
  int status;
  double topLimit;
  double lowerLimit;
  String purchaseDate;
  String lastDate;
  int pointFlag;
  int foreGift;
  int foreDiscount;
  int stockFlag;
  int foreBargain;
  int branchPrice;
  String managerType;
  int mallFlag;

  ///默认构造
  StoreProduct();

  ///Map转实体对象
  factory StoreProduct.fromMap(Map<String, dynamic> map) {
    return StoreProduct()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId = Convert.toStr(
          map[columnTenantId], "${Global.instance.authc?.tenantId}")
      ..storeId = Convert.toStr(map[columnStoreId])
      ..productId = Convert.toStr(map[columnProductId])
      ..specId = Convert.toStr(map[columnSpecId])
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
      ..supplierId = Convert.toStr(map[columnSupplierId])
      ..status = Convert.toInt(map[columnStatus])
      ..topLimit = Convert.toDouble(map[columnTopLimit])
      ..lowerLimit = Convert.toDouble(map[columnLowerLimit])
      ..purchaseDate = Convert.toStr(map[columnPurchaseDate])
      ..lastDate = Convert.toStr(map[columnLastDate])
      ..pointFlag = Convert.toInt(map[columnPointFlag])
      ..foreGift = Convert.toInt(map[columnForeGift])
      ..foreDiscount = Convert.toInt(map[columnForeDiscount])
      ..stockFlag = Convert.toInt(map[columnStockFlag])
      ..foreBargain = Convert.toInt(map[columnForeBargain])
      ..branchPrice = Convert.toInt(map[columnBranchPrice])
      ..managerType = Convert.toStr(map[columnManagerType])
      ..ext1 = Convert.toStr(map[columnExt1], "")
      ..ext2 = Convert.toStr(map[columnExt2], "")
      ..ext3 = Convert.toStr(map[columnExt3], "")
      ..createUser =
          Convert.toStr(map[columnCreateUser], Constants.DEFAULT_CREATE_USER)
      ..createDate = Convert.toStr(map[columnCreateDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..modifyUser =
          Convert.toStr(map[columnModifyUser], Constants.DEFAULT_MODIFY_USER)
      ..modifyDate = Convert.toStr(map[columnModifyDate],
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"))
      ..mallFlag = Convert.toInt(map[columnMallFlag]);
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnStoreId: this.storeId,
      columnProductId: this.productId,
      columnSpecId: this.specId,
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
      columnSupplierId: this.supplierId,
      columnStatus: this.status,
      columnTopLimit: this.topLimit,
      columnLowerLimit: this.lowerLimit,
      columnPurchaseDate: this.purchaseDate,
      columnLastDate: this.lastDate,
      columnPointFlag: this.pointFlag,
      columnForeGift: this.foreGift,
      columnForeDiscount: this.foreDiscount,
      columnStockFlag: this.stockFlag,
      columnForeBargain: this.foreBargain,
      columnBranchPrice: this.branchPrice,
      columnManagerType: this.managerType,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnMallFlag: this.mallFlag,
    };
    return map;
  }

  static List<StoreProduct> toList(List<Map<String, dynamic>> lists) {
    var result = new List<StoreProduct>();
    lists.forEach((map) => result.add(StoreProduct.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
