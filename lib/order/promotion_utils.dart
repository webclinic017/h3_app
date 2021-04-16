import 'package:h3_app/constants.dart';
import 'package:h3_app/enums/order_item_row_type.dart';
import 'package:h3_app/enums/promotion_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';

import 'order_item.dart';
import 'order_item_promotion.dart';
import 'order_object.dart';
import 'order_promotion.dart';

class PromotionUtils {
  // 工厂模式
  factory PromotionUtils() => _getInstance();
  static PromotionUtils get instance => _getInstance();
  static PromotionUtils _instance;

  static PromotionUtils _getInstance() {
    if (_instance == null) {
      _instance = new PromotionUtils._internal();
    }
    return _instance;
  }

  PromotionUtils._internal();

  /// 创建新的订单项促销
  OrderItemPromotion newOrderItemPromotion(
      OrderItem orderItem, PromotionType promotionType) {
    var promotion = new OrderItemPromotion();

    //标识
    promotion.id = IdWorkerUtils.getInstance().generate().toString();
    //租户ID
    promotion.tenantId = orderItem.tenantId;
    //订单ID
    promotion.orderId = orderItem.orderId;
    //订单编号
    promotion.tradeNo = orderItem.tradeNo;
    //单品编号
    promotion.itemId = orderItem.id;
    //类型
    promotion.promotionType = promotionType;
    if (promotionType == PromotionType.OnlinePromotion) {
      promotion.onlineFlag = 1;
    } else {
      promotion.onlineFlag = 0;
    }

    //操作人
    promotion.createUser = Global.instance.worker.no;
    //操作日期
    promotion.createDate =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

    promotion.sourceSign = Constants.TERMINAL_TYPE;

    return promotion;
  }

  /// 创建新的订单促销
  OrderPromotion newOrderPromotion(OrderObject orderObject,
      {PromotionType promotionType = PromotionType.None}) {
    var promotion = new OrderPromotion();
    //标识
    promotion.id = IdWorkerUtils.getInstance().generate().toString();
    //租户ID
    promotion.tenantId = orderObject.tenantId;
    //订单ID
    promotion.orderId = orderObject.id;
    //订单编号
    promotion.tradeNo = orderObject.tradeNo;
    //类型
    promotion.promotionType = promotionType;
    //操作人
    promotion.createUser = Global.instance.worker.no;
    //操作日期
    promotion.createDate =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

    promotion.sourceSign = Constants.TERMINAL_TYPE;

    return promotion;
  }

  /// 整单优惠分摊
  /// 整单分摊的说明：即使最低价限制，在整单面前无效，都要执行分摊
  void calculate(OrderObject orderObject, OrderPromotion orderPromotion,
      {List<OrderItem> itemList}) {
    try {
      switch (orderPromotion.promotionType) {
        case PromotionType.Coupon:
          {
            List<OrderItem> fineDiscountItem = orderObject.items
                .where((x) =>
                    x.rowType != OrderItemRowType.Detail &&
                    x.rowType != OrderItemRowType.SuitDetail &&
                    x.foreDiscount == 1)
                .toList();

            var discount = orderPromotion.discountRate;
            double discountAmountSum = 0;

            for (var item in fineDiscountItem) {
              OrderItemPromotion promotion =
                  newOrderItemPromotion(item, orderPromotion.promotionType);

              promotion.relationId = orderPromotion.id;
              promotion.couponId = orderPromotion.couponId; //每张券的ID
              promotion.couponNo = orderPromotion.couponNo;
              promotion.sourceSign = orderPromotion.sourceSign;
              promotion.couponName = orderPromotion.couponName;
              promotion.promotionId = orderPromotion.promotionId;
              promotion.promotionSn = orderPromotion.promotionSn;
              promotion.promotionMode = orderPromotion.promotionMode;
              promotion.reason = orderPromotion.reason;

              promotion.onlineFlag = 0;
              promotion.bargainPrice =
                  OrderUtils.instance.toRound(item.price * discount);
              promotion.discountRate = discount;
              promotion.enabled = 0;

              item.promotions.add(promotion);

              var _effectiveQuantity = item.quantity - item.refundQuantity;
              discountAmountSum += OrderUtils.instance.toRound(
                  (item.price - promotion.bargainPrice) * _effectiveQuantity);
            }

            orderPromotion.discountAmount = discountAmountSum;
          }
          break;
        case PromotionType.OrderDiscount:
          {
            List<OrderItem> fineDiscountItem = orderObject.items;

            //如果订单包含赠品，分摊议价金额的时候需要去除赠品
            fineDiscountItem = orderObject.items
                .where((x) =>
                    !x.promotions
                        .any((y) => y.promotionType == PromotionType.Gift) &&
                    x.rowType != OrderItemRowType.Detail &&
                    x.rowType != OrderItemRowType.SuitDetail)
                .toList();

            //禁止前台打折的商品允许做整单折扣
            var noBargainElseSwitch =
                "0"; //DataCacheManager.GetLineSalesSetting("allow_order_bargin_for_bandiscount_product");
            if (noBargainElseSwitch == "0") {
              //不允许，需要排除不允许前台议价的商品金额
              fineDiscountItem =
                  fineDiscountItem.where((x) => x.foreDiscount == 1).toList();
            }

            //参与促销优惠后的商品允许再做整单打折或议价是否启用 0-否，1-是
            var allowOrderDiscountForPromotion =
                "0"; //DataCacheManager.GetLineSalesSetting("allow_order_discount_for_promotioned_product");
            if (allowOrderDiscountForPromotion == "0") {
              fineDiscountItem = fineDiscountItem
                  .where((x) => !x.promotions.any(
                      (y) => y.promotionType == PromotionType.OnlinePromotion))
                  .toList();
            }

            FLogger.info(
                "整单商品数量:${orderObject.items.length},参与整单折扣的商品清单:${fineDiscountItem.length}");

            double discountRate = orderPromotion.discountRate;
            double discountAmountSum = 0.0;

            FLogger.info("折扣率:$discountRate");

            if (fineDiscountItem != null && fineDiscountItem.length > 0) {
              for (var item in fineDiscountItem) {
                OrderItemPromotion promotion;
                if (item.promotions != null &&
                    item.promotions.any((x) =>
                        x.promotionType == orderPromotion.promotionType)) {
                  //订单中包含整单折扣优惠时，先去掉整单折扣，再计算商品价格
                  item.promotions.removeWhere(
                      (x) => x.promotionType == orderPromotion.promotionType);
                  OrderUtils.instance.calculateOrderItem(item);
                }

                promotion =
                    newOrderItemPromotion(item, orderPromotion.promotionType);
                item.promotions.add(promotion);

                promotion.onlineFlag = 0;
                promotion.reason = orderPromotion.reason;
                promotion.bargainPrice =
                    OrderUtils.instance.toRound(item.price * discountRate);
                promotion.discountRate = discountRate;
                promotion.enabled = 0;
                promotion.relationId = orderPromotion.id;
                var _effectiveQuantity = item.quantity - item.refundQuantity;
                discountAmountSum += OrderUtils.instance.toRound(
                    (item.price - promotion.bargainPrice) * _effectiveQuantity);
              }

              FLogger.info("折扣总金额:$discountAmountSum");

              orderPromotion.discountAmount = discountAmountSum;
            } else {
              //没有能够适用的商品，删除该优惠
              orderObject.promotions
                  .removeWhere((x) => x.id == orderPromotion.id);
            }
          }
          break;
        case PromotionType.OrderReduction:
        case PromotionType.OrderBargain:
          {
            List<OrderItem> fineBargainItem = orderObject.items;
            //优惠金额减去赠品金额
            var giftOrderItem = orderObject.items
                .where((x) => x.promotions
                    .any((y) => y.promotionType == PromotionType.Gift))
                .toList();
            double giftAmount = 0.0;
            if (giftOrderItem != null && giftOrderItem.length > 0) {
              giftAmount = giftOrderItem
                  .map((e) => e.discountAmount)
                  .fold(0, (prev, amount) => prev + amount);
            }

            orderPromotion.discountAmount -= giftAmount;

            //如果订单包含赠品，分摊议价金额的时候需要去除赠品
            fineBargainItem = orderObject.items
                .where((x) =>
                    !x.promotions
                        .any((y) => y.promotionType == PromotionType.Gift) &&
                    x.rowType != OrderItemRowType.Detail &&
                    x.rowType != OrderItemRowType.SuitDetail)
                .toList();
            //禁止前台议价的商品允许做整单议价
            var noBargainElseSwitch =
                "0"; //DataCacheManager.GetLineSalesSetting("allow_order_bargin_for_bandiscount_product");
            if (noBargainElseSwitch == "0") {
              //不允许，需要排除不允许前台议价的商品金额
              fineBargainItem =
                  fineBargainItem.where((x) => x.foreBargain == 1).toList();
            }

            //参与促销优惠后的商品允许再做整单议价是否启用 0-否，1-是
            var allowOrderDiscountForPromotion =
                "0"; //DataCacheManager.GetLineSalesSetting("allow_order_discount_for_promotioned_product");
            if (allowOrderDiscountForPromotion == "0") {
              fineBargainItem = fineBargainItem
                  .where((x) => !x.promotions.any(
                      (y) => y.promotionType == PromotionType.OnlinePromotion))
                  .toList();
            }

            var discountAmountSum = orderPromotion.discountAmount;
            double sharedAmountSum = 0.0;
            int i = 0;

            FLogger.info(
                "整单商品数量:${orderObject.items.length},参与整单议价的商品清单:${fineBargainItem.length}");

            FLogger.info("总议价优惠金额:$discountAmountSum");

            for (var item in fineBargainItem) {
              i++;
              double share = 0.0;
              if (i >= fineBargainItem.length) {
                //最后一个，做减法
                share = OrderUtils.instance
                    .toRound(discountAmountSum - sharedAmountSum);
              } else {
                var rate = item.amount / orderObject.amount;
                share = OrderUtils.instance.toRound(discountAmountSum * rate);
              }
              if (orderPromotion.discountAmount >= 0 && share <= 0) {
                continue;
              }

              FLogger.info("分摊金额:$share");

              //计算单价
              var effectiveQuantity = item.quantity - item.refundQuantity;
              var discountPrice =
                  OrderUtils.instance.toRound(share / effectiveQuantity);

              if (OrderUtils.instance
                      .toRound(discountPrice * effectiveQuantity) >
                  share) {
                //这里说明经过除法计算后的优惠金额大于了本应分摊的金额，这里将优惠价格-0.01，这样优惠后的商品价格会上升，金额会下降，会存在表面看着价格*数量>金额的现象
                discountPrice -= 0.01;
              }

              if (item.promotions != null &&
                  item.promotions.any(
                      (x) => x.promotionType == orderPromotion.promotionType)) {
                //订单中包含整单折扣优惠时，先去掉整单折扣，再计算商品价格
                item.promotions.removeWhere(
                    (x) => x.promotionType == orderPromotion.promotionType);
                OrderUtils.instance.calculateOrderItem(item);
              }

              OrderItemPromotion promotion =
                  newOrderItemPromotion(item, orderPromotion.promotionType);
              item.promotions.add(promotion);

              promotion.onlineFlag = 0;
              promotion.reason = orderPromotion.reason;
              promotion.bargainPrice = item.salePrice - discountPrice;
              promotion.enabled = 0;
              promotion.relationId = orderPromotion.id;

              var currentShare = OrderUtils.instance.toRound(
                  (item.salePrice - promotion.bargainPrice) *
                      effectiveQuantity);
              //调整金额 = 本应分摊金额 - 实际分摊金额。在计算本行优惠金额的时候，需要+调整金额
              promotion.adjustAmount = share - currentShare;

              sharedAmountSum += share;
              //不去掉的话促销商品进行改价时，只显示商品议价，不显示商品促销
              //item.Promotions.RemoveAll(x => x.PromotionType != promotionOrder.PromotionType);
            }
          }
          break;
        case PromotionType.OnlinePromotion:
          {}
          break;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("整单优惠分摊发生异常:" + e.toString());
    }
  }
}
