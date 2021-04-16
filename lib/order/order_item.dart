import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/enums/order_item_join_type.dart';
import 'package:h3_app/enums/order_item_row_type.dart';
import 'package:h3_app/enums/order_row_status.dart';
import 'package:h3_app/enums/order_source_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/order/product_ext.dart';
import 'package:h3_app/utils/cache_manager.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/objectid_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';
import 'package:sprintf/sprintf.dart';

import 'order_item_make.dart';
import 'order_item_pay.dart';
import 'order_item_promotion.dart';
import 'order_object.dart';

@immutable
class OrderItem extends Equatable {
  ///订单ID
  String id = "";

  ///租户编码
  String tenantId = "";

  ///订单Id
  String orderId = "";

  ///订单号
  String tradeNo = "";

  ///行序号
  int orderNo = 0;

  ///行状态
  OrderItemRowType rowType = OrderItemRowType.None;

  /// 商品ID
  String productId = "";

  /// 商品名称
  String productName = "";

  /// 简称
  String shortName = "";

  /// 规格ID
  String specId = "";

  /// 规格名称
  String specName = "";

  ///购物车数量
  double quantity = 0;

  ///原销售价
  double salePrice = 0;

  ///购物车-零售价
  double price = 0;

  ///最低售价
  double minPrice = 0;

  ///商品类型 0-普通商品；1-可拆零商品；2-捆绑商品；3-自动转货
  int productType = 0;

  /// 商品条码
  String barCode = "";

  /// 商品金额小计 = 数量 * 零售价
  double amount = 0;

  /// 商品总金额 = 商品金额小计+做法小计
  double totalAmount = 0;

  ///是否需要称重(0否-1是)
  int weightFlag = 0;

  ///称重计价方式(1、计重 2、计数)
  int weightWay = 1;

  /// 购物车-退数量
  double refundQuantity = 0;

  /// 购物车-退金额
  double refundAmount = 0;

  /// 原订单明细ID
  String orgItemId = "";

  /// 议价原因
  String bargainReason = "";

  /// 最终折后价
  double discountPrice = 0;

  /// 是否为plus价格 0-否 1-是
  int isPlusPrice = 0;

  /// 价格类型 0-零售价 1-会员价 2-plus会员价
  int priceType = 0;

  /// PLUS价格
  double plusPrice = 0;

  /// 会员价
  double vipPrice = 0;

  /// <summary>
  /// 会员价2
  double vipPrice2 = 0;

  /// 会员价3
  double vipPrice3 = 0;

  /// 会员价4
  double vipPrice4 = 0;

  /// 会员价5
  double vipPrice5 = 0;

  /// 外送价
  double otherPrice = 0;

  /// 批发价
  double batchPrice = 0;

  /// 配送价
  double postPrice = 0;

  /// 进价
  double purPrice = 0;

  /// 赠送数量
  double giftQuantity = 0;

  /// 赠送金额
  double giftAmount = 0;

  /// 赠送原因
  String giftReason = "";

  /// 单品做法总数量
  int flavorCount = 0;

  /// 做法/要求加价合计金额
  double flavorAmount = 0;

  /// 做法/要求加价优惠金额
  double flavorDiscountAmount = 0;

  /// 做法/要求加价应收金额
  double flavorReceivableAmount = 0;

  /// 做法/要求描述
  String flavorNames = "";

  /// 商品优惠金额
  double discountAmount = 0;

  /// 商品应收金额 = 小计 - 优惠
  double receivableAmount = 0;

  /// 订单项加入方式
  OrderItemJoinType joinType = OrderItemJoinType.Touch;

  /// 条码金额， 超市条码秤打印的金额码，此金额优先级最高
  double labelAmount = 0;

  /// 总优惠金额 = 商品优惠小计+做法优惠小计
  double totalDiscountAmount = 0;

  /// 总应收金额 = 商品应收小计+做法应收小计
  double totalReceivableAmount = 0;

  /// 分摊的券占用金额
  double shareCouponLeastCost = 0;

  /// 用券金额
  double couponAmount = 0;

  /// 去券后总应收
  double totalReceivableRemoveCouponAmount = 0;

  /// 去券占用金额后总应收
  double totalReceivableRemoveCouponLeastCost = 0;

  /// 支付实收，支付方式中是否实收为是的支付合计
  double realPayAmount = 0;

  /// 商品推荐人ID
  String shareMemberId = "";

  /// 抹零金额
  double malingAmount = 0;

  /// 单品优惠率 = 单品优惠额 / 消费金额，不包含做法
  double discountRate = 0;

  /// 总单品优惠率 = 总优惠额 / 总消费金额
  double totalDiscountRate = 0;

  /// 行记录的创建时间
  String saleDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 行备注
  String remark = "";

  /// 订单项来源
  OrderSource itemSource = OrderSource.CashRegister;

  /// POS编号
  String posNo = "";

  /// 厨打标识
  String chudaFlag = "";

  /// 厨打方案
  String chuda = "";

  /// 已厨打数量
  double chudaQty = 0;

  /// 出品标识
  String chupinFlag = "";

  /// 出品方案
  String chupin = "";

  /// 已出品数量
  double chupinQty = 0;

  /// 厨打标签标识
  String chuDaLabelFlag = "";

  /// 厨打标签方案
  String chuDaLabel = "";

  /// 已厨打标签数量
  double chuDaLabelQty = 0;

  /// 购物车显示-优惠
  double cartDiscount = 0;

  /// 购物车-行下划线
  int underline = 0;

  /// 购物车-组标识
  String group = "";

  /// 购物车-父行
  String parentId = "";

  /// 购物车-是否包含做法
  int flavor = 0;

  /// 购物车-加料方案
  String scheme = "";

  ///道菜ID
  String suitId = "";

  /// 道菜基准数量
  double suitQuantity = 0;

  /// 道菜基准加价
  double suitAddPrice = 0;

  /// 道菜基准加价后的金额
  double suitAmount = 0;

  /// 商品自编码
  String subNo = "";

  /// 商品批次号
  String batchNo = "";

  /// 商品单位ID
  String productUnitId = "";

  /// 商品单位名称
  String productUnitName = "";

  /// 品类ID
  String categoryId = "";

  /// 品类编号
  String categoryNo = "";

  /// 品类名称
  String categoryName = "";

  /// 品牌ID
  String brandId = "";

  /// 品牌名称
  String brandName = "";

  /// 前台打折
  int foreDiscount = 0;

  /// 是否可议价(0否-1是)
  int foreBargain = 0;

  /// 是否积分(0否-1是)
  int pointFlag = 0;

  /// 积分值
  double pointValue = 0;

  /// 前台赠送
  int foreGift = 0;

  /// 能否促销
  int promotionFlag = 0;

  /// 管理库存(0否-1是)
  int stockFlag = 0;

  /// 批次管理库存
  int batchStockFlag = 0;

  /// 打印标签(0否-1是)
  int labelPrintFlag = 0;

  /// 已打印标签数量
  double labelQty = 0;

  /// 进项税
  double purchaseTax = 0;

  /// 销项税
  double saleTax = 0;

  /// 联营扣率
  double lyRate = 0;

  /// 供应商ID
  String supplierId = "";

  /// 供应商名称
  String supplierName = "";

  /// 经销方式
  String managerType = "";

  /// 营业员编码
  String salesCode = "";

  /// 营业员名称
  String salesName = "";

  /// 增加积分
  double addPoint = 0;

  /// 退积分
  double refundPoint = 0;

  /// 优惠描述
  String promotionInfo = "";

  /// 扩展信息1
  String ext1 = "";

  /// 扩展信息2
  String ext2 = "";

  /// 扩展信息3
  String ext3 = "";

  ///创建人
  String createUser = Constants.DEFAULT_CREATE_USER;

  ///创建日期
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///修改人
  String modifyUser = Constants.DEFAULT_MODIFY_USER;

  ///修改日期
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 单品享受的优惠列表
  List<OrderItemPromotion> promotions = <OrderItemPromotion>[];

  /// 做法/要求明细
  List<OrderItemMake> flavors = <OrderItemMake>[];

  ///支付方式分摊明细
  List<OrderItemPay> itemPays = <OrderItemPay>[];

  //商品信息
  ProductExt productExt;

  /// 桌台ID
  String tableId = "";

  /// 桌台编号
  String tableNo = "";

  /// 桌台名称
  String tableName = "";

  ///退单原因
  String refundReason = "";

  ///并台情况下批量增加商品的标识
  String tableBatchTag = "";

  /// 行状态
  OrderRowStatus orderRowStatus = OrderRowStatus.None;

  ///默认构造
  OrderItem();

  ///配合删除单品使用，目前已知copyWith方法对空对象赋值问题
  factory OrderItem.empty() {
    return OrderItem();
  }

  bool get isEmpty => (this.id == null || this.id.isEmpty);

  String get displayName {
    var result = this.productName;
    if (isNotEmpty(this.specName)) {
      result = sprintf("%s[%s]", [this.productName, this.specName]);
    }
    return result;
  }

  factory OrderItem.newOrderItem(
      OrderObject orderObject, ProductExt product, OrderItemJoinType joinType,
      {OrderRowStatus orderRowStatus = OrderRowStatus.None}) {
    return OrderItem()
      //ID
      ..id = IdWorkerUtils.getInstance().generate().toString()
      //租户编码
      ..tenantId = Global.instance.authc?.tenantId
      //订单ID
      ..orderId = orderObject.id
      //订单号
      ..tradeNo = orderObject.tradeNo
      //行序号
      ..orderNo = orderObject.items != null ? orderObject.items.length + 1 : 1
      //默认是普通菜品
      ..rowType = OrderItemRowType.Normal
      //商品ID
      ..productId = product.id
      //商品名称
      ..productName = product.name
      //商品简称
      ..shortName = product.shortName
      //规格ID
      ..specId = product.specId
      //规格名称
      ..specName = product.specName
      //购物车数量
      ..quantity = 0
      //原销售价
      ..salePrice = product.salePrice
      //购物车-零售价
      ..price = product.salePrice
      //最低售价
      ..minPrice = product.minPrice
      //商品类型 0-普通商品；1-可拆零商品；2-捆绑商品；3-自动转货
      ..productType = product.type
      //商品条码
      ..barCode = product.barCode ?? ""
      // 商品金额小计 = 数量 * 零售价
      ..amount = 0
      // 商品总金额 = 商品金额小计+做法小计
      ..totalAmount = 0
      //是否需要称重(0否-1是)
      ..weightFlag = product.weightFlag
      //称重计价方式(1、计重 2、计数)
      ..weightWay = product.weightWay
      // 购物车-退数量
      ..refundQuantity = 0
      //购物车-退金额
      ..refundAmount = 0
      //原订单明细ID
      ..orgItemId = ""
      //议价原因
      ..bargainReason = ""
      //最终折后价
      ..discountPrice = product.salePrice
      //是否为plus价格 0-否 1-是
      ..isPlusPrice = 0
      //价格类型 0-零售价 1-会员价 2-plus会员价
      ..priceType = 0
      //PLUS价格
      ..plusPrice = product.plusPrice
      //会员价
      ..vipPrice = product.vipPrice
      //外送价
      ..otherPrice = product.otherPrice
      //批发价
      ..batchPrice = product.batchPrice
      //配送价
      ..postPrice = product.postPrice
      //进价
      ..purPrice = product.purPrice
      //赠送数量
      ..giftQuantity = 0
      //赠送金额
      ..giftAmount = 0
      //赠送原因
      ..giftReason = ""
      //单品做法总数量
      ..flavorCount = 0
      //做法/要求加价合计金额
      ..flavorAmount = 0
      //做法/要求加价优惠金额
      ..flavorDiscountAmount = 0
      //做法/要求加价应收金额
      ..flavorReceivableAmount = 0
      //做法/要求描述
      ..flavorNames = ""
      //商品优惠金额
      ..discountAmount = 0
      //商品应收金额 = 小计 - 优惠
      ..receivableAmount = 0
      //订单项加入方式
      ..joinType = joinType
      //条码金额， 超市条码秤打印的金额码，此金额优先级最高
      ..labelAmount = 0
      //总优惠金额 = 商品优惠小计+做法优惠小计
      ..totalDiscountAmount = 0
      //总应收金额 = 商品应收小计+做法应收小计
      ..totalReceivableAmount = 0
      //分摊的券占用金额
      ..shareCouponLeastCost = 0
      //用券金额
      ..couponAmount = 0
      //去券后总应收
      ..totalReceivableRemoveCouponAmount = 0
      //去券占用金额后总应收
      ..totalReceivableRemoveCouponLeastCost = 0
      //支付实收，支付方式中是否实收为是的支付合计
      ..realPayAmount = 0
      //商品推荐人ID
      ..shareMemberId = ""
      //抹零金额
      ..malingAmount = 0
      //单品优惠率 = 单品优惠额 / 消费金额，不包含做法
      ..discountRate = 0
      //总单品优惠率 = 总优惠额 / 总消费金额
      ..totalDiscountRate = 0
      //行记录的创建时间
      ..saleDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      //订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      //行备注
      ..remark = ""
      //订单项来源
      ..itemSource = OrderSource.CashRegister
      //POS编号
      ..posNo = Global.instance.authc.posNo
      //厨打标识
      ..chudaFlag = product.chudaFlag
      //厨打方案
      ..chuda = product.chuda ?? ""
      //已厨打数量
      ..chudaQty = 0
      //出品标识
      ..chupinFlag = product.chupinFlag
      //出品方案
      ..chupin = product.chupin ?? ""
      //已出品数量
      ..chupinQty = 0
      //厨打标签标识
      ..chuDaLabelFlag = product.chudaLabelFlag
      //厨打标签方案
      ..chuDaLabel = product.chudaLabel
      //已厨打标签数量
      ..chuDaLabelQty = 0
      //购物车显示-优惠
      ..cartDiscount = 0
      //购物车-行下划线
      ..underline = 1
      //购物车-是否包含做法
      ..flavor = 0
      //购物车-父行
      ..parentId = ""
      //购物车-组标识
      ..group = ""
      //购物车-加料方案
      ..scheme = ""
      //道菜ID
      ..suitId = ""
      //道菜基准加价
      ..suitAddPrice = 0
      //道菜基准数量
      ..suitQuantity = 0
      //道菜基准加价后金额
      ..suitAmount = 0
      //商品自编码
      ..subNo = product.subNo ?? ""
      //商品批次号
      ..batchNo = ""
      //商品单位ID
      ..productUnitId = product.unitId
      //商品单位名称
      ..productUnitName = product.unitName
      //品类ID
      ..categoryId = product.categoryId
      //品类编号
      ..categoryNo = product.categoryNo
      //品类名称
      ..categoryName = product.categoryName
      //品牌ID
      ..brandId = product.brandId
      //品牌名称
      ..brandName = product.brandName
      //前台打折
      ..foreDiscount = product.foreDiscount
      //是否可议价(0否-1是)
      ..foreBargain = product.foreBargain
      //是否积分(0否-1是)
      ..pointFlag = product.pointFlag
      //积分值
      ..pointValue = product.pointValue
      //前台赠送
      ..foreGift = product.foreGift
      //能否促销
      ..promotionFlag = product.promotionFlag
      //管理库存(0否-1是)
      ..stockFlag = product.stockFlag
      //批次管理库存
      ..batchStockFlag = product.batchStockFlag
      //打印标签(0否-1是)
      ..labelPrintFlag = product.labelPrintFlag
      //已打印标签数量
      ..labelQty = 0
      //进项税
      ..purchaseTax = product.purchaseTax
      //销项税
      ..saleTax = product.saleTax
      //联营扣率
      ..lyRate = product.lyRate
      //供应商ID
      ..supplierId = product.supplierId
      //供应商名称
      ..supplierName = product.supplierName
      //经销方式
      ..managerType = product.managerType
      //营业员编码
      ..salesCode = ""
      //营业员名称
      ..salesName = ""
      //增加积分
      ..addPoint = 0
      //退积分
      ..refundPoint = 0
      //优惠描述
      ..promotionInfo = ""
      //扩展信息1
      ..ext1 = ""
      //扩展信息2
      ..ext2 = ""
      //扩展信息3
      ..ext3 = ""
      //创建人
      ..createUser = Global.instance.worker?.no
      //创建日期
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      //修改人
      ..modifyUser = ""
      //创建日期
      ..modifyDate = ""
      //单品享受的优惠列表
      ..promotions = <OrderItemPromotion>[]
      //做法/要求明细
      ..flavors = <OrderItemMake>[]
      //支付方式分摊明细
      ..itemPays = <OrderItemPay>[]
      ..tableId = ""
      ..tableNo = ""
      ..tableName = ""
      ..orderRowStatus = orderRowStatus
      ..refundReason = ""
      ..tableBatchTag = ObjectIdUtils.getInstance().generate()
      //对应的商品信息
      ..productExt = ProductExt.clone(product);
  }

  ///转List集合
  static List<OrderItem> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderItem>();
    lists.forEach((map) => result.add(OrderItem.fromJson(map)));
    return result;
  }

  factory OrderItem.fromJson(Map<String, dynamic> map) {
    OrderItem result = OrderItem()
      //ID
      ..id = Convert.toStr(map["id"])
      //租户编码
      ..tenantId = Convert.toStr(map["tenantId"])
      //订单ID
      ..orderId = Convert.toStr(map["orderId"])
      //订单号
      ..tradeNo = Convert.toStr(map["tradeNo"])
      //行序号
      ..orderNo = Convert.toInt(map["orderNo"])
      //默认是普通菜品
      ..rowType = OrderItemRowType.fromValue(Convert.toStr(map["rowType"]))
      //商品ID
      ..productId = Convert.toStr(map["productId"])
      //商品名称
      ..productName = Convert.toStr(map["productName"])
      //商品简称
      ..shortName = Convert.toStr(map["shortName"])
      //规格ID
      ..specId = Convert.toStr(map["specId"])
      //规格名称
      ..specName = Convert.toStr(map["specName"])
      //购物车数量
      ..quantity = Convert.toDouble(map["quantity"])
      //原销售价
      ..salePrice = Convert.toDouble(map["salePrice"])
      //购物车-零售价
      ..price = Convert.toDouble(map["price"])
      //最低售价
      ..minPrice = Convert.toDouble(map["minPrice"])
      //商品类型 0-普通商品；1-可拆零商品；2-捆绑商品；3-自动转货
      ..productType = Convert.toInt(map["productType"])
      //商品条码
      ..barCode = Convert.toStr(map["barCode"])
      // 商品金额小计 = 数量 * 零售价
      ..amount = Convert.toDouble(map["amount"])
      // 商品总金额 = 商品金额小计+做法小计
      ..totalAmount = Convert.toDouble(map["totalAmount"])
      //是否需要称重(0否-1是)
      ..weightFlag = Convert.toInt(map["weightFlag"])
      //称重计价方式(1、计重 2、计数)
      ..weightWay = Convert.toInt(map["weightWay"])
      // 购物车-退数量
      ..refundQuantity = Convert.toDouble(map["rquantity"])
      //购物车-退金额
      ..refundAmount = Convert.toDouble(map["ramount"])
      //原订单明细ID
      ..orgItemId = Convert.toStr(map["orgItemId"])
      //议价原因
      ..bargainReason = Convert.toStr(map["bargainReason"])
      //最终折后价
      ..discountPrice = Convert.toDouble(map["discountPrice"])
      //是否为plus价格 0-否 1-是
      ..isPlusPrice = Convert.toInt(map["isPlusPrice"])
      //价格类型 0-零售价 1-会员价 2-plus会员价
      ..priceType = Convert.toInt(map["priceType"])
      //PLUS价格
      ..plusPrice = Convert.toDouble(map["plusPrice"])
      //会员价
      ..vipPrice = Convert.toDouble(map["vipPrice"])
      //外送价
      ..otherPrice = Convert.toDouble(map["otherPrice"])
      //批发价
      ..batchPrice = Convert.toDouble(map["batchPrice"])
      //配送价
      ..postPrice = Convert.toDouble(map["postPrice"])
      //进价
      ..purPrice = Convert.toDouble(map["purPrice"])
      //赠送数量
      ..giftQuantity = Convert.toDouble(map["giftQuantity"])
      //赠送金额
      ..giftAmount = Convert.toDouble(map["giftAmount"])
      //赠送原因
      ..giftReason = Convert.toStr(map["giftReason"])
      //单品做法总数量
      ..flavorCount = Convert.toInt(map["flavorCount"])
      //做法/要求加价合计金额
      ..flavorAmount = Convert.toDouble(map["flavorAmount"])
      //做法/要求加价优惠金额
      ..flavorDiscountAmount = Convert.toDouble(map["flavorDiscountAmount"])
      //做法/要求加价应收金额
      ..flavorReceivableAmount = Convert.toDouble(map["flavorReceivableAmount"])
      //做法/要求描述
      ..flavorNames = Convert.toStr(map["flavorNames"])
      //商品优惠金额
      ..discountAmount = Convert.toDouble(map["discountAmount"])
      //商品应收金额 = 小计 - 优惠
      ..receivableAmount = Convert.toDouble(map["receivableAmount"])
      //订单项加入方式
      ..joinType = OrderItemJoinType.fromValue(Convert.toStr(map["joinType"]))
      //条码金额， 超市条码秤打印的金额码，此金额优先级最高
      ..labelAmount = Convert.toDouble(map["labelAmount"])
      //总优惠金额 = 商品优惠小计+做法优惠小计
      ..totalDiscountAmount = Convert.toDouble(map["totalDiscountAmount"])
      //总应收金额 = 商品应收小计+做法应收小计
      ..totalReceivableAmount = Convert.toDouble(map["totalReceivableAmount"])
      //分摊的券占用金额
      ..shareCouponLeastCost = Convert.toDouble(map["shareCouponLeastCost"])
      //用券金额
      ..couponAmount = Convert.toDouble(map["couponAmount"])
      //去券后总应收
      ..totalReceivableRemoveCouponAmount =
          Convert.toDouble(map["totalReceivableRemoveCouponAmount"])
      //去券占用金额后总应收
      ..totalReceivableRemoveCouponLeastCost =
          Convert.toDouble(map["totalReceivableRemoveCouponLeastCost"])
      //支付实收，支付方式中是否实收为是的支付合计
      ..realPayAmount = Convert.toDouble(map["realPayAmount"])
      //商品推荐人ID
      ..shareMemberId = Convert.toStr(map["shareMemberId"])
      //抹零金额
      ..malingAmount = Convert.toDouble(map["malingAmount"])
      //单品优惠率 = 单品优惠额 / 消费金额，不包含做法
      ..discountRate = Convert.toDouble(map["discountRate"])
      //总单品优惠率 = 总优惠额 / 总消费金额
      ..totalDiscountRate = Convert.toDouble(map["totalDiscountRate"])
      //行记录的创建时间
      ..saleDate = Convert.toStr(map["saleDate"])
      //订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
      ..finishDate = Convert.toStr(map["finishDate"])
      //行备注
      ..remark = Convert.toStr(map["remark"])
      //订单项来源
      ..itemSource = OrderSource.fromValue(Convert.toStr(map["itemSource"]))
      //POS编号
      ..posNo = Convert.toStr(map["posNo"])
      //厨打标识
      ..chudaFlag = Convert.toStr(map["chudaFlag"])
      //厨打方案
      ..chuda = Convert.toStr(map["chuda"])
      //已厨打数量
      ..chudaQty = Convert.toDouble(map["chudaQty"])
      //出品标识
      ..chupinFlag = Convert.toStr(map["chupinFlag"])
      //出品方案
      ..chupin = Convert.toStr(map["chupin"])
      //已出品数量
      ..chupinQty = Convert.toDouble(map["chupinQty"])
      //厨打标签标识
      ..chuDaLabelFlag = Convert.toStr(map["chuDaLabelFlag"])
      //厨打标签方案
      ..chuDaLabel = Convert.toStr(map["chuDaLabel"])
      //已厨打标签数量
      ..chuDaLabelQty = Convert.toDouble(map["chuDaLabelQty"])
      //购物车显示-优惠
      ..cartDiscount = Convert.toDouble(map["cartDiscount"])
      //购物车-行下划线
      ..underline = Convert.toInt(map["underline"])
      //购物车-是否包含做法
      ..flavor = Convert.toInt(map["flavor"])
      //购物车-父行
      ..parentId = Convert.toStr(map["parentId"])
      //购物车-组标识
      ..group = Convert.toStr(map["group"])
      //购物车-加料方案
      ..scheme = Convert.toStr(map["scheme"])
      //道菜ID
      ..suitId = Convert.toStr(map["suitId"])
      //道菜基准加价
      ..suitAddPrice = Convert.toDouble(map["suitAddPrice"])
      //道菜基准数量
      ..suitQuantity = Convert.toDouble(map["suitQuantity"])
      //道菜基准加价后金额
      ..suitAmount = Convert.toDouble(map["suitAmount"])
      //商品自编码
      ..subNo = Convert.toStr(map["subNo"])
      //商品批次号
      ..batchNo = Convert.toStr(map["batchNo"])
      //商品单位ID
      ..productUnitId = Convert.toStr(map["productUnitId"])
      //商品单位名称
      ..productUnitName = Convert.toStr(map["productUnitName"])
      //品类ID
      ..categoryId = Convert.toStr(map["categoryId"])
      //品类编号
      ..categoryNo = Convert.toStr(map["categoryNo"])
      //品类名称
      ..categoryName = Convert.toStr(map["categoryName"])
      //品牌ID
      ..brandId = Convert.toStr(map["brandId"])
      //品牌名称
      ..brandName = Convert.toStr(map["brandName"])
      //前台打折
      ..foreDiscount = Convert.toInt(map["foreDiscount"])
      //是否可议价(0否-1是)
      ..foreBargain = Convert.toInt(map["foreBargain"])
      //是否积分(0否-1是)
      ..pointFlag = Convert.toInt(map["pointFlag"])
      //积分值
      ..pointValue = Convert.toDouble(map["pointValue"])
      //前台赠送
      ..foreGift = Convert.toInt(map["foreGift"])
      //能否促销
      ..promotionFlag = Convert.toInt(map["promotionFlag"])
      //管理库存(0否-1是)
      ..stockFlag = Convert.toInt(map["stockFlag"])
      //批次管理库存
      ..batchStockFlag = Convert.toInt(map["batchStockFlag"])
      //打印标签(0否-1是)
      ..labelPrintFlag = Convert.toInt(map["labelPrintFlag"])
      //已打印标签数量
      ..labelQty = Convert.toDouble(map["labelQty"])
      //进项税
      ..purchaseTax = Convert.toDouble(map["purchaseTax"])
      //销项税
      ..saleTax = Convert.toDouble(map["saleTax"])
      //联营扣率
      ..lyRate = Convert.toDouble(map["lyRate"])
      //供应商ID
      ..supplierId = Convert.toStr(map["supplierId"])
      //供应商名称
      ..supplierName = Convert.toStr(map["supplierName"])
      //经销方式
      ..managerType = Convert.toStr(map["managerType"])
      //营业员编码
      ..salesCode = Convert.toStr(map["salesCode"])
      //营业员名称
      ..salesName = Convert.toStr(map["salesName"])
      //增加积分
      ..addPoint = Convert.toDouble(map["addPoint"])
      //退积分
      ..refundPoint = Convert.toDouble(map["refundPoint"])
      //优惠描述
      ..promotionInfo = Convert.toStr(map["promotionInfo"])
      //扩展信息1
      ..ext1 = Convert.toStr(map["ext1"])
      //扩展信息2
      ..ext2 = Convert.toStr(map["ext2"])
      //扩展信息3
      ..ext3 = Convert.toStr(map["ext3"])
      //创建人
      ..createUser = Convert.toStr(map["createUser"])
      //创建日期
      ..createDate = Convert.toStr(map["createDate"])
      //修改人
      ..modifyUser = Convert.toStr(map["modifyUser"])
      //创建日期
      ..modifyDate = Convert.toStr(map["modifyDate"])
      ..tableId = Convert.toStr(map["tableId"])
      ..tableNo = Convert.toStr(map["tableNo"])
      ..tableName = Convert.toStr(map["tableName"])
      ..refundReason = Convert.toStr(map["rreason"])
      ..tableBatchTag = Convert.toStr(map["tableBatchTag"])
      //行状态
      ..orderRowStatus =
          OrderRowStatus.fromValue(Convert.toStr(map["orderRowStatus"]))
      ..promotions = map["promotions"] != null
          ? List<OrderItemPromotion>.from(List<Map<String, dynamic>>.from(
                  map["promotions"] is String
                      ? json.decode(map["promotions"])
                      : map["promotions"])
              .map((x) => OrderItemPromotion.fromJson(x)))
          : <OrderItemPromotion>[];

    var product = ProductExt.clone(
        CacheManager.productExtList.lastWhere((x) => x.id == result.productId));
    result.productExt = product;
    return result;
  }

  factory OrderItem.clone(OrderItem obj) {
    return OrderItem()
      //ID
      ..id = obj.id
      //租户编码
      ..tenantId = obj.tenantId
      //订单ID
      ..orderId = obj.orderId
      //订单号
      ..tradeNo = obj.tradeNo
      //行序号
      ..orderNo = obj.orderNo
      //默认是普通菜品
      ..rowType = obj.rowType
      //商品ID
      ..productId = obj.productId
      //商品名称
      ..productName = obj.productName
      //商品简称
      ..shortName = obj.shortName
      //规格ID
      ..specId = obj.specId
      //规格名称
      ..specName = obj.specName
      //购物车数量
      ..quantity = obj.quantity
      //原销售价
      ..salePrice = obj.salePrice
      //购物车-零售价
      ..price = obj.price
      //最低售价
      ..minPrice = obj.minPrice
      //商品类型 0-普通商品；1-可拆零商品；2-捆绑商品；3-自动转货
      ..productType = obj.productType
      //商品条码
      ..barCode = obj.barCode
      // 商品金额小计 = 数量 * 零售价
      ..amount = obj.amount
      // 商品总金额 = 商品金额小计+做法小计
      ..totalAmount = obj.totalAmount
      //是否需要称重(0否-1是)
      ..weightFlag = obj.weightFlag
      //称重计价方式(1、计重 2、计数)
      ..weightWay = obj.weightWay
      // 购物车-退数量
      ..refundQuantity = obj.refundQuantity
      //购物车-退金额
      ..refundAmount = obj.refundAmount
      //原订单明细ID
      ..orgItemId = obj.orgItemId
      //议价原因
      ..bargainReason = obj.bargainReason
      //最终折后价
      ..discountPrice = obj.discountPrice
      //是否为plus价格 0-否 1-是
      ..isPlusPrice = obj.isPlusPrice
      //价格类型 0-零售价 1-会员价 2-plus会员价
      ..priceType = obj.priceType
      //PLUS价格
      ..plusPrice = obj.plusPrice
      //会员价
      ..vipPrice = obj.vipPrice
      //外送价
      ..otherPrice = obj.otherPrice
      //批发价
      ..batchPrice = obj.batchPrice
      //配送价
      ..postPrice = obj.postPrice
      //进价
      ..purPrice = obj.purPrice
      //赠送数量
      ..giftQuantity = obj.giftQuantity
      //赠送金额
      ..giftAmount = obj.giftAmount
      //赠送原因
      ..giftReason = obj.giftReason
      //单品做法总数量
      ..flavorCount = obj.flavorCount
      //做法/要求加价合计金额
      ..flavorAmount = obj.flavorAmount
      //做法/要求加价优惠金额
      ..flavorDiscountAmount = obj.flavorDiscountAmount
      //做法/要求加价应收金额
      ..flavorReceivableAmount = obj.flavorReceivableAmount
      //做法/要求描述
      ..flavorNames = obj.flavorNames
      //商品优惠金额
      ..discountAmount = obj.discountAmount
      //商品应收金额 = 小计 - 优惠
      ..receivableAmount = obj.receivableAmount
      //订单项加入方式
      ..joinType = obj.joinType
      //条码金额， 超市条码秤打印的金额码，此金额优先级最高
      ..labelAmount = obj.labelAmount
      //总优惠金额 = 商品优惠小计+做法优惠小计
      ..totalDiscountAmount = obj.totalDiscountAmount
      //总应收金额 = 商品应收小计+做法应收小计
      ..totalReceivableAmount = obj.totalReceivableAmount
      //分摊的券占用金额
      ..shareCouponLeastCost = obj.shareCouponLeastCost
      //用券金额
      ..couponAmount = obj.couponAmount
      //去券后总应收
      ..totalReceivableRemoveCouponAmount =
          obj.totalReceivableRemoveCouponAmount
      //去券占用金额后总应收
      ..totalReceivableRemoveCouponLeastCost =
          obj.totalReceivableRemoveCouponLeastCost
      //支付实收，支付方式中是否实收为是的支付合计
      ..realPayAmount = obj.realPayAmount
      //商品推荐人ID
      ..shareMemberId = obj.shareMemberId
      //抹零金额
      ..malingAmount = obj.malingAmount
      //单品优惠率 = 单品优惠额 / 消费金额，不包含做法
      ..discountRate = obj.discountRate
      //总单品优惠率 = 总优惠额 / 总消费金额
      ..totalDiscountRate = obj.totalDiscountRate
      //行记录的创建时间
      ..saleDate = obj.saleDate
      //订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
      ..finishDate = obj.finishDate
      //行备注
      ..remark = obj.remark
      //订单项来源
      ..itemSource = obj.itemSource
      //POS编号
      ..posNo = obj.posNo
      //厨打标识
      ..chudaFlag = obj.chudaFlag
      //厨打方案
      ..chuda = obj.chuda
      //已厨打数量
      ..chudaQty = obj.chudaQty
      //出品标识
      ..chupinFlag = obj.chupinFlag
      //出品方案
      ..chupin = obj.chupin
      //已出品数量
      ..chupinQty = obj.chupinQty
      //厨打标签标识
      ..chuDaLabelFlag = obj.chuDaLabelFlag
      //厨打标签方案
      ..chuDaLabel = obj.chuDaLabel
      //已厨打标签数量
      ..chuDaLabelQty = obj.chuDaLabelQty
      //购物车显示-优惠
      ..cartDiscount = obj.cartDiscount
      //购物车-行下划线
      ..underline = obj.underline
      //购物车-是否包含做法
      ..flavor = obj.flavor
      //购物车-父行
      ..parentId = obj.parentId
      //购物车-组标识
      ..group = obj.group
      //购物车-加料方案
      ..scheme = obj.scheme
      //道菜ID
      ..suitId = obj.suitId
      //道菜基准加价
      ..suitAddPrice = obj.suitAddPrice
      //道菜基准数量
      ..suitQuantity = obj.suitQuantity
      //道菜基准加价后金额
      ..suitAmount = obj.suitAmount
      //商品自编码
      ..subNo = obj.subNo
      //商品批次号
      ..batchNo = obj.batchNo
      //商品单位ID
      ..productUnitId = obj.productUnitId
      //商品单位名称
      ..productUnitName = obj.productUnitName
      //品类ID
      ..categoryId = obj.categoryId
      //品类编号
      ..categoryNo = obj.categoryNo
      //品类名称
      ..categoryName = obj.categoryName
      //品牌ID
      ..brandId = obj.brandId
      //品牌名称
      ..brandName = obj.brandName
      //前台打折
      ..foreDiscount = obj.foreDiscount
      //是否可议价(0否-1是)
      ..foreBargain = obj.foreBargain
      //是否积分(0否-1是)
      ..pointFlag = obj.pointFlag
      //积分值
      ..pointValue = obj.pointValue
      //前台赠送
      ..foreGift = obj.foreGift
      //能否促销
      ..promotionFlag = obj.promotionFlag
      //管理库存(0否-1是)
      ..stockFlag = obj.stockFlag
      //批次管理库存
      ..batchStockFlag = obj.batchStockFlag
      //打印标签(0否-1是)
      ..labelPrintFlag = obj.labelPrintFlag
      //已打印标签数量
      ..labelQty = obj.labelQty
      //进项税
      ..purchaseTax = obj.purchaseTax
      //销项税
      ..saleTax = obj.saleTax
      //联营扣率
      ..lyRate = obj.lyRate
      //供应商ID
      ..supplierId = obj.supplierId
      //供应商名称
      ..supplierName = obj.supplierName
      //经销方式
      ..managerType = obj.managerType
      //营业员编码
      ..salesCode = obj.salesCode
      //营业员名称
      ..salesName = obj.salesName
      //增加积分
      ..addPoint = obj.addPoint
      //退积分
      ..refundPoint = obj.refundPoint
      //优惠描述
      ..promotionInfo = obj.promotionInfo
      //扩展信息1
      ..ext1 = obj.ext1
      //扩展信息2
      ..ext2 = obj.ext2
      //扩展信息3
      ..ext3 = obj.ext3
      //创建人
      ..createUser = obj.createUser
      //创建日期
      ..createDate = obj.createDate
      //修改人
      ..modifyUser = obj.modifyUser
      //创建日期
      ..modifyDate = obj.modifyDate
      //单品享受的优惠列表
      ..promotions =
          obj.promotions.map((item) => OrderItemPromotion.clone(item)).toList()
      //做法/要求明细
      ..flavors = obj.flavors.map((item) => OrderItemMake.clone(item)).toList()
      //支付方式分摊明细
      ..itemPays = obj.itemPays.map((item) => OrderItemPay.clone(item)).toList()
      //商品信息
      ..productExt = obj.productExt
      ..tableId = obj.tableId
      ..tableName = obj.tableName
      ..tableNo = obj.tableNo
      ..orderRowStatus = obj.orderRowStatus
      ..refundReason = obj.refundReason
      ..tableBatchTag = obj.tableBatchTag;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      //ID
      "id": this.id,
      //租户编码
      "tenantId": this.tenantId,
      //订单ID
      "orderId": this.orderId,
      //订单号
      "tradeNo": this.tradeNo,
      //行序号
      "orderNo": this.orderNo,
      //默认是普通菜品
      "rowType": this.rowType.value,
      //商品ID
      "productId": this.productId,
      //商品名称
      "productName": this.productName,
      //商品简称
      "shortName": this.shortName,
      //规格ID
      "specId": this.specId,
      //规格名称
      "specName": this.specName,
      //购物车数量
      "quantity": this.quantity,
      //原销售价
      "salePrice": this.salePrice,
      //购物车-零售价
      "price": this.price,
      //最低售价
      "minPrice": this.minPrice,
      //商品类型 0-普通商品；1-可拆零商品；2-捆绑商品；3-自动转货
      "productType": this.productType,
      //商品条码
      "barCode": this.barCode,
      // 商品金额小计" :  数量 * 零售价
      "amount": this.amount,
      // 商品总金额" :  商品金额小计+做法小计
      "totalAmount": this.totalAmount,
      //是否需要称重(0否-1是)
      "weightFlag": this.weightFlag,
      //称重计价方式(1、计重 2、计数)
      "weightWay": this.weightWay,
      // 购物车-退数量
      "rquantity": this.refundQuantity,
      //购物车-退金额
      "ramount": this.refundAmount,
      //原订单明细ID
      "orgItemId": this.orgItemId,
      //议价原因
      "bargainReason": this.bargainReason,
      //最终折后价
      "discountPrice": this.discountPrice,
      //是否为plus价格 0-否 1-是
      "isPlusPrice": this.isPlusPrice,
      //价格类型 0-零售价 1-会员价 2-plus会员价
      "priceType": this.priceType,
      //PLUS价格
      "plusPrice": this.plusPrice,
      //会员价
      "vipPrice": this.vipPrice,
      //外送价
      "otherPrice": this.otherPrice,
      //批发价
      "batchPrice": this.batchPrice,
      //配送价
      "postPrice": this.postPrice,
      //进价
      "purPrice": this.purPrice,
      //赠送数量
      "giftQuantity": this.giftQuantity,
      //赠送金额
      "giftAmount": this.giftAmount,
      //赠送原因
      "giftReason": this.giftReason,
      //单品做法总数量
      "flavorCount": this.flavorCount,
      //做法/要求加价合计金额
      "flavorAmount": this.flavorAmount,
      //做法/要求加价优惠金额
      "flavorDiscountAmount": this.flavorDiscountAmount,
      //做法/要求加价应收金额
      "flavorReceivableAmount": this.flavorReceivableAmount,
      //做法/要求描述
      "flavorNames": this.flavorNames,
      //商品优惠金额
      "discountAmount": this.discountAmount,
      //商品应收金额" :  小计 - 优惠
      "receivableAmount": this.receivableAmount,
      //订单项加入方式
      "joinType": this.joinType.value,
      //条码金额， 超市条码秤打印的金额码，此金额优先级最高
      "labelAmount": this.labelAmount,
      //总优惠金额" :  商品优惠小计+做法优惠小计
      "totalDiscountAmount": this.totalDiscountAmount,
      //总应收金额" :  商品应收小计+做法应收小计
      "totalReceivableAmount": this.totalReceivableAmount,
      //分摊的券占用金额
      "shareCouponLeastCost": this.shareCouponLeastCost,
      //用券金额
      "couponAmount": this.couponAmount,
      //去券后总应收
      "totalReceivableRemoveCouponAmount":
          this.totalReceivableRemoveCouponAmount,
      //去券占用金额后总应收
      "totalReceivableRemoveCouponLeastCost":
          this.totalReceivableRemoveCouponLeastCost,
      //支付实收，支付方式中是否实收为是的支付合计
      "realPayAmount": this.realPayAmount,
      //商品推荐人ID
      "shareMemberId": this.shareMemberId,
      //抹零金额
      "malingAmount": this.malingAmount,
      //单品优惠率" :  单品优惠额 / 消费金额，不包含做法
      "discountRate": this.discountRate,
      //总单品优惠率" :  总优惠额 / 总消费金额
      "totalDiscountRate": this.totalDiscountRate,
      //行记录的创建时间
      "saleDate": this.saleDate,
      //订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
      "finishDate": this.finishDate,
      //行备注
      "remark": this.remark,
      //订单项来源
      "itemSource": this.itemSource.value,
      //POS编号
      "posNo": this.posNo,
      //厨打标识
      "chudaFlag": this.chudaFlag,
      //厨打方案
      "chuda": this.chuda,
      //已厨打数量
      "chudaQty": this.chudaQty,
      //出品标识
      "chupinFlag": this.chupinFlag,
      //出品方案
      "chupin": this.chupin,
      //已出品数量
      "chupinQty": this.chupinQty,
      //厨打标签标识
      "chuDaLabelFlag": this.chuDaLabelFlag,
      //厨打标签方案
      "chuDaLabel": this.chuDaLabel,
      //已厨打标签数量
      "chuDaLabelQty": this.chuDaLabelQty,
      //购物车显示-优惠
      "cartDiscount": this.cartDiscount,
      //购物车-行下划线
      "underline": this.underline,
      //购物车-是否包含做法
      "flavor": this.flavor,
      //购物车-父行
      "parentId": this.parentId,
      //购物车-组标识
      "group": this.group,
      //购物车-加料方案
      "scheme": this.scheme,
      //道菜ID
      "suitId": this.suitId,
      //道菜基准加价
      "suitAddPrice": this.suitAddPrice,
      //道菜基准数量
      "suitQuantity": this.suitQuantity,
      //道菜基准加价后金额
      "suitAmount": this.suitAmount,
      //商品自编码
      "subNo": this.subNo,
      //商品批次号
      "batchNo": this.batchNo,
      //商品单位ID
      "productUnitId": this.productUnitId,
      //商品单位名称
      "productUnitName": this.productUnitName,
      //品类ID
      "categoryId": this.categoryId,
      //品类编号
      "categoryNo": this.categoryNo,
      //品类名称
      "categoryName": this.categoryName,
      //品牌ID
      "brandId": this.brandId,
      //品牌名称
      "brandName": this.brandName,
      //前台打折
      "foreDiscount": this.foreDiscount,
      //是否可议价(0否-1是)
      "foreBargain": this.foreBargain,
      //是否积分(0否-1是)
      "pointFlag": this.pointFlag,
      //积分值
      "pointValue": this.pointValue,
      //前台赠送
      "foreGift": this.foreGift,
      //能否促销
      "promotionFlag": this.promotionFlag,
      //管理库存(0否-1是)
      "stockFlag": this.stockFlag,
      //批次管理库存
      "batchStockFlag": this.batchStockFlag,
      //打印标签(0否-1是)
      "labelPrintFlag": this.labelPrintFlag,
      //已打印标签数量
      "labelQty": this.labelQty,
      //进项税
      "purchaseTax": this.purchaseTax,
      //销项税
      "saleTax": this.saleTax,
      //联营扣率
      "lyRate": this.lyRate,
      //供应商ID
      "supplierId": this.supplierId,
      //供应商名称
      "supplierName": this.supplierName,
      //经销方式
      "managerType": this.managerType,
      //营业员编码
      "salesCode": this.salesCode,
      //营业员名称
      "salesName": this.salesName,
      //增加积分
      "addPoint": this.addPoint,
      //退积分
      "refundPoint": this.refundPoint,
      //优惠描述
      "promotionInfo": this.promotionInfo,
      //扩展信息1
      "ext1": this.ext1,
      //扩展信息2
      "ext2": this.ext2,
      //扩展信息3
      "ext3": this.ext3,
      //创建人
      "createUser": this.createUser,
      //创建日期
      "createDate": this.createDate,
      //修改人
      "modifyUser": this.modifyUser,
      //创建日期
      "modifyDate": this.modifyDate,
      //单品享受的优惠列表
      "promotions": this.promotions, //.toString(),
      //做法/要求明细
      "flavors": this.flavors, //.toString(),
      //支付方式分摊明细
      "itemPays": this.itemPays, //.toString(),
      "tableId": this.tableId,
      "tableNo": this.tableNo,
      "tableName": this.tableName,
      "orderRowStatus": this.orderRowStatus.value,
      "rreason": this.refundReason,
      "tableBatchTag": this.tableBatchTag,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.id,
        this.tenantId,
        this.orderId,
        this.tradeNo,
        this.orderNo,
        this.rowType,
        this.productId,
        this.productName,
        this.shortName,
        this.specId,
        this.specName,
        this.quantity,
        this.salePrice,
        this.price,
        this.minPrice,
        this.productType,
        this.barCode,
        this.amount,
        this.totalAmount,
        this.weightFlag,
        this.weightWay,
        this.refundQuantity,
        this.refundAmount,
        this.orgItemId,
        this.bargainReason,
        this.discountPrice,
        this.isPlusPrice,
        this.plusPrice,
        this.vipPrice,
        this.otherPrice,
        this.batchPrice,
        this.postPrice,
        this.purPrice,
        this.giftQuantity,
        this.giftAmount,
        this.giftReason,
        this.flavorCount,
        this.flavorAmount,
        this.flavorDiscountAmount,
        this.flavorReceivableAmount,
        this.flavorNames,
        this.discountAmount,
        this.receivableAmount,
        this.joinType,
        this.labelAmount,
        this.totalDiscountAmount,
        this.totalReceivableAmount,
        this.shareCouponLeastCost,
        this.couponAmount,
        this.totalReceivableRemoveCouponAmount,
        this.totalReceivableRemoveCouponLeastCost,
        this.realPayAmount,
        this.shareMemberId,
        this.malingAmount,
        this.discountRate,
        this.totalDiscountRate,
        this.saleDate,
        this.finishDate,
        this.remark,
        this.itemSource,
        this.posNo,
        this.chudaFlag,
        this.chuda,
        this.chudaQty,
        this.chupinFlag,
        this.chupin,
        this.chupinQty,
        this.chuDaLabelFlag,
        this.chuDaLabel,
        this.chuDaLabelQty,
        this.cartDiscount,
        this.underline,
        this.flavor,
        this.parentId,
        this.group,
        this.scheme,
        this.suitId,
        this.suitAddPrice,
        this.suitQuantity,
        this.suitAmount,
        this.subNo,
        this.batchNo,
        this.productUnitId,
        this.productUnitName,
        this.categoryId,
        this.categoryNo,
        this.categoryName,
        this.brandId,
        this.brandName,
        this.foreDiscount,
        this.foreBargain,
        this.pointFlag,
        this.pointValue,
        this.foreGift,
        this.promotionFlag,
        this.stockFlag,
        this.batchStockFlag,
        this.labelPrintFlag,
        this.labelQty,
        this.purchaseTax,
        this.saleTax,
        this.lyRate,
        this.supplierId,
        this.supplierName,
        this.managerType,
        this.salesCode,
        this.salesName,
        this.addPoint,
        this.refundPoint,
        this.ext1,
        this.ext2,
        this.ext3,
        this.createUser,
        this.createDate,
        this.modifyUser,
        this.modifyDate,
        this.promotions,
        this.flavors,
        this.itemPays,
        this.productExt,
        this.tableId,
        this.tableNo,
        this.tableName,
        this.orderRowStatus,
        this.refundReason,
        this.tableBatchTag,
      ];
}
