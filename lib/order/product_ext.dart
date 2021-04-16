import 'dart:convert';
import 'dart:core';

import 'package:h3_app/entity/pos_product_spec.dart';
import 'package:h3_app/entity/pos_promotion_product.dart';
import 'package:h3_app/entity/pos_setmeal_group.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

///点单商品展示对象,该类暂时没有继承Product类，目前Dart的继承不够强大
///修改Product类，可能需要调整本类
class ProductExt {
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
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnQuickInventoryFlag = "quickInventoryFlag";
  static final String columnPosSellFlag = "posSellFlag";

  ///------------------------ProductExt新增部分-----------------------------
  static final String columnCategoryNo = "categoryNo";
  static final String columnCategoryName = "categoryName";
  static final String columnUnitName = "unitName";
  static final String columnSupplierName = "supplierName";
  static final String columnBrandName = "brandName";
  static final String columnSpecName = "specName";
  static final String columnSpecId = "specId";
  static final String columnIsDefault = "isDefault";

  ///商品关联规格

  ///捆绑商品下属商品
  static final String columnSlaveNum = "slaveNum";
  static final String columnPurPrice = "purPrice";
  static final String columnSalePrice = "salePrice";
  static final String columnSpecialPrice = "specialPrice";
  static final String columnSpecialPriceLimitDateDesc =
      "specialPriceLimitDateDesc";
  static final String columnPromotionNow = "promotionNow";

  ///当前商品参与促销(有效促销)

  static final String columnMinPrice = "minPrice";
  static final String columnVipPrice = "vipPrice";
  static final String columnVipPrice2 = "vipPrice2";
  static final String columnVipPrice3 = "vipPrice3";
  static final String columnVipPrice4 = "vipPrice4";
  static final String columnVipPrice5 = "vipPrice5";
  static final String columnPostPrice = "postPrice";
  static final String columnBatchPrice = "batchPrice";
  static final String columnOtherPrice = "otherPrice";
  static final String columnPurchaseSpec = "purchaseSpec";
  static final String columnPlusFlag = "plusFlag";
  static final String columnPlusPrice = "plusPrice";
  static final String columnValidStartDate = "validStartDate";
  static final String columnValidEndDate = "validEndDate";
  static final String columnChuda = "chuda";
  static final String columnChudaFlag = "chudaFlag";
  static final String columnChupin = "chupin";
  static final String columnChupinFlag = "chupinFlag";
  static final String columnChudaLabel = "chudaLabel";
  static final String columnChudaLabelFlag = "chudaLabelFlag";

  //是否上架到网店
  static final String columnMallFlag = "mallFlag";

  ///-----------------------------------------------------------------------

  ///字段名称
  String id;
  String tenantId;
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
  String ext1;
  String ext2;
  String ext3;
  String createUser;
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
  String modifyUser;
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///------------------------ProductExt新增部分-----------------------------

  ///分类NO
  String categoryNo;

  ///分类名称
  String categoryName;

  ///单位名称
  String unitName;

  /// 供应商名称
  String supplierName;

  ///品牌名称
  String brandName;

  ///默认规格名称
  String specName;

  ///默认规格ID
  String specId;

  /// 是否默认规格，查询临时使用，不能作为依据
  int isDefault;

  /// 商品关联规格
  List<ProductSpec> specList;

  /// 捆绑商品下属商品
  List<ProductExt> bindingList;

  /// 子商品数量， 和BindingList配合使用
  double slaveNum;

  /// 套餐分组
  List<SetmealGroup> mealGroupList;

  /// 进价
  double purPrice;

  /// 原零售价
  double salePrice;

  /// 特价，促销特价
  double specialPrice;

  /// 特价时间段描述
  String specialPriceLimitDateDesc;

  /// 当前正在促销标识，选择商品区域使用
  bool promotionNow;

  /// 当前商品参与促销(有效促销)
  List<PromotionProduct> promotionList;

  /// 最低售价
  double minPrice;

  /// 会员价
  double vipPrice;

  /// 会员价2
  double vipPrice2;

  /// 会员价3
  double vipPrice3;

  /// 会员价4
  double vipPrice4;

  /// 会员价5
  double vipPrice5;

  /// 配送价
  double postPrice;

  /// 批发价
  double batchPrice;

  /// 外送价
  double otherPrice;

  /// 进货规格
  double purchaseSpec;

  /// PLUS商品标识
  bool plusFlag = false;

  /// PLUS商品价格
  double plusPrice;

  /// PLUS商品优惠开始时间
  String validStartDate;

  /// PLUS商品优惠结束时间
  String validEndDate;

  /// 厨打方案
  String chuda;

  /// 厨打标识
  String chudaFlag;

  /// 出品方案
  String chupin;

  /// 出品标识
  String chupinFlag;

  /// 厨打标签方案
  String chudaLabel;

  /// 厨打标签标识
  String chudaLabelFlag;

  //商品是否上架到网店
  int mallFlag;

  ///-----------------------------------------------------------------------

  ///默认构造
  ProductExt();

  ///Map转实体对象
  factory ProductExt.fromMap(Map<String, dynamic> map) {
    return ProductExt()
      ..id = Convert.toStr(map[columnId], "")
      ..tenantId = Convert.toStr(map[columnTenantId], "")
      ..categoryId = Convert.toStr(map[columnCategoryId])
      ..categoryPath = Convert.toStr(map[columnCategoryPath])
      ..type = Convert.toInt(map[columnType])
      ..no = Convert.toStr(map[columnNo], "")
      ..barCode = Convert.toStr(map[columnBarCode], "")
      ..subNo = Convert.toStr(map[columnSubNo], "")
      ..otherNo = Convert.toStr(map[columnOtherNo], "")
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
      ..ext1 = Convert.toStr(map[columnExt1], "")
      ..ext2 = Convert.toStr(map[columnExt2], "")
      ..ext3 = Convert.toStr(map[columnExt3], "")
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser], "")
      ..modifyDate = Convert.toStr(map[columnModifyDate], "")
      ..quickInventoryFlag = Convert.toInt(map[columnQuickInventoryFlag])
      ..posSellFlag = Convert.toInt(map[columnPosSellFlag])

      ///-------------------ProductExt新增--------------------------
      ..categoryNo = Convert.toStr(map[columnCategoryNo])
      ..categoryName = Convert.toStr(map[columnCategoryName])
      ..unitName = Convert.toStr(map[columnUnitName])
      ..supplierName = Convert.toStr(map[columnSupplierName])
      ..brandName = Convert.toStr(map[columnBrandName])
      ..specName = Convert.toStr(map[columnSpecName])
      ..specId = Convert.toStr(map[columnSpecId])
      ..isDefault = Convert.toInt(map[columnIsDefault])
      ..slaveNum = Convert.toDouble(map[columnSlaveNum])
      ..purPrice = Convert.toDouble(map[columnPurPrice])
      ..salePrice = Convert.toDouble(map[columnSalePrice])
      ..specialPrice = Convert.toDouble(map[columnSpecialPrice])
      ..specialPriceLimitDateDesc =
          Convert.toStr(map[columnSpecialPriceLimitDateDesc])
      ..promotionNow = Convert.toBool(map[columnPromotionNow])
      ..minPrice = Convert.toDouble(map[columnMinPrice])
      ..vipPrice = Convert.toDouble(map[columnVipPrice])
      ..vipPrice2 = Convert.toDouble(map[columnVipPrice2])
      ..vipPrice3 = Convert.toDouble(map[columnVipPrice3])
      ..vipPrice4 = Convert.toDouble(map[columnVipPrice4])
      ..vipPrice5 = Convert.toDouble(map[columnVipPrice5])
      ..postPrice = Convert.toDouble(map[columnPostPrice])
      ..batchPrice = Convert.toDouble(map[columnBatchPrice])
      ..otherPrice = Convert.toDouble(map[columnOtherPrice])
      ..purchaseSpec = Convert.toDouble(map[columnPurchaseSpec])
      ..plusFlag = Convert.toBool(map[columnPlusFlag])
      ..plusPrice = Convert.toDouble(map[columnPlusPrice])
      ..validStartDate = Convert.toStr(map[columnValidStartDate])
      ..validEndDate = Convert.toStr(map[columnValidEndDate])
      ..chuda = Convert.toStr(map[columnChuda], "")
      ..chudaFlag = Convert.toStr(map[columnChudaFlag], "")
      ..chupin = Convert.toStr(map[columnChupin], "")
      ..chupinFlag = Convert.toStr(map[columnChupinFlag], "")
      ..chudaLabel = Convert.toStr(map[columnChudaLabel], "")
      ..chudaLabelFlag = Convert.toStr(map[columnChudaLabelFlag], "");

    ///---------------------------------------------------------------
  }

  ///复制新对象
  factory ProductExt.clone(ProductExt obj) {
    return ProductExt()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..categoryId = obj.categoryId
      ..categoryPath = obj.categoryPath
      ..type = obj.type
      ..no = obj.no
      ..barCode = obj.barCode
      ..subNo = obj.subNo
      ..otherNo = obj.otherNo
      ..name = obj.name
      ..english = obj.english
      ..rem = obj.rem
      ..shortName = obj.shortName
      ..unitId = obj.unitId
      ..brandId = obj.brandId
      ..storageType = obj.storageType
      ..storageAddress = obj.storageAddress
      ..supplierId = obj.supplierId
      ..managerType = obj.managerType
      ..purchaseControl = obj.purchaseControl
      ..purchaserCycle = obj.purchaserCycle
      ..validDays = obj.validDays
      ..productArea = obj.productArea
      ..status = obj.status
      ..spNum = obj.spNum
      ..stockFlag = obj.stockFlag
      ..batchStockFlag = obj.batchStockFlag
      ..weightFlag = obj.weightFlag
      ..weightWay = obj.weightWay
      ..steelyardCode = obj.steelyardCode
      ..labelPrintFlag = obj.labelPrintFlag
      ..foreDiscount = obj.foreDiscount
      ..foreGift = obj.foreGift
      ..promotionFlag = obj.promotionFlag
      ..branchPrice = obj.branchPrice
      ..foreBargain = obj.foreBargain
      ..returnType = obj.returnType
      ..returnRate = obj.returnRate
      ..pointFlag = obj.pointFlag
      ..pointValue = obj.pointValue
      ..introduction = obj.introduction
      ..purchaseTax = obj.purchaseTax
      ..saleTax = obj.saleTax
      ..lyRate = obj.lyRate
      ..allCode = obj.allCode
      ..deleteFlag = obj.deleteFlag
      ..allowEditSup = obj.allowEditSup
      ..quickInventoryFlag = obj.quickInventoryFlag
      ..posSellFlag = obj.posSellFlag
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate

      ///-------------------ProductExt新增--------------------------
      ..categoryNo = obj.categoryNo
      ..categoryName = obj.categoryName
      ..unitName = obj.unitName
      ..supplierName = obj.supplierName
      ..brandName = obj.brandName
      ..specName = obj.specName
      ..specId = obj.specId
      ..isDefault = obj.isDefault
      ..slaveNum = obj.slaveNum
      ..purPrice = obj.purPrice
      ..salePrice = obj.salePrice
      ..specialPrice = obj.specialPrice
      ..specialPriceLimitDateDesc = obj.specialPriceLimitDateDesc
      ..promotionNow = obj.promotionNow
      ..minPrice = obj.minPrice
      ..vipPrice = obj.vipPrice
      ..vipPrice2 = obj.vipPrice2
      ..vipPrice3 = obj.vipPrice3
      ..vipPrice4 = obj.vipPrice4
      ..vipPrice5 = obj.vipPrice5
      ..postPrice = obj.postPrice
      ..batchPrice = obj.batchPrice
      ..otherPrice = obj.otherPrice
      ..purchaseSpec = obj.purchaseSpec
      ..plusFlag = obj.plusFlag
      ..plusPrice = obj.plusPrice
      ..validStartDate = obj.validStartDate
      ..validEndDate = obj.validEndDate
      ..chuda = obj.chuda
      ..chudaFlag = obj.chudaFlag
      ..chupin = obj.chupin
      ..chupinFlag = obj.chupinFlag
      ..chudaLabel = obj.chudaLabel
      ..chudaLabelFlag = obj.chudaLabelFlag
      ..mallFlag = obj.mallFlag
      ..specList = obj.specList
      ..mealGroupList = obj.mealGroupList
      ..bindingList = obj.bindingList
      ..promotionList = obj.promotionList;

    ///---------------------------------------------------------------
  }

  ///转List集合
  static List<ProductExt> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ProductExt>();
    lists.forEach((map) => result.add(ProductExt.fromMap(map)));
    return result;
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
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnQuickInventoryFlag: this.quickInventoryFlag,
      columnPosSellFlag: this.posSellFlag,

      ///-------------------ProductExt新增--------------------------
      columnCategoryNo: this.categoryNo,
      columnCategoryName: this.categoryName,
      columnUnitName: this.unitName,
      columnSupplierName: this.supplierName,
      columnBrandName: this.brandName,
      columnSpecName: this.specName,
      columnSpecId: this.specId,
      columnIsDefault: this.isDefault,
      columnSlaveNum: this.slaveNum,
      columnPurPrice: this.purPrice,
      columnSalePrice: this.salePrice,
      columnSpecialPrice: this.specialPrice,
      columnSpecialPriceLimitDateDesc: this.specialPriceLimitDateDesc,
      columnPromotionNow: this.promotionNow,
      columnMinPrice: this.minPrice,
      columnVipPrice: this.vipPrice,
      columnVipPrice2: this.vipPrice2,
      columnVipPrice3: this.vipPrice3,
      columnVipPrice4: this.vipPrice4,
      columnVipPrice5: this.vipPrice5,
      columnPostPrice: this.postPrice,
      columnBatchPrice: this.batchPrice,
      columnOtherPrice: this.otherPrice,
      columnPurchaseSpec: this.purchaseSpec,
      columnPlusFlag: this.plusFlag,
      columnPlusPrice: this.plusPrice,
      columnValidStartDate: this.validStartDate,
      columnValidEndDate: this.validEndDate,
      columnChuda: this.chuda,
      columnChudaFlag: this.chudaFlag,
      columnChupin: this.chupin,
      columnChupinFlag: this.chupinFlag,
      columnChudaLabel: this.chudaLabel,
      columnChudaLabelFlag: this.chudaLabelFlag,

      ///---------------------------------------------------------------
    };

    return map;
  }

  String get statusStr {
    String result = "";
    switch (this.status) {
      //1 - 正常；2 - 停购；3 - 停售；4 - 淘汰；
      case 1:
        {
          result = "正常";
        }
        break;
      case 2:
        {
          result = "停购";
        }
        break;
      case 3:
        {
          result = "停售";
        }
        break;
      case 4:
        {
          result = "淘汰";
        }
        break;
    }
    return result;
  }

  String get managerTypeStr {
    String result = "";
    switch (this.managerType) {
      //G-购销；D-代销；L-联营；K--扣率代销；
      case "G":
        {
          result = "购销";
        }
        break;
      case "D":
        {
          result = "代销";
        }
        break;
      case "L":
        {
          result = "联营";
        }
        break;
      case "K":
        {
          result = "扣率代销";
        }
        break;
    }
    return result;
  }

  String get weightWayName {
    return this.weightWay == 1 ? "计重" : "计数";
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
