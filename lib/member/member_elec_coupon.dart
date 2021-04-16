import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';

class MemberElecCoupon extends Equatable {
  /// 是否选中
  bool selected = false;

  /// 是否可用
  bool enable = true;

  /// 不可用原因
  String reason = "";

  /// 是否冻结（0-不冻结，1-冻结）
  int isFreeze = 0;

  /// 企业编号
  String tenantId = "";

  /// 明细ID ,是CouponNo的主键
  String id = "";

  /// 券分类Id
  String typeId = "";

  /// 券分类编号
  String typeNo = "";

  /// 电子券方案Id 制券ID
  String couponPlanId = "";

  /// 电子券方案代码  制券编号
  String couponPlanCode = "";

  /// 电子券券号  一券一码
  String couponNo = "";

  /// 电子券名称
  String name = "";

  /// 电子券来源(plus :plus会员 ，weixin:微信)
  String sourceSign = "";

  /// 名称
  String couponName = "";

  /// 电子券描述
  String description = "";

  /// 抵扣类型（1-固定值 2-比率）
  int discountType = 1;

  /// 抵扣值
  double discountValue = 0;

  /// 状态（0-新建，1-已领取，2-已核销，3-已失效）
  int status = 0;

  String get statusDes {
    String result = "非法";
    switch (status) {
      case 0:
        {
          result = "未领取";
        }
        break;
      case 1:
        {
          result = "已领取";
        }
        break;
      case 2:
        {
          result = "已核销";
        }
        break;
      case 3:
        {
          result = "已失效";
        }
        break;
    }
    return result;
  }

  /// 是否允许其他券使用（0-不允许 1-允许）
  int canUnionUse = 0;

  /// 有效开始时间
  String beginEffectiveTime = "";

  /// 有效结束时间
  String endEffectiveTime = "";

  String get effectiveTime {
    var result = "";

    try {
      var begin = DateUtils.getDateTime(beginEffectiveTime);
      var end = DateUtils.getDateTime(endEffectiveTime);
      var difference = end.difference(begin);

      if (difference.inDays > 1 && difference.inDays <= 30) {
        result = "仅剩余${difference.inDays}天";
      } else if (difference.inDays >= 100 * 360) {
        result = "永久有效";
      } else {
        result = endEffectiveTime;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("电子券起始日期转化发生异常:" + e.toString());
    }

    return result;
  }

  /// 适用范围（1-全场通用 2-部分商品 3-商品类别 4-商品品牌）
  int fitRange = 1;

  String get fitRangeDes {
    var result = "";
    if (fitRange == 1) {
      result = "全场通用";
    } else if (fitRange == 2) {
      result = "部分商品";
    } else if (fitRange == 3) {
      result = "部分类别";
    } else if (fitRange == 4) {
      result = "部分品牌";
    }

    return result;
  }

  /// 发放类型（1-不限量 2-限量）
  int deliveryType = 1;

  /// 当天已核销数量(同一券代码的券)
  int usedNum = 0;

  /// 预发数量
  int quantity = 0;

  /// 封面图片
  String coverLogo = "";

  /// 封面简介
  String coverContext = "";

  /// 时间类型(1-永久有效 2-固定日期区间 3-固定时长/自领取后按天算)
  int dateType = 1;

  /// 领取后多少天开始生效(表示自领取后多少天开始生效，领取后当天生效填写0)
  int fixedBeginTerm = 0;

  /// 领取后有效天数
  int fixedTerm = 0;

  /// 起用金额(消费满N元可使用)
  double leastCost = 0;

  /// 单人限领总数
  int getLimit = 0;

  /// 是否限定使用时段(0-不限定 1-限定)
  int useTimeFlag = 0;

  /// 使用时段类型(0-每日时段 1-指定时段)
  int useTimeType = 0;

  /// 是否限定领取时段(0-不限定;1-限定;)
  int gainTimeFlag = 0;

  /// 领取时段类型(0-每日时段 1-指定时段)
  int gainTimeType = 0;

  /// 是否可以转增(0-否 1-是)
  int canGiveFriend = 0;

  /// 核销门店ID
  String consumeStoreId = "";

  /// 核销门店编号
  String consumeStoreNo = "";

  /// 核销门店名称
  String consumeStoreName = "";

  /// 0-不限门店;1-指定门店;
  int consumeStoreFlag = 0;

  /// 单人单日限用N张;0-不限量 <>1 使用张数
  int dayLimitQuantity = 0;

  ///核销方式
  String codeType = "";

  ///例外商品标识
  int exGoodsFlag = 0;

  ///核销提示
  String notice = "";

  /// 电子券适用类别
  List<ElecCouponCategory> categoryList;

  /// 电子券适用品牌
  List<ElecCouponBrand> brandList;

  /// 电子券适用商品
  List<ElecCouponGoods> goodsList;

  /// 电子券适用商品黑名单
  List<ElecCouponGoods> exgoodsList;

  /// 电子券可核销门店
  List<ElecCouponStore> consumeStoreList;

  /// 电子券可用时段
  List<ElecCouponUseTime> useTimeList;

  MemberElecCoupon();

  factory MemberElecCoupon.fromJson(Map<String, dynamic> json) {
    return MemberElecCoupon()
      ..id = Convert.toStr(json['id'])
      ..name = Convert.toStr(json['name'])
      ..sourceSign = Convert.toStr(json['sourceSign'])
      ..typeId = Convert.toStr(json['typeId'])
      ..discountValue = Convert.toDouble(json['discountValue'])
      ..couponPlanCode = Convert.toStr(json['couponCode'])
      ..usedNum = Convert.toInt(json['usedNum'])
      ..coverLogo = Convert.toStr(json['coverLogo'])
      ..status = Convert.toInt(json['status'])
      ..gainTimeType = Convert.toInt(json['gainTimeType'])
      ..codeType = Convert.toStr(json['codeType'])
      ..canGiveFriend = Convert.toInt(json['canGiveFriend'])
      ..getLimit = Convert.toInt(json['getLimit'])
      ..useTimeFlag = Convert.toInt(json['useTimeFlag'])
      ..description = Convert.toStr(json['description'])
      ..exGoodsFlag = Convert.toInt(json['exGoodsFlag'])
      ..notice = Convert.toStr(json['notice'])
      ..beginEffectiveTime = Convert.toStr(json['beginEffectiveTime'])
      ..quantity = Convert.toInt(json['quantity'])
      ..leastCost = Convert.toDouble(json['leastCost'])
      ..fitRange = Convert.toInt(json['fitRange'])
      ..deliveryType = Convert.toInt(json['deliveryType'])
      ..couponNo = Convert.toStr(json['couponNo'])
      ..fixedBeginTerm = Convert.toInt(json['fixedBeginTerm'])
      ..canUnionUse = Convert.toInt(json['canUnionUse'])
      ..couponPlanId = Convert.toStr(json['couponId'])
      ..isFreeze = Convert.toInt(json['isFreeze'])
      ..endEffectiveTime = Convert.toStr(json['endEffectiveTime'])
      ..consumeStoreFlag = Convert.toInt(json['consumeStoreFlag'])
      ..consumeStoreId = Convert.toStr(json['consumeStoreId'])
      ..consumeStoreNo = Convert.toStr(json['consumeStoreNo'])
      ..consumeStoreName = Convert.toStr(json['consumeStoreName'])
      ..gainTimeFlag = Convert.toInt(json['gainTimeFlag'])
      ..dateType = Convert.toInt(json['dateType'])
      ..dayLimitQuantity = Convert.toInt(json['dayLimitQuantity'])
      ..typeNo = Convert.toStr(json['typeNo'])
      ..discountType = Convert.toInt(json['discountType'])
      ..categoryList = json["categoryList"] != null
          ? List<ElecCouponCategory>.from(
              json["categoryList"].map((x) => ElecCouponCategory.fromJson(x)))
          : <ElecCouponCategory>[]
      ..brandList = json["brandList"] != null
          ? List<ElecCouponBrand>.from(
              json["brandList"].map((x) => ElecCouponBrand.fromJson(x)))
          : <ElecCouponBrand>[]
      ..goodsList = json["goodsList"] != null
          ? List<ElecCouponGoods>.from(
              json["goodsList"].map((x) => ElecCouponGoods.fromJson(x)))
          : <ElecCouponGoods>[]
      ..exgoodsList = json["exgoodsList"] != null
          ? List<ElecCouponGoods>.from(
              json["exgoodsList"].map((x) => ElecCouponGoods.fromJson(x)))
          : <ElecCouponGoods>[]
      ..consumeStoreList = json["consumeStoreList"] != null
          ? List<ElecCouponStore>.from(
              json["consumeStoreList"].map((x) => ElecCouponStore.fromJson(x)))
          : <ElecCouponStore>[]
      ..useTimeList = json["useTimeList"] != null
          ? List<ElecCouponUseTime>.from(
              json["useTimeList"].map((x) => ElecCouponUseTime.fromJson(x)))
          : <ElecCouponUseTime>[];
  }

  ///转List集合
  static List<MemberElecCoupon> toList(List<Map<String, dynamic>> lists) {
    var result = new List<MemberElecCoupon>();
    lists.forEach((map) => result.add(MemberElecCoupon.fromJson(map)));
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sourceSign'] = this.sourceSign;
    data['typeId'] = this.typeId;
    data['discountValue'] = this.discountValue;
    data['couponCode'] = this.couponPlanCode;
    data['usedNum'] = this.usedNum;
    data['coverLogo'] = this.coverLogo;
    data['status'] = this.status;
    data['gainTimeType'] = this.gainTimeType;
    data['codeType'] = this.codeType;
    data['canGiveFriend'] = this.canGiveFriend;
    data['getLimit'] = this.getLimit;
    data['useTimeFlag'] = this.useTimeFlag;
    data['description'] = this.description;
    data['exGoodsFlag'] = this.exGoodsFlag;
    data['notice'] = this.notice;
    data['beginEffectiveTime'] = this.beginEffectiveTime;
    data['quantity'] = this.quantity;
    data['leastCost'] = this.leastCost;
    data['exGoodsFlag'] = this.exGoodsFlag;
    data['notice'] = this.notice;
    data['beginEffectiveTime'] = this.beginEffectiveTime;
    data['quantity'] = this.quantity;
    data['leastCost'] = this.leastCost;
    data['fitRange'] = this.fitRange;
    data['deliveryType'] = this.deliveryType;
    data['deliveryType'] = this.deliveryType;
    data['couponNo'] = this.couponNo;
    data['fixedBeginTerm'] = this.fixedBeginTerm;
    data['canUnionUse'] = this.canUnionUse;
    data['couponId'] = this.couponPlanId;
    data['isFreeze'] = this.isFreeze;
    data['endEffectiveTime'] = this.endEffectiveTime;
    data['consumeStoreFlag'] = this.consumeStoreFlag;
    data['consumeStoreId'] = this.consumeStoreId;
    data['consumeStoreNo'] = this.consumeStoreNo;
    data['consumeStoreName'] = this.consumeStoreName;
    data['gainTimeFlag'] = this.gainTimeFlag;
    data['dateType'] = this.dateType;

    data['dayLimitQuantity'] = this.dayLimitQuantity;
    data['typeNo'] = this.typeNo;
    data['discountType'] = this.discountType;

    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList.map((v) => v.toJson()).toList();
    }
    if (this.brandList != null) {
      data['brandList'] = this.brandList.map((v) => v.toJson()).toList();
    }
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    if (this.exgoodsList != null) {
      data['exgoodsList'] = this.exgoodsList.map((v) => v.toJson()).toList();
    }
    if (this.consumeStoreList != null) {
      data['consumeStoreList'] =
          this.consumeStoreList.map((v) => v.toJson()).toList();
    }
    if (this.useTimeList != null) {
      data['useTimeList'] = this.useTimeList.map((v) => v.toJson()).toList();
    }

    return data;
  }

  ///复制新对象
  factory MemberElecCoupon.clone(MemberElecCoupon obj) {
    return MemberElecCoupon()
      ..selected = obj.selected
      ..enable = obj.enable
      ..reason = obj.reason
      ..id = obj.id
      ..name = obj.name
      ..sourceSign = obj.sourceSign
      ..typeId = obj.typeId
      ..discountValue = obj.discountValue
      ..couponPlanCode = obj.couponPlanCode
      ..usedNum = obj.usedNum
      ..coverLogo = obj.coverLogo
      ..status = obj.status
      ..gainTimeType = obj.gainTimeType
      ..codeType = obj.codeType
      ..canGiveFriend = obj.canGiveFriend
      ..getLimit = obj.getLimit
      ..useTimeFlag = obj.useTimeFlag
      ..description = obj.description
      ..exGoodsFlag = obj.exGoodsFlag
      ..notice = obj.notice
      ..beginEffectiveTime = obj.beginEffectiveTime
      ..quantity = obj.quantity
      ..leastCost = obj.leastCost
      ..fitRange = obj.fitRange
      ..deliveryType = obj.deliveryType
      ..couponNo = obj.couponNo
      ..fixedBeginTerm = obj.fixedBeginTerm
      ..canUnionUse = obj.canUnionUse
      ..couponPlanId = obj.couponPlanId
      ..isFreeze = obj.isFreeze
      ..endEffectiveTime = obj.endEffectiveTime
      ..consumeStoreFlag = obj.consumeStoreFlag
      ..consumeStoreId = obj.consumeStoreId
      ..consumeStoreNo = obj.consumeStoreNo
      ..consumeStoreName = obj.consumeStoreName
      ..gainTimeFlag = obj.gainTimeFlag
      ..dateType = obj.dateType
      ..dayLimitQuantity = obj.dayLimitQuantity
      ..typeNo = obj.typeNo
      ..discountType = obj.discountType
      ..categoryList =
          obj.categoryList.map((e) => ElecCouponCategory.clone(e)).toList()
      ..brandList = obj.brandList.map((e) => ElecCouponBrand.clone(e)).toList()
      ..goodsList = obj.goodsList.map((e) => ElecCouponGoods.clone(e)).toList()
      ..exgoodsList =
          obj.exgoodsList.map((e) => ElecCouponGoods.clone(e)).toList()
      ..consumeStoreList =
          obj.consumeStoreList.map((e) => ElecCouponStore.clone(e)).toList()
      ..useTimeList =
          obj.useTimeList.map((e) => ElecCouponUseTime.clone(e)).toList();
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.id,
        this.name,
        this.sourceSign,
        this.typeId,
        this.discountValue,
        this.couponPlanCode,
        this.usedNum,
        this.coverLogo,
        this.status,
        this.gainTimeType,
        this.codeType,
        this.canGiveFriend,
        this.getLimit,
        this.useTimeFlag,
        this.description,
        this.exGoodsFlag,
        this.notice,
        this.beginEffectiveTime,
        this.quantity,
        this.leastCost,
        this.fitRange,
        this.deliveryType,
        this.couponNo,
        this.fixedBeginTerm,
        this.canUnionUse,
        this.couponPlanId,
        this.isFreeze,
        this.endEffectiveTime,
        this.consumeStoreFlag,
        this.consumeStoreId,
        this.consumeStoreNo,
        this.consumeStoreName,
        this.gainTimeFlag,
        this.dateType,
        this.dayLimitQuantity,
        this.typeNo,
        this.discountType,
        this.categoryList,
        this.brandList,
        this.goodsList,
        this.exgoodsList,
        this.consumeStoreList,
        this.useTimeList,
      ];
}

/// 优惠券使用品类
class ElecCouponCategory extends Equatable {
  /// 电子券ID
  String couponId = "";

  /// 电子券代码
  String couponCode = "";

  /// 类别ID
  String categoryId = "";

  /// 类别编码
  String categoryCode = "";

  /// 类别名称
  String categoryName = "";

  /// 类别路径
  String categoryPath = "";

  ElecCouponCategory();

  factory ElecCouponCategory.fromJson(Map<String, dynamic> json) {
    return ElecCouponCategory()
      ..categoryCode = Convert.toStr(json['categoryCode'])
      ..categoryId = Convert.toStr(json['categoryId'])
      ..categoryName = Convert.toStr(json['categoryName'])
      ..categoryPath = Convert.toStr(json['categoryPath'])
      ..couponCode = Convert.toStr(json['couponCode'])
      ..couponId = Convert.toStr(json['couponId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryCode'] = this.categoryCode;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryPath'] = this.categoryPath;
    data['couponCode'] = this.couponCode;
    data['couponId'] = this.couponId;
    return data;
  }

  ///转List集合
  static List<ElecCouponCategory> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponCategory>();
    lists.forEach((map) => result.add(ElecCouponCategory.fromJson(map)));
    return result;
  }

  ///复制新对象
  factory ElecCouponCategory.clone(ElecCouponCategory obj) {
    return ElecCouponCategory()
      ..categoryCode = obj.categoryCode
      ..categoryId = obj.categoryId
      ..categoryName = obj.categoryName
      ..categoryPath = obj.categoryPath
      ..couponCode = obj.couponCode
      ..couponId = obj.couponId;
  }
  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        categoryCode,
        categoryId,
        categoryName,
        categoryPath,
        couponCode,
        couponId,
      ];
}

/// 优惠券使用品类
class ElecCouponBrand extends Equatable {
  /// 电子券ID
  String couponId = "";

  /// 电子券代码
  String couponCode = "";

  /// 品牌ID
  String brandId = "";

  /// 品牌名称
  String brandName = "";

  ElecCouponBrand();

  factory ElecCouponBrand.fromJson(Map<String, dynamic> json) {
    return ElecCouponBrand()
      ..brandId = Convert.toStr(json['brandId'])
      ..brandName = Convert.toStr(json['brandName'])
      ..couponCode = Convert.toStr(json['couponCode'])
      ..couponId = Convert.toStr(json['couponId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['couponCode'] = this.couponCode;
    data['couponId'] = this.couponId;
    return data;
  }

  ///转List集合
  static List<ElecCouponBrand> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponBrand>();
    lists.forEach((map) => result.add(ElecCouponBrand.fromJson(map)));
    return result;
  }

  ///复制新对象
  factory ElecCouponBrand.clone(ElecCouponBrand obj) {
    return ElecCouponBrand()
      ..brandId = obj.brandId
      ..brandName = obj.brandName
      ..couponCode = obj.couponCode
      ..couponId = obj.couponId;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        brandId,
        brandName,
        couponCode,
        couponId,
      ];
}

/// 优惠券可用商品
class ElecCouponGoods extends Equatable {
  /// 电子券ID
  String couponId = "";

  /// 电子券代码
  String couponCode = "";

  /// 商品Id
  String productId = "";

  /// 商品条码
  String productNo = "";

  /// 商品名称
  String productName = "";

  /// 规格Id
  String specId = "";

  /// 规格名称
  String specName = "";

  ElecCouponGoods();

  factory ElecCouponGoods.fromJson(Map<String, dynamic> json) {
    return ElecCouponGoods()
      ..couponCode = Convert.toStr(json['couponCode'])
      ..couponId = Convert.toStr(json['couponId'])
      ..productId = Convert.toStr(json['productId'])
      ..productName = Convert.toStr(json['productName'])
      ..productNo = Convert.toStr(json['productNo'])
      ..specId = Convert.toStr(json['specId'])
      ..specName = Convert.toStr(json['specName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponCode'] = this.couponCode;
    data['couponId'] = this.couponId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productNo'] = this.productNo;
    data['specId'] = this.specId;
    data['specName'] = this.specName;
    return data;
  }

  ///转List集合
  static List<ElecCouponGoods> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponGoods>();
    lists.forEach((map) => result.add(ElecCouponGoods.fromJson(map)));
    return result;
  }

  ///复制新对象
  factory ElecCouponGoods.clone(ElecCouponGoods obj) {
    return ElecCouponGoods()
      ..couponCode = obj.couponCode
      ..couponId = obj.couponId
      ..productId = obj.productId
      ..productName = obj.productName
      ..productNo = obj.productNo
      ..specId = obj.specId
      ..specName = obj.specName;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        couponCode,
        couponId,
        productId,
        productName,
        productNo,
        specId,
        specName,
      ];
}

/// 优惠券可用门店
class ElecCouponStore extends Equatable {
  /// 电子券ID
  String couponId = "";

  /// 电子券代码
  String couponCode = "";

  /// 门店Id
  String storeId = "";

  /// 门店编号
  String storeNo = "";

  /// 门店名称
  String storeName = "";

  ElecCouponStore();

  factory ElecCouponStore.fromJson(Map<String, dynamic> json) {
    return ElecCouponStore()
      ..couponCode = Convert.toStr(json['couponCode'])
      ..couponId = Convert.toStr(json['couponId'])
      ..storeId = Convert.toStr(json['storeId'])
      ..storeName = Convert.toStr(json['storeName'])
      ..storeNo = Convert.toStr(json['storeNo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponCode'] = this.couponCode;
    data['couponId'] = this.couponId;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['storeNo'] = this.storeNo;
    return data;
  }

  ///转List集合
  static List<ElecCouponStore> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponStore>();
    lists.forEach((map) => result.add(ElecCouponStore.fromJson(map)));
    return result;
  }

  ///复制新对象
  factory ElecCouponStore.clone(ElecCouponStore obj) {
    return ElecCouponStore()
      ..couponCode = obj.couponCode
      ..couponId = obj.couponId
      ..storeId = obj.storeId
      ..storeName = obj.storeName
      ..storeNo = obj.storeNo;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        couponCode,
        couponId,
        storeId,
        storeName,
        storeNo,
      ];
}

/// 优惠券可用时段数据说明
class ElecCouponUseTime {
  /// 电子券ID
  String couponId = "";

  /// 电子券代码
  String couponCode = "";

  /// 时段类型(0-每日时段 1-指定时段)
  int limitType = 0;

  /// 星期值,每日时段时有效
  int week = 0;

  /// 开始日期
  String beginDate = "";

  /// 结束日期
  String endDate = "";

  /// 开始时间
  String beginTime = "";

  /// 结束时间
  String endTime = "";

  /// 当前时间
  String currentTime = "";

  ElecCouponUseTime();

  factory ElecCouponUseTime.fromJson(Map<String, dynamic> json) {
    return ElecCouponUseTime()
      ..couponId = Convert.toStr(json['couponId'])
      ..couponCode = Convert.toStr(json['couponCode'])
      ..limitType = Convert.toInt(json['limitType'])
      ..week = Convert.toInt(json['week'])
      ..beginDate = Convert.toStr(json['beginDate'])
      ..endDate = Convert.toStr(json['endDate'])
      ..beginTime = Convert.toStr(json['beginTime'])
      ..endTime = Convert.toStr(json['endTime'])
      ..currentTime = Convert.toStr(json['currentTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponId'] = this.couponId;
    data['couponCode'] = this.couponCode;
    data['limitType'] = this.limitType;
    data['week'] = this.week;
    data['beginDate'] = this.beginDate;
    data['endDate'] = this.endDate;
    data['beginTime'] = this.beginTime;
    data['endTime'] = this.endTime;
    data['currentTime'] = this.currentTime;
    return data;
  }

  ///转List集合
  static List<ElecCouponUseTime> toList(List<Map<String, dynamic>> lists) {
    var result = new List<ElecCouponUseTime>();
    lists.forEach((map) => result.add(ElecCouponUseTime.fromJson(map)));
    return result;
  }

  ///复制新对象
  factory ElecCouponUseTime.clone(ElecCouponUseTime obj) {
    return ElecCouponUseTime()
      ..couponCode = obj.couponCode
      ..couponId = obj.couponId
      ..limitType = obj.limitType
      ..week = obj.week
      ..beginDate = obj.beginDate
      ..endDate = obj.endDate
      ..beginTime = obj.beginTime
      ..endTime = obj.endTime
      ..currentTime = obj.currentTime;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  /// 校验优惠券是否在使用时间内
  bool get checkTime {
    bool result = true;

    var _currentTime = DateTime.parse(this.currentTime);
    if (limitType == 0) {
      // 每日时段
      int currentWeek = _currentTime.weekday;
      if (currentWeek != this.week) {
        return false;
      }
    }
    try {
      var _time = DateUtils.formatDate(_currentTime, format: "HH:mm");
      if (_time.compareTo(this.beginTime) < 0 ||
          _time.compareTo(this.endTime) >= 0) {
        return false;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("校验优惠券是否在使用时间内异常:" + e.toString());

      return false;
    }

    return result;
  }
}
