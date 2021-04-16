import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';

import 'base_entity.dart';

///Generate By ZhangYing
///CreateTime:2020-10-18 00:18:53
class Product extends BaseEntity {
  ///表名称
  static final String tableName = "pos_product";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnCategoryId = "categoryId";
  static final String columnCategoryPath = "categoryPath";
  static final String columnType = "type";
  static final String columnNo = "no";
  static final String columnBarCode = "barCode";
  static final String columnSubNo = "subNo";
  static final String columnOtherNo = "otherNo";
  static final String columnName = "name";
  static final String columnEnglish = "english";
  static final String columnRem = "rem";
  static final String columnShortName = "shortName";
  static final String columnUnitId = "unitId";
  static final String columnBrandId = "brandId";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnSupplierId = "supplierId";
  static final String columnManagerType = "managerType";
  static final String columnPurchaseControl = "purchaseControl";
  static final String columnPurchaserCycle = "purchaserCycle";
  static final String columnValidDays = "validDays";
  static final String columnProductArea = "productArea";
  static final String columnStatus = "status";
  static final String columnSpNum = "spNum";
  static final String columnStockFlag = "stockFlag";
  static final String columnBatchStockFlag = "batchStockFlag";
  static final String columnWeightFlag = "weightFlag";
  static final String columnWeightWay = "weightWay";
  static final String columnSteelyardCode = "steelyardCode";
  static final String columnLabelPrintFlag = "labelPrintFlag";
  static final String columnForeDiscount = "foreDiscount";
  static final String columnForeGift = "foreGift";
  static final String columnPromotionFlag = "promotionFlag";
  static final String columnBranchPrice = "branchPrice";
  static final String columnForeBargain = "foreBargain";
  static final String columnReturnType = "returnType";
  static final String columnReturnRate = "returnRate";
  static final String columnPointFlag = "pointFlag";
  static final String columnPointValue = "pointValue";
  static final String columnIntroduction = "introduction";
  static final String columnPurchaseTax = "purchaseTax";
  static final String columnSaleTax = "saleTax";
  static final String columnLyRate = "lyRate";
  static final String columnAllCode = "allCode";
  static final String columnDeleteFlag = "deleteFlag";
  static final String columnAllowEditSup = "allowEditSup";
  static final String columnQuickInventoryFlag = "quickInventoryFlag";
  static final String columnPosSellFlag = "posSellFlag";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String categoryId;
  String categoryPath;
  int type;
  String no;
  String barCode;
  String subNo;
  String otherNo;
  String name;
  String english;
  String rem;
  String shortName;
  String unitId;
  String brandId;
  int storageType;
  String storageAddress;
  String supplierId;
  String managerType;
  int purchaseControl;
  double purchaserCycle;
  double validDays;
  String productArea;
  int status;
  int spNum;
  int stockFlag;
  int batchStockFlag;
  int weightFlag;
  int weightWay;
  String steelyardCode;
  int labelPrintFlag;
  int foreDiscount;
  int foreGift;
  int promotionFlag;
  int branchPrice;
  int foreBargain;
  int returnType;
  double returnRate;
  int pointFlag;
  double pointValue;
  String introduction;
  double purchaseTax;
  double saleTax;
  double lyRate;
  String allCode;
  int deleteFlag;
  int allowEditSup;
  int quickInventoryFlag;
  int posSellFlag;

  ///默认构造
  Product();

  ///Map转实体对象
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product()
      ..id = Convert.toStr(
          map[columnId], "${IdWorkerUtils.getInstance().generate()}")
      ..tenantId =
          Convert.toStr(map[columnTenantId], "${Global.instance.authc?.id}")
      ..categoryId = Convert.toStr(map[columnCategoryId])
      ..categoryPath = Convert.toStr(map[columnCategoryPath])
      ..type = Convert.toInt(map[columnType])
      ..no = Convert.toStr(map[columnNo])
      ..barCode = Convert.toStr(map[columnBarCode])
      ..subNo = Convert.toStr(map[columnSubNo])
      ..otherNo = Convert.toStr(map[columnOtherNo])
      ..name = Convert.toStr(map[columnName])
      ..english = Convert.toStr(map[columnEnglish])
      ..rem = Convert.toStr(map[columnRem])
      ..shortName = Convert.toStr(map[columnShortName])
      ..unitId = Convert.toStr(map[columnUnitId])
      ..brandId = Convert.toStr(map[columnBrandId])
      ..storageType = Convert.toInt(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress], "")
      ..supplierId = Convert.toStr(map[columnSupplierId])
      ..managerType = Convert.toStr(map[columnManagerType])
      ..purchaseControl = Convert.toInt(map[columnPurchaseControl])
      ..purchaserCycle = Convert.toDouble(map[columnPurchaserCycle])
      ..validDays = Convert.toDouble(map[columnValidDays])
      ..productArea = Convert.toStr(map[columnProductArea])
      ..status = Convert.toInt(map[columnStatus])
      ..spNum = Convert.toInt(map[columnSpNum])
      ..stockFlag = Convert.toInt(map[columnStockFlag])
      ..batchStockFlag = Convert.toInt(map[columnBatchStockFlag])
      ..weightFlag = Convert.toInt(map[columnWeightFlag])
      ..weightWay = Convert.toInt(map[columnWeightWay])
      ..steelyardCode = Convert.toStr(map[columnSteelyardCode])
      ..labelPrintFlag = Convert.toInt(map[columnLabelPrintFlag])
      ..foreDiscount = Convert.toInt(map[columnForeDiscount])
      ..foreGift = Convert.toInt(map[columnForeGift])
      ..promotionFlag = Convert.toInt(map[columnPromotionFlag])
      ..branchPrice = Convert.toInt(map[columnBranchPrice])
      ..foreBargain = Convert.toInt(map[columnForeBargain])
      ..returnType = Convert.toInt(map[columnReturnType])
      ..returnRate = Convert.toDouble(map[columnReturnRate])
      ..pointFlag = Convert.toInt(map[columnPointFlag])
      ..pointValue = Convert.toDouble(map[columnPointValue])
      ..introduction = Convert.toStr(map[columnIntroduction])
      ..purchaseTax = Convert.toDouble(map[columnPurchaseTax])
      ..saleTax = Convert.toDouble(map[columnSaleTax])
      ..lyRate = Convert.toDouble(map[columnLyRate])
      ..allCode = Convert.toStr(map[columnAllCode])
      ..deleteFlag = Convert.toInt(map[columnDeleteFlag])
      ..allowEditSup = Convert.toInt(map[columnAllowEditSup])
      ..quickInventoryFlag = Convert.toInt(map[columnQuickInventoryFlag])
      ..posSellFlag = Convert.toInt(map[columnPosSellFlag])
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
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"));
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnCategoryId: this.categoryId,
      columnCategoryPath: this.categoryPath,
      columnType: this.type,
      columnNo: this.no,
      columnBarCode: this.barCode,
      columnSubNo: this.subNo,
      columnOtherNo: this.otherNo,
      columnName: this.name,
      columnEnglish: this.english,
      columnRem: this.rem,
      columnShortName: this.shortName,
      columnUnitId: this.unitId,
      columnBrandId: this.brandId,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
      columnSupplierId: this.supplierId,
      columnManagerType: this.managerType,
      columnPurchaseControl: this.purchaseControl,
      columnPurchaserCycle: this.purchaserCycle,
      columnValidDays: this.validDays,
      columnProductArea: this.productArea,
      columnStatus: this.status,
      columnSpNum: this.spNum,
      columnStockFlag: this.stockFlag,
      columnBatchStockFlag: this.batchStockFlag,
      columnWeightFlag: this.weightFlag,
      columnWeightWay: this.weightWay,
      columnSteelyardCode: this.steelyardCode,
      columnLabelPrintFlag: this.labelPrintFlag,
      columnForeDiscount: this.foreDiscount,
      columnForeGift: this.foreGift,
      columnPromotionFlag: this.promotionFlag,
      columnBranchPrice: this.branchPrice,
      columnForeBargain: this.foreBargain,
      columnReturnType: this.returnType,
      columnReturnRate: this.returnRate,
      columnPointFlag: this.pointFlag,
      columnPointValue: this.pointValue,
      columnIntroduction: this.introduction,
      columnPurchaseTax: this.purchaseTax,
      columnSaleTax: this.saleTax,
      columnLyRate: this.lyRate,
      columnAllCode: this.allCode,
      columnDeleteFlag: this.deleteFlag,
      columnAllowEditSup: this.allowEditSup,
      columnQuickInventoryFlag: this.quickInventoryFlag,
      columnPosSellFlag: this.posSellFlag,
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

  static List<Product> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Product>();
    lists.forEach((map) => result.add(Product.fromMap(map)));
    return result;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
