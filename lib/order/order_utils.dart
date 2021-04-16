import 'dart:collection';
import 'dart:convert';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/pos_advert_picture.dart';
import 'package:h3_app/entity/pos_base_parameter.dart';
import 'package:h3_app/entity/pos_config.dart';
import 'package:h3_app/entity/pos_make_info.dart';
import 'package:h3_app/entity/pos_module.dart';
import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/entity/pos_payment_group_parameter.dart';
import 'package:h3_app/entity/pos_payment_parameter.dart';
import 'package:h3_app/entity/pos_print_img.dart';
import 'package:h3_app/entity/pos_product.dart';
import 'package:h3_app/entity/pos_product_category.dart';
import 'package:h3_app/entity/pos_product_make.dart';
import 'package:h3_app/entity/pos_product_spec.dart';
import 'package:h3_app/entity/pos_store_make.dart';
import 'package:h3_app/enums/cashier_action_type.dart';
import 'package:h3_app/enums/maling_enum.dart';
import 'package:h3_app/enums/online_pay_bus_type_enum.dart';
import 'package:h3_app/enums/order_item_join_type.dart';
import 'package:h3_app/enums/order_item_row_type.dart';
import 'package:h3_app/enums/order_payment_status_type.dart';
import 'package:h3_app/enums/order_refund_status.dart';
import 'package:h3_app/enums/order_source_type.dart';
import 'package:h3_app/enums/order_status_type.dart';
import 'package:h3_app/enums/order_table_action.dart';
import 'package:h3_app/enums/order_table_status.dart';
import 'package:h3_app/enums/pay_parameter_sign_enum.dart';
import 'package:h3_app/enums/promotion_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/number/decimal.dart';
import 'package:h3_app/number/number.dart';
import 'package:h3_app/order/product_ext.dart';
import 'package:h3_app/order/promotion_utils.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/utils/cache_manager.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/image_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:sprintf/sprintf.dart';

import 'order_item.dart';
import 'order_item_make.dart';
import 'order_item_pay.dart';
import 'order_item_promotion.dart';
import 'order_object.dart';
import 'order_pay.dart';
import 'order_promotion.dart';
import 'order_table.dart';

class OrderUtils {
  // 工厂模式
  factory OrderUtils() => _getInstance();

  static OrderUtils get instance => _getInstance();
  static OrderUtils _instance;

  static OrderUtils _getInstance() {
    if (_instance == null) {
      _instance = new OrderUtils._internal();
    }
    return _instance;
  }

  OrderUtils._internal();

  ///计算单行商品的金额
  void calculateOrderItem(OrderItem master, {bool allOrder = false}) {
    //是否有退菜
    bool isRefund = master.refundQuantity > 0;
    //退菜品金额小计 = 退数量 *  售价
    master.refundAmount =
        OrderUtils.instance.toRound(master.refundQuantity * master.price);
    //如果退数量和点单数量相等，说明全退，需要删除全部优惠
    if (isRefund) {
      if (master.refundQuantity == master.quantity) {
        //全部退操作后，默认赠送数量置零
        master.giftQuantity = 0;
        //赠菜金额置零
        master.giftAmount = 0;
        //赠菜原因置空
        master.giftReason = "";

        //刪除全部优惠列表
        if (master.promotions != null) {
          master.promotions.clear();
        }
      } else {
        if ((master.refundQuantity + master.giftQuantity) > master.quantity) {
          //全部退操作后，默认赠送数量置零
          master.giftQuantity = 0;
          //赠菜金额置零
          master.giftAmount = 0;
          //赠菜原因置空
          master.giftReason = "";

          //刪除全部优惠列表
          if (master.promotions != null) {
            master.promotions.removeWhere((x) =>
                x.orderId == master.orderId &&
                x.itemId == master.id &&
                x.promotionType == PromotionType.Gift);
          }
        }
      }
    }

    //有效点单数量 = 数量 - 退量 - 赠量
    var _effectiveQuantity =
        master.quantity - master.refundQuantity - master.giftQuantity;

    //金额小计 = 菜品数量 * 售价。必须放前，后续的促销依赖
    master.amount = OrderUtils.instance.toRound(
        (master.quantity - master.refundQuantity) * master.salePrice,
        precision: 2);
    //价格恢复到原价
    master.price = master.salePrice;
    //初始化
    master.bargainReason = "";

    //是否有赠菜(退货时giftQuantity为负数)
    bool isGift = master.giftQuantity.abs() > 0;
    if (isGift) {
      //刪除全部优惠列表
      master.promotions.clear();

      //输入的赠送数量
      double giftQuantity = master.giftQuantity;
      //选择的赠送原因
      String giftReason = master.giftReason;

      //新增的优惠对象压入单品优惠列表
      OrderItemPromotion promotion = PromotionUtils.instance
          .newOrderItemPromotion(master, PromotionType.Gift);
      master.promotions.add(promotion);
      //按照原销售价格计算优惠
      master.giftAmount =
          OrderUtils.instance.toRound(master.giftQuantity * master.salePrice);
      master.price = 0.0;
      //赠送原因
      promotion.reason = giftReason;
      promotion.bargainPrice = 0.0;
      //优惠金额
      promotion.discountAmount = master.giftAmount;
    } else {
      //赠送数量、金额、优惠重置
      master.giftQuantity = 0;
      master.giftAmount = 0;
      master.giftReason = "";
      if (master.promotions != null &&
          master.promotions.any((x) => x.promotionType == PromotionType.Gift)) {
        master.promotions
            .removeWhere((x) => x.promotionType == PromotionType.Gift);
      }
    }

    //判断订单商品是否采用plus会员价
    if (master.productExt != null) {
      // if (master.productExt.plusFlag && master.promotions.any((x) => x.promotionType == PromotionType.PlusPriceDiscount)) {
      //   master.isPlusPrice = 1;
      // }
    }

    //计算优惠
    if (master.promotions != null && master.promotions.length > 0) {
      master.promotions
          .sort((left, right) => left.createDate.compareTo(right.createDate));
      master.promotions.forEach((item) {
        _calculateItem(master, item);
      });
    }

    // //应用最大优惠
    // var attendPromotions = master.attendPromotions;
    // //开启促销商品允许整单议价时不进行促销价格的比较（只有整单议价时才会去判断，正常情况下都要进行最小值的比较）
    // if (allOrder)
    // {
    //   //参与促销优惠后的商品允许再做整单打折或议价是否启用 0-否，1-是
    //   var allowOrderBargainForPromotion = DataCacheManager.GetLineSalesSetting("allow_order_discount_for_promotioned_product");
    //   if (!string.IsNullOrEmpty(allowOrderBargainForPromotion) && allowOrderBargainForPromotion.Equals("1"))
    //   {
    //     attendPromotions = null;
    //   }
    // }
    // if (attendPromotions != null && attendPromotions.Count > 0)
    // {
    //   var enablePromotion = attendPromotions.FindAll(x => x.Enabled);
    //   if (enablePromotion != null && enablePromotion.Count > 0)
    //   {
    //     var finePromotion = enablePromotion.OrderBy(x => x.BargainPrice).First();
    //     if (finePromotion.BargainPrice < master.Price)
    //     {
    //       //删除其它优惠
    //       master.Promotions = new List<PromotionItem>();
    //       //还原原始售价
    //       master.Price = master.SalePrice;
    //       //议价原因也清空
    //       master.BargainReason = null;
    //       //应用该优惠
    //       CalculateItem(master, finePromotion);
    //     }
    //   }
    // }

    //优先调整做法计价
    if (master.flavors != null &&
        master.rowType != OrderItemRowType.Master &&
        master.rowType != OrderItemRowType.SuitMaster) {
      //做法友好名称
      StringBuffer flavorNames = new StringBuffer();

      for (var x in master.flavors) {
        x.itemQuantity = _effectiveQuantity;
        //做法数量的变更，需要:1、区别是否控制数量；2、主单数量变更对做法数量的影响
        x.quantity = x.baseQuantity * x.itemQuantity;
        switch (x.qtyFlag) {
          case 1:
            {
              //不加价
              x.amount = 0;
            }
            break;
          case 2:
            {
              //固定加价
              x.amount = OrderUtils.instance
                  .toRound(x.itemQuantity * x.price, precision: 2);
            }
            break;
          case 3:
            {
              //按数量加价
              x.amount = OrderUtils.instance
                  .toRound(x.quantity * x.price, precision: 2);
            }
            break;
          default:
            {
              //不加价
              x.amount = 0;
            }
            break;
        }
        x.discountAmount = 0.0;
        x.receivableAmount = x.amount - x.discountAmount;

        if (flavorNames.length > 0) {
          flavorNames.write(",");
        }
        flavorNames.write("${x.name}");
        if (x.salePrice > 0) {
          flavorNames.write(
              "*¥${OrderUtils.instance.removeDecimalZeroFormat(x.salePrice, precision: 2)}");
        }
        if (x.quantity > 1) {
          flavorNames.write(
              "*${OrderUtils.instance.removeDecimalZeroFormat(x.quantity)}");
        }
      }

      //做法显示的友好名称
      master.flavorNames = flavorNames.toString();
      //做法金额合计
      master.flavorAmount = master.flavors
          .map((e) => e.amount)
          .fold(0, (prev, amount) => prev + amount);
      //做法优惠合计
      master.flavorDiscountAmount = master.flavors
          .map((e) => e.discountAmount)
          .fold(0, (prev, discountAmount) => prev + discountAmount);
      //做法应收合计
      master.flavorReceivableAmount = master.flavors
          .map((e) => e.receivableAmount)
          .fold(0, (prev, receivableAmount) => prev + receivableAmount);
    }

    //行优惠金额
    double discountAmount = 0;
    master.promotions.forEach((item) {
      discountAmount += item.discountAmount;
    });
    master.discountAmount =
        OrderUtils.instance.toRound(discountAmount, precision: 4);

    if (master.joinType == OrderItemJoinType.ScanAmountCode &&
        master.discountAmount == 0) {
      //没有优惠的扫描金额码  原价金额、应用与条码一致
      master.amount = master.labelAmount;
      master.receivableAmount = master.labelAmount;
    } else {
      //行应收金额 = 消费金额 - 退金额master.RefundAmount - 优惠金额
      master.receivableAmount = OrderUtils.instance
          .toRound(master.amount - master.discountAmount, precision: 2);
    }

    // //退货并且扫描金额码的时候，固定的金额需要转化为负数
    // if(master.cashierAction == CashierAction.退货 && master.JoinType == OrderItemJoinType.扫描金额码)
    // {
    //   //加绝对值的原因是无单退货是金额都为正数(无单只修改数量为负数)但是在按单退货是金额为负数(退货界面做得处理)
    //   master.Amount = 0 - Math.Abs(master.LabelAmount);
    //   master.ReceivableAmount = 0 - Math.Abs(master.LabelAmount);
    // }

    //不包含做法的优惠率 = 优惠金额 / 有效消费金额
    master.discountRate = master.amount == 0
        ? 0
        : OrderUtils.instance
            .toRound(master.discountAmount / master.amount, precision: 4);

    //行总金额 = 金额小计 + 做法金额
    master.totalAmount = master.amount + master.flavorAmount;
    //行总优惠金额
    master.totalDiscountAmount =
        master.discountAmount + master.flavorDiscountAmount;
    //行总应收金额
    master.totalReceivableAmount =
        master.receivableAmount + master.flavorReceivableAmount;

    //用券金额
    double couponAmount = 0;
    //券占用金额
    double shareCouponLeastCost = 0;
    //行实收金额
    double realPayAmount = 0;
    master.itemPays.forEach((item) {
      if (item.no == Constants.PAYMODE_CODE_COUPON) {
        couponAmount += item.shareAmount;
        shareCouponLeastCost += item.shareCouponLeastCost;
      }
      if (item.incomeFlag == 1) {
        realPayAmount += item.shareAmount;
      }
    });
    master.couponAmount =
        OrderUtils.instance.toRound(couponAmount, precision: 4);
    //去券后总应收
    master.totalReceivableRemoveCouponAmount =
        master.totalReceivableAmount - master.couponAmount;
    //券占用金额
    master.shareCouponLeastCost =
        OrderUtils.instance.toRound(shareCouponLeastCost, precision: 4);
    //去券占用后总应收
    master.totalReceivableRemoveCouponLeastCost =
        master.totalReceivableAmount - master.shareCouponLeastCost;

    //行支付实收
    master.realPayAmount =
        OrderUtils.instance.toRound(realPayAmount, precision: 4);

    //优惠率
    master.totalDiscountRate = master.totalAmount == 0
        ? 0
        : OrderUtils.instance.toRound(
            master.totalDiscountAmount / master.totalAmount,
            precision: 4);
    //购物车显示优惠金额
    master.cartDiscount = master.totalDiscountAmount;
    //折后价 = 零售价。主要是现在的零售价取代了折后价，打折都直接重算了零售价
    master.discountPrice = master.price;
    //抹零
    double malingAmount = 0;
    if (master.promotions != null && master.promotions.length > 0) {
      malingAmount = master.promotions
          .where((x) => x.promotionType == PromotionType.MalingCostSharing)
          .map((e) => e.discountAmount)
          .fold(0, (prev, discountAmount) => prev + discountAmount);
    }
    master.malingAmount = malingAmount;

    //行优惠友好显示
    StringBuffer promotionInfo = new StringBuffer();
    if (master.promotions != null && master.promotions.length > 0) {
      master.promotions.forEach((m) {
        if (promotionInfo.length > 0) {
          promotionInfo.write(",");
        }
        promotionInfo.write("${m.promotionType.name}${m.discountAmount}元");
      });
    }
    master.promotionInfo = promotionInfo.toString();

    print(">>>>>>优惠描述了>>>${master.promotionInfo}");

    //修改人
    master.modifyUser = Global.instance.worker.no;
    //修改日期
    master.modifyDate =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
  }

  void _calculateItem(OrderItem master, OrderItemPromotion promotion) {
    print(">>>>>>计算优惠>>>${promotion.promotionType.name}");

    switch (promotion.promotionType) {
      case PromotionType.Coupon: //优惠券只代表折扣券
      case PromotionType.OrderDiscount: //整单折扣
      case PromotionType.ProductDiscount: //单品折扣
        {
          //有效数量
          var effectiveQuantity =
              master.quantity - master.giftQuantity - master.refundQuantity;
          FLogger.info(
              "参与折扣的数量<$effectiveQuantity>,折扣率<${promotion.discountRate}>");
          //优惠前的价格、金额  金额用上次优惠后的价格计算
          promotion.amount = OrderUtils.instance
              .toRound(effectiveQuantity * master.price, precision: 2);
          promotion.price = master.price;
          //调整销售价
          master.price = promotion.bargainPrice;
          master.bargainReason = promotion.reason;
          //重算优惠金额 = 有效数量 * 售价 * (1-折扣率)
          promotion.discountAmount = OrderUtils.instance.toRound(
              effectiveQuantity * (promotion.price - promotion.bargainPrice),
              precision: 2);

          //折后应收金额
          promotion.receivableAmount =
              promotion.amount - promotion.discountAmount;

          //操作人
          promotion.modifyUser = Global.instance.worker.no;
          //操作日期
          promotion.modifyDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");
        }
        break;
      case PromotionType.OrderBargain: //整单议价
      case PromotionType.ProductBargain: //单品议价
      case PromotionType.Reduction:
      case PromotionType.OrderReduction:
        {
          //有效数量
          var effectiveQuantity = master.quantity - master.refundQuantity;
          FLogger.info(
              "参与议价的数量<$effectiveQuantity>,议价金额<${promotion.bargainPrice}>");

          //优惠前的价格、金额  金额用上次优惠后的价格计算
          promotion.amount =
              OrderUtils.instance.toRound(effectiveQuantity * master.price);
          promotion.price = master.price;
          //调整销售价
          master.price = promotion.bargainPrice;
          master.bargainReason = promotion.reason;

          if (promotion.promotionType == PromotionType.Reduction ||
              promotion.promotionType == PromotionType.OrderReduction) {
            master.bargainReason = "";
          }

          //重算优惠金额 = 有效数量 * (原销售价 - 售价)(原来是master.SalePrice,现在是在促销优惠的基础上对优惠金额进行计算)
          //凑足整单议价或单品议价金额
          promotion.discountAmount = OrderUtils.instance.toRound(
                  effectiveQuantity *
                      (promotion.price - promotion.bargainPrice)) +
              promotion.adjustAmount;
          //重算优惠率
          if (master.salePrice == 0) {
            promotion.discountRate = 0;
          } else {
            promotion.discountRate = OrderUtils.instance.toRound(
                promotion.bargainPrice / master.salePrice,
                precision: 4);
          }

          //折后应收
          promotion.receivableAmount =
              promotion.amount - promotion.discountAmount;

          //操作人
          promotion.modifyUser = Global.instance.worker.no;
          //操作日期
          promotion.modifyDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");
        }
        break;
      case PromotionType.TakeawayFee: //外卖扣费
        {}
        break;
      case PromotionType.MemberLevelDiscount: //会员等级优惠
        {}
        break;
      case PromotionType.PlusPriceDiscount: //PLUS会员价优惠
        {}
        break;
      case PromotionType.ProductCostSharing: //捆绑商品分摊
      case PromotionType.SuitCostSharing: //套餐商品分摊
        {}
        break;
      case PromotionType.MalingCostSharing: //抹零分摊
        {}
        break;
      case PromotionType.OnlinePromotion: //线上促销
        {}
        break;
    }
  }

  ///刷新订单行号
  void refreshOrderNo(OrderObject orderObject) {
    ///刷新序号
    int rowIndex = 1;
    orderObject.items.forEach((item) {
      switch (item.rowType) {
        case OrderItemRowType.Detail:
          {
            item.orderNo = rowIndex;
            //捆绑商品，将捆绑商品纳入这里
            var details = orderObject.items
                .where((x) => x.group == item.group && x.parentId == item.id)
                .toList();
            if (details != null && details.length > 0) {
              for (var detail in details) {
                rowIndex++;
                detail.orderNo = rowIndex;
              }
            }
          }
          break;
        case OrderItemRowType.Normal:
          {
            item.orderNo = rowIndex;
          }
          break;
      }

      rowIndex++;
    });

    orderObject.items.sortBy((x) => x.orderNo);
  }

  void calculateTable(OrderObject orderObject, OrderTable table) {
    //桌台的商品清单1)当前桌

    //整单的数量合计(当非称重商品可以输入小数时，向上取整作为数量的合计)
    double unWeightCount = orderObject.items
        .where((item) =>
            item.tableId == table.tableId &&
            item.rowType != OrderItemRowType.Detail &&
            item.rowType != OrderItemRowType.SuitDetail &&
            item.weightFlag == 0)
        .map((e) => e.quantity)
        .fold(0, (prev, quantity) => prev + quantity);
    double weightCount = orderObject.items
        .where((item) =>
            item.tableId == table.tableId &&
            item.rowType != OrderItemRowType.Detail &&
            item.rowType != OrderItemRowType.SuitDetail &&
            item.weightFlag == 1)
        .map((e) => e.quantity)
        .fold(0, (prev, quantity) => prev + quantity);

    if (orderObject.cashierAction == CashierAction.Refund) {
      weightCount = 0 - weightCount;
    }
    table.totalQuantity = unWeightCount.ceil() + weightCount;

    //桌台的商品清单列表：2)不包含捆绑明;3)不包含套餐明;
    var tableItems = orderObject.items.where((x) =>
        x.tableId == table.tableId &&
        x.rowType != OrderItemRowType.Detail &&
        x.rowType != OrderItemRowType.SuitDetail);

    //当前桌台的消费总金额 = 其他金额小计 + 当前桌台的数量
    table.totalAmount = tableItems
        .map((e) => e.totalAmount)
        .fold(0, (prev, amount) => prev + amount);
    table.totalRefund = tableItems
        .map((e) => e.refundQuantity)
        .fold(0, (prev, quantity) => prev + quantity);
    table.totalRefundAmount = tableItems
        .map((e) => e.refundAmount)
        .fold(0, (prev, amount) => prev + amount); //
    table.totalGive = tableItems
        .map((e) => e.giftQuantity)
        .fold(0, (prev, quantity) => prev + quantity); //
    table.totalGiveAmount = tableItems
        .map((e) => e.giftAmount)
        .fold(0, (prev, amount) => prev + amount); //.Sum(m => m.GiftAmount);
    table.discountAmount = tableItems.map((e) => e.totalDiscountAmount).fold(
        0, (prev, amount) => prev + amount); //.Sum(m => m.TotalDiscountAmount);
    table.receivableAmount = tableItems
        .map((e) => e.totalReceivableAmount)
        .fold(
            0,
            (prev, amount) =>
                prev + amount); //.Sum(m => m.TotalReceivableAmonut);
    table.paidAmount = table.receivableAmount;

    //2020-12-04 zhangy Add
    for (var t in orderObject.tables) {
      if (t.tableId == table.tableId) {
        t.totalQuantity = table.totalQuantity;
        t.totalAmount = table.totalAmount;
        t.totalRefund = table.totalRefund;
        t.totalRefundAmount = table.totalRefundAmount;
        t.totalGive = table.totalGive;
        t.totalGiveAmount = table.totalGiveAmount;
        t.discountAmount = table.discountAmount;
        t.receivableAmount = table.receivableAmount;
        t.paidAmount = table.receivableAmount;
      }
    }
  }

  ///整单重算
  void calculateOrderObject(OrderObject orderObject) {
    this.calculateChangeAmount(orderObject);

    //整单的数量合计(当非称重商品可以输入小数时，向上取整作为数量的合计)
    double unWeightCount = orderObject.items
        .where((item) =>
            item.rowType != OrderItemRowType.Detail &&
            item.rowType != OrderItemRowType.SuitDetail &&
            item.weightFlag == 0)
        .map((e) => e.quantity)
        .fold(0, (prev, quantity) => prev + quantity);
    double weightCount = orderObject.items
        .where((item) =>
            item.rowType != OrderItemRowType.Detail &&
            item.rowType != OrderItemRowType.SuitDetail &&
            item.weightFlag == 1)
        .map((e) => e.quantity)
        .fold(0, (prev, quantity) => prev + quantity);

    if (orderObject.cashierAction == CashierAction.Refund) {
      weightCount = 0 - weightCount;
    }
    orderObject.totalQuantity = unWeightCount.ceil() + weightCount;

    ///整单消费金额,包含商品+加价
    double totalAmount = 0;
    orderObject.items
        .where((item) =>
            item.rowType != OrderItemRowType.Detail &&
            item.rowType != OrderItemRowType.SuitDetail)
        .forEach((item) {
      totalAmount += item.totalAmount;
    });

    orderObject.amount = OrderUtils.instance.toRound(totalAmount, precision: 2);

    //整单退数量合计
    orderObject.totalRefundQuantity = orderObject.items
        .where((x) =>
            x.rowType != OrderItemRowType.Detail &&
            x.rowType != OrderItemRowType.SuitDetail)
        .map((e) => e.refundQuantity)
        .fold(0, (prev, quantity) => prev + quantity);
    //整单退金额合计
    orderObject.totalRefundAmount = orderObject.items
        .where((x) =>
            x.rowType != OrderItemRowType.Detail &&
            x.rowType != OrderItemRowType.SuitDetail)
        .map((e) => e.refundAmount)
        .fold(0, (prev, amount) => prev + amount);

    //整单赠数量合计
    orderObject.totalGiftQuantity = orderObject.items
        .where((x) =>
            x.rowType != OrderItemRowType.Detail &&
            x.rowType != OrderItemRowType.SuitDetail)
        .map((e) => e.giftQuantity)
        .fold(0, (prev, quantity) => prev + quantity);
    //整单赠金额合计
    orderObject.totalGiftAmount = orderObject.items
        .where((x) =>
            x.rowType != OrderItemRowType.Detail &&
            x.rowType != OrderItemRowType.SuitDetail)
        .map((e) => e.giftAmount)
        .fold(0, (prev, amount) => prev + amount);

    //优惠金额,包含商品+加价  抛去单品分摊的抹零金额
    orderObject.discountAmount = orderObject.items
        .where((x) =>
            x.rowType != OrderItemRowType.Detail &&
            x.rowType != OrderItemRowType.SuitDetail)
        .map((e) => e.totalDiscountAmount)
        .fold(0, (prev, totalDiscountAmount) => prev + totalDiscountAmount);
    //总优惠率,包含商品+加价
    orderObject.discountRate = orderObject.amount == 0
        ? 0
        : OrderUtils.instance.toRound(
            orderObject.discountAmount / orderObject.amount,
            precision: 2);
    //应收金额
    orderObject.receivableAmount = OrderUtils.instance.toRound(
        orderObject.amount +
            orderObject.freightAmount -
            orderObject.discountAmount,
        precision: 2);
    //券后应收
    orderObject.receivableRemoveCouponAmount = orderObject.items
        .map((e) => e.totalReceivableRemoveCouponAmount)
        .fold(
            0,
            (prev, totalReceivableRemoveCouponAmount) =>
                prev + totalReceivableRemoveCouponAmount);
    //溢收
    orderObject.overAmount = orderObject.pays
        .map((e) => e.overAmount)
        .fold(0, (prev, overAmount) => prev + overAmount);
    //支付实收
    orderObject.realPayAmount = orderObject.pays
        .where((x) => x.incomeFlag == 1)
        .map((e) => e.paidAmount)
        .fold(0, (prev, paidAmount) => prev + paidAmount);

    // //plus代金券支付
    // var plusCouponPay = orderObject.Pays.FindAll(x => x.No == Constant.PAYMODE_CODE_COUPON && x.SourceSign == CouponSourceSignEnum.plus.ToString()).Sum(x => x.PaidAmount);
    // //plus折扣券优惠
    // var plusDiscountAmount = orderObject.Promotions.FindAll(x => !string.IsNullOrEmpty(x.CouponId) && x.SourceSign == CouponSourceSignEnum.plus.ToString()).Sum(x => x.DiscountAmount);
    // //plus商品
    // var plusPriceAmount = orderObject.Items.FindAll(x => x.IsPlusPrice == 1).Sum(y => y.Promotions.FindAll(z => z.PromotionType == PromotionType.PLUS会员价优惠).Sum(z => z.DiscountAmount));
    //
    // //plus优惠金额
    // orderObject.PlusDiscountAmount = DecimalUtils.ToRound(plusCouponPay + plusDiscountAmount + plusPriceAmount, 2);

    //抹零是支付方式
    if (orderObject.cashierAction == CashierAction.Refund) {
      //按单退货按照当时支付金额退款，抹零直接取支付分摊
      if (StringUtils.isNotBlank(orderObject.orgTradeNo)) {
        //按原单退，取支付方式抹零合计
        orderObject.malingAmount = orderObject.pays == null
            ? 0.0
            : orderObject.pays
                .where((x) => x.no == Constants.PAYMODE_CODE_MALING)
                .map((e) => e.paidAmount)
                .fold(0, (prev, paidAmount) => prev + paidAmount);
      } else {
        //无单退货
        orderObject.malingAmount = 0 -
            OrderUtils.instance
                .calculateMaling(orderObject.receivableAmount.abs());
      }
    } else {
      //网店下单没有抹零金额
      if (orderObject.orderSource == OrderSource.OnlineStore) {
        orderObject.malingAmount = 0;
      } else {
        orderObject.malingAmount =
            OrderUtils.instance.calculateMaling(orderObject.receivableAmount);
      }
    }

    //抹零和(结账时，以下支付方式为实款实收：微信、支付宝、储值卡、银行卡、扫码付)开关都开启的情况下，如果支付方式中存在这些支付方式，均不计算抹零
    if (Global.instance.payRealAmount() &&
        orderObject.pays.any((x) =>
            x.no == Constants.PAYMODE_CODE_ALIPAY ||
            x.no == Constants.PAYMODE_CODE_WEIXIN ||
            x.no == Constants.PAYMODE_CODE_YUNSHANFU ||
            x.no == Constants.PAYMODE_CODE_SCANPAY ||
            x.no == Constants.PAYMODE_CODE_CARD ||
            x.no == Constants.PAYMODE_CODE_BANK)) {
      orderObject.malingAmount = 0.0;
      //订单实款实收标识
      orderObject.payRealAmountFlag = true;
    } else {
      orderObject.payRealAmountFlag = false;
    }

    //已收金额，各种支付明细的实收金额合计
    orderObject.receivedAmount = (orderObject.pays == null
        ? 0
        : orderObject.pays
            .map((e) => e.paidAmount)
            .fold(0, (prev, paidAmount) => prev + paidAmount));

    if (orderObject.orderSource == OrderSource.MeituanTakeout) {
      //外卖特殊处理，实收金额等于已收金额，避免外卖平台转商品优惠，导致的商品金额加起来不等于外卖收款金额(我们会进行价格*数量，反算单品金额，会导致单品金额加起来不等于收款金额)
      orderObject.paidAmount = orderObject.receivedAmount;
    } else {
      //实收金额 = 应收金额 - 抹零金额
      orderObject.paidAmount =
          orderObject.receivableAmount - orderObject.malingAmount;
    }

    //找零金额
    var cashPayList =
        orderObject.pays.where((x) => x.no == Constants.PAYMODE_CODE_CASH);
    if (cashPayList.length == 0) {
      orderObject.changeAmount = 0;
    } else {
      orderObject.changeAmount = cashPayList
          .map((e) => e.changeAmount)
          .fold(0, (prev, changeAmount) => prev + changeAmount);
    }

    var unreceivableAmount =
        orderObject.receivableAmount - orderObject.receivedAmount;
    orderObject.unreceivableAmount = OrderUtils.instance
        .toRound(unreceivableAmount > 0 ? unreceivableAmount : 0, precision: 2);
    orderObject.payCount = orderObject.pays.length;
    orderObject.itemCount = orderObject.items.length;

    //会员
    var member = orderObject.member;
    if (member != null) {
      orderObject.isMember = 1;
      orderObject.memberMobileNo = member.mobile;
      orderObject.memberName = member.name;
      orderObject.memberId = member.id;
      if (member.defaultCard != null) {
        orderObject.memberNo = member.defaultCard.cardNo;
        orderObject.cardFaceNo = member.defaultCard.cardFaceNo;
      } else {
        orderObject.memberNo = null;
        orderObject.cardFaceNo = null;
      }

      //判断是否使用plus会员支付
      orderObject.isPlus = 0; //member.isPlus;
    } else {
      if (orderObject.cashierAction == CashierAction.Cashier) {
        if (orderObject.pays != null && orderObject.pays.length > 0) {
          var pay = orderObject.pays
              .firstWhere((x) => x.no == "02", orElse: () => null);
          if (pay != null) {
            orderObject.cardFaceNo = pay.cardFaceNo;
            orderObject.isMember = 1;
            orderObject.memberMobileNo = pay.memberMobileNo;
            orderObject.memberName = pay.accountName;
            orderObject.memberNo = pay.cardNo;
            orderObject.addPoint = pay.cardChangePoint;
            orderObject.prePoint = pay.cardPrePoint;
            orderObject.aftPoint = pay.cardAftPoint;
            orderObject.aftAmount = pay.cardAftAmount;
            orderObject.changeAmount = pay.changeAmount;
          }
        }

        if (orderObject.isMember == 0) {
          orderObject.memberMobileNo = null;
          orderObject.memberName = null;
          orderObject.memberId = null;
          orderObject.memberNo = null;
          orderObject.cardFaceNo = null;
        }

        //判断是否使用plus会员支付
        orderObject.isPlus = 0;
      }
    }

    //计算桌台数据
  }

  /// 计算找零金额
  void calculateChangeAmount(OrderObject orderObject) {
    ///应收款,实时变化为未收款
    double receivedAmount = 0;

    ///支付实收
    double realPayAmount = 0;

    ///录入金额
    double totalInputAmount = 0;

    orderObject.pays?.forEach((item) {
      receivedAmount += item.paidAmount;
      totalInputAmount += item.inputAmount;
      if (item.incomeFlag == 1) {
        realPayAmount += item.paidAmount;
      }
    });
    orderObject.receivedAmount = receivedAmount;
    orderObject.realPayAmount = realPayAmount;

    ///计算找零金额
    var receivableAmount = orderObject.paidAmount.abs();
    if (totalInputAmount > receivableAmount) {
      orderObject.changeAmount = OrderUtils.instance
          .toRound(totalInputAmount - receivableAmount, precision: 2);
    } else {
      orderObject.changeAmount = 0;
    }
  }

  ///抹零计算
  double calculateMaling(double amount) {
    double result = 0;
    var maling =
        Global.instance.globalConfigBoolValue(ConfigConstant.MALING_ENABLE);
    if (maling) {
      //抹零规则
      var rule =
          Global.instance.globalConfigStringValue(ConfigConstant.MALING_RULE);
      if (StringUtils.isNotBlank(rule)) {
        MalingEnum malingRule = MalingEnum.fromValue(rule);
        result = _calculateMaling(malingRule, amount);
      }
    }

    return result;
  }

  double _calculateMaling(MalingEnum malingRule, double amount,
      {int fractionDigits = 2}) {
    print("抹零前参数配置：${malingRule.value},${malingRule.name},$amount");
    double result = amount;
    switch (malingRule) {
      case MalingEnum.MALING_1: //四舍五入到元:
        {
          //优先四舍五入到元
          result = double.tryParse(amount.toStringAsFixed(0));
          result = result - amount;
        }
        break;
      case MalingEnum.MALING_2: //向下抹零到元:
        {
          // String amountString = "$amount";
          // result = double.tryParse("${amountString.substring(0, (amountString.length - amountString.lastIndexOf(".") - 1))}");
          result = amount ~/ 1 - amount;
        }
        break;
      case MalingEnum.MALING_3: //向上抹零到元:
        {
          result = amount - amount ~/ 1;
          if (result.abs() > 0) {
            //证明包含小数
            result = 1 - result;
          }
        }
        break;
      case MalingEnum.MALING_4: //四舍五入到角:
        {
          result = double.tryParse(amount.toStringAsFixed(1));
          result = result - amount;
        }
        break;
      case MalingEnum.MALING_5: //向下抹零到角:
        {
          result = ((amount * 10) ~/ 1) / 10 - amount;

          // result = amount - Math.Floor(amount * 10) / 10M;
        }
        break;
      case MalingEnum.MALING_6: //向上抹零到角:
        {
          result = amount - ((amount * 10) ~/ 1) / 10;
          if (result.abs() > 0) {
            //证明包含小数
            result = 0.1 - result;
          }

          // result = Math.Floor(amount * 10) / 10M;
          // if (amount > result)
          // {
          // //证明包含小数
          // result += 0.1M;
          // }
          // result = amount - result;
        }
        break;
      case MalingEnum.MALING_7: //向下抹零到5角:
        {
          result = amount.floorToDouble();
          if (amount - result >= 0.5) {
            result = amount - (result + 0.5);
          } else {
            result = amount - result;
          }
        }
        break;
      case MalingEnum.MALING_8: //向上抹零到5角:
        {
          result = amount.floorToDouble();
          if (amount - result > 0.5) {
            result = amount - (result + 1);
          } else {
            result = amount == 0 ? 0 : (amount - (result + 0.5));
          }

          // result = Math.Floor(amount);
          // if (amount - result > 0.5M)
          // {
          // result = amount - (result + 1);
          // }
          // else
          // {
          // //应收金额为0时，返回0
          // if (amount == 0) return decimal.Zero;
          // result = amount - (result + 0.5M);
          // }
        }
        break;
      case MalingEnum.MALING_9: //向下抹零到5元:
        {
          result = amount.floorToDouble();
          if (result % 5 != 0) {
            result -= result % 5;
          }
          result = amount - result;
        }
        break;
      case MalingEnum.MALING_10: //向下抹零到10元:
        {
          result = amount.floorToDouble();
          if (result % 10 != 0) {
            result -= result % 10;
          }
          result = amount - result;

          // result = Math.Floor(amount);
          // if (result % 10 != 0)
          // {
          // result -= result % 10;
          // }
          // result = amount - result;
        }
        break;
      case MalingEnum.MALING_11: //向下抹零到100元:
        {
          result = amount.floorToDouble();
          if (result % 100 != 0) {
            result -= result % 100;
          }
          result = amount - result;
        }
        break;
    }

    result = OrderUtils.instance.toRound(result, precision: fractionDigits);
    print("抹零前后数配置：${malingRule.value},${malingRule.name},$result");
    return result;
  }

  /// 校验订单是否全额付款
  bool checkOrderFullPay(OrderObject orderObject) {
    bool isVerify = false;

    print("校验订单是否全额付款>>${orderObject.cashierAction.name}>>");

    if (orderObject.cashierAction == CashierAction.Cashier) {
      double paidAmount = 0;
      orderObject.pays.forEach((item) {
        paidAmount += item.paidAmount;
      });

      print("校验订单是否全额付款>>${orderObject.paidAmount}>>$paidAmount");

      isVerify = paidAmount >= toRound(orderObject.paidAmount, precision: 2);
    }

    return isVerify;
  }

  ///获取全部支付方式
  Future<List<PayMode>> getPayModeAll() async {
    List<PayMode> result = new List<PayMode>();
    try {
      String sql =
          "select id,tenantId,`no`,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag from pos_pay_mode where frontFlag = 1 and deleteFlag = 0 order by orderNo,no asc;";
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      if (lists != null && lists.length > 0) {
        result = PayMode.toList(lists);
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取支付方式发生异常:" + e.toString());
    }
    return result;
  }

  Future<PayMode> getPayMode(String no) async {
    PayMode result;
    try {
      String sql =
          "select id,tenantId,`no`,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag from pos_pay_mode where frontFlag = 1 and deleteFlag = 0  and `no` = '$no' order by orderNo,no asc;";
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      if (lists != null && lists.length > 0) {
        result = PayMode.fromMap(lists[0]);
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取支付方式<$no>发生异常:" + e.toString());
    }
    return result;
  }

  Future<OrderObject> orderObjectFinished(
      OrderObject orderObject, double inputAmount) async {
    try {
      //默认剩余未付款金额计人民币
      if (inputAmount != 0) {
        //获取现金支付方式
        var chshPayMode =
            await OrderUtils.instance.getPayMode(Constants.PAYMODE_CODE_CASH);

        //构建现金支付方式
        var orderPay = OrderPay.fromPayMode(orderObject, chshPayMode);
        orderPay.orderNo = orderObject.pays.length + 1;

        orderPay.inputAmount = inputAmount;
        orderPay.amount = orderPay.inputAmount;
        orderPay.paidAmount = orderPay.inputAmount;
        orderPay.overAmount = 0;
        orderPay.changeAmount = 0;
        orderPay.platformDiscount = 0;
        orderPay.platformPaid = 0;
        orderPay.payNo = "";

        orderPay.status = OrderPaymentStatus.Paid;
        if (orderPay.no == Constants.PAYMODE_CODE_MALING) {
          orderPay.statusDesc = Constants.PAYMODE_MALING_HAND;
        }
        orderPay.payTime =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

        await addPayment(orderObject, orderPay);
      }

      //支付清单为空
      var isVerify = OrderUtils.instance.checkOrderFullPay(orderObject);
      if (isVerify) {
        //应收款金额为零，这时没有任何支付记录，默认添加金额为零的现金收款
        if (orderObject.pays.length == 0) {
          await addDefaultZeroPay(orderObject);
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("加载本地支付方式数据异常:" + e.toString());
    }

    return Future.value(orderObject);
  }

  Future<void> addDefaultZeroPay(OrderObject orderObject) async {
    //获取现金支付方式
    var chshPayMode =
        await OrderUtils.instance.getPayMode(Constants.PAYMODE_CODE_CASH);

    //构建现金支付方式
    var orderPay = OrderPay.fromPayMode(orderObject, chshPayMode);
    orderPay.orderNo = orderObject.pays.length + 1;

    orderPay.inputAmount = 0;
    orderPay.amount = 0;
    orderPay.paidAmount = 0;
    orderPay.overAmount = 0;
    orderPay.changeAmount = 0;
    orderPay.platformDiscount = 0;
    orderPay.platformPaid = 0;
    orderPay.payNo = "";

    orderPay.status = OrderPaymentStatus.Paid;
    orderPay.payTime =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

    orderObject.pays.add(orderPay);
  }

  //订单添加支付方式
  Future<OrderObject> addPayment(
      OrderObject orderObject, OrderPay orderPay) async {
    if (orderPay.no == Constants.PAYMODE_CODE_CASH) {
      ///已经存在现金支付,将输入金额合并
      var cashPayIndex = orderObject.pays
          .indexWhere((item) => item.no == Constants.PAYMODE_CODE_CASH);
      if (cashPayIndex > -1) {
        var cashPayItem = orderObject.pays[cashPayIndex];
        //将原来的输入金额合并
        cashPayItem.inputAmount += orderPay.inputAmount;
        //重新计算找零
        OrderUtils.instance.calculateChangeAmount(orderObject);

        cashPayItem.changeAmount = orderObject.changeAmount;
        cashPayItem.paidAmount =
            cashPayItem.inputAmount - cashPayItem.changeAmount;
        cashPayItem.amount = cashPayItem.paidAmount;
      } else {
        orderObject.pays.add(orderPay);
      }
    } else {
      orderObject.pays.add(orderPay);
    }

    orderObject.payCount = orderObject.pays.length;

    //整单重算
    OrderUtils.instance.calculateOrderObject(orderObject);

    return orderObject;
  }

  Future<OrderObject> clearPayment(OrderObject orderObject,
      {OrderPay orderPay}) async {
    //清除单个支付方式
    if (orderPay != null) {
      orderObject.pays.removeWhere((item) => item.id == orderPay.id);
    } else {
      //清除全部支付方式
      orderObject.pays.clear();
    }

    orderObject.payCount = orderObject.pays.length;

    //整单重算
    OrderUtils.instance.calculateOrderObject(orderObject);

    return Future.value(orderObject);
  }

  int getMaxValueByLength(int len) {
    int maxVal = 0;
    switch (len) {
      case 1:
        {
          maxVal = 9;
        }
        break;
      case 2:
        {
          maxVal = 99;
        }
        break;
      case 3:
        {
          maxVal = 999;
        }
        break;
      case 4:
        {
          maxVal = 9999;
        }
        break;
      case 5:
      default:
        {
          maxVal = 99999;
        }
        break;
    }

    return maxVal;
  }

  ///并台操作的序号
  Future<Tuple3<bool, String, String>> generateMergeNo({int length = 2}) async {
    bool result = false;
    String message = "本地序号生成失败";
    String mergeNo = "";
    try {
      int val = 0;
      //根据设置的位数获取对应的最大值
      int maxVal = getMaxValueByLength(length);

      bool isNew = false;

      String sql = sprintf(
          "select `id`, `tenantId`, `group`, `keys`, `initValue`, `values`, `createUser`, `createDate`, `modifyUser`, `modifyDate` from pos_config where `group` = '%s' and `keys` = '%s';",
          [ConfigConstant.GROUP_BUSINESS, ConfigConstant.TABLE_MERGE_NO]);
      Config config;
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      if (lists != null && lists.length > 0) {
        config = Config.fromMap(lists[0]);
      }

      if (config != null) {
        var modifyDate = DateTime.parse(config.modifyDate);
        if (modifyDate.difference(DateTime.now()).inDays != 0) {
          val = 0;
        } else {
          val = int.tryParse(config.values);
        }
      } else {
        config = new Config();

        config.id = IdWorkerUtils.getInstance().generate().toString();
        config.tenantId = Global.instance.authc.tenantId;
        config.group = ConfigConstant.GROUP_BUSINESS;
        config.keys = ConfigConstant.TABLE_MERGE_NO;
        config.initValue = "0";
        config.values = "0";
        config.createUser = Constants.DEFAULT_CREATE_USER;
        config.createDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

        isNew = true;
      }

      val++;

      //循环使用
      if (maxVal != 0 && val > maxVal) {
        val = 1;
      }

      config.values = "$val";

      config.modifyUser = Constants.DEFAULT_MODIFY_USER;
      config.modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

      String template =
          "update pos_config set `values`= '%s',modifyUser= '%s',modifyDate= '%s' where `group` = '%s' and `keys` = '%s';";
      String updateSql = sprintf(template, [
        config.values,
        config.modifyUser,
        config.modifyDate,
        config.group,
        config.keys
      ]);

      if (isNew) {
        template =
            "insert into pos_config(id,tenantId,`group`,`keys`,initValue,`values`,createUser,createDate,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')";
        updateSql = sprintf(template, [
          config.id,
          config.tenantId,
          config.group,
          config.keys,
          config.initValue,
          config.values,
          config.createUser,
          config.createDate,
          config.modifyUser,
          config.modifyDate
        ]);
      }

      await database.transaction((txn) async {
        await txn.execute(updateSql);
      });

      mergeNo = config.values;

      result = true;
      message = "生成并台序号成功";
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取并台序号发生异常:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, mergeNo);
  }

  ///收银小票的前缀<1>,格式为YYMMDDHHMM+POS编码+4位流水号
  Future<Tuple3<bool, String, String>> generateTicketNo(
      {int length = 4}) async {
    String serialNumber = "";
    String message = "本地流水号获取失败!!";

    try {
      serialNumber = await _generateSerialNumber(
          length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.TRADE_NO);
      message = "本地流水号获取成功";
      if (serialNumber.isNotEmpty) {
        //日期
        String yyMMddHHmm =
            DateUtils.formatDate(DateTime.now(), format: "yyMMddHHmm");
        String result = sprintf("1%s%s%s",
            [yyMMddHHmm, Global.instance.authc?.posNo, serialNumber]);

        return Tuple3<bool, String, String>(true, message, result);
      } else {
        return Tuple3<bool, String, String>(false, message, "");
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取POS功能模块发生异常:" + e.toString());
    }
  }

  ///支付单PayNo,格式为门店编码+分隔符+订单编号+1位数字
  String generatePayNo(String tradeNo, {String separator = '-'}) {
    var payNo =
        "${Global.instance.authc.storeNo}$separator$tradeNo${Global.instance.getNextPayNoSuffix}";
    //第一次支付保留原始tradeNo，以后自动补1位数字
    if (payNo.endsWith("0")) {
      payNo = payNo.substring(0, payNo.length - 1);
    }
    return payNo;
  }

  /// <summary>
  /// 交班小票的前缀<3>,格式为YYMMDDHHMM+POS编码+4位流水号
  /// </summary>
  /// <returns></returns>
  Future<Tuple3<bool, String, String>> generateShiftNo({int length = 4}) async {
    bool result = false;
    String message = "批次编号获取失败!!";
    String data = "";
    try {
      var shiftNo = await _generateSerialNumber(
          length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.SHIFT_NO);
      data =
          "3${DateUtils.formatDate(DateTime.now(), format: "yyMMddHHmm")}${Global.instance.authc.posNo}$shiftNo";

      result = true;
      message = "交班单号获取成功";
    } catch (e, stack) {
      result = false;
      message = "交班单号获取异常";

      FlutterChain.printError(e, stack);
      FLogger.error("获取交班单号发生异常:" + e.toString());
    }

    return Tuple3<bool, String, String>(result, message, data);
  }

  Future<Tuple3<bool, String, String>> generateBatchNo({int length = 4}) async {
    bool result = false;
    String message = "批次编号获取失败!!";
    String data = "";
    try {
      data = await _generateSerialNumber(
          length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.BATCH_NO);

      if (StringUtils.isNotBlank(data)) {
        result = true;
        message = "批次编号获取成功";
      } else {
        result = false;
      }
    } catch (e, stack) {
      result = false;
      message = "批次编号获取异常";

      FlutterChain.printError(e, stack);
      FLogger.error("获取批次编号发生异常:" + e.toString());
    }

    return Tuple3<bool, String, String>(result, message, data);
  }

  Future<String> _generateSerialNumber(
      int len, String group, String key) async {
    String result = "";
    try {
      String sql = sprintf(
          "select `id`, `tenantId`, `group`, `keys`, `initValue`, `values`, `createUser`, `createDate`, `modifyUser`, `modifyDate` from pos_config where `group` = '%s' and `keys` = '%s';",
          [group, key]);

      int value = 0;
      bool isNew = false;
      Config config;
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        config = Config.fromMap(lists[0]);
      }

      if (config != null) {
        value = Convert.toInt(config.values);
        config.modifyDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
        config.modifyUser = Constants.DEFAULT_MODIFY_USER;

        if (value >= 9999) {
          value = 0;
        }
        isNew = false;
      } else {
        config = new Config();
        config.id = IdWorkerUtils.getInstance().generate().toString();
        config.tenantId = Global.instance.authc?.tenantId;
        config.group = group;
        config.keys = key;
        config.initValue = "0";
        config.createDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
        config.createUser = Constants.DEFAULT_CREATE_USER;

        isNew = true;
      }

      value = value + 1;
      result = value.toString().padLeft(len, '0'); //0003
      config.values = result;

      config.modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
      config.modifyUser = Constants.DEFAULT_CREATE_USER;

      String template =
          "update pos_config set `values`= '%s',modifyUser= '%s',modifyDate= '%s' where `group` = '%s' and `keys` = '%s';";
      String updateSql = sprintf(template, [
        config.values,
        config.modifyUser,
        config.modifyDate,
        config.group,
        config.keys
      ]);

      if (isNew) {
        template =
            "insert into pos_config(id,tenantId,`group`,`keys`,initValue,`values`,createUser,createDate,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')";
        updateSql = sprintf(template, [
          config.id,
          config.tenantId,
          config.group,
          config.keys,
          config.initValue,
          config.values,
          config.createUser,
          config.createDate,
          config.modifyUser,
          config.modifyDate
        ]);
      }

      await database.transaction((txn) async {
        await txn.execute(updateSql);
      });
    } catch (e, stack) {
      result = "";

      FlutterChain.printError(e, stack);
      FLogger.error("生成小票流水号发生异常:" + e.toString());
    }

    return result;
  }

  /// <summary>
  /// 根据扫描码适配支付方式
  ///
  /// 支付宝授权码，25~30开头的长度为16~24位的数字
  ///
  /// 微信授权码 18位纯数字，以10、11、12、13、14、15开头
  ///
  /// 云闪付 62开头
  Future<PayMode> getPayModeByPayCode(String payCode) {
    String result;
    if (StringUtils.isNotBlank(payCode) && payCode.length >= 16) {
      String prefix = payCode.substring(0, 2);

      switch (prefix) {
        case "10":
        case "11":
        case "12":
        case "13":
        case "14":
        case "15":
          {
            //微信
            result = "05";
          }
          break;
        case "25":
        case "26":
        case "27":
        case "28":
        case "29":
        case "30":
          {
            //支付宝
            result = "04";
          }
          break;
        case "62":
          {
            //银联云闪付  09
            result = "09";
          }
          break;
        default:
          result = "";
          break;
      }
    }

    if (StringUtils.isBlank(result)) {
      return null;
    }
    return getPayMode(result);
  }

  Future<Tuple3<bool, String, PaymentParameter>> getPayParameterByPayMode(
      PayMode payMode, OnLinePayBusTypeEnum busType) async {
    bool result = true;
    String message = "执行成功";
    PaymentParameter paymentParameter;

    try {
      //支付宝子商户
      var subalipay = PayParameterSignEnum.SubAlipay.name;
      //微信子商户
      var subwxpay = PayParameterSignEnum.SubWxpay.name;

      //加载门店信息
      var storeInfo = await Global.instance.getStoreInfo();

      //打开数据库
      var database = await SqlUtils.instance.open();

      //获取充值支付参数
      String sql = sprintf(
          "select * from pos_payment_group_parameter where `enabled` = 1 and groupNo = '%s';",
          [storeInfo.groupNo]);
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      List<PaymentGroupParameter> groupParameterList;
      if (lists != null) {
        groupParameterList = PaymentGroupParameter.toList(lists);
      }

      if (groupParameterList != null &&
          groupParameterList.length > 0 &&
          (busType == OnLinePayBusTypeEnum.MemberRecharge)) {
        //获取需要的充值支付参数,优先选择第三方通道，排除了微信和支付宝子商户
        var paymentGroupParameter = groupParameterList.firstWhere(
            (x) =>
                x.localFlag == 0 && x.sign != subalipay && x.sign != subwxpay,
            orElse: null);
        //没有适配到第三方通道，寻找微信和支付宝原生通道
        if (paymentGroupParameter == null) {
          //微信子商户
          if (payMode.no == "05") {
            paymentGroupParameter = groupParameterList
                .firstWhere((x) => x.localFlag == 0 && x.sign == subwxpay);
          }
          // 支付宝子商户
          if (payMode.no == "04") {
            paymentGroupParameter = groupParameterList
                .firstWhere((x) => x.localFlag == 0 && x.sign == subalipay);
          }
        }

        //适配到第三方通道
        if (paymentGroupParameter != null) {
          //将充值支付参数转化为普通的支付参数，用于返回结果
          var exchangeParam = new PaymentParameter();
          exchangeParam.pbody = paymentGroupParameter.pbody;
          exchangeParam.certText = paymentGroupParameter.certText;
          exchangeParam.enabled = paymentGroupParameter.enabled;
          exchangeParam.id = paymentGroupParameter.id;
          exchangeParam.localFlag = paymentGroupParameter.localFlag;
          exchangeParam.no = paymentGroupParameter.no;
          exchangeParam.sign = paymentGroupParameter.sign;
          exchangeParam.storeId = paymentGroupParameter.storeId;
          exchangeParam.tenantId = paymentGroupParameter.tenantId;

          paymentParameter = exchangeParam;
        }
      } else {
        //获取门店消费支付参数
        sql = sprintf(
            "select * from pos_payment_parameter where `enabled` = 1;", []);
        lists = await database.rawQuery(sql);
        List<PaymentParameter> parameterList;
        if (lists != null) {
          parameterList = PaymentParameter.toList(lists);
        }

        if (parameterList != null) {
          //使用总部参数
          paymentParameter = parameterList.firstWhere(
              (x) =>
                  x.localFlag == 0 && x.sign != subalipay && x.sign != subwxpay,
              orElse: null);

          //没有适配到第三方通道，寻找微信和支付宝原生通道
          if (paymentParameter == null) {
            //微信子商户
            if (payMode.no == "05") {
              paymentParameter = parameterList
                  .firstWhere((x) => x.localFlag == 0 && x.sign == subwxpay);
            }
            // 支付宝子商户
            if (payMode.no == "04") {
              paymentParameter = parameterList
                  .firstWhere((x) => x.localFlag == 0 && x.sign == subalipay);
            }
          }
        }
      }

      //没有可用的支付参数
      if (paymentParameter == null) {
        result = false;
        message = "没有配置扫码支付参数";
      }
    } catch (e, stack) {
      result = false;
      message = "加载支付参数异常";

      FlutterChain.printError(e, stack);
      FLogger.error("获取支付参数发生异常:" + e.toString());
    }

    return Tuple3<bool, String, PaymentParameter>(
        result, message, paymentParameter);
  }

  Future<Tuple3<bool, String, PaymentParameter>> getPayParameter(
      PayParameterSignEnum sign, OnLinePayBusTypeEnum busType) async {
    bool result = true;
    String message = "执行成功";
    PaymentParameter paymentParameter;

    try {
      //支付通道的友好名称
      var friendlyName = sign.toFriendlyName();

      //加载门店信息
      var storeInfo = await Global.instance.getStoreInfo();

      //打开数据库
      var database = await SqlUtils.instance.open();

      //获取充值支付参数
      String sql = sprintf(
          "select * from pos_payment_group_parameter where `enabled` = 1 and groupNo = '%s';",
          [storeInfo.groupNo]);
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      List<PaymentGroupParameter> groupParameterList;
      if (lists != null) {
        groupParameterList = PaymentGroupParameter.toList(lists);
      }

      if (groupParameterList != null &&
          groupParameterList.length > 0 &&
          (busType == OnLinePayBusTypeEnum.MemberRecharge)) {
        //获取需要的充值支付参数
        var paymentGroupParameter = groupParameterList.firstWhere(
            (x) => x.localFlag == 0 && x.sign == sign.name,
            orElse: null);

        if (paymentGroupParameter != null) {
          //将充值支付参数转化为普通的支付参数，用于返回结果
          var exchangeParam = new PaymentParameter();
          exchangeParam.pbody = paymentGroupParameter.pbody;
          exchangeParam.certText = paymentGroupParameter.certText;
          exchangeParam.enabled = paymentGroupParameter.enabled;
          exchangeParam.id = paymentGroupParameter.id;
          exchangeParam.localFlag = paymentGroupParameter.localFlag;
          exchangeParam.no = paymentGroupParameter.no;
          exchangeParam.sign = paymentGroupParameter.sign;
          exchangeParam.storeId = paymentGroupParameter.storeId;
          exchangeParam.tenantId = paymentGroupParameter.tenantId;

          paymentParameter = exchangeParam;
        }

        if (paymentParameter != null) {
          result = true;
          message = "";
        } else {
          //未配置
          result = false;
          message = "未配置$friendlyName支付参数";
        }
      } else {
        //获取消费支付参数
        sql = sprintf(
            "select * from pos_payment_parameter where `enabled` = 1;", []);
        lists = await database.rawQuery(sql);
        List<PaymentParameter> parameterList;
        if (lists != null) {
          parameterList = PaymentParameter.toList(lists);
        }

        if (parameterList != null) {
          //使用总部参数
          paymentParameter = parameterList.firstWhere(
              (x) => x.localFlag == 0 && x.sign == sign.name,
              orElse: null);
          if (paymentParameter != null) {
            result = true;
            message = "";
          } else {
            //未配置
            result = false;
            message = "未配置$friendlyName支付参数";
          }
        } else {
          //未配置
          result = false;
          message = "未配置$friendlyName支付参数";
        }
      }
    } catch (e, stack) {
      result = false;
      message = "加载支付参数异常";

      FlutterChain.printError(e, stack);
      FLogger.error("获取支付参数发生异常:" + e.toString());
    }

    return Tuple3<bool, String, PaymentParameter>(
        result, message, paymentParameter);
  }

  //扫码支付的结果构建付款方式
  Future<OrderObject> addOrderPayByScanPayResult(
      OrderObject orderObject, ScanPayResult payResult) async {
    print(">>>>@@@@@@@@>>>支付方式>>$payResult");

    if (payResult != null && payResult.success) {
      var payMode = await OrderUtils.instance.getPayMode(payResult.payType);

      print(">>>>@@@@@@@@>>>支付方式>>$payMode");

      if (payMode != null) {
        OrderPay pay = new OrderPay();
        pay.id = IdWorkerUtils.getInstance().generate().toString();
        pay.tenantId = Global.instance.authc.tenantId;
        pay.tradeNo = orderObject.tradeNo;
        pay.orderId = orderObject.id;
        pay.orderNo = orderObject.pays.length + 1;
        pay.no = payMode.no;
        pay.name = payMode.name;
        pay.amount = payResult.paidAmount;
        pay.inputAmount = 0;
        pay.paidAmount = payResult.paidAmount;
        pay.overAmount = 0.00;
        pay.changeAmount = 0.00;
        pay.platformDiscount = payResult.platformDiscount;
        pay.platformPaid = payResult.platformPaid;
        pay.payNo = payResult.payNo;
        pay.channelNo = payResult.channelNo;
        pay.payChannel = payResult.payChannel;
        pay.voucherNo = payResult.voucherNo;
        pay.status = OrderPaymentStatus.Paid;
        pay.statusDesc = payResult.statusDesc;
        pay.subscribe = payResult.subscribe;
        pay.accountName = payResult.accountName;
        pay.bankType = payResult.bankType;
        pay.payTime =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
        pay.incomeFlag = payMode.incomeFlag;
        pay.pointFlag = payMode.pointFlag;
        pay.shiftId = ""; //结账环节，统一赋值
        pay.shiftNo = ""; //结账环节，统一赋值
        pay.shiftName = ""; //结账环节，统一赋值
        pay.createUser = Global.instance.worker.no;
        pay.createDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

        orderObject.pays.add(pay);
      }
    }

    return orderObject;
  }

  ///获取折扣原因
  Future<List<BaseParameter>> getReason(String code) async {
    List<BaseParameter> result = new List<BaseParameter>();
    try {
      var reasons = await OrderUtils.instance.getBaseParameterList();
      if (reasons != null) {
        //所有大类
        var dataSource =
            reasons.where((item) => StringUtils.isBlank(item.parentId));
        if (dataSource != null) {
          var data = dataSource.lastWhere((item) => item.code == code,
              orElse: () => null);

          if (data != null) {
            result = reasons.where((item) => item.parentId == data.id).toList();
          }
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取折扣原因发生异常:" + e.toString());
    }
    return result;
  }

  ///获取辅助信息列表
  Future<List<BaseParameter>> getBaseParameterList(
      {bool forceRefresh = false}) async {
    List<BaseParameter> result = new List<BaseParameter>();
    try {
      String sql = sprintf(
          "select id,tenantId,parentId,code,name,memo,orderNo,enabled,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_base_parameter; ",
          []);
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      result = BaseParameter.toList(lists);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("加载辅助信息发生异常:" + e.toString());
    }
    return result;
  }

  ///获取商品信息
  Future<ProductExt> getProductExt(String productId) async {
    ProductExt result;
    try {
      String sql = sprintf("""
        select p.`id`, p.`tenantId`, p.`categoryId`, p.`categoryPath`, p.`type`, p.`no`, p.`barCode`, p.`subNo`, p.`otherNo`, p.`name`, p.`english`, p.`rem`, p.`shortName`, p.`unitId`, p.`brandId`, p.`storageType`, p.`storageAddress`, sp.`supplierId`, sp.`managerType`, p.`purchaseControl`, p.`purchaserCycle`, p.`validDays`, p.`productArea`, p.`status`, p.`spNum`, sp.`stockFlag`, p.`quickInventoryFlag`,p.`posSellFlag`, p.`batchStockFlag`, p.`weightFlag`, p.`weightWay`, p.`steelyardCode`, p.`labelPrintFlag`, sp.`foreDiscount`, sp.`foreGift`, p.`promotionFlag`, sp.`branchPrice`, sp.`foreBargain`, p.`returnType`, p.`returnRate`, sp.`pointFlag`, p.`pointValue`, p.`introduction`, p.`purchaseTax`, p.`saleTax`, p.`lyRate`, p.`allCode`, p.`deleteFlag`, p.`allowEditSup`, p.`ext1`, p.`ext2`, p.`ext3`, p.`createUser`, p.`createDate`, p.`modifyUser`, p.`modifyDate`, ps.specification as specName, ps.id as specId,
        pc.name as categoryName, pc.code as categoryNo, pu.name as unitName, pb.name as brandName, sp.batchPrice, sp.batchPrice2, sp.batchPrice3, sp.batchPrice4, sp.batchPrice5, sp.batchPrice6, sp.batchPrice7, sp.batchPrice8, sp.minPrice, sp.otherPrice, sp.postPrice, sp.purPrice, sp.salePrice, sp.vipPrice, sp.vipPrice2, sp.vipPrice3, sp.vipPrice4, sp.vipPrice5, ps.isDefault, ps.purchaseSpec,
        su.name as supplierName, kp.chudaFlag, kp.chuda,kp.chupinFlag, kp.chupin, kp.labelFlag as chudaLabelFlag, kp.labelValue as chudaLabel
	      from pos_product p 
	      inner join pos_product_spec ps on p.id = ps.productId
	      inner join pos_store_product sp on ps.id = sp.specId
	      left join pos_product_unit pu on p.unitId = pu.id
	      left join pos_product_category pc on p.categoryId = pc.id
	      left join pos_product_brand pb on p.brandId = pb.id
	      left join pos_supplier su on sp.supplierId = su.id
	      left join pos_kit_plan_product kp on p.id = kp.productId
	      where sp.status in (1, 2) and ps.deleteFlag = 0 and p.posSellFlag = 1 and p.id = '%s'
	      order by p.categoryId, p.barCode; 
        """, [productId]);

      var database = await SqlUtils.instance.open();
      var lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        result = ProductExt.fromMap(lists[0]);
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取商品信息发生异常:" + e.toString());
    }
    return result;
  }

  ///获取商品多规格信息
  Future<List<ProductSpec>> getProductSpecList(String productId) async {
    List<ProductSpec> result = [];
    try {
      String sql =
          "select * from pos_product_spec where productId = '$productId'";

      var database = await SqlUtils.instance.open();
      var lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        result.addAll(ProductSpec.toList(lists));
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取商品规格发生异常:" + e.toString());
    }
    return result;
  }

  ///获取商品做法信息
  Future<List<MakeInfo>> getProductMakeList(String productId) async {
    List<MakeInfo> result = [];

    //优化从缓存中获取
    if (CacheManager.makeList.containsKey(productId)) {
      result.addAll(CacheManager.makeList[productId]);
      return result;
    }
    //数据库中获取并压入缓存
    try {
      String sql =
          "SELECT m.*, c.type as categoryType, c.isRadio, c.color as categoryColor FROM pos_make_info m LEFT JOIN pos_make_category c ON m.categoryId = c.id WHERE m.deleteFlag = 0 ORDER BY c.orderNo + 0, m.orderNo + 0;";
      var database = await SqlUtils.instance.open();
      //全部做法
      var allMakeMap = await database.rawQuery(sql);

      if (allMakeMap != null && allMakeMap.length > 0) {
        //全部做法的对象
        var dataSource = MakeInfo.toList(allMakeMap);
        //门店做法
        sql = "select * from pos_store_make;";
        var storeMakeMap = await database.rawQuery(sql);
        var storeMakeData = StoreMake.toList(storeMakeMap);

        //商品私有做法
        sql = "select * from pos_product_make where productId = '$productId';";
        var productMakeMap = await database.rawQuery(sql);
        var productMakeData = ProductMake.toList(productMakeMap);

        //优先过滤适合门店的全部做法,如果门店没有关联做法，获取全部公有做法
        List<MakeInfo> storeFilterData;
        if (storeMakeData != null && storeMakeData.length > 0) {
          //取门店关联的做法
          storeFilterData = dataSource
              .where((x) =>
                  x.prvFlag == 0 && storeMakeData.any((y) => y.makeId == x.id))
              .toList();
        } else {
          //取全部公有做法
          storeFilterData = dataSource.where((x) => x.prvFlag == 0).toList();
        }
        //门店做法压入记录集
        storeFilterData.forEach((item) {
          result.add(item);
        });

        if (productMakeData != null && productMakeData.length > 0) {
          var productFilterData = dataSource.where((x) => productMakeData
              .any((y) => y.productId == productId && y.makeId == x.id));

          if (productFilterData != null) {
            result.addAll(productFilterData.toList());
          }
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取商品可用做法发生异常:" + e.toString());
    }

    //去重排序
    result = result.distinctBy((u) => u.id);
    //result.sort((left, right) => left.orderNo.compareTo(right.orderNo));
    List<MakeInfo> productMakeList = [];
    productMakeList.addAll(result.where((x) => x.categoryType == 0));
    productMakeList.addAll(result.where((x) => x.categoryType == 1));

    //将数据库查询的做法压入缓存
    CacheManager.makeList[productId] = productMakeList;

    return productMakeList;
  }

  ///获取选择品类对应的商品列表
  Future<List<ProductExt>> getProductExtList() async {
    List<ProductExt> result = CacheManager.productExtList;

    if (result == null) {
      Map<String, ProductExt> realDic = new Map<String, ProductExt>();
      try {
        String sql = """
        select p.`id`, p.`tenantId`, p.`categoryId`, p.`categoryPath`, p.`type`, p.`no`, p.`barCode`, p.`subNo`, p.`otherNo`, p.`name`, p.`english`, p.`rem`, p.`shortName`, p.`unitId`, p.`brandId`, p.`storageType`, p.`storageAddress`, sp.`supplierId`, sp.`managerType`, p.`purchaseControl`, p.`purchaserCycle`, p.`validDays`, p.`productArea`, p.`status`, p.`spNum`, sp.`stockFlag`, p.`quickInventoryFlag`,p.`posSellFlag`, p.`batchStockFlag`, p.`weightFlag`, p.`weightWay`, p.`steelyardCode`, p.`labelPrintFlag`, sp.`foreDiscount`, sp.`foreGift`, p.`promotionFlag`, sp.`branchPrice`, sp.`foreBargain`, p.`returnType`, p.`returnRate`, sp.`pointFlag`, p.`pointValue`, p.`introduction`, p.`purchaseTax`, p.`saleTax`, p.`lyRate`, p.`allCode`, p.`deleteFlag`, p.`allowEditSup`, p.`ext1`, p.`ext2`, p.`ext3`, p.`createUser`, p.`createDate`, p.`modifyUser`, p.`modifyDate`, ps.specification AS specName, ps.id AS specId,
        pc.name AS categoryName, pc.code AS categoryNo, pu.name AS unitName, pb.name AS brandName, sp.batchPrice, sp.batchPrice2, sp.batchPrice3, sp.batchPrice4, sp.batchPrice5, sp.batchPrice6, sp.batchPrice7, sp.batchPrice8, sp.minPrice, sp.otherPrice, sp.postPrice, sp.purPrice, sp.salePrice, sp.vipPrice, sp.vipPrice2, sp.vipPrice3, sp.vipPrice4, sp.vipPrice5, sp.mallFlag, ps.isDefault, ps.purchaseSpec,
        su.name AS supplierName, kp.chudaFlag, kp.chuda,kp.chupinFlag, kp.chupin, kp.labelFlag AS chudaLabelFlag, kp.labelValue AS chudaLabel, kd.`chuxianFlag`, kd.`chuxian`, kd.`chuxianTime` ,kd.`chupinFlag` AS kdsChupinFlag, kd.`chupin` AS kdsChupin, kd.`chupinTime` AS kdsChupinTime
	      from pos_product p 
	      inner join pos_product_spec ps on p.id = ps.productId 
	      inner join pos_store_product sp on ps.id = sp.specId 
	      left join pos_product_unit pu on p.unitId = pu.id 
	      left join pos_product_category pc on p.categoryId = pc.id 
	      left join pos_product_brand pb on p.brandId = pb.id 
	      left join pos_supplier su on sp.supplierId = su.id 
	      left join pos_kit_plan_product kp on p.id = kp.productId 
        left join pos_kds_plan_product kd ON p.id = kd.productId 
	      where sp.status in (1, 2, 3) and ps.deleteFlag = 0 and p.posSellFlag = 1 
	      order by p.categoryId, p.barCode; 
        """;

        var database = await SqlUtils.instance.open();
        List<Map<String, dynamic>> lists =
            await database.rawQuery(sql.replaceAll("\n", " "));

        var productExtList = ProductExt.toList(lists);

        if (productExtList != null) {
          //数据处理
          for (var ex in productExtList) {
            String productId = ex.id;
            String specId = ex.specId;

            //使用精准匹配，这样特殊处理下
            ex.allCode = ",${ex.allCode},";
            //特价赋值，默认售价
            ex.specialPrice = ex.salePrice;

            //捆绑商品，组装捆绑内容，规定捆绑商品不能使用多规格
            if (ex.type == 2) {
              ///
            } else if (ex.type == 7) {
              //套餐,允许建多规格
            }
            //多规格商品，进行规格合并
            if (ex.spNum >= 1) {
              ProductExt masterProduct;
              var moreSpecs =
                  productExtList.where((x) => x.id == productId).toList();
              if (moreSpecs != null && moreSpecs.length > 0) {
                ProductExt defaultProductSpec;
                if (moreSpecs.any((x) => x.isDefault == 1)) {
                  defaultProductSpec =
                      moreSpecs.lastWhere((x) => x.isDefault == 1);
                } else {
                  defaultProductSpec = moreSpecs[0];
                }

                List<ProductSpec> newMoreSpecList = <ProductSpec>[];
                for (var sp in moreSpecs) {
                  ProductSpec s = ProductSpec()
                    ..id = sp.specId
                    ..tenantId = sp.tenantId
                    ..productId = productId
                    ..specification = sp.specName
                    ..purPrice = sp.purPrice
                    ..salePrice = sp.salePrice
                    ..minPrice = sp.minPrice
                    ..vipPrice = sp.vipPrice
                    ..vipPrice2 = sp.vipPrice2
                    ..vipPrice3 = sp.vipPrice3
                    ..vipPrice4 = sp.vipPrice4
                    ..vipPrice5 = sp.vipPrice5
                    //..plusPrice = sp.plusPrice
                    ..purchaseSpec = sp.purchaseSpec
                    ..postPrice = sp.postPrice
                    ..batchPrice = sp.batchPrice
                    ..otherPrice = sp.otherPrice
                    ..isDefault = sp.isDefault;
                  //..mallFlag = sp.mallFlag;

                  newMoreSpecList.add(s);
                }

                if (newMoreSpecList.length > 0) {
                  //多规格
                  if (defaultProductSpec != null) {
                    //找到默认规格，以此规格作为默认规格
                    defaultProductSpec.specList = newMoreSpecList;
                    masterProduct = defaultProductSpec;
                  } else {
                    //加在当前商品中
                    ex.specList = newMoreSpecList;
                  }
                }
              }

              if (masterProduct == null) {
                realDic[productId] = ex;
              } else {
                realDic[productId] = masterProduct;
              }
            } else {
              //单规格商品，直接组装
              List<ProductSpec> newMoreSpecList = new List<ProductSpec>();
              ProductSpec s = ProductSpec()
                ..id = ex.specId
                ..tenantId = ex.tenantId
                ..productId = productId
                ..specification = ex.specName
                ..purPrice = ex.purPrice
                ..salePrice = ex.salePrice
                ..minPrice = ex.minPrice
                ..vipPrice = ex.vipPrice
                ..vipPrice2 = ex.vipPrice2
                ..vipPrice3 = ex.vipPrice3
                ..vipPrice4 = ex.vipPrice4
                ..vipPrice5 = ex.vipPrice5
                //..plusPrice = ex.plusPrice
                ..purchaseSpec = ex.purchaseSpec
                ..postPrice = ex.postPrice
                ..batchPrice = ex.batchPrice
                ..otherPrice = ex.otherPrice
                ..isDefault = ex.isDefault;

              ///..mallFlag = sp.mallFlag
              newMoreSpecList.add(s);

              ex.specList = newMoreSpecList;

              realDic[productId] = ex;
            }
          }
        }
      } catch (e, stack) {
        FlutterChain.printError(e, stack);
        FLogger.error("获取POS功能模块发生异常:" + e.toString());
      }

      result = realDic.values.toList();
      FLogger.info("数据库中获取商品信息${result.length}条");

      //压入缓存中
      CacheManager.productExtList = result;
    } else {
      FLogger.info("缓存中获取商品信息${result.length}条");
    }

    return result;
  }

  ///下载商品图片信息
  Future<Tuple2<bool, String>> downloadProductImage() async {
    bool result = false;
    String msg = "";

    try {
      String sql = sprintf(
          "select * from pos_product where trim(storageAddress) != ''", []);
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        List<Product> products = Product.toList(lists);
        for (var product in products) {
          String url = product.storageAddress;
          bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
          if (isUrl) {
            String fileName = url.split('/').last;
            if (StringUtils.isNotBlank(fileName)) {
              print(">>>>url:$url");
              await ImageUtils.downloadFiles(url,
                  dir: Constants.PRODUCT_IMAGE_PATH);
            }
          }
        }
      }

      result = true;
      msg = "商品图片下载成功...";
    } catch (e, stack) {
      result = false;
      msg = "下载商品图片出错了";

      FlutterChain.printError(e, stack);
      FLogger.error("下载商品图片异常:" + e.toString());
    }
    return Tuple2<bool, String>(result, msg);
  }

  ///下载副屏图片信息
  Future<Tuple2<bool, String>> downloadViceImage() async {
    bool result = false;
    String msg = "";

    try {
      String sql = sprintf(
          "select * from pos_advert_picture where trim(storageAddress) != ''",
          []);
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        List<AdvertPicture> pictures = AdvertPicture.toList(lists);
        for (var picture in pictures) {
          String url = picture.storageAddress;
          bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
          if (isUrl) {
            String fileName = url.split('/').last;
            if (StringUtils.isNotBlank(fileName)) {
              await ImageUtils.downloadFiles(url,
                  dir: Constants.VICE_IMAGE_PATH);
            }
          }
        }
      }

      result = true;
      msg = "副屏图片下载成功...";
    } catch (e, stack) {
      result = false;
      msg = "下载副屏图片出错了";

      FlutterChain.printError(e, stack);
      FLogger.error("下载副屏图片异常:" + e.toString());
    }
    return Tuple2<bool, String>(result, msg);
  }

  ///下载小票图片信息
  Future<Tuple2<bool, String>> downloadPrinterImage() async {
    bool result = false;
    String msg = "";

    try {
      String sql =
          "select * from pos_print_img where trim(storageAddress) != ''";
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists != null && lists.length > 0) {
        List<PrintImg> imgs = PrintImg.toList(lists);
        for (var img in imgs) {
          String url = img.storageAddress;
          bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
          if (isUrl) {
            String fileName = url.split('/').last;
            if (StringUtils.isNotBlank(fileName)) {
              await ImageUtils.downloadFiles(url,
                  dir: Constants.PRINTER_IMAGE_PATH);
            }
          }
        }
      }

      result = true;
      msg = "小票图片下载成功...";
    } catch (e, stack) {
      result = false;
      msg = "下载小票图片出错了";

      FlutterChain.printError(e, stack);
      FLogger.error("下载小票图片异常:" + e.toString());
    }
    return Tuple2<bool, String>(result, msg);
  }

  /// 分转元
  double fen2YuanByInt(int amount) {
    return amount / 100;
  }

  String yuan2Fen(double amount) {
    return Convert.toInt(amount * 100).toString();
  }

  double toRound(double value, {int precision = 2}) {
    Decimal result = Decimal.fromDouble(value)
        .roundWithPrecision(precision, RoundingMode.nearestFromZero);
    return result.toDouble();
  }

  String removeDecimalZeroFormat(double n, {int precision = 2}) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : precision);
  }

  Future<List<OrderObject>> getUploadOrderObject({int limit = 5}) async {
    List<OrderObject> result = new List<OrderObject>();

    try {
      String orderTemplate =
          "select * from pos_order where orderStatus in(2, 4) and uploadStatus = 0 order by uploadErrors limit %s;";
      String orderSql = sprintf(orderTemplate, [limit]);

      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(orderSql);

      result.addAll(OrderObject.toList(lists));
    } catch (e, stack) {
      FLogger.error("获取待上传订单发生异常:" + e.toString());
    } finally {}
    return result;
  }

  Future<OrderObject> builderOrderObject(String orderId,
      {String tradeNo = ""}) async {
    OrderObject orderObject;
    try {
      //加载主单数据
      String orderTemplate = "select * from pos_order where id = '%s';";
      String orderSql = sprintf(orderTemplate, [orderId]);
      if (StringUtils.isNotBlank(tradeNo)) {
        orderTemplate =
            "select * from pos_order where tradeNo like '%%s' order by saleDate desc;";
        orderSql = sprintf(orderTemplate, [tradeNo]);
      }
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> orderMap = await database.rawQuery(orderSql);
      if (orderMap != null && orderMap.length > 0) {
        orderObject = OrderObject.fromMap(orderMap[0]);
      }

      //订单明细
      List<OrderItem> items = <OrderItem>[];
      //订单支付方式
      List<OrderPay> pays = <OrderPay>[];
      //单品做法
      List<OrderItemMake> flavors = <OrderItemMake>[];
      //单品优惠
      List<OrderItemPromotion> promotionItems = <OrderItemPromotion>[];
      //整单优惠
      List<OrderPromotion> promotionOrders = <OrderPromotion>[];
      //单品分摊的优惠
      List<OrderItemPay> itemPays = <OrderItemPay>[];
      //桌台列表
      List<OrderTable> tables = <OrderTable>[];

      //List<ProductExt> productList = GetPosCanSaleProduct();

      if (orderObject != null) {
        //加载订单明细
        String orderItemTemplate =
            "select * from pos_order_item where orderId = '%s';";
        String orderItemSql = sprintf(orderItemTemplate, [orderId]);

        List<Map<String, dynamic>> orderItemLists =
            await database.rawQuery(orderItemSql);
        if (orderItemLists != null && orderItemLists.length > 0) {
          items.addAll(OrderItem.toList(orderItemLists));
        }

        //加载订单支付列表
        String orderPayTemplate =
            "select * from pos_order_pay where orderId = '%s';";
        String orderPaySql = sprintf(orderPayTemplate, [orderId]);
        List<Map<String, dynamic>> orderPayLists =
            await database.rawQuery(orderPaySql);
        if (orderPayLists != null && orderPayLists.length > 0) {
          pays.addAll(OrderPay.toList(orderPayLists));
        }

        //加载订单优惠
        String orderPromotionTemplate =
            "select * from pos_order_promotion where orderId = '%s';";
        String orderPromotionSql = sprintf(orderPromotionTemplate, [orderId]);
        List<Map<String, dynamic>> orderPromotionLists =
            await database.rawQuery(orderPromotionSql);
        if (orderPromotionLists != null && orderPromotionLists.length > 0) {
          promotionOrders.addAll(OrderPromotion.toList(orderPromotionLists));
        }

        //订单关联的桌台信息
        String orderTableTemplate =
            "select * from pos_order_table where orderId = '%s';";
        String orderTableSql = sprintf(orderTableTemplate, [orderId]);
        List<Map<String, dynamic>> orderTableLists =
            await database.rawQuery(orderTableSql);
        if (orderTableLists != null && orderTableLists.length > 0) {
          tables.addAll(OrderTable.toList(orderTableLists));
        }

        //加载订单明细优惠
        String orderItemPromotionTemplate =
            "select * from pos_order_item_promotion where orderId = '%s';";
        String orderItemPromotionSql =
            sprintf(orderItemPromotionTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemPromotionLists =
            await database.rawQuery(orderItemPromotionSql);
        if (orderItemPromotionLists != null &&
            orderItemPromotionLists.length > 0) {
          promotionItems
              .addAll(OrderItemPromotion.toList(orderItemPromotionLists));
        }

        //加载订单明细做法
        String orderItemMakeTemplate =
            "select * from pos_order_item_make where orderId = '%s';";
        String orderItemMakeSql = sprintf(orderItemMakeTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemMakeLists =
            await database.rawQuery(orderItemMakeSql);
        if (orderItemMakeLists != null && orderItemMakeLists.length > 0) {
          flavors.addAll(OrderItemMake.toList(orderItemMakeLists));
        }

        //加载订单明细分摊支付
        String orderItemPayTemplate =
            "select * from pos_order_item_pay where orderId = '%s';";
        String orderItemPaySql = sprintf(orderItemPayTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemPayLists =
            await database.rawQuery(orderItemPaySql);
        if (orderItemPayLists != null && orderItemPayLists.length > 0) {
          itemPays.addAll(OrderItemPay.toList(orderItemPayLists));
        }

        orderObject.items = items;
        orderObject.pays = pays;
        orderObject.promotions = promotionOrders;
        orderObject.tables = tables;

        for (var item in orderObject.items) {
          //单品做法
          item.flavors = <OrderItemMake>[];
          var _flavors = flavors.where((f) => f.itemId == item.id).toList();
          if (_flavors != null && _flavors.length > 0) {
            item.flavors.addAll(_flavors);
          }

          //单品支付方式分摊
          item.itemPays = <OrderItemPay>[];
          var _pays = itemPays.where((p) => p.itemId == item.id).toList();
          if (_pays != null && _pays.length > 0) {
            item.itemPays.addAll(_pays);
          }
          //单品促销
          item.promotions = <OrderItemPromotion>[];
          var _promotions =
              promotionItems.where((p) => p.itemId == item.id).toList();
          if (_promotions != null && _promotions.length > 0) {
            item.promotions.addAll(_promotions);
          }
          //商品关联的详细信息

        }
      }
    } catch (e, stack) {
      FLogger.error("获取订单发生异常:" + e.toString());
    } finally {
      //await SqlUtils.instance.close();
    }

    return orderObject;
  }

  Future<OrderObject> additionalOrderObject(OrderObject orderObject) async {
    try {
      //订单明细
      List<OrderItem> items = <OrderItem>[];
      //订单支付方式
      List<OrderPay> pays = <OrderPay>[];
      //单品做法
      List<OrderItemMake> flavors = <OrderItemMake>[];
      //单品优惠
      List<OrderItemPromotion> promotionItems = <OrderItemPromotion>[];
      //整单优惠
      List<OrderPromotion> promotionOrders = <OrderPromotion>[];
      //单品分摊的优惠
      List<OrderItemPay> itemPays = <OrderItemPay>[];
      //桌台清单
      List<OrderTable> tables = <OrderTable>[];

      //List<ProductExt> productList = GetPosCanSaleProduct();

      if (orderObject != null) {
        String orderId = orderObject.id;

        var database = await SqlUtils.instance.open();

        //加载订单明细
        String orderItemTemplate =
            "select * from pos_order_item where orderId = '%s';";
        String orderItemSql = sprintf(orderItemTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemLists =
            await database.rawQuery(orderItemSql);
        if (orderItemLists != null && orderItemLists.length > 0) {
          items.addAll(OrderItem.toList(orderItemLists));
        }
        //加载订单支付列表
        String orderPayTemplate =
            "select * from pos_order_pay where orderId = '%s';";
        String orderPaySql = sprintf(orderPayTemplate, [orderId]);
        List<Map<String, dynamic>> orderPayLists =
            await database.rawQuery(orderPaySql);
        if (orderPayLists != null && orderPayLists.length > 0) {
          pays.addAll(OrderPay.toList(orderPayLists));
        }
        //加载订单优惠
        String orderPromotionTemplate =
            "select * from pos_order_promotion where orderId = '%s';";
        String orderPromotionSql = sprintf(orderPromotionTemplate, [orderId]);
        List<Map<String, dynamic>> orderPromotionLists =
            await database.rawQuery(orderPromotionSql);
        if (orderPromotionLists != null && orderPromotionLists.length > 0) {
          promotionOrders.addAll(OrderPromotion.toList(orderPromotionLists));
        }

        //订单关联的桌台信息
        String orderTableTemplate =
            "select * from pos_order_table where orderId = '%s';";
        String orderTableSql = sprintf(orderTableTemplate, [orderId]);
        List<Map<String, dynamic>> orderTableLists =
            await database.rawQuery(orderTableSql);
        if (orderTableLists != null && orderTableLists.length > 0) {
          tables.addAll(OrderTable.toList(orderTableLists));
        }
        orderObject.tables = tables;

        //加载订单明细优惠
        String orderItemPromotionTemplate =
            "select * from pos_order_item_promotion where orderId = '%s';";
        String orderItemPromotionSql =
            sprintf(orderItemPromotionTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemPromotionLists =
            await database.rawQuery(orderItemPromotionSql);
        if (orderItemPromotionLists != null &&
            orderItemPromotionLists.length > 0) {
          promotionItems
              .addAll(OrderItemPromotion.toList(orderItemPromotionLists));
        }

        //加载订单明细做法
        String orderItemMakeTemplate =
            "select * from pos_order_item_make where orderId = '%s';";
        String orderItemMakeSql = sprintf(orderItemMakeTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemMakeLists =
            await database.rawQuery(orderItemMakeSql);
        if (orderItemMakeLists != null && orderItemMakeLists.length > 0) {
          flavors.addAll(OrderItemMake.toList(orderItemMakeLists));
        }

        //加载订单明细分摊支付
        String orderItemPayTemplate =
            "select * from pos_order_item_pay where orderId = '%s';";
        String orderItemPaySql = sprintf(orderItemPayTemplate, [orderId]);
        List<Map<String, dynamic>> orderItemPayLists =
            await database.rawQuery(orderItemPaySql);
        if (orderItemPayLists != null && orderItemPayLists.length > 0) {
          itemPays.addAll(OrderItemPay.toList(orderItemPayLists));
        }

        orderObject.items = items;
        orderObject.pays = pays;
        orderObject.promotions = promotionOrders;

        for (var item in orderObject.items) {
          //单品做法
          item.flavors = <OrderItemMake>[];
          var _flavors = flavors.where((f) => f.itemId == item.id).toList();
          if (_flavors != null && _flavors.length > 0) {
            item.flavors.addAll(_flavors);
          }

          //单品支付方式分摊
          item.itemPays = <OrderItemPay>[];
          var _pays = itemPays.where((p) => p.itemId == item.id).toList();
          if (_pays != null && _pays.length > 0) {
            item.itemPays.addAll(_pays);
          }
          //单品促销
          item.promotions = <OrderItemPromotion>[];
          var _promotions =
              promotionItems.where((p) => p.itemId == item.id).toList();
          if (_promotions != null && _promotions.length > 0) {
            item.promotions.addAll(_promotions);
          }
          //商品关联的详细信息
        }
      }
    } catch (e, stack) {
      FLogger.error("获取订单发生异常:" + e.toString());
    } finally {
      //await SqlUtils.instance.close();
    }

    return orderObject;
  }

  ///更新订单上送状态
  Future<Tuple2<bool, String>> updateUploadStatus(
      Map<String, dynamic> data) async {
    bool result = true;
    String message = "订单上送状态更新成功";
    try {
      //"serverId", "uploadStatus", "uploadCode", "uploadMessage", "uploadErrors", "uploadTime", "modifyUser", "modifyDate"

      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();

          var template =
              "update pos_order set serverId = '%s',uploadStatus = '%s' ,uploadCode = '%s' ,uploadMessage = '%s' ,uploadErrors = '%s' ,uploadTime = '%s' ,modifyUser = '%s' ,modifyDate = '%s' where id = '%s';";
          var sql = sprintf(template, [
            data["serverId"],
            data["uploadStatus"],
            data["uploadCode"],
            data["uploadMessage"],
            data["uploadErrors"],
            data["uploadTime"],
            data["modifyUser"],
            data["modifyDate"],
            data["id"],
          ]);
          batch.rawInsert(sql);

          await batch.commit(noResult: false);
        } catch (e) {
          FLogger.error("更新订单上送状态异常:" + e.toString());
        }
      });
    } catch (e, stack) {
      result = false;
      message = "更新订单上送状态异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    } finally {
      //await SqlUtils.instance.close();
    }
    return Tuple2<bool, String>(result, message);
  }

  ///生成订单序号
  Future<Tuple3<bool, String, String>> generateOrderNo({int length = 2}) async {
    bool result = false;
    String message = "每日订单序号获取失败!!";
    String data = "";
    try {
      data = await _generateSerialNumber(
          length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.ORDER_NO);

      if (StringUtils.isNotBlank(data)) {
        result = true;
        message = "每日订单序号获取成功";
      } else {
        result = false;
      }
    } catch (e, stack) {
      result = false;
      message = "每日订单序号获取异常";

      FlutterChain.printError(e, stack);
      FLogger.error("获取每日订单序号发生异常:" + e.toString());
    }

    return Tuple3<bool, String, String>(result, message, data);

    //return Tuple3<bool, String, String>(true, "", "1");
  }

  ///整单保存
  Future<Tuple3<bool, String, OrderObject>> saveOrderObject(
      OrderObject orderObject) async {
    bool result = false;
    String message = "";

    try {
      ///统一主表和明细表的订单完成时间
      var finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
      //重置订单完成时间
      orderObject.finishDate = finishDate;
      //订单支付状态
      orderObject.paymentStatus = OrderPaymentStatus.Paid;
      //订单状态
      orderObject.orderStatus = OrderStatus.Completed;
      //退款状态
      orderObject.refundStatus = OrderRefundStatus.NonRefund;

      orderObject.payCount = orderObject.pays.length;
      orderObject.itemCount = orderObject.items.length;

      //班次
      var shitLog = await Global.instance.getShiftLog();
      //硬件信息
      orderObject.deviceName = Global.instance.authc.compterName;
      orderObject.macAddress = Global.instance.authc.macAddress;
      orderObject.ipAddress = await DeviceUtils.instance.getIpAddress();

      //班次信息
      orderObject.shiftId = shitLog.id;
      orderObject.shiftNo = shitLog.no;
      orderObject.shiftName = shitLog.name;

      //制作状态 0-待制作 1-制作完成,待取餐 2-已取餐 3-待叫号已取消,尚未支持
      //orderObject.MakeStatus = 0;

      //生成订单流水号
      var orderNoResult = await OrderUtils.instance.generateOrderNo();
      orderObject.orderNo = orderNoResult.item3;

      orderObject.orderStatus = OrderStatus.Completed;

      await builderMalingPayMode(orderObject);

      // //抹零附加记入支付方式
      // BuilderMalingPayMode(orderObject);
      //
      // //捆绑商品明细加入订单明细
      // AddBindingItems2Order(orderObject);
      //
      // //包含套餐进行套餐分摊
      // if (orderObject.Items.Exists(x => x.RowType == OrderRowType.套餐主))
      // {
      //   CalculateSetMealShare(orderObject);
      // }
      //
      // //支付方式分摊
      // BuilderItemPayShared(orderObject);

      //构建订单明细支付方式分摊
      await builderItemPayShared(orderObject);

      //整单状态
      if (orderObject.cashierAction == CashierAction.Refund) {
        orderObject.orderStatus = OrderStatus.ChargeBack;
      } else {
        orderObject.orderStatus = OrderStatus.Completed;
      }
      //整单支付状态
      orderObject.paymentStatus = OrderPaymentStatus.Paid;

      var queues = new Queue<String>();

      //pos_order表的SQL语句
      var order = await buildOrderObjectSql(orderObject, finishDate);
      if (order.item1) {
        queues.add(order.item3);
      }

      //pos_order_item表的SQL语句
      var orderItem = await buildOrderItemSql(orderObject, finishDate);
      if (orderItem.item1) {
        queues.addAll(orderItem.item3);
      }

      //pos_order_promotion表的SQL语句
      var orderPromotion =
          await buildOrderPromotionSql(orderObject, finishDate);
      if (orderPromotion.item1) {
        queues.add(orderPromotion.item3);
      }

      //pos_order_pay表的SQL语句
      var orderPay = await _buildOrderPaySql(orderObject, finishDate);
      if (orderPay.item1) {
        queues.add(orderPay.item3);
      }

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("保存订单数据异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "数据保存失败...";
      } else {
        result = true;
        message = "数据保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存订单发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, OrderObject>(result, message, orderObject);
  }

  ///桌台订单保存
  Future<Tuple3<bool, String, OrderObject>> saveTableOrderObject(
      OrderObject orderObject) async {
    bool result = false;
    String message = "";

    ///统一主表和明细表的订单完成时间
    var finishDate =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
    try {
      //重置订单完成时间
      orderObject.finishDate = finishDate;
      //订单支付状态
      orderObject.paymentStatus = OrderPaymentStatus.Paid;

      //退款状态
      orderObject.refundStatus = OrderRefundStatus.NonRefund;

      orderObject.payCount = orderObject.pays.length;
      orderObject.itemCount = orderObject.items.length;

      //班次
      var shitLog = await Global.instance.getShiftLog();
      //硬件信息
      orderObject.deviceName = Global.instance.authc.compterName;
      orderObject.macAddress = Global.instance.authc.macAddress;
      orderObject.ipAddress = await DeviceUtils.instance.getIpAddress();

      //班次信息
      orderObject.shiftId = shitLog.id;
      orderObject.shiftNo = shitLog.no;
      orderObject.shiftName = shitLog.name;

      //制作状态 0-待制作 1-制作完成,待取餐 2-已取餐 3-待叫号已取消,尚未支持
      orderObject.makeStatus = 2;

      //生成订单流水号
      var orderNoResult = await OrderUtils.instance.generateOrderNo();
      orderObject.orderNo = orderNoResult.item3;

      await builderMalingPayMode(orderObject);

      // //抹零附加记入支付方式
      // BuilderMalingPayMode(orderObject);
      //
      // //捆绑商品明细加入订单明细
      // AddBindingItems2Order(orderObject);
      //
      // //包含套餐进行套餐分摊
      // if (orderObject.Items.Exists(x => x.RowType == OrderRowType.套餐主))
      // {
      //   CalculateSetMealShare(orderObject);
      // }
      //
      // //支付方式分摊
      // BuilderItemPayShared(orderObject);

      //构建订单明细支付方式分摊
      await builderItemPayShared(orderObject);

      //整单状态
      if (orderObject.cashierAction == CashierAction.Refund) {
        orderObject.orderStatus = OrderStatus.ChargeBack;
      } else {
        orderObject.orderStatus = OrderStatus.Completed;
      }

      var queues = new Queue<String>();

      //桌台模式，更新主单数据
      var orderObjectSql = sprintf(
          "update pos_order set finishDate='%s',paidAmount='%s',paymentStatus='%s',orderStatus='%s',refundStatus='%s',payCount='%s',itemCount='%s',deviceName='%s',macAddress='%s',ipAddress='%s',shiftId='%s',shiftNo='%s',shiftName='%s',makeStatus='%s',orderNo='%s' where id = '%s';",
          [
            orderObject.finishDate,
            orderObject.paidAmount,
            orderObject.paymentStatus.value,
            orderObject.orderStatus.value,
            orderObject.refundStatus.value,
            orderObject.payCount,
            orderObject.itemCount,
            orderObject.deviceName,
            orderObject.macAddress,
            orderObject.ipAddress,
            orderObject.shiftId,
            orderObject.shiftNo,
            orderObject.shiftName,
            orderObject.makeStatus,
            orderObject.orderNo,
            orderObject.id,
          ]);
      //pos_order表的SQL语句
      queues.add(orderObjectSql);

      //pos_order_item表的SQL语句
      var newItems = orderObject.items;
      for (var item in newItems) {
        var orderItemSql = sprintf(
            "update pos_order_item set finishDate='%s',salesCode='%s',salesName='%s' where id='%s';",
            [
              orderObject.finishDate,
              orderObject.salesCode,
              orderObject.salesName,
              item.id,
            ]);
        queues.add(orderItemSql);

        for (var p in item.promotions) {
          var orderItemPromotionSql = sprintf(
              "update pos_order_item_promotion set finishDate='%s' where id='%s';",
              [
                orderObject.finishDate,
                p.id,
              ]);
          queues.add(orderItemPromotionSql);
        }

        for (var f in item.flavors) {
          var orderItemMakeSql = sprintf(
              "update pos_order_item_make set finishDate='%s' where id='%s';", [
            orderObject.finishDate,
            f.id,
          ]);
          queues.add(orderItemMakeSql);
        }

        //pos_order_item_pay表的SQL语句
        var orderItemPay = await _buildOrderItemPaySql(item, finishDate);
        if (orderItemPay.item1) {
          queues.add(orderItemPay.item3);
        }
      }

      //pos_order_table表的SQL语句
      var newTables = orderObject.tables;
      for (var table in newTables) {
        var orderItemSql = sprintf(
            "update pos_order_table set finishDate='%s',tableAction='%s',tableStatus='%s' where id='%s';",
            [
              orderObject.finishDate,
              OrderTableAction.None.value, //可用
              OrderTableStatus.Free.value, //空闲
              // OrderTableAction.Clear.value, //待清台
              // OrderTableStatus.Occupied.value, //在用
              table.id,
            ]);
        queues.add(orderItemSql);
      }

      //更新pos_order_promotion表的SQL语句
      for (var promotion in orderObject.promotions) {
        var orderPromotionSql = sprintf(
            "update pos_order_promotion set finishDate='%s' where id='%s';", [
          orderObject.finishDate,
          promotion.id,
        ]);
        queues.add(orderPromotionSql);
      }

      //pos_order_pay表的SQL语句
      var orderPay = await _buildOrderPaySql(orderObject, finishDate);
      if (orderPay.item1) {
        queues.add(orderPay.item3);
      }

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.execute(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e, stack) {
          FlutterChain.printError(e, stack);
          FLogger.error("保存订单数据异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "数据保存失败...";
      } else {
        result = true;
        message = "数据保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存桌台订单发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    } finally {
      //订单保存成功，处理状态
    }

    return Tuple3<bool, String, OrderObject>(result, message, orderObject);
  }

  ///保存退单
  Future<Tuple3<bool, String, OrderObject>> saveRefundOrderObject(
      OrderObject source, OrderObject refund) async {
    bool result = false;
    String message = "";
    try {
      ///统一主表和明细表的订单完成时间
      var finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
      //重置订单完成时间
      refund.finishDate = finishDate;
      //订单支付状态
      refund.paymentStatus = OrderPaymentStatus.Paid;
      //订单状态
      refund.orderStatus = OrderStatus.ChargeBack;
      //退款状态
      refund.refundStatus = OrderRefundStatus.NonRefund;

      refund.payCount = refund.pays.length;
      refund.itemCount = refund.items.length;

      //硬件信息
      refund.deviceName = Global.instance.authc.compterName;
      refund.macAddress = Global.instance.authc.macAddress;
      refund.ipAddress = await DeviceUtils.instance.getIpAddress();
      //班次
      var shitLog = await Global.instance.getShiftLog();
      //班次信息
      refund.shiftId = shitLog.id;
      refund.shiftNo = shitLog.no;
      refund.shiftName = shitLog.name;

      var queues = new Queue<String>();

      //pos_order表的SQL语句
      var order = await buildOrderObjectSql(refund, finishDate);
      if (order.item1) {
        queues.add(order.item3);
      }

      //pos_order_item表的SQL语句
      var orderItem = await buildOrderItemSql(refund, finishDate);
      if (orderItem.item1) {
        queues.addAll(orderItem.item3);
      }

      //pos_order_promotion表的SQL语句
      var orderPromotion = await buildOrderPromotionSql(refund, finishDate);
      if (orderPromotion.item1) {
        queues.add(orderPromotion.item3);
      }

      //pos_order_pay表的SQL语句
      var orderPay = await _buildOrderPaySql(refund, finishDate);
      if (orderPay.item1) {
        queues.add(orderPay.item3);
      }

      //修改原单的退款状态
      bool allRefund = (refund.receivableAmount + source.receivableAmount == 0);
      source.refundStatus =
          allRefund ? OrderRefundStatus.Refund : OrderRefundStatus.PartRefund;

      //保存原单更新信息
      for (var item in source.items) {
        String updateOrderItemSql =
            "update pos_order_item set rquantity='${item.refundQuantity}',ramount='${item.refundAmount}',refundPoint='${item.refundPoint}' where id='${item.id}';";
        queues.add(updateOrderItemSql);
        //原明细支付分摊
        if (item.itemPays != null && item.itemPays.length > 0) {
          for (var itemPay in item.itemPays) {
            String updateOrderItemPaySql =
                "update pos_order_item_pay set ramount='${itemPay.refundAmount}' where id='${itemPay.id}';";
            queues.add(updateOrderItemPaySql);
          }
        }
      }

      for (var pay in source.pays) {
        String updateOrderPaySql =
            "update pos_order_pay set ramount='${pay.refundAmount}' where id='${pay.id}';";
        queues.add(updateOrderPaySql);
      }

      String updateOrderObjectSql =
          "update pos_order set refundStatus='${source.refundStatus.value}',refundPoint='${source.refundPoint}' where id='${source.id}';";
      queues.add(updateOrderObjectSql);

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("保存退单数据异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "退单数据保存失败...";
      } else {
        result = true;
        message = "退单数据保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存退单信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, OrderObject>(result, message, refund);
  }

  //构建pos_order表SQL语句
  Future<Tuple3<bool, String, String>> buildOrderObjectSql(
      OrderObject orderObject, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      //构建主单pos_order信息
      String template = """
          insert into pos_order(id,tenantId,objectId,orderNo,tradeNo,storeId,storeNo,storeName,workerNo,workerName,saleDate,finishDate,tableNo,tableName,
          salesCode,salesName,posNo,deviceName,macAddress,ipAddress,itemCount,payCount,totalQuantity,amount,discountAmount,receivableAmount,paidAmount,
          receivedAmount,malingAmount,changeAmount,invoicedAmount,overAmount,orderStatus,paymentStatus,printStatus,printTimes,postWay,orderSource,people,
          shiftId,shiftNo,shiftName,discountRate,orgTradeNo,refundCause,isMember,memberNo,memberName,memberMobileNo,cardFaceNo,prePoint,addPoint,refundPoint,
          aftPoint,aftAmount,uploadStatus,uploadErrors,uploadCode,uploadMessage,serverId,uploadTime,weather,weeker,remark,memberId,receivableRemoveCouponAmount,
          isPlus,plusDiscountAmount,ext1,ext2,ext3,createUser,createDate,refundStatus,orderUploadSource,pointDealStatus,cashierAction) values 
          ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
          '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
          '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
          '%s','%s','%s','%s','%s','%s','%s','%s');
         """;
      //构建SQL语句
      data = sprintf(template, [
        //第一行
        orderObject.id,
        orderObject.tenantId,
        orderObject.objectId,
        orderObject.orderNo,
        orderObject.tradeNo,
        orderObject.storeId,
        orderObject.storeNo,
        orderObject.storeName,
        orderObject.workerNo,
        orderObject.workerName,
        orderObject.saleDate,
        orderObject.finishDate,
        orderObject.tableNo,
        orderObject.tableName,
        //第二行
        orderObject.salesCode,
        orderObject.salesName,
        orderObject.posNo,
        orderObject.deviceName,
        orderObject.macAddress,
        orderObject.ipAddress,
        orderObject.itemCount,
        orderObject.payCount,
        orderObject.totalQuantity,
        orderObject.amount,
        orderObject.discountAmount,
        orderObject.receivableAmount,
        orderObject.paidAmount,
        //第三行
        orderObject.receivedAmount,
        orderObject.malingAmount,
        orderObject.changeAmount,
        orderObject.invoicedAmount,
        orderObject.overAmount,
        orderObject.orderStatus.value,
        orderObject.paymentStatus.value,
        orderObject.printStatus.value,
        orderObject.printTimes,
        orderObject.postWay.value,
        orderObject.orderSource.value,
        orderObject.people,
        //第四行
        orderObject.shiftId,
        orderObject.shiftNo,
        orderObject.shiftName,
        orderObject.discountRate,
        orderObject.orgTradeNo,
        orderObject.refundCause,
        orderObject.isMember,
        orderObject.memberNo,
        orderObject.memberName,
        orderObject.memberMobileNo,
        orderObject.cardFaceNo,
        orderObject.prePoint,
        orderObject.addPoint,
        orderObject.refundPoint,
        //第五行
        orderObject.aftPoint,
        orderObject.aftAmount,
        orderObject.uploadStatus,
        orderObject.uploadErrors,
        orderObject.uploadCode,
        orderObject.uploadMessage,
        orderObject.serverId,
        orderObject.uploadTime,
        orderObject.weather,
        orderObject.weeker,
        orderObject.remark,
        orderObject.memberId,
        orderObject.receivableRemoveCouponAmount,
        //第六行
        orderObject.isPlus,
        orderObject.plusDiscountAmount,
        orderObject.ext1 ?? "",
        orderObject.ext2 ?? "",
        orderObject.ext3 ?? "",
        orderObject.createUser ?? Constants.DEFAULT_CREATE_USER,
        orderObject.createDate ??
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
        orderObject.refundStatus.value,
        orderObject.orderUploadSource.value,
        orderObject.pointDealStatus.value,
        orderObject.cashierAction.value,
      ]);

      //处理为单行
      data = data.replaceAll("\n", "");
    } catch (e, stack) {
      result = false;
      message = "构建订单主表异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  ///构建pos_order_item表SQL语句
  /// newItemList 参数用于中餐点单，这个参数作为新增商品下单保存
  Future<Tuple3<bool, String, List<String>>> buildOrderItemSql(
      OrderObject orderObject, String finishDate,
      {List<OrderItem> newItemList}) async {
    bool result = true;
    String message = "执行成功";
    List<String> data = <String>[];
    try {
      //构建订单明细表pos_order_item
      String templatePrefix = """
        insert into pos_order_item (id,tenantId,orderId,tradeNo,orderNo,productId,productName,shortName,specId,specName,
        displayName,quantity,rquantity,ramount,orgItemId,salePrice,price,bargainReason,discountPrice,vipPrice,otherPrice,
        batchPrice,postPrice,purPrice,minPrice,giftQuantity,giftAmount,giftReason,flavorCount,flavorNames,flavorAmount,
        flavorDiscountAmount,flavorReceivableAmount,amount,totalAmount,discountAmount,receivableAmount,totalDiscountAmount,
        totalReceivableAmount,discountRate,totalDiscountRate,malingAmount,remark,saleDate,finishDate,cartDiscount,underline,
        `group`,parentId,flavor,scheme,rowType,suitId,suitQuantity,suitAddPrice,suitAmount,chuda,chudaFlag,chudaQty,
        chupin,chupinFlag,chupinQty,productType,barCode,subNo,batchNo,productUnitId,productUnitName,categoryId,categoryNo,
        categoryName,brandId,brandName,foreDiscount,weightFlag,weightWay,foreBargain,pointFlag,pointValue,foreGift,promotionFlag,
        stockFlag,batchStockFlag,labelPrintFlag,labelQty,purchaseTax,saleTax,supplierId,supplierName,managerType,salesCode,
        salesName,itemSource,posNo,addPoint,refundPoint,promotionInfo,ext1,ext2,ext3,createUser,createDate,lyRate,chuDaLabel,
        chuDaLabelFlag,chuDaLabelQty,shareCouponLeastCost,couponAmount,totalReceivableRemoveCouponAmount,
        totalReceivableRemoveCouponLeastCost,joinType,labelAmount,isPlusPrice,realPayAmount,shareMemberId,
        orderRowStatus,tableId,tableNo,tableName,rreason,tableBatchTag) values 
      """;
      String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
        '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
        '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
        '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
        '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
        '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

      //订单明细的缓存
      var bufferOrderItem = new StringBuffer();
      bufferOrderItem.write(templatePrefix);

      // //订单明细优惠缓存
      // var bufferOrderItemPromotion = new StringBuffer();
      // //订单明细做法缓存
      // var bufferOrderItemMake = new StringBuffer();
      // //订单明细支付分摊缓存
      // var bufferOrderItemPay = new StringBuffer();

      //兼容中餐未下单商品下单用
      var newItems = newItemList ?? orderObject.items;
      for (var item in newItems) {
        if (StringUtils.isBlank(item.id)) {
          item.id = IdWorkerUtils.getInstance().generate().toString();
        }

        if (StringUtils.isBlank(item.tenantId)) {
          item.tenantId = Global.instance.authc.tenantId;
        }

        item.finishDate = finishDate;
        item.salesCode = orderObject.salesCode;
        item.salesName = orderObject.salesName;

        var sql = sprintf(templateSuffix, [
          //第一行
          item.id,
          item.tenantId,
          item.orderId,
          item.tradeNo,
          item.orderNo,
          item.productId,
          item.productName,
          item.shortName,
          item.specId,
          item.specName,
          //第二行
          item.displayName,
          item.quantity,
          item.refundQuantity,
          item.refundAmount,
          item.orgItemId,
          item.salePrice,
          item.price,
          item.bargainReason,
          item.discountPrice,
          item.vipPrice,
          item.otherPrice,
          //第三行
          item.batchPrice,
          item.postPrice,
          item.purPrice,
          item.minPrice,
          item.giftQuantity,
          item.giftAmount,
          item.giftReason,
          item.flavorCount,
          item.flavorNames,
          item.flavorAmount,
          //第四行
          item.flavorDiscountAmount,
          item.flavorReceivableAmount,
          item.amount,
          item.totalAmount,
          item.discountAmount,
          item.receivableAmount,
          item.totalDiscountAmount,
          //第五行
          item.totalReceivableAmount,
          item.discountRate,
          item.totalDiscountRate,
          item.malingAmount,
          item.remark,
          item.saleDate,
          item.finishDate,
          item.cartDiscount,
          item.underline,
          //第六行
          item.group,
          item.parentId,
          item.flavor,
          item.scheme,
          item.rowType.value,
          item.suitId,
          item.suitQuantity,
          item.suitAddPrice,
          item.suitAmount,
          item.chuda,
          item.chudaFlag,
          item.chudaQty,
          //第七行
          item.chupin,
          item.chupinFlag,
          item.chupinQty,
          item.productType,
          item.barCode,
          item.subNo ?? "",
          item.batchNo,
          item.productUnitId,
          item.productUnitName,
          item.categoryId,
          item.categoryNo,
          //第八行
          item.categoryName,
          item.brandId,
          item.brandName,
          item.foreDiscount,
          item.weightFlag,
          item.weightWay,
          item.foreBargain,
          item.pointFlag,
          item.pointValue,
          item.foreGift,
          item.promotionFlag,
          //第九行
          item.stockFlag,
          item.batchStockFlag,
          item.labelPrintFlag,
          item.labelQty,
          item.purchaseTax,
          item.saleTax,
          item.supplierId,
          item.supplierName,
          item.managerType,
          item.salesCode,
          //第十行
          item.salesName,
          item.itemSource.value,
          item.posNo,
          item.addPoint,
          item.refundPoint,
          item.promotionInfo,
          item.ext1,
          item.ext2,
          item.ext3,
          item.createUser,
          item.createDate,
          item.lyRate,
          item.chuDaLabel,
          //第十一行
          item.chuDaLabelFlag,
          item.chuDaLabelQty,
          item.shareCouponLeastCost,
          item.couponAmount,
          item.totalReceivableRemoveCouponAmount,
          //第十二行
          item.totalReceivableRemoveCouponLeastCost,
          item.joinType.value,
          item.labelAmount,
          item.isPlusPrice,
          item.realPayAmount,
          item.shareMemberId,
          item.orderRowStatus.value,
          item.tableId,
          item.tableNo,
          item.tableName,
          item.refundReason,
          item.tableBatchTag,
        ]);

        //处理为单行
        var line = sql.replaceAll("\n", "");
        bufferOrderItem.write(line.trim());

        //pos_order_item_promotion表的SQL语句
        var orderItemPromotion =
            await buildOrderItemPromotionSql(item, finishDate);
        if (orderItemPromotion.item1) {
          data.add(orderItemPromotion.item3);
        }

        //pos_order_item_make表的SQL语句
        var orderItemMake = await _buildOrderItemMakeSql(item, finishDate);
        if (orderItemMake.item1) {
          data.add(orderItemMake.item3);
        }

        //pos_order_item_pay表的SQL语句
        var orderItemPay = await _buildOrderItemPaySql(item, finishDate);
        if (orderItemPay.item1) {
          data.add(orderItemPay.item3);
        }
      }

      ///整理订单明细表SQL语句，末尾的,修正为;
      String str = bufferOrderItem.toString();
      //pos_order_item
      data.add(str.substring(0, str.length - 1) + ";");
    } catch (e, stack) {
      result = false;
      message = "构建订单明细表异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, List<String>>(result, message, data);
  }

  Future<Tuple3<bool, String, String>> buildOrderItemPromotionSql(
      OrderItem orderItem, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderItem.promotions != null && orderItem.promotions.length > 0) {
        //构建pos_order_item_promotion信息
        String templatePrefix = """
          insert into pos_order_item_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,
          scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,
          receivableAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,ext1,ext2,ext3,createUser,
          createDate,sourceSign,tableId,tableNo,tableName) values
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        orderItem.promotions.forEach((item) {
          if (StringUtils.isBlank(item.id)) {
            item.id = IdWorkerUtils.getInstance().generate().toString();
          }

          item.finishDate = finishDate;
          var sql = sprintf(templateSuffix, [
            //第一行
            item.id,
            item.tenantId,
            item.orderId,
            item.itemId,
            item.tradeNo,
            item.onlineFlag,
            item.promotionType.value,
            item.reason,
            item.scheduleId,
            //第二行
            item.scheduleSn,
            item.promotionId,
            item.promotionSn,
            item.promotionMode,
            item.scopeType,
            item.promotionPlan,
            item.price,
            item.bargainPrice,
            item.amount,
            item.discountAmount,
            //第三行
            item.receivableAmount,
            item.discountRate,
            item.enabled,
            item.relationId,
            item.couponId,
            item.couponNo,
            item.couponName,
            item.finishDate,
            item.ext1,
            item.ext2,
            item.ext3,
            item.createUser,
            //第四行
            item.createDate,
            item.sourceSign,
            item.tableId,
            item.tableNo,
            item.tableName,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${orderItem.tradeNo}没有单品优惠数据";
        data = "";
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单明细优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  Tuple3<bool, String, String> orderItemPromotionToSql(
      OrderItemPromotion item, String finishDate) {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (item != null) {
        //构建pos_order_item_promotion信息
        String templatePrefix = """
          insert into pos_order_item_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,
          scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,
          receivableAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,ext1,ext2,ext3,createUser,
          createDate,sourceSign,tableId,tableNo,tableName) values
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        if (StringUtils.isBlank(item.id)) {
          item.id = IdWorkerUtils.getInstance().generate().toString();
        }

        item.finishDate = finishDate;
        var sql = sprintf(templateSuffix, [
          //第一行
          item.id,
          item.tenantId,
          item.orderId,
          item.itemId,
          item.tradeNo,
          item.onlineFlag,
          item.promotionType.value,
          item.reason,
          item.scheduleId,
          //第二行
          item.scheduleSn,
          item.promotionId,
          item.promotionSn,
          item.promotionMode,
          item.scopeType,
          item.promotionPlan,
          item.price,
          item.bargainPrice,
          item.amount,
          item.discountAmount,
          //第三行
          item.receivableAmount,
          item.discountRate,
          item.enabled,
          item.relationId,
          item.couponId,
          item.couponNo,
          item.couponName,
          item.finishDate,
          item.ext1,
          item.ext2,
          item.ext3,
          item.createUser,
          //第四行
          item.createDate,
          item.sourceSign,
          item.tableId,
          item.tableNo,
          item.tableName,
        ]);

        //处理为单行
        var line = sql.replaceAll("\n", "");
        buffer.write(line.trim());

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${item.tradeNo}没有单品优惠数据";
        data = "";
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单明细优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  Future<Tuple3<bool, String, String>> _buildOrderItemMakeSql(
      OrderItem orderItem, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderItem.flavors != null && orderItem.flavors.length > 0) {
        //构建pos_order_item_make信息
        String templatePrefix = """
          insert into pos_order_item_make(id,tenantId,tradeNo,orderId,itemId,makeId,code,name,qtyFlag,quantity,refund,
          salePrice,price,amount,discountAmount,receivableAmount,discountRate,`type`,isRadio,description,hand,`group`,
          baseQuantity,itemQuantity,finishDate,ext1,ext2,ext3,createUser,createDate,tableId,tableNo,tableName) values
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        orderItem.flavors.forEach((item) {
          if (StringUtils.isBlank(item.id)) {
            item.id = IdWorkerUtils.getInstance().generate().toString();
          }

          item.finishDate = finishDate;
          var sql = sprintf(templateSuffix, [
            //第一行
            item.id,
            item.tenantId,
            item.tradeNo,
            item.orderId,
            item.itemId,
            item.makeId,
            item.code,
            item.name,
            item.qtyFlag,
            item.quantity,
            item.refundQuantity,
            //第二行
            item.salePrice,
            item.price,
            item.amount,
            item.discountAmount,
            item.receivableAmount,
            item.discountRate,
            item.type,
            item.isRadio,
            item.description,
            item.hand,
            item.group,
            //第三行
            item.baseQuantity,
            item.itemQuantity,
            item.finishDate,
            item.ext1,
            item.ext2,
            item.ext3,
            item.createUser,
            item.createDate,
            item.tableId,
            item.tableNo,
            item.tableName,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "商品${orderItem.displayName}没有做法数据";
        data = "";

        FLogger.debug(message);
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单明细优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  Future<Tuple3<bool, String, String>> _buildOrderItemPaySql(
      OrderItem orderItem, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderItem.itemPays != null && orderItem.itemPays.length > 0) {
        //构建pos_order_item_pay信息
        String templatePrefix = """
          insert into pos_order_item_pay(id,tenantId,orderId,tradeNo,itemId,productId,specId,payId,no,name,couponId,couponNo,
          couponName,faceAmount,shareCouponLeastCost,shareAmount,ramount,finishDate,ext1,ext2,ext3,createUser,createDate,sourceSign,incomeFlag) values 
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        orderItem.itemPays.forEach((item) {
          if (StringUtils.isBlank(item.id)) {
            item.id = IdWorkerUtils.getInstance().generate().toString();
          }

          item.finishDate = finishDate;
          var sql = sprintf(templateSuffix, [
            //第一行
            item.id,
            item.tenantId,
            item.orderId,
            item.tradeNo,
            item.itemId,
            item.productId,
            item.specId,
            item.payId,
            item.no,
            item.name,
            item.couponId,
            item.couponNo,
            //第二行
            item.couponName,
            item.faceAmount,
            item.shareCouponLeastCost,
            item.shareAmount,
            item.refundAmount,
            item.finishDate,
            item.ext1,
            item.ext2,
            item.ext3,
            item.createUser,
            item.createDate,
            item.sourceSign,
            item.incomeFlag,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${orderItem.tradeNo}没有明细分摊数据";
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单明细优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  //构建pos_order_pay表SQL语句
  Future<Tuple3<bool, String, String>> _buildOrderPaySql(
      OrderObject orderObject, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderObject.pays != null && orderObject.pays.length > 0) {
        //构建主单pos_order_pay信息
        String templatePrefix = """
          insert into pos_order_pay (id,tenantId,tradeNo,orderId,orgPayId,orderNo,`no`,name,amount,inputAmount,faceAmount,
          paidAmount,ramount,overAmount,changeAmount,platformDiscount,platformPaid,payNo,prePayNo,channelNo,voucherNo,status,
          statusDesc,payTime,finishDate,payChannel,incomeFlag,pointFlag,subscribe,useConfirmed,accountName,bankType,memo,
          cardNo,cardPreAmount,cardChangeAmount,cardAftAmount,cardPrePoint,cardChangePoint,cardAftPoint,memberMobileNo,
          cardFaceNo,pointAmountRate,shiftId,shiftNo,shiftName,ext1,ext2,ext3,createUser,createDate,
          couponId,couponNo,couponName,couponLeastCost,sourceSign) values 
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'
        ,'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'
        ,'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;
        var buffer = new StringBuffer();
        buffer.write(templatePrefix);
        orderObject.pays.forEach((item) {
          if (StringUtils.isBlank(item.id)) {
            item.id = IdWorkerUtils.getInstance().generate().toString();
          }

          item.shiftId = orderObject.shiftId;
          item.shiftNo = orderObject.shiftNo;
          item.shiftName = orderObject.shiftName;

          item.finishDate = finishDate;

          var sql = sprintf(templateSuffix, [
            //第一行
            item.id,
            item.tenantId,
            item.tradeNo,
            item.orderId,
            item.orgPayId,
            item.orderNo,
            item.no,
            item.name,
            item.amount,
            item.inputAmount,
            item.faceAmount,
            //第二行
            item.paidAmount,
            item.refundAmount,
            item.overAmount,
            item.changeAmount,
            item.platformDiscount,
            item.platformPaid,
            item.payNo,
            item.prePayNo,
            item.channelNo,
            item.voucherNo,
            item.status.value,
            //第三行
            item.statusDesc,
            item.payTime,
            item.finishDate,
            item.payChannel.value,
            item.incomeFlag,
            item.pointFlag,
            item.subscribe,
            item.useConfirmed,
            item.accountName,
            item.bankType,
            item.memo,
            //第四行
            item.cardNo,
            item.cardPreAmount,
            item.cardChangeAmount,
            item.cardAftAmount,
            item.cardPrePoint,
            item.cardChangePoint,
            item.cardAftPoint,
            item.memberMobileNo,
            //第五行
            item.cardFaceNo,
            item.pointAmountRate,
            item.shiftId,
            item.shiftNo,
            item.shiftName,
            item.ext1,
            item.ext2,
            item.ext3,
            item.createUser,
            item.createDate,
            //第六行
            item.couponId,
            item.couponNo,
            item.couponName,
            item.couponLeastCost,
            item.sourceSign,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${orderObject.tradeNo}没有支付数据";
        data = "";

        FLogger.debug(message);
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单明细表异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  Future<Tuple3<bool, String, String>> buildOrderPromotionSql(
      OrderObject orderObject, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderObject.promotions != null && orderObject.promotions.length > 0) {
        //构建pos_order_promotion信息
        String templatePrefix = """
          insert into pos_order_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,receivableAmount,adjustAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,sourceSign,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values 
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        orderObject.promotions.forEach((entity) {
          if (StringUtils.isBlank(entity.id)) {
            entity.id = IdWorkerUtils.getInstance().generate().toString();
          }

          entity.finishDate = finishDate;
          var sql = sprintf(templateSuffix, [
            entity.id,
            entity.tenantId,
            entity.orderId,
            entity.itemId,
            entity.tradeNo,
            entity.onlineFlag,
            entity.promotionType.value,
            entity.reason,
            entity.scheduleId,
            entity.scheduleSn,
            entity.promotionId,
            entity.promotionSn,
            entity.promotionMode,
            entity.scopeType,
            entity.promotionPlan,
            entity.price,
            entity.bargainPrice,
            entity.amount,
            entity.discountAmount,
            entity.receivableAmount,
            entity.adjustAmount,
            entity.discountRate,
            entity.enabled,
            entity.relationId,
            entity.couponId,
            entity.couponNo,
            entity.couponName,
            entity.finishDate,
            entity.sourceSign,
            entity.ext1,
            entity.ext2,
            entity.ext3,
            entity.createUser,
            entity.createDate,
            entity.modifyUser,
            entity.modifyDate,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${orderObject.tradeNo}没有整单优惠数据";
        data = "";

        FLogger.debug(message);
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  Tuple3<bool, String, String> orderPromotionToSql(
      OrderPromotion item, String finishDate) {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (item != null) {
        //构建pos_order_promotion信息
        String templatePrefix = """
          insert into pos_order_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,receivableAmount,adjustAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,sourceSign,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values 
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;

        var buffer = new StringBuffer();
        buffer.write(templatePrefix);

        if (StringUtils.isBlank(item.id)) {
          item.id = IdWorkerUtils.getInstance().generate().toString();
        }

        item.finishDate = finishDate;
        var sql = sprintf(templateSuffix, [
          item.id,
          item.tenantId,
          item.orderId,
          item.itemId,
          item.tradeNo,
          item.onlineFlag,
          item.promotionType.value,
          item.reason,
          item.scheduleId,
          item.scheduleSn,
          item.promotionId,
          item.promotionSn,
          item.promotionMode,
          item.scopeType,
          item.promotionPlan,
          item.price,
          item.bargainPrice,
          item.amount,
          item.discountAmount,
          item.receivableAmount,
          item.adjustAmount,
          item.discountRate,
          item.enabled,
          item.relationId,
          item.couponId,
          item.couponNo,
          item.couponName,
          item.finishDate,
          item.sourceSign,
          item.ext1,
          item.ext2,
          item.ext3,
          item.createUser,
          item.createDate,
          item.modifyUser,
          item.modifyDate,
        ]);

        //处理为单行
        var line = sql.replaceAll("\n", "");
        buffer.write(line.trim());

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${item.tradeNo}没有整单优惠数据";
        data = "";
      }
    } catch (e, stack) {
      result = false;
      message = "构建整单优惠异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  //构建pos_order_table表SQL语句
  Future<Tuple3<bool, String, String>> buildOrderTableSql(
      OrderObject orderObject, String finishDate) async {
    bool result = true;
    String message = "执行成功";
    String data = "";
    try {
      if (orderObject.tables != null && orderObject.tables.length > 0) {
        //构建主单pos_order_pay信息
        String templatePrefix = """
          insert into pos_order_table(id,tenantId,orderId,tradeNo,tableId,tableNo,tableName,typeId,typeNo,typeName,areaId,areaNo,areaName,tableStatus,openTime,openUser,tableNumber,serialNo,tableAction,people,excessFlag,totalAmount,totalQuantity,discountAmount,totalRefund,totalRefundAmount,totalGive,totalGiveAmount,discountRate,receivableAmount,paidAmount,malingAmount,maxOrderNo,masterTable,perCapitaAmount,posNo,payNo,finishDate,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values 
          """;

        String templateSuffix = """
        ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
        """;
        var buffer = new StringBuffer();
        buffer.write(templatePrefix);
        orderObject.tables.forEach((entity) {
          if (StringUtils.isBlank(entity.id)) {
            entity.id = IdWorkerUtils.getInstance().generate().toString();
          }

          entity.finishDate = finishDate;

          var sql = sprintf(templateSuffix, [
            entity.id,
            entity.tenantId,
            entity.orderId,
            entity.tradeNo,
            entity.tableId,
            entity.tableNo,
            entity.tableName,
            entity.typeId,
            entity.typeNo,
            entity.typeName,
            entity.areaId,
            entity.areaNo,
            entity.areaName,
            entity.tableStatus,
            entity.openTime,
            entity.openUser,
            entity.tableNumber,
            entity.serialNo,
            entity.tableAction,
            entity.people,
            entity.excessFlag,
            entity.totalAmount,
            entity.totalQuantity,
            entity.discountAmount,
            entity.totalRefund,
            entity.totalRefundAmount,
            entity.totalGive,
            entity.totalGiveAmount,
            entity.discountRate,
            entity.receivableAmount,
            entity.paidAmount,
            entity.malingAmount,
            entity.maxOrderNo,
            entity.masterTable,
            entity.perCapitaAmount,
            entity.posNo,
            entity.payNo,
            entity.finishDate,
            entity.ext1,
            entity.ext2,
            entity.ext3,
            entity.createUser,
            entity.createDate,
            entity.modifyUser,
            entity.modifyDate,
          ]);

          //处理为单行
          var line = sql.replaceAll("\n", "");
          buffer.write(line.trim());
        });

        ///整理SQL语句，末尾的,修正为;
        String str = buffer.toString();
        data = str.substring(0, str.length - 1) + ";";
      } else {
        result = false;
        message = "订单${orderObject.tradeNo}没有桌台数据";
        data = "";
      }
    } catch (e, stack) {
      result = false;
      message = "构建订单桌台表异常";
      FLogger.error("$message:" + e.toString());
    }
    return Tuple3<bool, String, String>(result, message, data);
  }

  //支付方式分摊
  Future<Tuple2<bool, String>> builderItemPayShared(
      OrderObject orderObject) async {
    bool result = false;
    String message = "初始错误";
    try {
      //找到未分摊的支付方式
      var waitSharedPay = orderObject.pays.where((x) => !(orderObject.items
          .any((y) => y.itemPays.any((z) => z.payId == x.id))));
      print("未分摊的支付方式:${waitSharedPay.length}");

      if (waitSharedPay != null && waitSharedPay.length > 0) {
        for (var pay in waitSharedPay) {
          //本次分摊总额
          var waitSharedAmount = pay.paidAmount;
          //已分摊金额
          double alreadyShared = 0;

          //参与分摊的商品
          var allItems = orderObject.items.where((x) =>
              x.rowType != OrderItemRowType.Detail &&
              x.rowType != OrderItemRowType.SuitDetail);
          double allItemFineAmount = 0;
          if (allItems != null && allItems.length > 0) {
            //商品可参与分摊剩余总额（应收-已分摊）
            allItems.forEach((item) {
              double totalShareAmount = item.itemPays
                  .map((p) => p.shareAmount)
                  .fold(0, (prev, shareAmount) => prev + shareAmount);
              allItemFineAmount +=
                  item.totalReceivableAmount - totalShareAmount;
            });
          }

          print("可分摊的总金额:$allItemFineAmount");

          for (int i = 0; i < orderObject.items.length; i++) {
            var item = orderObject.items[i];
            if (item.rowType == OrderItemRowType.Detail ||
                item.rowType == OrderItemRowType.SuitDetail) {
              continue;
            }

            double share = 0;
            //本商品剩余可分摊的余额
            var itemFineAmount = item.totalReceivableAmount -
                item.itemPays
                    .map((p) => p.shareAmount)
                    .fold(0, (prev, shareAmount) => prev + shareAmount);
            if (i + 1 == orderObject.items.length) {
              //最后一个用减法
              share = waitSharedAmount - alreadyShared;
            } else {
              //排除整单全赠送的情况
              if (allItemFineAmount != 0) {
                var rate = itemFineAmount / allItemFineAmount;
                share = OrderUtils.instance
                    .toRound(waitSharedAmount * rate, precision: 2);
              } else {
                share = 0;
              }
            }

            if (share == 0) {
              //此商品不分摊，可能是已经分摊的和应收一样了，也就是分摊够了
              continue;
            }

            OrderItemPay itemPay = OrderItemPay.newOrderItemPay();
            itemPay.id = IdWorkerUtils.getInstance().generate().toString();
            itemPay.tenantId = pay.tenantId;
            itemPay.orderId = pay.orderId;
            itemPay.tradeNo = pay.tradeNo;
            itemPay.payId = pay.id;
            itemPay.itemId = item.id;
            itemPay.no = pay.no;
            itemPay.name = pay.name;
            itemPay.productId = item.productId;
            itemPay.specId = item.specId;
            itemPay.couponId = pay.couponId;
            itemPay.couponNo = pay.couponNo;
            itemPay.sourceSign = pay.sourceSign;
            itemPay.couponName = pay.couponName;
            itemPay.faceAmount = pay.faceAmount;
            itemPay.shareAmount = share;
            itemPay.shareCouponLeastCost = 0;
            itemPay.refundAmount = 0;
            itemPay.incomeFlag = pay.incomeFlag;

            item.itemPays.add(itemPay);
            alreadyShared += share;

            print("商品<${item.displayName}>分摊的支付方式:${itemPay.toString()}");
          }
        }

        //重算，主要是算商品根据支付方式的分摊到商品，得出商品的支付实收realPayAmount
        if (orderObject.orderSource == OrderSource.CashRegister ||
            orderObject.orderSource == OrderSource.SelfServiceCash) {
          //本地订单使用此方式计算，
          for (var item in orderObject.items) {
            OrderUtils.instance.calculateOrderItem(item);
          }
        } else {
          // //外卖等信息不全的信息，不能使用上面if方式重算，避免影响了外卖平台的金额
          // var payModeList = DataCacheManager.GetCacheList<PayMode>(DataCacheEnum.LIST_PAYMODE);
          // if (payModeList != null)
          // {
          //   //行支付实收
          //   for (var item in orderObject.items)
          //   {
          //     item.RealPayAmount = item.ItemPayList.FindAll(x => payModeList.FirstOrDefault(y => y.No == x.No && y.IncomeFlag == 1) != null).Sum(x => x.ShareAmount);
          //   }
          // }
        }
      }

      result = true;
      message = "支付方式分摊成功";
    } catch (e, stack) {
      result = false;
      message = "支付方式分摊异常";

      FLogger.error("支付方式分摊发生异常:" + e.toString());
    }
    return Tuple2<bool, String>(result, message);
  }

  //创建抹零支付方式
  Future<Tuple2<bool, String>> builderMalingPayMode(
      OrderObject orderObject) async {
    bool result = false;
    String message = "";
    try {
      if (orderObject.malingAmount != 0) {
        if (orderObject.pays != null &&
            orderObject.pays.any((x) =>
                x.no == Constants.PAYMODE_CODE_MALING &&
                x.statusDesc != Constants.PAYMODE_MALING_HAND)) {
          //已存在抹零支付方式，跳过
          result = true;
          message = "已存在抹零支付方式，跳过本次执行";
        } else {
          var malingPayMode = await OrderUtils.instance
              .getPayMode(Constants.PAYMODE_CODE_MALING);
          if (malingPayMode == null) {
            //云端未配置抹零支付方式，创建默认支付方式
            malingPayMode = PayMode.newPayMode();
            malingPayMode.no = Constants.PAYMODE_CODE_MALING;
            malingPayMode.name = "抹零";
            malingPayMode.incomeFlag = 0;
            malingPayMode.pointFlag = 0;
          }

          //构建抹零支付方式
          OrderPay pay = OrderPay.newOrderPay();
          pay.id = IdWorkerUtils.getInstance().generate().toString();
          pay.tenantId = Global.instance.authc.tenantId;
          pay.tradeNo = orderObject.tradeNo;
          pay.orderId = orderObject.id;
          pay.orderNo = orderObject.pays.length + 1;
          pay.no = malingPayMode.no;
          pay.name = malingPayMode.name;
          pay.amount = orderObject.malingAmount;
          pay.inputAmount = orderObject.malingAmount;
          pay.paidAmount = orderObject.malingAmount;
          pay.overAmount = 0.00;
          pay.changeAmount = 0.00;
          pay.platformDiscount = 0.00;
          pay.platformPaid = 0.00;
          pay.payNo = null;
          pay.status = OrderPaymentStatus.Paid;
          pay.payTime = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");
          pay.incomeFlag = malingPayMode.incomeFlag;
          pay.pointFlag = malingPayMode.pointFlag;
          pay.shiftId = orderObject.shiftId;
          pay.shiftNo = orderObject.shiftNo;
          pay.shiftName = orderObject.shiftName;
          pay.createUser = Global.instance.worker.no;
          pay.createDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");

          //将支付方式压入整单支付明细中
          orderObject.pays.add(pay);

          result = true;
          message = "创建抹零支付方式成功";
        }
      }
    } catch (e, stack) {
      result = false;
      message = "创建抹零支付方式异常";

      FLogger.error("创建抹零支付方式发生异常:" + e.toString());
    }
    return Tuple2<bool, String>(result, message);
  }

  ///更新订单上送状态
  Future<Tuple2<bool, String>> deleteAllOrderObject() async {
    bool result = true;
    String message = "订单删除成功";
    try {
      //"serverId", "uploadStatus", "uploadCode", "uploadMessage", "uploadErrors", "uploadTime", "modifyUser", "modifyDate"

      var queues = new Queue<String>();

      //清除pos_order表
      queues.add("delete from pos_order;");
      //清除pos_order_item表
      queues.add("delete from pos_order_item;");
      //清除pos_order_pay表
      queues.add("delete from pos_order_pay;");
      //清除pos_order_promotion表
      queues.add("delete from pos_order_promotion;");
      //清除pos_order_item_pay表
      queues.add("delete from pos_order_item_pay;");
      //清除pos_order_item_make表
      queues.add("delete from pos_order_item_make;");
      //清除pos_order_item_promotion表
      queues.add("delete from pos_order_item_promotion;");
      //清除pos_order_table表
      queues.add("delete from pos_order_table;");

      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
        } catch (e) {
          FLogger.error("清除订单数据异常:" + e.toString());
        }
      });
    } catch (e, stack) {
      result = false;
      message = "清除订单发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    } finally {
      //await SqlUtils.instance.close();
    }
    return Tuple2<bool, String>(result, message);
  }

  Tuple2<bool, String> buildUploadOrder(OrderObject order) {
    bool result = false;
    String message = "";
    try {
      var items = new List<Map<String, dynamic>>();
      order.items.forEach((item) {
        var it = new Map<String, dynamic>();
        it["clientId"] = item.id;
        it["clientOrderId"] = item.orderId;
        it["tradeNo"] = item.tradeNo;
        it["orderNo"] = item.orderNo;
        it["productId"] = item.productId;
        it["productName"] = item.productName;
        it["shortName"] = item.shortName;
        it["specId"] = item.specId;
        it["specName"] = item.specName;
        it["quantity"] = item.quantity;
        it["rquantity"] = item.refundQuantity;
        it["ramount"] = item.refundAmount;
        it["salePrice"] = item.salePrice;
        it["price"] = item.price;
        it["bargainReason"] = item.bargainReason;
        it["discountPrice"] = item.discountPrice;
        it["vipPrice"] = item.vipPrice;
        it["otherPrice"] = item.otherPrice;
        it["minPrice"] = item.minPrice;
        it["giftQuantity"] = item.giftQuantity;
        it["giftAmount"] = item.giftAmount;
        it["giftReason"] = item.giftReason;
        it["flavorAmount"] = item.flavorAmount;
        it["flavorDiscountAmount"] = item.flavorDiscountAmount;
        it["flavorReceivableAmount"] = item.flavorReceivableAmount;
        it["flavorNames"] = item.flavorNames;
        it["amount"] = item.amount;
        it["totalAmount"] = item.totalAmount;
        it["discountAmount"] = item.discountAmount;
        it["receivableAmount"] = item.receivableAmount;
        it["totalDiscountAmount"] = item.totalDiscountAmount;
        it["totalReceivableAmount"] = item.totalReceivableAmount;
        it["discountRate"] = item.discountRate;
        it["totalDiscountRate"] = item.totalDiscountRate;
        it["saleDate"] = item.saleDate;
        it["finishDate"] = item.finishDate;
        it["remark"] = item.remark;
        it["itemSource"] = item.itemSource.value;
        it["posNo"] = item.posNo;
        it["groupId"] = item.group;
        it["parentId"] = item.parentId;
        it["scheme"] = item.scheme;
        it["rowType"] = item.rowType.value;
        it["suitId"] = item.suitId;
        it["suitQuantity"] = item.suitQuantity;
        it["suitAddPrice"] = item.suitAddPrice;
        it["suitAmount"] = item.suitAmount;
        it["productType"] = item.productType;
        it["barCode"] = item.barCode;
        it["subNo"] = item.subNo ?? "";
        it["batchNo"] = item.batchNo;
        it["productUnitId"] = item.productUnitId;
        it["productUnitName"] = item.productUnitName;
        it["categoryId"] = item.categoryId;
        it["categoryName"] = item.categoryName;
        it["brandId"] = item.brandId;
        it["brandName"] = item.brandName;
        it["weightFlag"] = item.weightFlag;
        it["weightWay"] = item.weightWay;
        it["pointFlag"] = item.pointFlag;
        it["pointValue"] = item.pointValue;
        it["stockFlag"] = item.stockFlag;
        it["batchStockFlag"] = item.batchStockFlag;
        it["purchaseTax"] = item.purchaseTax;
        it["saleTax"] = item.saleTax;
        it["supplierId"] = item.supplierId;
        it["supplierName"] = item.supplierName;
        it["managerType"] = item.managerType;
        it["salesCode"] = item.salesCode;
        it["salesName"] = item.salesName;
        it["addPoint"] = item.addPoint;
        it["refundPoint"] = item.refundPoint;
        it["promotionInfo"] = item.promotionInfo;
        it["lyRate"] = item.lyRate;
        it["orgItemId"] = item.orgItemId;
        it["joinType"] = item.joinType.value;
        it["labelAmount"] = item.labelAmount;
        it["isPlusPrice"] = item.isPlusPrice;
        it["shareCouponLeastCost"] = item.shareCouponLeastCost;
        it["couponAmount"] = item.couponAmount;
        it["totalReceivableRemoveCouponAmount"] =
            item.totalReceivableRemoveCouponAmount;
        it["totalReceivableRemoveCouponLeastCost"] =
            item.totalReceivableRemoveCouponLeastCost;
        it["realPayAmount"] = item.realPayAmount;
        it["shareMemberId"] = item.shareMemberId;
        it["tableId"] = item.tableId;
        it["tableNo"] = item.tableNo;
        it["tableName"] = item.tableName;
        //组装做法
        var flavors = new List<Map<String, dynamic>>();
        if (item.flavors != null && item.flavors.length > 0) {
          item.flavors.forEach((f) {
            var dic = new Map<String, dynamic>();
            dic["clientId"] = f.id;
            dic["clientOrderId"] = f.orderId;
            dic["tradeNo"] = f.tradeNo;
            dic["clientOrderItemId"] = f.itemId;
            dic["makeId"] = f.makeId;
            dic["code"] = f.code;
            dic["name"] = f.name;
            dic["qtyFlag"] = f.qtyFlag;
            dic["quantity"] = f.quantity;
            dic["refund"] = f.refundQuantity;
            dic["salePrice"] = f.salePrice;
            dic["price"] = f.price;
            dic["type"] = f.type;
            dic["isRadio"] = f.isRadio;
            dic["finishDate"] = f.finishDate;
            dic["groupId"] = f.group;
            dic["amount"] = f.amount;
            dic["discountAmount"] = f.discountAmount;
            dic["discountRate"] = f.discountRate;
            dic["receivableAmount"] = f.receivableAmount;
            dic["hand"] = f.hand;
            dic["baseQuantity"] = f.baseQuantity;
            dic["description"] = f.description;

            flavors.add(dic);
          });
        }
        it["makes"] = flavors;

        //组装单品促销
        var itemPromotions = new List<Map<String, dynamic>>();
        if (item.promotions != null && item.promotions.length > 0) {
          item.promotions.forEach((p) {
            var dic = new Map<String, dynamic>();
            dic["clientId"] = p.id;
            dic["clientOrderId"] = p.orderId;
            dic["tradeNo"] = p.tradeNo;
            dic["clientOrderItemId"] = p.itemId;
            dic["onlineFlag"] = p.onlineFlag;
            dic["promotionType"] = p.promotionType.value;
            dic["scheduleId"] = p.scheduleId;
            dic["scheduleSn"] = p.scheduleSn;
            dic["promotionId"] = p.promotionId;
            dic["promotionSn"] = p.promotionSn;
            dic["promotionMode"] = p.promotionMode;
            dic["scopeType"] = p.scopeType;
            dic["promotionPlan"] = p.promotionPlan;
            dic["amount"] = p.amount;
            dic["discountAmount"] = p.discountAmount;
            dic["receivableAmount"] = p.receivableAmount;
            dic["discountRate"] = p.discountRate;
            dic["enabled"] = p.enabled;
            dic["couponId"] = p.couponId;
            dic["couponNo"] = p.couponNo;
            dic["couponName"] = p.couponName;
            dic["finishDate"] = p.finishDate;
            dic["relationId"] = p.relationId;

            itemPromotions.add(dic);
          });
        }
        it["promotions"] = itemPromotions;

        //商品分摊支付方式
        var itemPays = new List<Map<String, dynamic>>();
        if (item.itemPays != null && item.itemPays.length > 0) {
          item.itemPays.forEach((p) {
            var dic = new Map<String, dynamic>();
            dic["clientId"] = p.id;
            dic["clientOrderId"] = p.orderId;
            dic["tradeNo"] = p.tradeNo;
            dic["clientOrderItemId"] = p.itemId;
            dic["clientPayId"] = p.payId;
            dic["no"] = p.no;
            dic["name"] = p.name;
            dic["storeId"] = order.storeId;
            dic["storeNo"] = order.storeNo;
            dic["storeName"] = order.storeName;
            dic["productId"] = p.productId;
            dic["productName"] = item.productName;
            dic["specId"] = p.specId;
            dic["specName"] = item.specName;
            dic["couponId"] = p.couponId;
            dic["couponNo"] = p.couponNo;
            dic["couponName"] = p.couponName;
            dic["faceAmount"] = p.faceAmount;
            dic["shareCouponLeastCost"] = p.shareCouponLeastCost;
            dic["shareAmount"] = p.shareAmount;
            dic["refundAmount"] = p.refundAmount;
            dic["finishDate"] = p.finishDate;

            itemPays.add(dic);
          });
        }
        it["itemPays"] = itemPays;

        items.add(it);
      });

      //组装整单促销
      var orderPromotions = new List<Map<String, dynamic>>();
      if (order.promotions != null && order.promotions.length > 0) {
        order.promotions.forEach((p) {
          var dic = new Map<String, dynamic>();
          dic["clientId"] = p.id;
          dic["clientOrderId"] = p.orderId;
          dic["tradeNo"] = p.tradeNo;
          dic["clientOrderItemId"] = p.itemId;
          dic["onlineFlag"] = p.onlineFlag;
          dic["promotionType"] = p.promotionType.value;
          dic["scheduleId"] = p.scheduleId;
          dic["scheduleSn"] = p.scheduleSn;
          dic["promotionId"] = p.promotionId;
          dic["promotionSn"] = p.promotionSn;
          dic["promotionMode"] = p.promotionMode;
          dic["scopeType"] = p.scopeType;
          dic["promotionPlan"] = p.promotionPlan;
          dic["amount"] = p.amount;
          dic["discountAmount"] = p.discountAmount;
          dic["receivableAmount"] = p.receivableAmount;
          dic["discountRate"] = p.discountRate;
          dic["enabled"] = p.enabled;
          dic["couponId"] = p.couponId;
          dic["couponNo"] = p.couponNo;
          dic["couponName"] = p.couponName;
          dic["finishDate"] = p.finishDate;
          dic["relationId"] = p.relationId;

          orderPromotions.add(dic);
        });
      }

      //组装支付
      var pays = new List<Map<String, dynamic>>();
      if (order.pays != null && order.pays.length > 0) {
        order.pays.forEach((p) {
          var dic = new Map<String, dynamic>();
          dic["clientId"] = p.id;
          dic["clientOrderId"] = p.orderId;
          dic["tradeNo"] = p.tradeNo;
          dic["orderNo"] = p.orderNo;
          dic["no"] = p.no;
          dic["name"] = p.name;
          dic["amount"] = p.amount;
          dic["inputAmount"] = p.inputAmount;
          dic["faceAmount"] = p.faceAmount;
          dic["paidAmount"] = p.paidAmount;
          dic["overAmount"] = p.overAmount;
          dic["changeAmount"] = p.changeAmount;
          dic["platformDiscount"] = p.platformDiscount;
          dic["platformPaid"] = p.platformPaid;
          dic["payNo"] = p.payNo;
          dic["prePayNo"] = p.prePayNo;
          dic["channelNo"] = p.channelNo;
          dic["voucherNo"] = p.voucherNo;
          dic["status"] = p.status.value;
          dic["statusDesc"] = p.statusDesc;
          dic["subscribe"] = p.subscribe;
          dic["useConfirmed"] = p.useConfirmed;
          dic["accountName"] = p.accountName;
          dic["bankType"] = p.bankType;
          dic["memo"] = p.memo;
          dic["payTime"] = p.payTime;
          dic["finishDate"] = p.finishDate;
          dic["payChannel"] = p.payChannel.value;
          dic["pointFlag"] = p.pointFlag;
          dic["incomeFlag"] = p.incomeFlag;
          dic["cardNo"] = p.cardNo;
          dic["cardPreAmount"] = p.cardPreAmount;
          dic["cardAftAmount"] = p.cardAftAmount;
          dic["cardChangeAmount"] = p.cardChangeAmount;
          dic["cardPrePoint"] = p.cardPrePoint;
          dic["cardChangePoint"] = p.cardChangePoint;
          dic["cardAftPoint"] = p.cardAftPoint;
          dic["memberMobileNo"] = p.memberMobileNo;
          dic["cardFaceNo"] = p.cardFaceNo;
          dic["shiftId"] = p.shiftId;
          dic["shiftNo"] = p.shiftNo;
          dic["shiftName"] = p.shiftName;
          dic["couponId"] = p.couponId;

          dic["couponNo"] = p.couponNo;
          dic["couponName"] = p.couponName;
          dic["couponLeastCost"] = p.couponLeastCost;

          pays.add(dic);
        });
      }

      //组装桌台数据
      var tables = new List<Map<String, dynamic>>();
      if (order.tables != null && order.tables.length > 0) {
        for (var table in order.tables) {
          var it = new Map<String, dynamic>();
          it["clientId"] = table.id;
          it["clientOrderId"] = table.orderId;
          it["tradeNo"] = table.tradeNo;
          it["tableId"] = table.tableId;
          it["tableNo"] = table.tableNo;
          it["tableName"] = table.tableName;
          it["typeId"] = table.typeId;
          it["typeNo"] = table.typeNo;
          it["typeName"] = table.typeName;
          it["areaId"] = table.areaId;
          it["areaNo"] = table.areaNo;
          it["areaName"] = table.areaName;
          it["tableStatus"] = table.tableStatus;
          it["openTime"] = table.openTime;
          it["openUser"] = table.openUser;
          it["tableNumber"] = table.tableNumber;
          it["serialNo"] = table.serialNo;
          it["tableAction"] = table.tableAction;
          it["people"] = table.people;
          it["excessFlag"] = table.excessFlag;
          it["totalAmount"] = table.totalAmount;
          it["totalQuantity"] = table.totalQuantity;
          it["discountAmount"] = table.discountAmount;
          it["totalRefund"] = table.totalRefund;
          it["totalRefundAmount"] = table.totalRefundAmount;
          it["totalGive"] = table.totalGive;
          it["totalGiveAmount"] = table.totalGiveAmount;
          it["discountRate"] = table.discountRate;
          it["receivableAmount"] = table.receivableAmount;
          it["paidAmount"] = table.paidAmount;
          it["malingAmount"] = table.malingAmount;
          it["maxOrderNo"] = table.maxOrderNo;
          it["masterTable"] = table.masterTable;
          it["perCapitaAmount"] = table.perCapitaAmount;
          it["posNo"] = table.posNo;
          it["payNo"] = table.payNo;
          it["finishDate"] = table.finishDate;

          tables.add(it);
        }
      }

      //组装主单数据
      var data = new Map<String, dynamic>();

      data["clientId"] = order.id;
      data["storeId"] = order.storeId;
      data["storeNo"] = order.storeNo;
      data["storeName"] = order.storeName;
      data["objectId"] = order.objectId;
      data["tradeNo"] = order.tradeNo;
      data["orderNo"] = order.orderNo;

      data["workerNo"] = order.workerNo;
      data["workerName"] = order.workerName;
      data["posNo"] = order.posNo;
      data["deviceName"] = order.deviceName;
      data["macAddress"] = order.macAddress;
      data["ipAddress"] = order.ipAddress;
      data["salesCode"] = order.salesCode;
      data["salesName"] = order.salesName;
      data["tableNo"] = order.tableNo;
      data["tableName"] = order.tableName;

      data["people"] = order.people;
      data["shiftId"] = order.shiftId;
      data["shiftNo"] = order.shiftNo;
      data["shiftName"] = order.shiftName;
      data["saleDate"] = order.saleDate;
      data["finishDate"] = order.finishDate;
      data["weeker"] = order.weeker;
      data["weather"] = order.weather;
      data["totalQuantity"] = order.totalQuantity;
      data["itemCount"] = order.itemCount;
      data["payCount"] = order.payCount;
      data["amount"] = order.amount;
      data["discountAmount"] = order.discountAmount;
      data["receivableAmount"] = order.receivableAmount;
      data["paidAmount"] = order.paidAmount;
      data["receivedAmount"] = order.receivedAmount;
      data["malingAmount"] = order.malingAmount;
      data["changeAmount"] = order.changeAmount;

      data["invoicedAmount"] = order.invoicedAmount;
      data["overAmount"] = order.overAmount;
      data["isMember"] = order.isMember;
      data["memberName"] = order.memberName ?? "";
      data["memberMobileNo"] = order.memberMobileNo ?? "";
      data["memberNo"] = order.memberNo ?? "";
      data["memberId"] = order.memberId ?? "";
      data["cardFaceNo"] = order.cardFaceNo ?? "";
      data["prePoint"] = order.prePoint;
      data["addPoint"] = order.addPoint;
      data["aftPoint"] = order.aftPoint;
      data["remark"] = order.remark;
      data["discountRate"] = order.discountRate;
      data["postWay"] = order.postWay.value;
      data["orderSource"] = order.orderSource.value;

      data["orderStatus"] = order.orderStatus.value;
      data["paymentStatus"] = order.paymentStatus.value;
      data["orgTradeNo"] = order.orgTradeNo;
      data["refundCause"] = order.refundCause;
      data["receivableRemoveCouponAmount"] = order.receivableRemoveCouponAmount;
      data["isPlus"] = order.isPlus;
      data["freightAmount"] = order.freightAmount;
      data["realPayAmount"] = order.realPayAmount;
      data["orderItems"] = items;
      data["pays"] = pays;
      data["orderPromotions"] = orderPromotions;
      data["orderUploadSource"] = order.orderUploadSource.value;
      data["orderTables"] = tables;

      ///zhangy 2020-10-28 Add 添加订单退款状态
      data["refundStatus"] = order.refundStatus.value;

      return Tuple2<bool, String>(true, json.encode(data));
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      return Tuple2<bool, String>(false, "发生异常");
    }
  }

  ///获取商品分类列表
  Future<List<ProductCategory>> getCategoryList() async {
    List<ProductCategory> result = new List<ProductCategory>();
    try {
      String sql = sprintf(
          "select id,tenantId,parentId,name,code,path,categoryType,english,returnRate,description,orderNo,deleteFlag,products,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_product_category where deleteFlag = 0  and products > 0 order by orderNo asc;",
          []);

      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      result = ProductCategory.toList(lists);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取商品分类发生异常:" + e.toString());
    }
    return result;
  }

  ///获取快捷菜单数据
  Future<List<Module>> getModule(
      {List<String> moduleNames, bool orderBy = true}) async {
    List<Module> result = new List<Module>();
    try {
      String sql = "select * from pos_module ";

      if (moduleNames != null && moduleNames.length > 0) {
        String whereCondition = JsonEncoder().convert(moduleNames);
        whereCondition = whereCondition.substring(1, whereCondition.length - 1);
        sql += " where `name` in ($whereCondition) ";
      }

      if (orderBy) {
        sql += " order by orderNo asc; ";
      }

      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      result = Module.toList(lists);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取POS功能模块发生异常:" + e.toString());
    }
    return result;
  }

  ///获取快捷菜单数据
  Future<List<Module>> getShortcutModule() async {
    List<Module> result = new List<Module>();
    try {
      String sql = sprintf(
          "select id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate from pos_module where area = '%s' order by orderNo asc;",
          ["快捷"]);
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      result = Module.toList(lists);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取POS功能模块发生异常:" + e.toString());
    }
    return result;
  }

  ///获取更多功能数据
  Future<List<Module>> getMoreModule() async {
    List<Module> result = new List<Module>();
    try {
      String sql = sprintf(
          "select id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate from pos_module where area = '%s' order by orderNo asc;",
          ["更多"]);
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      result = Module.toList(lists);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取POS功能模块发生异常:" + e.toString());
    }
    return result;
  }
}
