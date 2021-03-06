// import 'dart:collection';
// import 'dart:convert';

// import 'package:dart_extensions/dart_extensions.dart';
// import 'package:h3_app/constants.dart';
// import 'package:h3_app/entity/pos_advert_picture.dart';
// import 'package:h3_app/entity/pos_base_parameter.dart';
// import 'package:h3_app/entity/pos_config.dart';
// import 'package:h3_app/entity/pos_make_info.dart';
// import 'package:h3_app/entity/pos_module.dart';
// import 'package:h3_app/entity/pos_pay_mode.dart';
// import 'package:h3_app/entity/pos_payment_group_parameter.dart';
// import 'package:h3_app/entity/pos_payment_parameter.dart';
// import 'package:h3_app/entity/pos_print_img.dart';
// import 'package:h3_app/entity/pos_product.dart';
// import 'package:h3_app/entity/pos_product_category.dart';
// import 'package:h3_app/entity/pos_product_make.dart';
// import 'package:h3_app/entity/pos_product_spec.dart';
// import 'package:h3_app/entity/pos_store_make.dart';
// import 'package:h3_app/enums/cashier_action_type.dart';
// import 'package:h3_app/enums/maling_enum.dart';
// import 'package:h3_app/enums/online_pay_bus_type_enum.dart';
// import 'package:h3_app/enums/order_item_join_type.dart';
// import 'package:h3_app/enums/order_item_row_type.dart';
// import 'package:h3_app/enums/order_payment_status_type.dart';
// import 'package:h3_app/enums/order_refund_status.dart';
// import 'package:h3_app/enums/order_source_type.dart';
// import 'package:h3_app/enums/order_status_type.dart';
// import 'package:h3_app/enums/order_table_action.dart';
// import 'package:h3_app/enums/order_table_status.dart';
// import 'package:h3_app/enums/pay_parameter_sign_enum.dart';
// import 'package:h3_app/enums/promotion_type.dart';
// import 'package:h3_app/global.dart';
// import 'package:h3_app/logger/logger.dart';
// import 'package:h3_app/number/decimal.dart';
// import 'package:h3_app/number/number.dart';
// import 'package:h3_app/order/product_ext.dart';
// import 'package:h3_app/order/promotion_utils.dart';
// import 'package:h3_app/payment/scan_pay_result.dart';
// import 'package:h3_app/utils/cache_manager.dart';
// import 'package:h3_app/utils/converts.dart';
// import 'package:h3_app/utils/date_utils.dart';
// import 'package:h3_app/utils/device_utils.dart';
// import 'package:h3_app/utils/idworker_utils.dart';
// import 'package:h3_app/utils/image_utils.dart';
// import 'package:h3_app/utils/sql_utils.dart';
// import 'package:h3_app/utils/stack_trace.dart';
// import 'package:h3_app/utils/string_utils.dart';
// import 'package:h3_app/utils/tuple.dart';
// import 'package:sprintf/sprintf.dart';

// import 'order_item.dart';
// import 'order_item_make.dart';
// import 'order_item_pay.dart';
// import 'order_item_promotion.dart';
// import 'order_object.dart';
// import 'order_pay.dart';
// import 'order_promotion.dart';
// import 'order_table.dart';

// class OrderUtils {
//   // ????????????
//   factory OrderUtils() => _getInstance();

//   static OrderUtils get instance => _getInstance();
//   static OrderUtils _instance;

//   static OrderUtils _getInstance() {
//     if (_instance == null) {
//       _instance = new OrderUtils._internal();
//     }
//     return _instance;
//   }

//   OrderUtils._internal();

//   ///???????????????????????????
//   void calculateOrderItem(OrderItem master, {bool allOrder = false}) {
//     //???????????????
//     bool isRefund = master.refundQuantity > 0;
//     //????????????????????? = ????????? *  ??????
//     master.refundAmount = OrderUtils.instance.toRound(master.refundQuantity * master.price);
//     //??????????????????????????????????????????????????????????????????????????????
//     if (isRefund) {
//       if (master.refundQuantity == master.quantity) {
//         //?????????????????????????????????????????????
//         master.giftQuantity = 0;
//         //??????????????????
//         master.giftAmount = 0;
//         //??????????????????
//         master.giftReason = "";

//         //????????????????????????
//         if (master.promotions != null) {
//           master.promotions.clear();
//         }
//       } else {
//         if ((master.refundQuantity + master.giftQuantity) > master.quantity) {
//           //?????????????????????????????????????????????
//           master.giftQuantity = 0;
//           //??????????????????
//           master.giftAmount = 0;
//           //??????????????????
//           master.giftReason = "";

//           //????????????????????????
//           if (master.promotions != null) {
//             master.promotions.removeWhere((x) => x.orderId == master.orderId && x.itemId == master.id && x.promotionType == PromotionType.Gift);
//           }
//         }
//       }
//     }

//     //?????????????????? = ?????? - ?????? - ??????
//     var _effectiveQuantity = master.quantity - master.refundQuantity - master.giftQuantity;

//     //???????????? = ???????????? * ?????????????????????????????????????????????
//     master.amount = OrderUtils.instance.toRound((master.quantity - master.refundQuantity) * master.salePrice, precision: 2);
//     //?????????????????????
//     master.price = master.salePrice;
//     //?????????
//     master.bargainReason = "";

//     //???????????????(?????????giftQuantity?????????)
//     bool isGift = master.giftQuantity.abs() > 0;
//     if (isGift) {
//       //????????????????????????
//       master.promotions.clear();

//       //?????????????????????
//       double giftQuantity = master.giftQuantity;
//       //?????????????????????
//       String giftReason = master.giftReason;

//       //?????????????????????????????????????????????
//       OrderItemPromotion promotion = PromotionUtils.instance.newOrderItemPromotion(master, PromotionType.Gift);
//       master.promotions.add(promotion);
//       //?????????????????????????????????
//       master.giftAmount = OrderUtils.instance.toRound(master.giftQuantity * master.salePrice);
//       master.price = 0.0;
//       //????????????
//       promotion.reason = giftReason;
//       promotion.bargainPrice = 0.0;
//       //????????????
//       promotion.discountAmount = master.giftAmount;
//     } else {
//       //????????????????????????????????????
//       master.giftQuantity = 0;
//       master.giftAmount = 0;
//       master.giftReason = "";
//       if (master.promotions != null && master.promotions.any((x) => x.promotionType == PromotionType.Gift)) {
//         master.promotions.removeWhere((x) => x.promotionType == PromotionType.Gift);
//       }
//     }

//     //??????????????????????????????plus?????????
//     if (master.productExt != null) {
//       // if (master.productExt.plusFlag && master.promotions.any((x) => x.promotionType == PromotionType.PlusPriceDiscount)) {
//       //   master.isPlusPrice = 1;
//       // }
//     }

//     //????????????
//     if (master.promotions != null && master.promotions.length > 0) {
//       master.promotions.sort((left, right) => left.createDate.compareTo(right.createDate));
//       master.promotions.forEach((item) {
//         _calculateItem(master, item);
//       });
//     }

//     // //??????????????????
//     // var attendPromotions = master.attendPromotions;
//     // //???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
//     // if (allOrder)
//     // {
//     //   //??????????????????????????????????????????????????????????????????????????? 0-??????1-???
//     //   var allowOrderBargainForPromotion = DataCacheManager.GetLineSalesSetting("allow_order_discount_for_promotioned_product");
//     //   if (!string.IsNullOrEmpty(allowOrderBargainForPromotion) && allowOrderBargainForPromotion.Equals("1"))
//     //   {
//     //     attendPromotions = null;
//     //   }
//     // }
//     // if (attendPromotions != null && attendPromotions.Count > 0)
//     // {
//     //   var enablePromotion = attendPromotions.FindAll(x => x.Enabled);
//     //   if (enablePromotion != null && enablePromotion.Count > 0)
//     //   {
//     //     var finePromotion = enablePromotion.OrderBy(x => x.BargainPrice).First();
//     //     if (finePromotion.BargainPrice < master.Price)
//     //     {
//     //       //??????????????????
//     //       master.Promotions = new List<PromotionItem>();
//     //       //??????????????????
//     //       master.Price = master.SalePrice;
//     //       //?????????????????????
//     //       master.BargainReason = null;
//     //       //???????????????
//     //       CalculateItem(master, finePromotion);
//     //     }
//     //   }
//     // }

//     //????????????????????????
//     if (master.flavors != null && master.rowType != OrderItemRowType.Master && master.rowType != OrderItemRowType.SuitMaster) {
//       //??????????????????
//       StringBuffer flavorNames = new StringBuffer();

//       for (var x in master.flavors) {
//         x.itemQuantity = _effectiveQuantity;
//         //??????????????????????????????:1??????????????????????????????2?????????????????????????????????????????????
//         x.quantity = x.baseQuantity * x.itemQuantity;
//         switch (x.qtyFlag) {
//           case 1:
//             {
//               //?????????
//               x.amount = 0;
//             }
//             break;
//           case 2:
//             {
//               //????????????
//               x.amount = OrderUtils.instance.toRound(x.itemQuantity * x.price, precision: 2);
//             }
//             break;
//           case 3:
//             {
//               //???????????????
//               x.amount = OrderUtils.instance.toRound(x.quantity * x.price, precision: 2);
//             }
//             break;
//           default:
//             {
//               //?????????
//               x.amount = 0;
//             }
//             break;
//         }
//         x.discountAmount = 0.0;
//         x.receivableAmount = x.amount - x.discountAmount;

//         if (flavorNames.length > 0) {
//           flavorNames.write(",");
//         }
//         flavorNames.write("${x.name}");
//         if (x.salePrice > 0) {
//           flavorNames.write("*??${OrderUtils.instance.removeDecimalZeroFormat(x.salePrice, precision: 2)}");
//         }
//         if (x.quantity > 1) {
//           flavorNames.write("*${OrderUtils.instance.removeDecimalZeroFormat(x.quantity)}");
//         }
//       }

//       //???????????????????????????
//       master.flavorNames = flavorNames.toString();
//       //??????????????????
//       master.flavorAmount = master.flavors.map((e) => e.amount).fold(0, (prev, amount) => prev + amount);
//       //??????????????????
//       master.flavorDiscountAmount = master.flavors.map((e) => e.discountAmount).fold(0, (prev, discountAmount) => prev + discountAmount);
//       //??????????????????
//       master.flavorReceivableAmount = master.flavors.map((e) => e.receivableAmount).fold(0, (prev, receivableAmount) => prev + receivableAmount);
//     }

//     //???????????????
//     double discountAmount = 0;
//     master.promotions.forEach((item) {
//       discountAmount += item.discountAmount;
//     });
//     master.discountAmount = OrderUtils.instance.toRound(discountAmount, precision: 4);

//     if (master.joinType == OrderItemJoinType.ScanAmountCode && master.discountAmount == 0) {
//       //??????????????????????????????  ????????????????????????????????????
//       master.amount = master.labelAmount;
//       master.receivableAmount = master.labelAmount;
//     } else {
//       //??????????????? = ???????????? - ?????????master.RefundAmount - ????????????
//       master.receivableAmount = OrderUtils.instance.toRound(master.amount - master.discountAmount, precision: 2);
//     }

//     // //???????????????????????????????????????????????????????????????????????????
//     // if(master.cashierAction == CashierAction.?????? && master.JoinType == OrderItemJoinType.???????????????)
//     // {
//     //   //?????????????????????????????????????????????????????????(??????????????????????????????)???????????????????????????????????????(????????????????????????)
//     //   master.Amount = 0 - Math.Abs(master.LabelAmount);
//     //   master.ReceivableAmount = 0 - Math.Abs(master.LabelAmount);
//     // }

//     //??????????????????????????? = ???????????? / ??????????????????
//     master.discountRate = master.amount == 0 ? 0 : OrderUtils.instance.toRound(master.discountAmount / master.amount, precision: 4);

//     //???????????? = ???????????? + ????????????
//     master.totalAmount = master.amount + master.flavorAmount;
//     //??????????????????
//     master.totalDiscountAmount = master.discountAmount + master.flavorDiscountAmount;
//     //??????????????????
//     master.totalReceivableAmount = master.receivableAmount + master.flavorReceivableAmount;

//     //????????????
//     double couponAmount = 0;
//     //???????????????
//     double shareCouponLeastCost = 0;
//     //???????????????
//     double realPayAmount = 0;
//     master.itemPays.forEach((item) {
//       if (item.no == Constants.PAYMODE_CODE_COUPON) {
//         couponAmount += item.shareAmount;
//         shareCouponLeastCost += item.shareCouponLeastCost;
//       }
//       if (item.incomeFlag == 1) {
//         realPayAmount += item.shareAmount;
//       }
//     });
//     master.couponAmount = OrderUtils.instance.toRound(couponAmount, precision: 4);
//     //??????????????????
//     master.totalReceivableRemoveCouponAmount = master.totalReceivableAmount - master.couponAmount;
//     //???????????????
//     master.shareCouponLeastCost = OrderUtils.instance.toRound(shareCouponLeastCost, precision: 4);
//     //????????????????????????
//     master.totalReceivableRemoveCouponLeastCost = master.totalReceivableAmount - master.shareCouponLeastCost;

//     //???????????????
//     master.realPayAmount = OrderUtils.instance.toRound(realPayAmount, precision: 4);

//     //?????????
//     master.totalDiscountRate = master.totalAmount == 0 ? 0 : OrderUtils.instance.toRound(master.totalDiscountAmount / master.totalAmount, precision: 4);
//     //???????????????????????????
//     master.cartDiscount = master.totalDiscountAmount;
//     //????????? = ?????????????????????????????????????????????????????????????????????????????????????????????
//     master.discountPrice = master.price;
//     //??????
//     double malingAmount = 0;
//     if (master.promotions != null && master.promotions.length > 0) {
//       malingAmount = master.promotions.where((x) => x.promotionType == PromotionType.MalingCostSharing).map((e) => e.discountAmount).fold(0, (prev, discountAmount) => prev + discountAmount);
//     }
//     master.malingAmount = malingAmount;

//     //?????????????????????
//     StringBuffer promotionInfo = new StringBuffer();
//     if (master.promotions != null && master.promotions.length > 0) {
//       master.promotions.forEach((m) {
//         if (promotionInfo.length > 0) {
//           promotionInfo.write(",");
//         }
//         promotionInfo.write("${m.promotionType.name}${m.discountAmount}???");
//       });
//     }
//     master.promotionInfo = promotionInfo.toString();

//     print(">>>>>>???????????????>>>${master.promotionInfo}");

//     //?????????
//     master.modifyUser = Global.instance.worker.no;
//     //????????????
//     master.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//   }

//   void _calculateItem(OrderItem master, OrderItemPromotion promotion) {
//     print(">>>>>>????????????>>>${promotion.promotionType.name}");

//     switch (promotion.promotionType) {
//       case PromotionType.Coupon: //???????????????????????????
//       case PromotionType.OrderDiscount: //????????????
//       case PromotionType.ProductDiscount: //????????????
//         {
//           //????????????
//           var effectiveQuantity = master.quantity - master.giftQuantity - master.refundQuantity;
//           FLogger.info("?????????????????????<$effectiveQuantity>,?????????<${promotion.discountRate}>");
//           //???????????????????????????  ???????????????????????????????????????
//           promotion.amount = OrderUtils.instance.toRound(effectiveQuantity * master.price, precision: 2);
//           promotion.price = master.price;
//           //???????????????
//           master.price = promotion.bargainPrice;
//           master.bargainReason = promotion.reason;
//           //?????????????????? = ???????????? * ?????? * (1-?????????)
//           promotion.discountAmount = OrderUtils.instance.toRound(effectiveQuantity * (promotion.price - promotion.bargainPrice), precision: 2);

//           //??????????????????
//           promotion.receivableAmount = promotion.amount - promotion.discountAmount;

//           //?????????
//           promotion.modifyUser = Global.instance.worker.no;
//           //????????????
//           promotion.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//         }
//         break;
//       case PromotionType.OrderBargain: //????????????
//       case PromotionType.ProductBargain: //????????????
//       case PromotionType.Reduction:
//       case PromotionType.OrderReduction:
//         {
//           //????????????
//           var effectiveQuantity = master.quantity - master.refundQuantity;
//           FLogger.info("?????????????????????<$effectiveQuantity>,????????????<${promotion.bargainPrice}>");

//           //???????????????????????????  ???????????????????????????????????????
//           promotion.amount = OrderUtils.instance.toRound(effectiveQuantity * master.price);
//           promotion.price = master.price;
//           //???????????????
//           master.price = promotion.bargainPrice;
//           master.bargainReason = promotion.reason;

//           if (promotion.promotionType == PromotionType.Reduction || promotion.promotionType == PromotionType.OrderReduction) {
//             master.bargainReason = "";
//           }

//           //?????????????????? = ???????????? * (???????????? - ??????)(?????????master.SalePrice,???????????????????????????????????????????????????????????????)
//           //???????????????????????????????????????
//           promotion.discountAmount = OrderUtils.instance.toRound(effectiveQuantity * (promotion.price - promotion.bargainPrice)) + promotion.adjustAmount;
//           //???????????????
//           if (master.salePrice == 0) {
//             promotion.discountRate = 0;
//           } else {
//             promotion.discountRate = OrderUtils.instance.toRound(promotion.bargainPrice / master.salePrice, precision: 4);
//           }

//           //????????????
//           promotion.receivableAmount = promotion.amount - promotion.discountAmount;

//           //?????????
//           promotion.modifyUser = Global.instance.worker.no;
//           //????????????
//           promotion.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//         }
//         break;
//       case PromotionType.TakeawayFee: //????????????
//         {}
//         break;
//       case PromotionType.MemberLevelDiscount: //??????????????????
//         {}
//         break;
//       case PromotionType.PlusPriceDiscount: //PLUS???????????????
//         {}
//         break;
//       case PromotionType.ProductCostSharing: //??????????????????
//       case PromotionType.SuitCostSharing: //??????????????????
//         {}
//         break;
//       case PromotionType.MalingCostSharing: //????????????
//         {}
//         break;
//       case PromotionType.OnlinePromotion: //????????????
//         {}
//         break;
//     }
//   }

//   ///??????????????????
//   void refreshOrderNo(OrderObject orderObject) {
//     ///????????????
//     int rowIndex = 1;
//     orderObject.items.forEach((item) {
//       switch (item.rowType) {
//         case OrderItemRowType.Detail:
//           {
//             item.orderNo = rowIndex;
//             //??????????????????????????????????????????
//             var details = orderObject.items.where((x) => x.group == item.group && x.parentId == item.id).toList();
//             if (details != null && details.length > 0) {
//               for (var detail in details) {
//                 rowIndex++;
//                 detail.orderNo = rowIndex;
//               }
//             }
//           }
//           break;
//         case OrderItemRowType.Normal:
//           {
//             item.orderNo = rowIndex;
//           }
//           break;
//       }

//       rowIndex++;
//     });

//     orderObject.items.sortBy((x) => x.orderNo);
//   }

//   void calculateTable(OrderObject orderObject, OrderTable table) {
//     //?????????????????????1)?????????

//     //?????????????????????(???????????????????????????????????????????????????????????????????????????)
//     double unWeightCount = orderObject.items.where((item) => item.tableId == table.tableId && item.rowType != OrderItemRowType.Detail && item.rowType != OrderItemRowType.SuitDetail && item.weightFlag == 0).map((e) => e.quantity).fold(0, (prev, quantity) => prev + quantity);
//     double weightCount = orderObject.items.where((item) => item.tableId == table.tableId && item.rowType != OrderItemRowType.Detail && item.rowType != OrderItemRowType.SuitDetail && item.weightFlag == 1).map((e) => e.quantity).fold(0, (prev, quantity) => prev + quantity);

//     if (orderObject.cashierAction == CashierAction.Refund) {
//       weightCount = 0 - weightCount;
//     }
//     table.totalQuantity = unWeightCount.ceil() + weightCount;

//     //??????????????????????????????2)??????????????????;3)??????????????????;
//     var tableItems = orderObject.items.where((x) => x.tableId == table.tableId && x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail);

//     //?????????????????????????????? = ?????????????????? + ?????????????????????
//     table.totalAmount = tableItems.map((e) => e.totalAmount).fold(0, (prev, amount) => prev + amount);
//     table.totalRefund = tableItems.map((e) => e.refundQuantity).fold(0, (prev, quantity) => prev + quantity);
//     table.totalRefundAmount = tableItems.map((e) => e.refundAmount).fold(0, (prev, amount) => prev + amount); //
//     table.totalGive = tableItems.map((e) => e.giftQuantity).fold(0, (prev, quantity) => prev + quantity); //
//     table.totalGiveAmount = tableItems.map((e) => e.giftAmount).fold(0, (prev, amount) => prev + amount); //.Sum(m => m.GiftAmount);
//     table.discountAmount = tableItems.map((e) => e.totalDiscountAmount).fold(0, (prev, amount) => prev + amount); //.Sum(m => m.TotalDiscountAmount);
//     table.receivableAmount = tableItems.map((e) => e.totalReceivableAmount).fold(0, (prev, amount) => prev + amount); //.Sum(m => m.TotalReceivableAmonut);
//     table.paidAmount = table.receivableAmount;

//     //2020-12-04 zhangy Add
//     for (var t in orderObject.tables) {
//       if (t.tableId == table.tableId) {
//         t.totalQuantity = table.totalQuantity;
//         t.totalAmount = table.totalAmount;
//         t.totalRefund = table.totalRefund;
//         t.totalRefundAmount = table.totalRefundAmount;
//         t.totalGive = table.totalGive;
//         t.totalGiveAmount = table.totalGiveAmount;
//         t.discountAmount = table.discountAmount;
//         t.receivableAmount = table.receivableAmount;
//         t.paidAmount = table.receivableAmount;
//       }
//     }
//   }

//   ///????????????
//   void calculateOrderObject(OrderObject orderObject) {
//     this.calculateChangeAmount(orderObject);

//     //?????????????????????(???????????????????????????????????????????????????????????????????????????)
//     double unWeightCount = orderObject.items.where((item) => item.rowType != OrderItemRowType.Detail && item.rowType != OrderItemRowType.SuitDetail && item.weightFlag == 0).map((e) => e.quantity).fold(0, (prev, quantity) => prev + quantity);
//     double weightCount = orderObject.items.where((item) => item.rowType != OrderItemRowType.Detail && item.rowType != OrderItemRowType.SuitDetail && item.weightFlag == 1).map((e) => e.quantity).fold(0, (prev, quantity) => prev + quantity);

//     if (orderObject.cashierAction == CashierAction.Refund) {
//       weightCount = 0 - weightCount;
//     }
//     orderObject.totalQuantity = unWeightCount.ceil() + weightCount;

//     ///??????????????????,????????????+??????
//     double totalAmount = 0;
//     orderObject.items.where((item) => item.rowType != OrderItemRowType.Detail && item.rowType != OrderItemRowType.SuitDetail).forEach((item) {
//       totalAmount += item.totalAmount;
//     });

//     orderObject.amount = OrderUtils.instance.toRound(totalAmount, precision: 2);

//     //?????????????????????
//     orderObject.totalRefundQuantity = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail).map((e) => e.refundQuantity).fold(0, (prev, quantity) => prev + quantity);
//     //?????????????????????
//     orderObject.totalRefundAmount = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail).map((e) => e.refundAmount).fold(0, (prev, amount) => prev + amount);

//     //?????????????????????
//     orderObject.totalGiftQuantity = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail).map((e) => e.giftQuantity).fold(0, (prev, quantity) => prev + quantity);
//     //?????????????????????
//     orderObject.totalGiftAmount = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail).map((e) => e.giftAmount).fold(0, (prev, amount) => prev + amount);

//     //????????????,????????????+??????  ?????????????????????????????????
//     orderObject.discountAmount = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail).map((e) => e.totalDiscountAmount).fold(0, (prev, totalDiscountAmount) => prev + totalDiscountAmount);
//     //????????????,????????????+??????
//     orderObject.discountRate = orderObject.amount == 0 ? 0 : OrderUtils.instance.toRound(orderObject.discountAmount / orderObject.amount, precision: 2);
//     //????????????
//     orderObject.receivableAmount = OrderUtils.instance.toRound(orderObject.amount + orderObject.freightAmount - orderObject.discountAmount, precision: 2);
//     //????????????
//     orderObject.receivableRemoveCouponAmount = orderObject.items.map((e) => e.totalReceivableRemoveCouponAmount).fold(0, (prev, totalReceivableRemoveCouponAmount) => prev + totalReceivableRemoveCouponAmount);
//     //??????
//     orderObject.overAmount = orderObject.pays.map((e) => e.overAmount).fold(0, (prev, overAmount) => prev + overAmount);
//     //????????????
//     orderObject.realPayAmount = orderObject.pays.where((x) => x.incomeFlag == 1).map((e) => e.paidAmount).fold(0, (prev, paidAmount) => prev + paidAmount);

//     // //plus???????????????
//     // var plusCouponPay = orderObject.Pays.FindAll(x => x.No == Constant.PAYMODE_CODE_COUPON && x.SourceSign == CouponSourceSignEnum.plus.ToString()).Sum(x => x.PaidAmount);
//     // //plus???????????????
//     // var plusDiscountAmount = orderObject.Promotions.FindAll(x => !string.IsNullOrEmpty(x.CouponId) && x.SourceSign == CouponSourceSignEnum.plus.ToString()).Sum(x => x.DiscountAmount);
//     // //plus??????
//     // var plusPriceAmount = orderObject.Items.FindAll(x => x.IsPlusPrice == 1).Sum(y => y.Promotions.FindAll(z => z.PromotionType == PromotionType.PLUS???????????????).Sum(z => z.DiscountAmount));
//     //
//     // //plus????????????
//     // orderObject.PlusDiscountAmount = DecimalUtils.ToRound(plusCouponPay + plusDiscountAmount + plusPriceAmount, 2);

//     //?????????????????????
//     if (orderObject.cashierAction == CashierAction.Refund) {
//       //????????????????????????????????????????????????????????????????????????
//       if (StringUtils.isNotBlank(orderObject.orgTradeNo)) {
//         //??????????????????????????????????????????
//         orderObject.malingAmount = orderObject.pays == null ? 0.0 : orderObject.pays.where((x) => x.no == Constants.PAYMODE_CODE_MALING).map((e) => e.paidAmount).fold(0, (prev, paidAmount) => prev + paidAmount);
//       } else {
//         //????????????
//         orderObject.malingAmount = 0 - OrderUtils.instance.calculateMaling(orderObject.receivableAmount.abs());
//       }
//     } else {
//       //??????????????????????????????
//       if (orderObject.orderSource == OrderSource.OnlineStore) {
//         orderObject.malingAmount = 0;
//       } else {
//         orderObject.malingAmount = OrderUtils.instance.calculateMaling(orderObject.receivableAmount);
//       }
//     }

//     //?????????(??????????????????????????????????????????????????????????????????????????????????????????????????????)????????????????????????????????????????????????????????????????????????????????????????????????
//     if (Global.instance.payRealAmount() && orderObject.pays.any((x) => x.no == Constants.PAYMODE_CODE_ALIPAY || x.no == Constants.PAYMODE_CODE_WEIXIN || x.no == Constants.PAYMODE_CODE_YUNSHANFU || x.no == Constants.PAYMODE_CODE_SCANPAY || x.no == Constants.PAYMODE_CODE_CARD || x.no == Constants.PAYMODE_CODE_BANK)) {
//       orderObject.malingAmount = 0.0;
//       //????????????????????????
//       orderObject.payRealAmountFlag = true;
//     } else {
//       orderObject.payRealAmountFlag = false;
//     }

//     //??????????????????????????????????????????????????????
//     orderObject.receivedAmount = (orderObject.pays == null ? 0 : orderObject.pays.map((e) => e.paidAmount).fold(0, (prev, paidAmount) => prev + paidAmount));

//     if (orderObject.orderSource == OrderSource.MeituanTakeout) {
//       //???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????(?????????????????????*?????????????????????????????????????????????????????????????????????????????????)
//       orderObject.paidAmount = orderObject.receivedAmount;
//     } else {
//       //???????????? = ???????????? - ????????????
//       orderObject.paidAmount = orderObject.receivableAmount - orderObject.malingAmount;
//     }

//     //????????????
//     var cashPayList = orderObject.pays.where((x) => x.no == Constants.PAYMODE_CODE_CASH);
//     if (cashPayList.length == 0) {
//       orderObject.changeAmount = 0;
//     } else {
//       orderObject.changeAmount = cashPayList.map((e) => e.changeAmount).fold(0, (prev, changeAmount) => prev + changeAmount);
//     }

//     var unreceivableAmount = orderObject.receivableAmount - orderObject.receivedAmount;
//     orderObject.unreceivableAmount = OrderUtils.instance.toRound(unreceivableAmount > 0 ? unreceivableAmount : 0, precision: 2);
//     orderObject.payCount = orderObject.pays.length;
//     orderObject.itemCount = orderObject.items.length;

//     //??????
//     var member = orderObject.member;
//     if (member != null) {
//       orderObject.isMember = 1;
//       orderObject.memberMobileNo = member.mobile;
//       orderObject.memberName = member.name;
//       orderObject.memberId = member.id;
//       if (member.defaultCard != null) {
//         orderObject.memberNo = member.defaultCard.cardNo;
//         orderObject.cardFaceNo = member.defaultCard.cardFaceNo;
//       } else {
//         orderObject.memberNo = null;
//         orderObject.cardFaceNo = null;
//       }

//       //??????????????????plus????????????
//       orderObject.isPlus = 0; //member.isPlus;
//     } else {
//       if (orderObject.cashierAction == CashierAction.Cashier) {
//         if (orderObject.pays != null && orderObject.pays.length > 0) {
//           var pay = orderObject.pays.firstWhere((x) => x.no == "02", orElse: () => null);
//           if (pay != null) {
//             orderObject.cardFaceNo = pay.cardFaceNo;
//             orderObject.isMember = 1;
//             orderObject.memberMobileNo = pay.memberMobileNo;
//             orderObject.memberName = pay.accountName;
//             orderObject.memberNo = pay.cardNo;
//             orderObject.addPoint = pay.cardChangePoint;
//             orderObject.prePoint = pay.cardPrePoint;
//             orderObject.aftPoint = pay.cardAftPoint;
//             orderObject.aftAmount = pay.cardAftAmount;
//             orderObject.changeAmount = pay.changeAmount;
//           }
//         }

//         if (orderObject.isMember == 0) {
//           orderObject.memberMobileNo = null;
//           orderObject.memberName = null;
//           orderObject.memberId = null;
//           orderObject.memberNo = null;
//           orderObject.cardFaceNo = null;
//         }

//         //??????????????????plus????????????
//         orderObject.isPlus = 0;
//       }
//     }

//     //??????????????????
//   }

//   /// ??????????????????
//   void calculateChangeAmount(OrderObject orderObject) {
//     ///?????????,????????????????????????
//     double receivedAmount = 0;

//     ///????????????
//     double realPayAmount = 0;

//     ///????????????
//     double totalInputAmount = 0;

//     orderObject.pays?.forEach((item) {
//       receivedAmount += item.paidAmount;
//       totalInputAmount += item.inputAmount;
//       if (item.incomeFlag == 1) {
//         realPayAmount += item.paidAmount;
//       }
//     });
//     orderObject.receivedAmount = receivedAmount;
//     orderObject.realPayAmount = realPayAmount;

//     ///??????????????????
//     var receivableAmount = orderObject.paidAmount.abs();
//     if (totalInputAmount > receivableAmount) {
//       orderObject.changeAmount = OrderUtils.instance.toRound(totalInputAmount - receivableAmount, precision: 2);
//     } else {
//       orderObject.changeAmount = 0;
//     }
//   }

//   ///????????????
//   double calculateMaling(double amount) {
//     double result = 0;
//     var maling = Global.instance.globalConfigBoolValue(ConfigConstant.MALING_ENABLE);
//     if (maling) {
//       //????????????
//       var rule = Global.instance.globalConfigStringValue(ConfigConstant.MALING_RULE);
//       if (StringUtils.isNotBlank(rule)) {
//         MalingEnum malingRule = MalingEnum.fromValue(rule);
//         result = _calculateMaling(malingRule, amount);
//       }
//     }

//     return result;
//   }

//   double _calculateMaling(MalingEnum malingRule, double amount, {int fractionDigits = 2}) {
//     print("????????????????????????${malingRule.value},${malingRule.name},$amount");
//     double result = amount;
//     switch (malingRule) {
//       case MalingEnum.MALING_1: //??????????????????:
//         {
//           //????????????????????????
//           result = double.tryParse(amount.toStringAsFixed(0));
//           result = result - amount;
//         }
//         break;
//       case MalingEnum.MALING_2: //??????????????????:
//         {
//           // String amountString = "$amount";
//           // result = double.tryParse("${amountString.substring(0, (amountString.length - amountString.lastIndexOf(".") - 1))}");
//           result = amount ~/ 1 - amount;
//         }
//         break;
//       case MalingEnum.MALING_3: //??????????????????:
//         {
//           result = amount - amount ~/ 1;
//           if (result.abs() > 0) {
//             //??????????????????
//             result = 1 - result;
//           }
//         }
//         break;
//       case MalingEnum.MALING_4: //??????????????????:
//         {
//           result = double.tryParse(amount.toStringAsFixed(1));
//           result = result - amount;
//         }
//         break;
//       case MalingEnum.MALING_5: //??????????????????:
//         {
//           result = ((amount * 10) ~/ 1) / 10 - amount;

//           // result = amount - Math.Floor(amount * 10) / 10M;
//         }
//         break;
//       case MalingEnum.MALING_6: //??????????????????:
//         {
//           result = amount - ((amount * 10) ~/ 1) / 10;
//           if (result.abs() > 0) {
//             //??????????????????
//             result = 0.1 - result;
//           }

//           // result = Math.Floor(amount * 10) / 10M;
//           // if (amount > result)
//           // {
//           // //??????????????????
//           // result += 0.1M;
//           // }
//           // result = amount - result;
//         }
//         break;
//       case MalingEnum.MALING_7: //???????????????5???:
//         {
//           result = amount.floorToDouble();
//           if (amount - result >= 0.5) {
//             result = amount - (result + 0.5);
//           } else {
//             result = amount - result;
//           }
//         }
//         break;
//       case MalingEnum.MALING_8: //???????????????5???:
//         {
//           result = amount.floorToDouble();
//           if (amount - result > 0.5) {
//             result = amount - (result + 1);
//           } else {
//             result = amount == 0 ? 0 : (amount - (result + 0.5));
//           }

//           // result = Math.Floor(amount);
//           // if (amount - result > 0.5M)
//           // {
//           // result = amount - (result + 1);
//           // }
//           // else
//           // {
//           // //???????????????0????????????0
//           // if (amount == 0) return decimal.Zero;
//           // result = amount - (result + 0.5M);
//           // }
//         }
//         break;
//       case MalingEnum.MALING_9: //???????????????5???:
//         {
//           result = amount.floorToDouble();
//           if (result % 5 != 0) {
//             result -= result % 5;
//           }
//           result = amount - result;
//         }
//         break;
//       case MalingEnum.MALING_10: //???????????????10???:
//         {
//           result = amount.floorToDouble();
//           if (result % 10 != 0) {
//             result -= result % 10;
//           }
//           result = amount - result;

//           // result = Math.Floor(amount);
//           // if (result % 10 != 0)
//           // {
//           // result -= result % 10;
//           // }
//           // result = amount - result;
//         }
//         break;
//       case MalingEnum.MALING_11: //???????????????100???:
//         {
//           result = amount.floorToDouble();
//           if (result % 100 != 0) {
//             result -= result % 100;
//           }
//           result = amount - result;
//         }
//         break;
//     }

//     result = OrderUtils.instance.toRound(result, precision: fractionDigits);
//     print("????????????????????????${malingRule.value},${malingRule.name},$result");
//     return result;
//   }

//   /// ??????????????????????????????
//   bool checkOrderFullPay(OrderObject orderObject) {
//     bool isVerify = false;

//     print("??????????????????????????????>>${orderObject.cashierAction.name}>>");

//     if (orderObject.cashierAction == CashierAction.Cashier) {
//       double paidAmount = 0;
//       orderObject.pays.forEach((item) {
//         paidAmount += item.paidAmount;
//       });

//       print("??????????????????????????????>>${orderObject.paidAmount}>>$paidAmount");

//       isVerify = paidAmount >= toRound(orderObject.paidAmount, precision: 2);
//     }

//     return isVerify;
//   }

//   ///????????????????????????
//   Future<List<PayMode>> getPayModeAll() async {
//     List<PayMode> result = new List<PayMode>();
//     try {
//       String sql = "select id,tenantId,`no`,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag from pos_pay_mode where frontFlag = 1 and deleteFlag = 0 order by orderNo,no asc;";
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);
//       if (lists != null && lists.length > 0) {
//         result = PayMode.toList(lists);
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   Future<PayMode> getPayMode(String no) async {
//     PayMode result;
//     try {
//       String sql = "select id,tenantId,`no`,name,shortcut,pointFlag,frontFlag,backFlag,rechargeFlag,faceMoney,paidMoney,incomeFlag,orderNo,ext1,ext2,ext3,deleteFlag,createDate,createUser,modifyDate,modifyUser,plusFlag from pos_pay_mode where frontFlag = 1 and deleteFlag = 0  and `no` = '$no' order by orderNo,no asc;";
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);
//       if (lists != null && lists.length > 0) {
//         result = PayMode.fromMap(lists[0]);
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????<$no>????????????:" + e.toString());
//     }
//     return result;
//   }

//   Future<OrderObject> orderObjectFinished(OrderObject orderObject, double inputAmount) async {
//     try {
//       //???????????????????????????????????????
//       if (inputAmount != 0) {
//         //????????????????????????
//         var chshPayMode = await OrderUtils.instance.getPayMode(Constants.PAYMODE_CODE_CASH);

//         //????????????????????????
//         var orderPay = OrderPay.fromPayMode(orderObject, chshPayMode);
//         orderPay.orderNo = orderObject.pays.length + 1;

//         orderPay.inputAmount = inputAmount;
//         orderPay.amount = orderPay.inputAmount;
//         orderPay.paidAmount = orderPay.inputAmount;
//         orderPay.overAmount = 0;
//         orderPay.changeAmount = 0;
//         orderPay.platformDiscount = 0;
//         orderPay.platformPaid = 0;
//         orderPay.payNo = "";

//         orderPay.status = OrderPaymentStatus.Paid;
//         if (orderPay.no == Constants.PAYMODE_CODE_MALING) {
//           orderPay.statusDesc = Constants.PAYMODE_MALING_HAND;
//         }
//         orderPay.payTime = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//         await addPayment(orderObject, orderPay);
//       }

//       //??????????????????
//       var isVerify = OrderUtils.instance.checkOrderFullPay(orderObject);
//       if (isVerify) {
//         //????????????????????????????????????????????????????????????????????????????????????????????????
//         if (orderObject.pays.length == 0) {
//           await addDefaultZeroPay(orderObject);
//         }
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????????????????:" + e.toString());
//     }

//     return Future.value(orderObject);
//   }

//   Future<void> addDefaultZeroPay(OrderObject orderObject) async {
//     //????????????????????????
//     var chshPayMode = await OrderUtils.instance.getPayMode(Constants.PAYMODE_CODE_CASH);

//     //????????????????????????
//     var orderPay = OrderPay.fromPayMode(orderObject, chshPayMode);
//     orderPay.orderNo = orderObject.pays.length + 1;

//     orderPay.inputAmount = 0;
//     orderPay.amount = 0;
//     orderPay.paidAmount = 0;
//     orderPay.overAmount = 0;
//     orderPay.changeAmount = 0;
//     orderPay.platformDiscount = 0;
//     orderPay.platformPaid = 0;
//     orderPay.payNo = "";

//     orderPay.status = OrderPaymentStatus.Paid;
//     orderPay.payTime = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//     orderObject.pays.add(orderPay);
//   }

//   //????????????????????????
//   Future<OrderObject> addPayment(OrderObject orderObject, OrderPay orderPay) async {
//     if (orderPay.no == Constants.PAYMODE_CODE_CASH) {
//       ///????????????????????????,?????????????????????
//       var cashPayIndex = orderObject.pays.indexWhere((item) => item.no == Constants.PAYMODE_CODE_CASH);
//       if (cashPayIndex > -1) {
//         var cashPayItem = orderObject.pays[cashPayIndex];
//         //??????????????????????????????
//         cashPayItem.inputAmount += orderPay.inputAmount;
//         //??????????????????
//         OrderUtils.instance.calculateChangeAmount(orderObject);

//         cashPayItem.changeAmount = orderObject.changeAmount;
//         cashPayItem.paidAmount = cashPayItem.inputAmount - cashPayItem.changeAmount;
//         cashPayItem.amount = cashPayItem.paidAmount;
//       } else {
//         orderObject.pays.add(orderPay);
//       }
//     } else {
//       orderObject.pays.add(orderPay);
//     }

//     orderObject.payCount = orderObject.pays.length;

//     //????????????
//     OrderUtils.instance.calculateOrderObject(orderObject);

//     return orderObject;
//   }

//   Future<OrderObject> clearPayment(OrderObject orderObject, {OrderPay orderPay}) async {
//     //????????????????????????
//     if (orderPay != null) {
//       orderObject.pays.removeWhere((item) => item.id == orderPay.id);
//     } else {
//       //????????????????????????
//       orderObject.pays.clear();
//     }

//     orderObject.payCount = orderObject.pays.length;

//     //????????????
//     OrderUtils.instance.calculateOrderObject(orderObject);

//     return Future.value(orderObject);
//   }

//   int getMaxValueByLength(int len) {
//     int maxVal = 0;
//     switch (len) {
//       case 1:
//         {
//           maxVal = 9;
//         }
//         break;
//       case 2:
//         {
//           maxVal = 99;
//         }
//         break;
//       case 3:
//         {
//           maxVal = 999;
//         }
//         break;
//       case 4:
//         {
//           maxVal = 9999;
//         }
//         break;
//       case 5:
//       default:
//         {
//           maxVal = 99999;
//         }
//         break;
//     }

//     return maxVal;
//   }

//   ///?????????????????????
//   Future<Tuple3<bool, String, String>> generateMergeNo({int length = 2}) async {
//     bool result = false;
//     String message = "????????????????????????";
//     String mergeNo = "";
//     try {
//       int val = 0;
//       //?????????????????????????????????????????????
//       int maxVal = getMaxValueByLength(length);

//       bool isNew = false;

//       String sql = sprintf("select `id`, `tenantId`, `group`, `keys`, `initValue`, `values`, `createUser`, `createDate`, `modifyUser`, `modifyDate` from pos_config where `group` = '%s' and `keys` = '%s';", [ConfigConstant.GROUP_BUSINESS, ConfigConstant.TABLE_MERGE_NO]);
//       Config config;
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);
//       if (lists != null && lists.length > 0) {
//         config = Config.fromMap(lists[0]);
//       }

//       if (config != null) {
//         var modifyDate = DateTime.parse(config.modifyDate);
//         if (modifyDate.difference(DateTime.now()).inDays != 0) {
//           val = 0;
//         } else {
//           val = int.tryParse(config.values);
//         }
//       } else {
//         config = new Config();

//         config.id = IdWorkerUtils.getInstance().generate().toString();
//         config.tenantId = Global.instance.authc.tenantId;
//         config.group = ConfigConstant.GROUP_BUSINESS;
//         config.keys = ConfigConstant.TABLE_MERGE_NO;
//         config.initValue = "0";
//         config.values = "0";
//         config.createUser = Constants.DEFAULT_CREATE_USER;
//         config.createDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//         isNew = true;
//       }

//       val++;

//       //????????????
//       if (maxVal != 0 && val > maxVal) {
//         val = 1;
//       }

//       config.values = "$val";

//       config.modifyUser = Constants.DEFAULT_MODIFY_USER;
//       config.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//       String template = "update pos_config set `values`= '%s',modifyUser= '%s',modifyDate= '%s' where `group` = '%s' and `keys` = '%s';";
//       String updateSql = sprintf(template, [config.values, config.modifyUser, config.modifyDate, config.group, config.keys]);

//       if (isNew) {
//         template = "insert into pos_config(id,tenantId,`group`,`keys`,initValue,`values`,createUser,createDate,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')";
//         updateSql = sprintf(template, [config.id, config.tenantId, config.group, config.keys, config.initValue, config.values, config.createUser, config.createDate, config.modifyUser, config.modifyDate]);
//       }

//       await database.transaction((txn) async {
//         await txn.execute(updateSql);
//       });

//       mergeNo = config.values;

//       result = true;
//       message = "????????????????????????";
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, mergeNo);
//   }

//   ///?????????????????????<1>,?????????YYMMDDHHMM+POS??????+4????????????
//   Future<Tuple3<bool, String, String>> generateTicketNo({int length = 4}) async {
//     String serialNumber = "";
//     String message = "???????????????????????????!!";

//     try {
//       serialNumber = await _generateSerialNumber(length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.TRADE_NO);
//       message = "???????????????????????????";
//       if (serialNumber.isNotEmpty) {
//         //??????
//         String yyMMddHHmm = DateUtils.formatDate(DateTime.now(), format: "yyMMddHHmm");
//         String result = sprintf("1%s%s%s", [yyMMddHHmm, Global.instance.authc?.posNo, serialNumber]);

//         return Tuple3<bool, String, String>(true, message, result);
//       } else {
//         return Tuple3<bool, String, String>(false, message, "");
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????POS????????????????????????:" + e.toString());
//     }
//   }

//   ///?????????PayNo,?????????????????????+?????????+????????????+1?????????
//   String generatePayNo(String tradeNo, {String separator = '-'}) {
//     var payNo = "${Global.instance.authc.storeNo}$separator$tradeNo${Global.instance.getNextPayNoSuffix}";
//     //???????????????????????????tradeNo??????????????????1?????????
//     if (payNo.endsWith("0")) {
//       payNo = payNo.substring(0, payNo.length - 1);
//     }
//     return payNo;
//   }

//   /// <summary>
//   /// ?????????????????????<3>,?????????YYMMDDHHMM+POS??????+4????????????
//   /// </summary>
//   /// <returns></returns>
//   Future<Tuple3<bool, String, String>> generateShiftNo({int length = 4}) async {
//     bool result = false;
//     String message = "????????????????????????!!";
//     String data = "";
//     try {
//       var shiftNo = await _generateSerialNumber(length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.SHIFT_NO);
//       data = "3${DateUtils.formatDate(DateTime.now(), format: "yyMMddHHmm")}${Global.instance.authc.posNo}$shiftNo";

//       result = true;
//       message = "????????????????????????";
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }

//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Future<Tuple3<bool, String, String>> generateBatchNo({int length = 4}) async {
//     bool result = false;
//     String message = "????????????????????????!!";
//     String data = "";
//     try {
//       data = await _generateSerialNumber(length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.BATCH_NO);

//       if (StringUtils.isNotBlank(data)) {
//         result = true;
//         message = "????????????????????????";
//       } else {
//         result = false;
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }

//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Future<String> _generateSerialNumber(int len, String group, String key) async {
//     String result = "";
//     try {
//       String sql = sprintf("select `id`, `tenantId`, `group`, `keys`, `initValue`, `values`, `createUser`, `createDate`, `modifyUser`, `modifyDate` from pos_config where `group` = '%s' and `keys` = '%s';", [group, key]);

//       int value = 0;
//       bool isNew = false;
//       Config config;
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         config = Config.fromMap(lists[0]);
//       }

//       if (config != null) {
//         value = Convert.toInt(config.values);
//         config.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//         config.modifyUser = Constants.DEFAULT_MODIFY_USER;

//         if (value >= 9999) {
//           value = 0;
//         }
//         isNew = false;
//       } else {
//         config = new Config();
//         config.id = IdWorkerUtils.getInstance().generate().toString();
//         config.tenantId = Global.instance.authc?.tenantId;
//         config.group = group;
//         config.keys = key;
//         config.initValue = "0";
//         config.createDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//         config.createUser = Constants.DEFAULT_CREATE_USER;

//         isNew = true;
//       }

//       value = value + 1;
//       result = value.toString().padLeft(len, '0'); //0003
//       config.values = result;

//       config.modifyDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//       config.modifyUser = Constants.DEFAULT_CREATE_USER;

//       String template = "update pos_config set `values`= '%s',modifyUser= '%s',modifyDate= '%s' where `group` = '%s' and `keys` = '%s';";
//       String updateSql = sprintf(template, [config.values, config.modifyUser, config.modifyDate, config.group, config.keys]);

//       if (isNew) {
//         template = "insert into pos_config(id,tenantId,`group`,`keys`,initValue,`values`,createUser,createDate,modifyUser,modifyDate) values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')";
//         updateSql = sprintf(template, [config.id, config.tenantId, config.group, config.keys, config.initValue, config.values, config.createUser, config.createDate, config.modifyUser, config.modifyDate]);
//       }

//       await database.transaction((txn) async {
//         await txn.execute(updateSql);
//       });
//     } catch (e, stack) {
//       result = "";

//       FlutterChain.printError(e, stack);
//       FLogger.error("?????????????????????????????????:" + e.toString());
//     }

//     return result;
//   }

//   /// <summary>
//   /// ?????????????????????????????????
//   ///
//   /// ?????????????????????25~30??????????????????16~24????????????
//   ///
//   /// ??????????????? 18??????????????????10???11???12???13???14???15??????
//   ///
//   /// ????????? 62??????
//   Future<PayMode> getPayModeByPayCode(String payCode) {
//     String result;
//     if (StringUtils.isNotBlank(payCode) && payCode.length >= 16) {
//       String prefix = payCode.substring(0, 2);

//       switch (prefix) {
//         case "10":
//         case "11":
//         case "12":
//         case "13":
//         case "14":
//         case "15":
//           {
//             //??????
//             result = "05";
//           }
//           break;
//         case "25":
//         case "26":
//         case "27":
//         case "28":
//         case "29":
//         case "30":
//           {
//             //?????????
//             result = "04";
//           }
//           break;
//         case "62":
//           {
//             //???????????????  09
//             result = "09";
//           }
//           break;
//         default:
//           result = "";
//           break;
//       }
//     }

//     if (StringUtils.isBlank(result)) {
//       return null;
//     }
//     return getPayMode(result);
//   }

//   Future<Tuple3<bool, String, PaymentParameter>> getPayParameterByPayMode(PayMode payMode, OnLinePayBusTypeEnum busType) async {
//     bool result = true;
//     String message = "????????????";
//     PaymentParameter paymentParameter;

//     try {
//       //??????????????????
//       var subalipay = PayParameterSignEnum.SubAlipay.name;
//       //???????????????
//       var subwxpay = PayParameterSignEnum.SubWxpay.name;

//       //??????????????????
//       var storeInfo = await Global.instance.getStoreInfo();

//       //???????????????
//       var database = await SqlUtils.instance.open();

//       //????????????????????????
//       String sql = sprintf("select * from pos_payment_group_parameter where `enabled` = 1 and groupNo = '%s';", [storeInfo.groupNo]);
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);
//       List<PaymentGroupParameter> groupParameterList;
//       if (lists != null) {
//         groupParameterList = PaymentGroupParameter.toList(lists);
//       }

//       if (groupParameterList != null && groupParameterList.length > 0 && (busType == OnLinePayBusTypeEnum.MemberRecharge)) {
//         //?????????????????????????????????,??????????????????????????????????????????????????????????????????
//         var paymentGroupParameter = groupParameterList.firstWhere((x) => x.localFlag == 0 && x.sign != subalipay && x.sign != subwxpay, orElse: null);
//         //?????????????????????????????????????????????????????????????????????
//         if (paymentGroupParameter == null) {
//           //???????????????
//           if (payMode.no == "05") {
//             paymentGroupParameter = groupParameterList.firstWhere((x) => x.localFlag == 0 && x.sign == subwxpay);
//           }
//           // ??????????????????
//           if (payMode.no == "04") {
//             paymentGroupParameter = groupParameterList.firstWhere((x) => x.localFlag == 0 && x.sign == subalipay);
//           }
//         }

//         //????????????????????????
//         if (paymentGroupParameter != null) {
//           //????????????????????????????????????????????????????????????????????????
//           var exchangeParam = new PaymentParameter();
//           exchangeParam.pbody = paymentGroupParameter.pbody;
//           exchangeParam.certText = paymentGroupParameter.certText;
//           exchangeParam.enabled = paymentGroupParameter.enabled;
//           exchangeParam.id = paymentGroupParameter.id;
//           exchangeParam.localFlag = paymentGroupParameter.localFlag;
//           exchangeParam.no = paymentGroupParameter.no;
//           exchangeParam.sign = paymentGroupParameter.sign;
//           exchangeParam.storeId = paymentGroupParameter.storeId;
//           exchangeParam.tenantId = paymentGroupParameter.tenantId;

//           paymentParameter = exchangeParam;
//         }
//       } else {
//         //??????????????????????????????
//         sql = sprintf("select * from pos_payment_parameter where `enabled` = 1;", []);
//         lists = await database.rawQuery(sql);
//         List<PaymentParameter> parameterList;
//         if (lists != null) {
//           parameterList = PaymentParameter.toList(lists);
//         }

//         if (parameterList != null) {
//           //??????????????????
//           paymentParameter = parameterList.firstWhere((x) => x.localFlag == 0 && x.sign != subalipay && x.sign != subwxpay, orElse: null);

//           //?????????????????????????????????????????????????????????????????????
//           if (paymentParameter == null) {
//             //???????????????
//             if (payMode.no == "05") {
//               paymentParameter = parameterList.firstWhere((x) => x.localFlag == 0 && x.sign == subwxpay);
//             }
//             // ??????????????????
//             if (payMode.no == "04") {
//               paymentParameter = parameterList.firstWhere((x) => x.localFlag == 0 && x.sign == subalipay);
//             }
//           }
//         }
//       }

//       //???????????????????????????
//       if (paymentParameter == null) {
//         result = false;
//         message = "??????????????????????????????";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }

//     return Tuple3<bool, String, PaymentParameter>(result, message, paymentParameter);
//   }

//   Future<Tuple3<bool, String, PaymentParameter>> getPayParameter(PayParameterSignEnum sign, OnLinePayBusTypeEnum busType) async {
//     bool result = true;
//     String message = "????????????";
//     PaymentParameter paymentParameter;

//     try {
//       //???????????????????????????
//       var friendlyName = sign.toFriendlyName();

//       //??????????????????
//       var storeInfo = await Global.instance.getStoreInfo();

//       //???????????????
//       var database = await SqlUtils.instance.open();

//       //????????????????????????
//       String sql = sprintf("select * from pos_payment_group_parameter where `enabled` = 1 and groupNo = '%s';", [storeInfo.groupNo]);
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);
//       List<PaymentGroupParameter> groupParameterList;
//       if (lists != null) {
//         groupParameterList = PaymentGroupParameter.toList(lists);
//       }

//       if (groupParameterList != null && groupParameterList.length > 0 && (busType == OnLinePayBusTypeEnum.MemberRecharge)) {
//         //?????????????????????????????????
//         var paymentGroupParameter = groupParameterList.firstWhere((x) => x.localFlag == 0 && x.sign == sign.name, orElse: null);

//         if (paymentGroupParameter != null) {
//           //????????????????????????????????????????????????????????????????????????
//           var exchangeParam = new PaymentParameter();
//           exchangeParam.pbody = paymentGroupParameter.pbody;
//           exchangeParam.certText = paymentGroupParameter.certText;
//           exchangeParam.enabled = paymentGroupParameter.enabled;
//           exchangeParam.id = paymentGroupParameter.id;
//           exchangeParam.localFlag = paymentGroupParameter.localFlag;
//           exchangeParam.no = paymentGroupParameter.no;
//           exchangeParam.sign = paymentGroupParameter.sign;
//           exchangeParam.storeId = paymentGroupParameter.storeId;
//           exchangeParam.tenantId = paymentGroupParameter.tenantId;

//           paymentParameter = exchangeParam;
//         }

//         if (paymentParameter != null) {
//           result = true;
//           message = "";
//         } else {
//           //?????????
//           result = false;
//           message = "?????????$friendlyName????????????";
//         }
//       } else {
//         //????????????????????????
//         sql = sprintf("select * from pos_payment_parameter where `enabled` = 1;", []);
//         lists = await database.rawQuery(sql);
//         List<PaymentParameter> parameterList;
//         if (lists != null) {
//           parameterList = PaymentParameter.toList(lists);
//         }

//         if (parameterList != null) {
//           //??????????????????
//           paymentParameter = parameterList.firstWhere((x) => x.localFlag == 0 && x.sign == sign.name, orElse: null);
//           if (paymentParameter != null) {
//             result = true;
//             message = "";
//           } else {
//             //?????????
//             result = false;
//             message = "?????????$friendlyName????????????";
//           }
//         } else {
//           //?????????
//           result = false;
//           message = "?????????$friendlyName????????????";
//         }
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }

//     return Tuple3<bool, String, PaymentParameter>(result, message, paymentParameter);
//   }

//   //???????????????????????????????????????
//   Future<OrderObject> addOrderPayByScanPayResult(OrderObject orderObject, ScanPayResult payResult) async {
//     print(">>>>@@@@@@@@>>>????????????>>$payResult");

//     if (payResult != null && payResult.success) {
//       var payMode = await OrderUtils.instance.getPayMode(payResult.payType);

//       print(">>>>@@@@@@@@>>>????????????>>$payMode");

//       if (payMode != null) {
//         OrderPay pay = new OrderPay();
//         pay.id = IdWorkerUtils.getInstance().generate().toString();
//         pay.tenantId = Global.instance.authc.tenantId;
//         pay.tradeNo = orderObject.tradeNo;
//         pay.orderId = orderObject.id;
//         pay.orderNo = orderObject.pays.length + 1;
//         pay.no = payMode.no;
//         pay.name = payMode.name;
//         pay.amount = payResult.paidAmount;
//         pay.inputAmount = 0;
//         pay.paidAmount = payResult.paidAmount;
//         pay.overAmount = 0.00;
//         pay.changeAmount = 0.00;
//         pay.platformDiscount = payResult.platformDiscount;
//         pay.platformPaid = payResult.platformPaid;
//         pay.payNo = payResult.payNo;
//         pay.channelNo = payResult.channelNo;
//         pay.payChannel = payResult.payChannel;
//         pay.voucherNo = payResult.voucherNo;
//         pay.status = OrderPaymentStatus.Paid;
//         pay.statusDesc = payResult.statusDesc;
//         pay.subscribe = payResult.subscribe;
//         pay.accountName = payResult.accountName;
//         pay.bankType = payResult.bankType;
//         pay.payTime = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//         pay.incomeFlag = payMode.incomeFlag;
//         pay.pointFlag = payMode.pointFlag;
//         pay.shiftId = ""; //???????????????????????????
//         pay.shiftNo = ""; //???????????????????????????
//         pay.shiftName = ""; //???????????????????????????
//         pay.createUser = Global.instance.worker.no;
//         pay.createDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//         orderObject.pays.add(pay);
//       }
//     }

//     return orderObject;
//   }

//   ///??????????????????
//   Future<List<BaseParameter>> getReason(String code) async {
//     List<BaseParameter> result = new List<BaseParameter>();
//     try {
//       var reasons = await OrderUtils.instance.getBaseParameterList();
//       if (reasons != null) {
//         //????????????
//         var dataSource = reasons.where((item) => StringUtils.isBlank(item.parentId));
//         if (dataSource != null) {
//           var data = dataSource.lastWhere((item) => item.code == code, orElse: () => null);

//           if (data != null) {
//             result = reasons.where((item) => item.parentId == data.id).toList();
//           }
//         }
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///????????????????????????
//   Future<List<BaseParameter>> getBaseParameterList({bool forceRefresh = false}) async {
//     List<BaseParameter> result = new List<BaseParameter>();
//     try {
//       String sql = sprintf("select id,tenantId,parentId,code,name,memo,orderNo,enabled,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_base_parameter; ", []);
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       result = BaseParameter.toList(lists);
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///??????????????????
//   Future<ProductExt> getProductExt(String productId) async {
//     ProductExt result;
//     try {
//       String sql = sprintf("""
//         select p.`id`, p.`tenantId`, p.`categoryId`, p.`categoryPath`, p.`type`, p.`no`, p.`barCode`, p.`subNo`, p.`otherNo`, p.`name`, p.`english`, p.`rem`, p.`shortName`, p.`unitId`, p.`brandId`, p.`storageType`, p.`storageAddress`, sp.`supplierId`, sp.`managerType`, p.`purchaseControl`, p.`purchaserCycle`, p.`validDays`, p.`productArea`, p.`status`, p.`spNum`, sp.`stockFlag`, p.`quickInventoryFlag`,p.`posSellFlag`, p.`batchStockFlag`, p.`weightFlag`, p.`weightWay`, p.`steelyardCode`, p.`labelPrintFlag`, sp.`foreDiscount`, sp.`foreGift`, p.`promotionFlag`, sp.`branchPrice`, sp.`foreBargain`, p.`returnType`, p.`returnRate`, sp.`pointFlag`, p.`pointValue`, p.`introduction`, p.`purchaseTax`, p.`saleTax`, p.`lyRate`, p.`allCode`, p.`deleteFlag`, p.`allowEditSup`, p.`ext1`, p.`ext2`, p.`ext3`, p.`createUser`, p.`createDate`, p.`modifyUser`, p.`modifyDate`, ps.specification as specName, ps.id as specId,
//         pc.name as categoryName, pc.code as categoryNo, pu.name as unitName, pb.name as brandName, sp.batchPrice, sp.batchPrice2, sp.batchPrice3, sp.batchPrice4, sp.batchPrice5, sp.batchPrice6, sp.batchPrice7, sp.batchPrice8, sp.minPrice, sp.otherPrice, sp.postPrice, sp.purPrice, sp.salePrice, sp.vipPrice, sp.vipPrice2, sp.vipPrice3, sp.vipPrice4, sp.vipPrice5, ps.isDefault, ps.purchaseSpec,
//         su.name as supplierName, kp.chudaFlag, kp.chuda,kp.chupinFlag, kp.chupin, kp.labelFlag as chudaLabelFlag, kp.labelValue as chudaLabel
// 	      from pos_product p
// 	      inner join pos_product_spec ps on p.id = ps.productId
// 	      inner join pos_store_product sp on ps.id = sp.specId
// 	      left join pos_product_unit pu on p.unitId = pu.id
// 	      left join pos_product_category pc on p.categoryId = pc.id
// 	      left join pos_product_brand pb on p.brandId = pb.id
// 	      left join pos_supplier su on sp.supplierId = su.id
// 	      left join pos_kit_plan_product kp on p.id = kp.productId
// 	      where sp.status in (1, 2) and ps.deleteFlag = 0 and p.posSellFlag = 1 and p.id = '%s'
// 	      order by p.categoryId, p.barCode;
//         """, [productId]);

//       var database = await SqlUtils.instance.open();
//       var lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         result = ProductExt.fromMap(lists[0]);
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///???????????????????????????
//   Future<List<ProductSpec>> getProductSpecList(String productId) async {
//     List<ProductSpec> result = [];
//     try {
//       String sql = "select * from pos_product_spec where productId = '$productId'";

//       var database = await SqlUtils.instance.open();
//       var lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         result.addAll(ProductSpec.toList(lists));
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///????????????????????????
//   Future<List<MakeInfo>> getProductMakeList(String productId) async {
//     List<MakeInfo> result = [];

//     //????????????????????????
//     if (CacheManager.makeList.containsKey(productId)) {
//       result.addAll(CacheManager.makeList[productId]);
//       return result;
//     }
//     //?????????????????????????????????
//     try {
//       String sql = "SELECT m.*, c.type as categoryType, c.isRadio, c.color as categoryColor FROM pos_make_info m LEFT JOIN pos_make_category c ON m.categoryId = c.id WHERE m.deleteFlag = 0 ORDER BY c.orderNo + 0, m.orderNo + 0;";
//       var database = await SqlUtils.instance.open();
//       //????????????
//       var allMakeMap = await database.rawQuery(sql);

//       if (allMakeMap != null && allMakeMap.length > 0) {
//         //?????????????????????
//         var dataSource = MakeInfo.toList(allMakeMap);
//         //????????????
//         sql = "select * from pos_store_make;";
//         var storeMakeMap = await database.rawQuery(sql);
//         var storeMakeData = StoreMake.toList(storeMakeMap);

//         //??????????????????
//         sql = "select * from pos_product_make where productId = '$productId';";
//         var productMakeMap = await database.rawQuery(sql);
//         var productMakeData = ProductMake.toList(productMakeMap);

//         //???????????????????????????????????????,?????????????????????????????????????????????????????????
//         List<MakeInfo> storeFilterData;
//         if (storeMakeData != null && storeMakeData.length > 0) {
//           //????????????????????????
//           storeFilterData = dataSource.where((x) => x.prvFlag == 0 && storeMakeData.any((y) => y.makeId == x.id)).toList();
//         } else {
//           //?????????????????????
//           storeFilterData = dataSource.where((x) => x.prvFlag == 0).toList();
//         }
//         //???????????????????????????
//         storeFilterData.forEach((item) {
//           result.add(item);
//         });

//         if (productMakeData != null && productMakeData.length > 0) {
//           var productFilterData = dataSource.where((x) => productMakeData.any((y) => y.productId == productId && y.makeId == x.id));

//           if (productFilterData != null) {
//             result.addAll(productFilterData.toList());
//           }
//         }
//       }
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????????????????:" + e.toString());
//     }

//     //????????????
//     result = result.distinctBy((u) => u.id);
//     //result.sort((left, right) => left.orderNo.compareTo(right.orderNo));
//     List<MakeInfo> productMakeList = [];
//     productMakeList.addAll(result.where((x) => x.categoryType == 0));
//     productMakeList.addAll(result.where((x) => x.categoryType == 1));

//     //???????????????????????????????????????
//     CacheManager.makeList[productId] = productMakeList;

//     return productMakeList;
//   }

//   ///???????????????????????????????????????
//   Future<List<ProductExt>> getProductExtList() async {
//     List<ProductExt> result = CacheManager.productExtList;

//     if (result == null) {
//       Map<String, ProductExt> realDic = new Map<String, ProductExt>();
//       try {
//         String sql = """
//         select p.`id`, p.`tenantId`, p.`categoryId`, p.`categoryPath`, p.`type`, p.`no`, p.`barCode`, p.`subNo`, p.`otherNo`, p.`name`, p.`english`, p.`rem`, p.`shortName`, p.`unitId`, p.`brandId`, p.`storageType`, p.`storageAddress`, sp.`supplierId`, sp.`managerType`, p.`purchaseControl`, p.`purchaserCycle`, p.`validDays`, p.`productArea`, p.`status`, p.`spNum`, sp.`stockFlag`, p.`quickInventoryFlag`,p.`posSellFlag`, p.`batchStockFlag`, p.`weightFlag`, p.`weightWay`, p.`steelyardCode`, p.`labelPrintFlag`, sp.`foreDiscount`, sp.`foreGift`, p.`promotionFlag`, sp.`branchPrice`, sp.`foreBargain`, p.`returnType`, p.`returnRate`, sp.`pointFlag`, p.`pointValue`, p.`introduction`, p.`purchaseTax`, p.`saleTax`, p.`lyRate`, p.`allCode`, p.`deleteFlag`, p.`allowEditSup`, p.`ext1`, p.`ext2`, p.`ext3`, p.`createUser`, p.`createDate`, p.`modifyUser`, p.`modifyDate`, ps.specification AS specName, ps.id AS specId,
//         pc.name AS categoryName, pc.code AS categoryNo, pu.name AS unitName, pb.name AS brandName, sp.batchPrice, sp.batchPrice2, sp.batchPrice3, sp.batchPrice4, sp.batchPrice5, sp.batchPrice6, sp.batchPrice7, sp.batchPrice8, sp.minPrice, sp.otherPrice, sp.postPrice, sp.purPrice, sp.salePrice, sp.vipPrice, sp.vipPrice2, sp.vipPrice3, sp.vipPrice4, sp.vipPrice5, sp.mallFlag, ps.isDefault, ps.purchaseSpec,
//         su.name AS supplierName, kp.chudaFlag, kp.chuda,kp.chupinFlag, kp.chupin, kp.labelFlag AS chudaLabelFlag, kp.labelValue AS chudaLabel, kd.`chuxianFlag`, kd.`chuxian`, kd.`chuxianTime` ,kd.`chupinFlag` AS kdsChupinFlag, kd.`chupin` AS kdsChupin, kd.`chupinTime` AS kdsChupinTime
// 	      from pos_product p
// 	      inner join pos_product_spec ps on p.id = ps.productId
// 	      inner join pos_store_product sp on ps.id = sp.specId
// 	      left join pos_product_unit pu on p.unitId = pu.id
// 	      left join pos_product_category pc on p.categoryId = pc.id
// 	      left join pos_product_brand pb on p.brandId = pb.id
// 	      left join pos_supplier su on sp.supplierId = su.id
// 	      left join pos_kit_plan_product kp on p.id = kp.productId
//         left join pos_kds_plan_product kd ON p.id = kd.productId
// 	      where sp.status in (1, 2, 3) and ps.deleteFlag = 0 and p.posSellFlag = 1
// 	      order by p.categoryId, p.barCode;
//         """;

//         var database = await SqlUtils.instance.open();
//         List<Map<String, dynamic>> lists = await database.rawQuery(sql.replaceAll("\n", " "));

//         var productExtList = ProductExt.toList(lists);

//         if (productExtList != null) {
//           //????????????
//           for (var ex in productExtList) {
//             String productId = ex.id;
//             String specId = ex.specId;

//             //??????????????????????????????????????????
//             ex.allCode = ",${ex.allCode},";
//             //???????????????????????????
//             ex.specialPrice = ex.salePrice;

//             //???????????????????????????????????????????????????????????????????????????
//             if (ex.type == 2) {
//               ///
//             } else if (ex.type == 7) {
//               //??????,??????????????????
//             }
//             //????????????????????????????????????
//             if (ex.spNum >= 1) {
//               ProductExt masterProduct;
//               var moreSpecs = productExtList.where((x) => x.id == productId).toList();
//               if (moreSpecs != null && moreSpecs.length > 0) {
//                 ProductExt defaultProductSpec;
//                 if (moreSpecs.any((x) => x.isDefault == 1)) {
//                   defaultProductSpec = moreSpecs.lastWhere((x) => x.isDefault == 1);
//                 } else {
//                   defaultProductSpec = moreSpecs[0];
//                 }

//                 List<ProductSpec> newMoreSpecList = <ProductSpec>[];
//                 for (var sp in moreSpecs) {
//                   ProductSpec s = ProductSpec()
//                     ..id = sp.specId
//                     ..tenantId = sp.tenantId
//                     ..productId = productId
//                     ..specification = sp.specName
//                     ..purPrice = sp.purPrice
//                     ..salePrice = sp.salePrice
//                     ..minPrice = sp.minPrice
//                     ..vipPrice = sp.vipPrice
//                     ..vipPrice2 = sp.vipPrice2
//                     ..vipPrice3 = sp.vipPrice3
//                     ..vipPrice4 = sp.vipPrice4
//                     ..vipPrice5 = sp.vipPrice5
//                     //..plusPrice = sp.plusPrice
//                     ..purchaseSpec = sp.purchaseSpec
//                     ..postPrice = sp.postPrice
//                     ..batchPrice = sp.batchPrice
//                     ..otherPrice = sp.otherPrice
//                     ..isDefault = sp.isDefault;
//                   //..mallFlag = sp.mallFlag;

//                   newMoreSpecList.add(s);
//                 }

//                 if (newMoreSpecList.length > 0) {
//                   //?????????
//                   if (defaultProductSpec != null) {
//                     //???????????????????????????????????????????????????
//                     defaultProductSpec.specList = newMoreSpecList;
//                     masterProduct = defaultProductSpec;
//                   } else {
//                     //?????????????????????
//                     ex.specList = newMoreSpecList;
//                   }
//                 }
//               }

//               if (masterProduct == null) {
//                 realDic[productId] = ex;
//               } else {
//                 realDic[productId] = masterProduct;
//               }
//             } else {
//               //??????????????????????????????
//               List<ProductSpec> newMoreSpecList = new List<ProductSpec>();
//               ProductSpec s = ProductSpec()
//                 ..id = ex.specId
//                 ..tenantId = ex.tenantId
//                 ..productId = productId
//                 ..specification = ex.specName
//                 ..purPrice = ex.purPrice
//                 ..salePrice = ex.salePrice
//                 ..minPrice = ex.minPrice
//                 ..vipPrice = ex.vipPrice
//                 ..vipPrice2 = ex.vipPrice2
//                 ..vipPrice3 = ex.vipPrice3
//                 ..vipPrice4 = ex.vipPrice4
//                 ..vipPrice5 = ex.vipPrice5
//                 //..plusPrice = ex.plusPrice
//                 ..purchaseSpec = ex.purchaseSpec
//                 ..postPrice = ex.postPrice
//                 ..batchPrice = ex.batchPrice
//                 ..otherPrice = ex.otherPrice
//                 ..isDefault = ex.isDefault;

//               ///..mallFlag = sp.mallFlag
//               newMoreSpecList.add(s);

//               ex.specList = newMoreSpecList;

//               realDic[productId] = ex;
//             }
//           }
//         }
//       } catch (e, stack) {
//         FlutterChain.printError(e, stack);
//         FLogger.error("??????POS????????????????????????:" + e.toString());
//       }

//       result = realDic.values.toList();
//       FLogger.info("??????????????????????????????${result.length}???");

//       //???????????????
//       CacheManager.productExtList = result;
//     } else {
//       FLogger.info("???????????????????????????${result.length}???");
//     }

//     return result;
//   }

//   ///????????????????????????
//   Future<Tuple2<bool, String>> downloadProductImage() async {
//     bool result = false;
//     String msg = "";

//     try {
//       String sql = sprintf("select * from pos_product where trim(storageAddress) != ''", []);
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         List<Product> products = Product.toList(lists);
//         for (var product in products) {
//           String url = product.storageAddress;
//           bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
//           if (isUrl) {
//             String fileName = url.split('/').last;
//             if (StringUtils.isNotBlank(fileName)) {
//               print(">>>>url:$url");
//               await ImageUtils.downloadFiles(url, dir: Constants.PRODUCT_IMAGE_PATH);
//             }
//           }
//         }
//       }

//       result = true;
//       msg = "????????????????????????...";
//     } catch (e, stack) {
//       result = false;
//       msg = "???????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????:" + e.toString());
//     }
//     return Tuple2<bool, String>(result, msg);
//   }

//   ///????????????????????????
//   Future<Tuple2<bool, String>> downloadViceImage() async {
//     bool result = false;
//     String msg = "";

//     try {
//       String sql = sprintf("select * from pos_advert_picture where trim(storageAddress) != ''", []);
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         List<AdvertPicture> pictures = AdvertPicture.toList(lists);
//         for (var picture in pictures) {
//           String url = picture.storageAddress;
//           bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
//           if (isUrl) {
//             String fileName = url.split('/').last;
//             if (StringUtils.isNotBlank(fileName)) {
//               await ImageUtils.downloadFiles(url, dir: Constants.VICE_IMAGE_PATH);
//             }
//           }
//         }
//       }

//       result = true;
//       msg = "????????????????????????...";
//     } catch (e, stack) {
//       result = false;
//       msg = "???????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????:" + e.toString());
//     }
//     return Tuple2<bool, String>(result, msg);
//   }

//   ///????????????????????????
//   Future<Tuple2<bool, String>> downloadPrinterImage() async {
//     bool result = false;
//     String msg = "";

//     try {
//       String sql = "select * from pos_print_img where trim(storageAddress) != ''";
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       if (lists != null && lists.length > 0) {
//         List<PrintImg> imgs = PrintImg.toList(lists);
//         for (var img in imgs) {
//           String url = img.storageAddress;
//           bool isUrl = RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(url);
//           if (isUrl) {
//             String fileName = url.split('/').last;
//             if (StringUtils.isNotBlank(fileName)) {
//               await ImageUtils.downloadFiles(url, dir: Constants.PRINTER_IMAGE_PATH);
//             }
//           }
//         }
//       }

//       result = true;
//       msg = "????????????????????????...";
//     } catch (e, stack) {
//       result = false;
//       msg = "???????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????:" + e.toString());
//     }
//     return Tuple2<bool, String>(result, msg);
//   }

//   /// ?????????
//   double fen2YuanByInt(int amount) {
//     return amount / 100;
//   }

//   String yuan2Fen(double amount) {
//     return Convert.toInt(amount * 100).toString();
//   }

//   double toRound(double value, {int precision = 2}) {
//     Decimal result = Decimal.fromDouble(value).roundWithPrecision(precision, RoundingMode.nearestFromZero);
//     return result.toDouble();
//   }

//   String removeDecimalZeroFormat(double n, {int precision = 2}) {
//     return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : precision);
//   }

//   Future<List<OrderObject>> getUploadOrderObject({int limit = 5}) async {
//     List<OrderObject> result = new List<OrderObject>();

//     try {
//       String orderTemplate = "select * from pos_order where orderStatus in(2, 4) and uploadStatus = 0 order by uploadErrors limit %s;";
//       String orderSql = sprintf(orderTemplate, [limit]);

//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(orderSql);

//       result.addAll(OrderObject.toList(lists));
//     } catch (e, stack) {
//       FLogger.error("?????????????????????????????????:" + e.toString());
//     } finally {}
//     return result;
//   }

//   Future<OrderObject> builderOrderObject(String orderId, {String tradeNo = ""}) async {
//     OrderObject orderObject;
//     try {
//       //??????????????????
//       String orderTemplate = "select * from pos_order where id = '%s';";
//       String orderSql = sprintf(orderTemplate, [orderId]);
//       if (StringUtils.isNotBlank(tradeNo)) {
//         orderTemplate = "select * from pos_order where tradeNo like '%%s' order by saleDate desc;";
//         orderSql = sprintf(orderTemplate, [tradeNo]);
//       }
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> orderMap = await database.rawQuery(orderSql);
//       if (orderMap != null && orderMap.length > 0) {
//         orderObject = OrderObject.fromMap(orderMap[0]);
//       }

//       //????????????
//       List<OrderItem> items = <OrderItem>[];
//       //??????????????????
//       List<OrderPay> pays = <OrderPay>[];
//       //????????????
//       List<OrderItemMake> flavors = <OrderItemMake>[];
//       //????????????
//       List<OrderItemPromotion> promotionItems = <OrderItemPromotion>[];
//       //????????????
//       List<OrderPromotion> promotionOrders = <OrderPromotion>[];
//       //?????????????????????
//       List<OrderItemPay> itemPays = <OrderItemPay>[];
//       //????????????
//       List<OrderTable> tables = <OrderTable>[];

//       //List<ProductExt> productList = GetPosCanSaleProduct();

//       if (orderObject != null) {
//         //??????????????????
//         String orderItemTemplate = "select * from pos_order_item where orderId = '%s';";
//         String orderItemSql = sprintf(orderItemTemplate, [orderId]);

//         List<Map<String, dynamic>> orderItemLists = await database.rawQuery(orderItemSql);
//         if (orderItemLists != null && orderItemLists.length > 0) {
//           items.addAll(OrderItem.toList(orderItemLists));
//         }

//         //????????????????????????
//         String orderPayTemplate = "select * from pos_order_pay where orderId = '%s';";
//         String orderPaySql = sprintf(orderPayTemplate, [orderId]);
//         List<Map<String, dynamic>> orderPayLists = await database.rawQuery(orderPaySql);
//         if (orderPayLists != null && orderPayLists.length > 0) {
//           pays.addAll(OrderPay.toList(orderPayLists));
//         }

//         //??????????????????
//         String orderPromotionTemplate = "select * from pos_order_promotion where orderId = '%s';";
//         String orderPromotionSql = sprintf(orderPromotionTemplate, [orderId]);
//         List<Map<String, dynamic>> orderPromotionLists = await database.rawQuery(orderPromotionSql);
//         if (orderPromotionLists != null && orderPromotionLists.length > 0) {
//           promotionOrders.addAll(OrderPromotion.toList(orderPromotionLists));
//         }

//         //???????????????????????????
//         String orderTableTemplate = "select * from pos_order_table where orderId = '%s';";
//         String orderTableSql = sprintf(orderTableTemplate, [orderId]);
//         List<Map<String, dynamic>> orderTableLists = await database.rawQuery(orderTableSql);
//         if (orderTableLists != null && orderTableLists.length > 0) {
//           tables.addAll(OrderTable.toList(orderTableLists));
//         }

//         //????????????????????????
//         String orderItemPromotionTemplate = "select * from pos_order_item_promotion where orderId = '%s';";
//         String orderItemPromotionSql = sprintf(orderItemPromotionTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemPromotionLists = await database.rawQuery(orderItemPromotionSql);
//         if (orderItemPromotionLists != null && orderItemPromotionLists.length > 0) {
//           promotionItems.addAll(OrderItemPromotion.toList(orderItemPromotionLists));
//         }

//         //????????????????????????
//         String orderItemMakeTemplate = "select * from pos_order_item_make where orderId = '%s';";
//         String orderItemMakeSql = sprintf(orderItemMakeTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemMakeLists = await database.rawQuery(orderItemMakeSql);
//         if (orderItemMakeLists != null && orderItemMakeLists.length > 0) {
//           flavors.addAll(OrderItemMake.toList(orderItemMakeLists));
//         }

//         //??????????????????????????????
//         String orderItemPayTemplate = "select * from pos_order_item_pay where orderId = '%s';";
//         String orderItemPaySql = sprintf(orderItemPayTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemPayLists = await database.rawQuery(orderItemPaySql);
//         if (orderItemPayLists != null && orderItemPayLists.length > 0) {
//           itemPays.addAll(OrderItemPay.toList(orderItemPayLists));
//         }

//         orderObject.items = items;
//         orderObject.pays = pays;
//         orderObject.promotions = promotionOrders;
//         orderObject.tables = tables;

//         for (var item in orderObject.items) {
//           //????????????
//           item.flavors = <OrderItemMake>[];
//           var _flavors = flavors.where((f) => f.itemId == item.id).toList();
//           if (_flavors != null && _flavors.length > 0) {
//             item.flavors.addAll(_flavors);
//           }

//           //????????????????????????
//           item.itemPays = <OrderItemPay>[];
//           var _pays = itemPays.where((p) => p.itemId == item.id).toList();
//           if (_pays != null && _pays.length > 0) {
//             item.itemPays.addAll(_pays);
//           }
//           //????????????
//           item.promotions = <OrderItemPromotion>[];
//           var _promotions = promotionItems.where((p) => p.itemId == item.id).toList();
//           if (_promotions != null && _promotions.length > 0) {
//             item.promotions.addAll(_promotions);
//           }
//           //???????????????????????????

//         }
//       }
//     } catch (e, stack) {
//       FLogger.error("????????????????????????:" + e.toString());
//     } finally {
//       //await SqlUtils.instance.close();
//     }

//     return orderObject;
//   }

//   Future<OrderObject> additionalOrderObject(OrderObject orderObject) async {
//     try {
//       //????????????
//       List<OrderItem> items = <OrderItem>[];
//       //??????????????????
//       List<OrderPay> pays = <OrderPay>[];
//       //????????????
//       List<OrderItemMake> flavors = <OrderItemMake>[];
//       //????????????
//       List<OrderItemPromotion> promotionItems = <OrderItemPromotion>[];
//       //????????????
//       List<OrderPromotion> promotionOrders = <OrderPromotion>[];
//       //?????????????????????
//       List<OrderItemPay> itemPays = <OrderItemPay>[];
//       //????????????
//       List<OrderTable> tables = <OrderTable>[];

//       //List<ProductExt> productList = GetPosCanSaleProduct();

//       if (orderObject != null) {
//         String orderId = orderObject.id;

//         var database = await SqlUtils.instance.open();

//         //??????????????????
//         String orderItemTemplate = "select * from pos_order_item where orderId = '%s';";
//         String orderItemSql = sprintf(orderItemTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemLists = await database.rawQuery(orderItemSql);
//         if (orderItemLists != null && orderItemLists.length > 0) {
//           items.addAll(OrderItem.toList(orderItemLists));
//         }
//         //????????????????????????
//         String orderPayTemplate = "select * from pos_order_pay where orderId = '%s';";
//         String orderPaySql = sprintf(orderPayTemplate, [orderId]);
//         List<Map<String, dynamic>> orderPayLists = await database.rawQuery(orderPaySql);
//         if (orderPayLists != null && orderPayLists.length > 0) {
//           pays.addAll(OrderPay.toList(orderPayLists));
//         }
//         //??????????????????
//         String orderPromotionTemplate = "select * from pos_order_promotion where orderId = '%s';";
//         String orderPromotionSql = sprintf(orderPromotionTemplate, [orderId]);
//         List<Map<String, dynamic>> orderPromotionLists = await database.rawQuery(orderPromotionSql);
//         if (orderPromotionLists != null && orderPromotionLists.length > 0) {
//           promotionOrders.addAll(OrderPromotion.toList(orderPromotionLists));
//         }

//         //???????????????????????????
//         String orderTableTemplate = "select * from pos_order_table where orderId = '%s';";
//         String orderTableSql = sprintf(orderTableTemplate, [orderId]);
//         List<Map<String, dynamic>> orderTableLists = await database.rawQuery(orderTableSql);
//         if (orderTableLists != null && orderTableLists.length > 0) {
//           tables.addAll(OrderTable.toList(orderTableLists));
//         }
//         orderObject.tables = tables;

//         //????????????????????????
//         String orderItemPromotionTemplate = "select * from pos_order_item_promotion where orderId = '%s';";
//         String orderItemPromotionSql = sprintf(orderItemPromotionTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemPromotionLists = await database.rawQuery(orderItemPromotionSql);
//         if (orderItemPromotionLists != null && orderItemPromotionLists.length > 0) {
//           promotionItems.addAll(OrderItemPromotion.toList(orderItemPromotionLists));
//         }

//         //????????????????????????
//         String orderItemMakeTemplate = "select * from pos_order_item_make where orderId = '%s';";
//         String orderItemMakeSql = sprintf(orderItemMakeTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemMakeLists = await database.rawQuery(orderItemMakeSql);
//         if (orderItemMakeLists != null && orderItemMakeLists.length > 0) {
//           flavors.addAll(OrderItemMake.toList(orderItemMakeLists));
//         }

//         //??????????????????????????????
//         String orderItemPayTemplate = "select * from pos_order_item_pay where orderId = '%s';";
//         String orderItemPaySql = sprintf(orderItemPayTemplate, [orderId]);
//         List<Map<String, dynamic>> orderItemPayLists = await database.rawQuery(orderItemPaySql);
//         if (orderItemPayLists != null && orderItemPayLists.length > 0) {
//           itemPays.addAll(OrderItemPay.toList(orderItemPayLists));
//         }

//         orderObject.items = items;
//         orderObject.pays = pays;
//         orderObject.promotions = promotionOrders;

//         for (var item in orderObject.items) {
//           //????????????
//           item.flavors = <OrderItemMake>[];
//           var _flavors = flavors.where((f) => f.itemId == item.id).toList();
//           if (_flavors != null && _flavors.length > 0) {
//             item.flavors.addAll(_flavors);
//           }

//           //????????????????????????
//           item.itemPays = <OrderItemPay>[];
//           var _pays = itemPays.where((p) => p.itemId == item.id).toList();
//           if (_pays != null && _pays.length > 0) {
//             item.itemPays.addAll(_pays);
//           }
//           //????????????
//           item.promotions = <OrderItemPromotion>[];
//           var _promotions = promotionItems.where((p) => p.itemId == item.id).toList();
//           if (_promotions != null && _promotions.length > 0) {
//             item.promotions.addAll(_promotions);
//           }
//           //???????????????????????????
//         }
//       }
//     } catch (e, stack) {
//       FLogger.error("????????????????????????:" + e.toString());
//     } finally {
//       //await SqlUtils.instance.close();
//     }

//     return orderObject;
//   }

//   ///????????????????????????
//   Future<Tuple2<bool, String>> updateUploadStatus(Map<String, dynamic> data) async {
//     bool result = true;
//     String message = "??????????????????????????????";
//     try {
//       //"serverId", "uploadStatus", "uploadCode", "uploadMessage", "uploadErrors", "uploadTime", "modifyUser", "modifyDate"

//       var database = await SqlUtils.instance.open();
//       await database.transaction((txn) async {
//         try {
//           var batch = txn.batch();

//           var template = "update pos_order set serverId = '%s',uploadStatus = '%s' ,uploadCode = '%s' ,uploadMessage = '%s' ,uploadErrors = '%s' ,uploadTime = '%s' ,modifyUser = '%s' ,modifyDate = '%s' where id = '%s';";
//           var sql = sprintf(template, [
//             data["serverId"],
//             data["uploadStatus"],
//             data["uploadCode"],
//             data["uploadMessage"],
//             data["uploadErrors"],
//             data["uploadTime"],
//             data["modifyUser"],
//             data["modifyDate"],
//             data["id"],
//           ]);
//           batch.rawInsert(sql);

//           await batch.commit(noResult: false);
//         } catch (e) {
//           FLogger.error("??????????????????????????????:" + e.toString());
//         }
//       });
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     } finally {
//       //await SqlUtils.instance.close();
//     }
//     return Tuple2<bool, String>(result, message);
//   }

//   ///??????????????????
//   Future<Tuple3<bool, String, String>> generateOrderNo({int length = 2}) async {
//     bool result = false;
//     String message = "??????????????????????????????!!";
//     String data = "";
//     try {
//       data = await _generateSerialNumber(length, ConfigConstant.GROUP_BUSINESS, ConfigConstant.ORDER_NO);

//       if (StringUtils.isNotBlank(data)) {
//         result = true;
//         message = "??????????????????????????????";
//       } else {
//         result = false;
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";

//       FlutterChain.printError(e, stack);
//       FLogger.error("????????????????????????????????????:" + e.toString());
//     }

//     return Tuple3<bool, String, String>(result, message, data);

//     //return Tuple3<bool, String, String>(true, "", "1");
//   }

//   ///????????????
//   Future<Tuple3<bool, String, OrderObject>> saveOrderObject(OrderObject orderObject) async {
//     bool result = false;
//     String message = "";

//     try {
//       ///?????????????????????????????????????????????
//       var finishDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//       //????????????????????????
//       orderObject.finishDate = finishDate;
//       //??????????????????
//       orderObject.paymentStatus = OrderPaymentStatus.Paid;
//       //????????????
//       orderObject.orderStatus = OrderStatus.Completed;
//       //????????????
//       orderObject.refundStatus = OrderRefundStatus.NonRefund;

//       orderObject.payCount = orderObject.pays.length;
//       orderObject.itemCount = orderObject.items.length;

//       //??????
//       var shitLog = await Global.instance.getShiftLog();
//       //????????????
//       orderObject.deviceName = Global.instance.authc.compterName;
//       orderObject.macAddress = Global.instance.authc.macAddress;
//       orderObject.ipAddress = await DeviceUtils.instance.getIpAddress();

//       //????????????
//       orderObject.shiftId = shitLog.id;
//       orderObject.shiftNo = shitLog.no;
//       orderObject.shiftName = shitLog.name;

//       //???????????? 0-????????? 1-????????????,????????? 2-????????? 3-??????????????????,????????????
//       //orderObject.MakeStatus = 0;

//       //?????????????????????
//       var orderNoResult = await OrderUtils.instance.generateOrderNo();
//       orderObject.orderNo = orderNoResult.item3;

//       orderObject.orderStatus = OrderStatus.Completed;

//       await builderMalingPayMode(orderObject);

//       // //??????????????????????????????
//       // BuilderMalingPayMode(orderObject);
//       //
//       // //????????????????????????????????????
//       // AddBindingItems2Order(orderObject);
//       //
//       // //??????????????????????????????
//       // if (orderObject.Items.Exists(x => x.RowType == OrderRowType.?????????))
//       // {
//       //   CalculateSetMealShare(orderObject);
//       // }
//       //
//       // //??????????????????
//       // BuilderItemPayShared(orderObject);

//       //????????????????????????????????????
//       await builderItemPayShared(orderObject);

//       //????????????
//       if (orderObject.cashierAction == CashierAction.Refund) {
//         orderObject.orderStatus = OrderStatus.ChargeBack;
//       } else {
//         orderObject.orderStatus = OrderStatus.Completed;
//       }
//       //??????????????????
//       orderObject.paymentStatus = OrderPaymentStatus.Paid;

//       var queues = new Queue<String>();

//       //pos_order??????SQL??????
//       var order = await buildOrderObjectSql(orderObject, finishDate);
//       if (order.item1) {
//         queues.add(order.item3);
//       }

//       //pos_order_item??????SQL??????
//       var orderItem = await buildOrderItemSql(orderObject, finishDate);
//       if (orderItem.item1) {
//         queues.addAll(orderItem.item3);
//       }

//       //pos_order_promotion??????SQL??????
//       var orderPromotion = await buildOrderPromotionSql(orderObject, finishDate);
//       if (orderPromotion.item1) {
//         queues.add(orderPromotion.item3);
//       }

//       //pos_order_pay??????SQL??????
//       var orderPay = await _buildOrderPaySql(orderObject, finishDate);
//       if (orderPay.item1) {
//         queues.add(orderPay.item3);
//       }

//       bool hasFailed = true;
//       var database = await SqlUtils.instance.open();
//       await database.transaction((txn) async {
//         try {
//           var batch = txn.batch();
//           queues.forEach((obj) {
//             batch.rawInsert(obj);
//           });
//           await batch.commit(noResult: false);
//           hasFailed = false;
//         } catch (e) {
//           FLogger.error("????????????????????????:" + e.toString());
//         }
//       });

//       if (hasFailed) {
//         result = false;
//         message = "??????????????????...";
//       } else {
//         result = true;
//         message = "??????????????????,???<${queues.length}>???...";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, OrderObject>(result, message, orderObject);
//   }

//   ///??????????????????
//   Future<Tuple3<bool, String, OrderObject>> saveTableOrderObject(OrderObject orderObject) async {
//     bool result = false;
//     String message = "";

//     ///?????????????????????????????????????????????
//     var finishDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//     try {
//       //????????????????????????
//       orderObject.finishDate = finishDate;
//       //??????????????????
//       orderObject.paymentStatus = OrderPaymentStatus.Paid;

//       //????????????
//       orderObject.refundStatus = OrderRefundStatus.NonRefund;

//       orderObject.payCount = orderObject.pays.length;
//       orderObject.itemCount = orderObject.items.length;

//       //??????
//       var shitLog = await Global.instance.getShiftLog();
//       //????????????
//       orderObject.deviceName = Global.instance.authc.compterName;
//       orderObject.macAddress = Global.instance.authc.macAddress;
//       orderObject.ipAddress = await DeviceUtils.instance.getIpAddress();

//       //????????????
//       orderObject.shiftId = shitLog.id;
//       orderObject.shiftNo = shitLog.no;
//       orderObject.shiftName = shitLog.name;

//       //???????????? 0-????????? 1-????????????,????????? 2-????????? 3-??????????????????,????????????
//       orderObject.makeStatus = 2;

//       //?????????????????????
//       var orderNoResult = await OrderUtils.instance.generateOrderNo();
//       orderObject.orderNo = orderNoResult.item3;

//       await builderMalingPayMode(orderObject);

//       // //??????????????????????????????
//       // BuilderMalingPayMode(orderObject);
//       //
//       // //????????????????????????????????????
//       // AddBindingItems2Order(orderObject);
//       //
//       // //??????????????????????????????
//       // if (orderObject.Items.Exists(x => x.RowType == OrderRowType.?????????))
//       // {
//       //   CalculateSetMealShare(orderObject);
//       // }
//       //
//       // //??????????????????
//       // BuilderItemPayShared(orderObject);

//       //????????????????????????????????????
//       await builderItemPayShared(orderObject);

//       //????????????
//       if (orderObject.cashierAction == CashierAction.Refund) {
//         orderObject.orderStatus = OrderStatus.ChargeBack;
//       } else {
//         orderObject.orderStatus = OrderStatus.Completed;
//       }

//       var queues = new Queue<String>();

//       //?????????????????????????????????
//       var orderObjectSql = sprintf("update pos_order set finishDate='%s',paidAmount='%s',paymentStatus='%s',orderStatus='%s',refundStatus='%s',payCount='%s',itemCount='%s',deviceName='%s',macAddress='%s',ipAddress='%s',shiftId='%s',shiftNo='%s',shiftName='%s',makeStatus='%s',orderNo='%s' where id = '%s';", [
//         orderObject.finishDate,
//         orderObject.paidAmount,
//         orderObject.paymentStatus.value,
//         orderObject.orderStatus.value,
//         orderObject.refundStatus.value,
//         orderObject.payCount,
//         orderObject.itemCount,
//         orderObject.deviceName,
//         orderObject.macAddress,
//         orderObject.ipAddress,
//         orderObject.shiftId,
//         orderObject.shiftNo,
//         orderObject.shiftName,
//         orderObject.makeStatus,
//         orderObject.orderNo,
//         orderObject.id,
//       ]);
//       //pos_order??????SQL??????
//       queues.add(orderObjectSql);

//       //pos_order_item??????SQL??????
//       var newItems = orderObject.items;
//       for (var item in newItems) {
//         var orderItemSql = sprintf("update pos_order_item set finishDate='%s',salesCode='%s',salesName='%s' where id='%s';", [
//           orderObject.finishDate,
//           orderObject.salesCode,
//           orderObject.salesName,
//           item.id,
//         ]);
//         queues.add(orderItemSql);

//         for (var p in item.promotions) {
//           var orderItemPromotionSql = sprintf("update pos_order_item_promotion set finishDate='%s' where id='%s';", [
//             orderObject.finishDate,
//             p.id,
//           ]);
//           queues.add(orderItemPromotionSql);
//         }

//         for (var f in item.flavors) {
//           var orderItemMakeSql = sprintf("update pos_order_item_make set finishDate='%s' where id='%s';", [
//             orderObject.finishDate,
//             f.id,
//           ]);
//           queues.add(orderItemMakeSql);
//         }

//         //pos_order_item_pay??????SQL??????
//         var orderItemPay = await _buildOrderItemPaySql(item, finishDate);
//         if (orderItemPay.item1) {
//           queues.add(orderItemPay.item3);
//         }
//       }

//       //pos_order_table??????SQL??????
//       var newTables = orderObject.tables;
//       for (var table in newTables) {
//         var orderItemSql = sprintf("update pos_order_table set finishDate='%s',tableAction='%s',tableStatus='%s' where id='%s';", [
//           orderObject.finishDate,
//           OrderTableAction.None.value, //??????
//           OrderTableStatus.Free.value, //??????
//           // OrderTableAction.Clear.value, //?????????
//           // OrderTableStatus.Occupied.value, //??????
//           table.id,
//         ]);
//         queues.add(orderItemSql);
//       }

//       //??????pos_order_promotion??????SQL??????
//       for (var promotion in orderObject.promotions) {
//         var orderPromotionSql = sprintf("update pos_order_promotion set finishDate='%s' where id='%s';", [
//           orderObject.finishDate,
//           promotion.id,
//         ]);
//         queues.add(orderPromotionSql);
//       }

//       //pos_order_pay??????SQL??????
//       var orderPay = await _buildOrderPaySql(orderObject, finishDate);
//       if (orderPay.item1) {
//         queues.add(orderPay.item3);
//       }

//       bool hasFailed = true;
//       var database = await SqlUtils.instance.open();
//       await database.transaction((txn) async {
//         try {
//           var batch = txn.batch();
//           queues.forEach((obj) {
//             batch.execute(obj);
//           });
//           await batch.commit(noResult: false);
//           hasFailed = false;
//         } catch (e, stack) {
//           FlutterChain.printError(e, stack);
//           FLogger.error("????????????????????????:" + e.toString());
//         }
//       });

//       if (hasFailed) {
//         result = false;
//         message = "??????????????????...";
//       } else {
//         result = true;
//         message = "??????????????????,???<${queues.length}>???...";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     } finally {
//       //?????????????????????????????????
//     }

//     return Tuple3<bool, String, OrderObject>(result, message, orderObject);
//   }

//   ///????????????
//   Future<Tuple3<bool, String, OrderObject>> saveRefundOrderObject(OrderObject source, OrderObject refund) async {
//     bool result = false;
//     String message = "";
//     try {
//       ///?????????????????????????????????????????????
//       var finishDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//       //????????????????????????
//       refund.finishDate = finishDate;
//       //??????????????????
//       refund.paymentStatus = OrderPaymentStatus.Paid;
//       //????????????
//       refund.orderStatus = OrderStatus.ChargeBack;
//       //????????????
//       refund.refundStatus = OrderRefundStatus.NonRefund;

//       refund.payCount = refund.pays.length;
//       refund.itemCount = refund.items.length;

//       //????????????
//       refund.deviceName = Global.instance.authc.compterName;
//       refund.macAddress = Global.instance.authc.macAddress;
//       refund.ipAddress = await DeviceUtils.instance.getIpAddress();
//       //??????
//       var shitLog = await Global.instance.getShiftLog();
//       //????????????
//       refund.shiftId = shitLog.id;
//       refund.shiftNo = shitLog.no;
//       refund.shiftName = shitLog.name;

//       var queues = new Queue<String>();

//       //pos_order??????SQL??????
//       var order = await buildOrderObjectSql(refund, finishDate);
//       if (order.item1) {
//         queues.add(order.item3);
//       }

//       //pos_order_item??????SQL??????
//       var orderItem = await buildOrderItemSql(refund, finishDate);
//       if (orderItem.item1) {
//         queues.addAll(orderItem.item3);
//       }

//       //pos_order_promotion??????SQL??????
//       var orderPromotion = await buildOrderPromotionSql(refund, finishDate);
//       if (orderPromotion.item1) {
//         queues.add(orderPromotion.item3);
//       }

//       //pos_order_pay??????SQL??????
//       var orderPay = await _buildOrderPaySql(refund, finishDate);
//       if (orderPay.item1) {
//         queues.add(orderPay.item3);
//       }

//       //???????????????????????????
//       bool allRefund = (refund.receivableAmount + source.receivableAmount == 0);
//       source.refundStatus = allRefund ? OrderRefundStatus.Refund : OrderRefundStatus.PartRefund;

//       //????????????????????????
//       for (var item in source.items) {
//         String updateOrderItemSql = "update pos_order_item set rquantity='${item.refundQuantity}',ramount='${item.refundAmount}',refundPoint='${item.refundPoint}' where id='${item.id}';";
//         queues.add(updateOrderItemSql);
//         //?????????????????????
//         if (item.itemPays != null && item.itemPays.length > 0) {
//           for (var itemPay in item.itemPays) {
//             String updateOrderItemPaySql = "update pos_order_item_pay set ramount='${itemPay.refundAmount}' where id='${itemPay.id}';";
//             queues.add(updateOrderItemPaySql);
//           }
//         }
//       }

//       for (var pay in source.pays) {
//         String updateOrderPaySql = "update pos_order_pay set ramount='${pay.refundAmount}' where id='${pay.id}';";
//         queues.add(updateOrderPaySql);
//       }

//       String updateOrderObjectSql = "update pos_order set refundStatus='${source.refundStatus.value}',refundPoint='${source.refundPoint}' where id='${source.id}';";
//       queues.add(updateOrderObjectSql);

//       bool hasFailed = true;
//       var database = await SqlUtils.instance.open();
//       await database.transaction((txn) async {
//         try {
//           var batch = txn.batch();
//           queues.forEach((obj) {
//             batch.rawInsert(obj);
//           });
//           await batch.commit(noResult: false);
//           hasFailed = false;
//         } catch (e) {
//           FLogger.error("????????????????????????:" + e.toString());
//         }
//       });

//       if (hasFailed) {
//         result = false;
//         message = "????????????????????????...";
//       } else {
//         result = true;
//         message = "????????????????????????,???<${queues.length}>???...";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, OrderObject>(result, message, refund);
//   }

//   //??????pos_order???SQL??????
//   Future<Tuple3<bool, String, String>> buildOrderObjectSql(OrderObject orderObject, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       //????????????pos_order??????
//       String template = """
//           insert into pos_order(id,tenantId,objectId,orderNo,tradeNo,storeId,storeNo,storeName,workerNo,workerName,saleDate,finishDate,tableNo,tableName,
//           salesCode,salesName,posNo,deviceName,macAddress,ipAddress,itemCount,payCount,totalQuantity,amount,discountAmount,receivableAmount,paidAmount,
//           receivedAmount,malingAmount,changeAmount,invoicedAmount,overAmount,orderStatus,paymentStatus,printStatus,printTimes,postWay,orderSource,people,
//           shiftId,shiftNo,shiftName,discountRate,orgTradeNo,refundCause,isMember,memberNo,memberName,memberMobileNo,cardFaceNo,prePoint,addPoint,refundPoint,
//           aftPoint,aftAmount,uploadStatus,uploadErrors,uploadCode,uploadMessage,serverId,uploadTime,weather,weeker,remark,memberId,receivableRemoveCouponAmount,
//           isPlus,plusDiscountAmount,ext1,ext2,ext3,createUser,createDate,refundStatus,orderUploadSource,pointDealStatus,cashierAction) values
//           ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//           '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//           '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//           '%s','%s','%s','%s','%s','%s','%s','%s');
//          """;
//       //??????SQL??????
//       data = sprintf(template, [
//         //?????????
//         orderObject.id,
//         orderObject.tenantId,
//         orderObject.objectId,
//         orderObject.orderNo,
//         orderObject.tradeNo,
//         orderObject.storeId,
//         orderObject.storeNo,
//         orderObject.storeName,
//         orderObject.workerNo,
//         orderObject.workerName,
//         orderObject.saleDate,
//         orderObject.finishDate,
//         orderObject.tableNo,
//         orderObject.tableName,
//         //?????????
//         orderObject.salesCode,
//         orderObject.salesName,
//         orderObject.posNo,
//         orderObject.deviceName,
//         orderObject.macAddress,
//         orderObject.ipAddress,
//         orderObject.itemCount,
//         orderObject.payCount,
//         orderObject.totalQuantity,
//         orderObject.amount,
//         orderObject.discountAmount,
//         orderObject.receivableAmount,
//         orderObject.paidAmount,
//         //?????????
//         orderObject.receivedAmount,
//         orderObject.malingAmount,
//         orderObject.changeAmount,
//         orderObject.invoicedAmount,
//         orderObject.overAmount,
//         orderObject.orderStatus.value,
//         orderObject.paymentStatus.value,
//         orderObject.printStatus.value,
//         orderObject.printTimes,
//         orderObject.postWay.value,
//         orderObject.orderSource.value,
//         orderObject.people,
//         //?????????
//         orderObject.shiftId,
//         orderObject.shiftNo,
//         orderObject.shiftName,
//         orderObject.discountRate,
//         orderObject.orgTradeNo,
//         orderObject.refundCause,
//         orderObject.isMember,
//         orderObject.memberNo,
//         orderObject.memberName,
//         orderObject.memberMobileNo,
//         orderObject.cardFaceNo,
//         orderObject.prePoint,
//         orderObject.addPoint,
//         orderObject.refundPoint,
//         //?????????
//         orderObject.aftPoint,
//         orderObject.aftAmount,
//         orderObject.uploadStatus,
//         orderObject.uploadErrors,
//         orderObject.uploadCode,
//         orderObject.uploadMessage,
//         orderObject.serverId,
//         orderObject.uploadTime,
//         orderObject.weather,
//         orderObject.weeker,
//         orderObject.remark,
//         orderObject.memberId,
//         orderObject.receivableRemoveCouponAmount,
//         //?????????
//         orderObject.isPlus,
//         orderObject.plusDiscountAmount,
//         orderObject.ext1 ?? "",
//         orderObject.ext2 ?? "",
//         orderObject.ext3 ?? "",
//         orderObject.createUser ?? Constants.DEFAULT_CREATE_USER,
//         orderObject.createDate ?? DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
//         orderObject.refundStatus.value,
//         orderObject.orderUploadSource.value,
//         orderObject.pointDealStatus.value,
//         orderObject.cashierAction.value,
//       ]);

//       //???????????????
//       data = data.replaceAll("\n", "");
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   ///??????pos_order_item???SQL??????
//   /// newItemList ?????????????????????????????????????????????????????????????????????
//   Future<Tuple3<bool, String, List<String>>> buildOrderItemSql(OrderObject orderObject, String finishDate, {List<OrderItem> newItemList}) async {
//     bool result = true;
//     String message = "????????????";
//     List<String> data = <String>[];
//     try {
//       //?????????????????????pos_order_item
//       String templatePrefix = """
//         insert into pos_order_item (id,tenantId,orderId,tradeNo,orderNo,productId,productName,shortName,specId,specName,
//         displayName,quantity,rquantity,ramount,orgItemId,salePrice,price,bargainReason,discountPrice,vipPrice,otherPrice,
//         batchPrice,postPrice,purPrice,minPrice,giftQuantity,giftAmount,giftReason,flavorCount,flavorNames,flavorAmount,
//         flavorDiscountAmount,flavorReceivableAmount,amount,totalAmount,discountAmount,receivableAmount,totalDiscountAmount,
//         totalReceivableAmount,discountRate,totalDiscountRate,malingAmount,remark,saleDate,finishDate,cartDiscount,underline,
//         `group`,parentId,flavor,scheme,rowType,suitId,suitQuantity,suitAddPrice,suitAmount,chuda,chudaFlag,chudaQty,
//         chupin,chupinFlag,chupinQty,productType,barCode,subNo,batchNo,productUnitId,productUnitName,categoryId,categoryNo,
//         categoryName,brandId,brandName,foreDiscount,weightFlag,weightWay,foreBargain,pointFlag,pointValue,foreGift,promotionFlag,
//         stockFlag,batchStockFlag,labelPrintFlag,labelQty,purchaseTax,saleTax,supplierId,supplierName,managerType,salesCode,
//         salesName,itemSource,posNo,addPoint,refundPoint,promotionInfo,ext1,ext2,ext3,createUser,createDate,lyRate,chuDaLabel,
//         chuDaLabelFlag,chuDaLabelQty,shareCouponLeastCost,couponAmount,totalReceivableRemoveCouponAmount,
//         totalReceivableRemoveCouponLeastCost,joinType,labelAmount,isPlusPrice,realPayAmount,shareMemberId,
//         orderRowStatus,tableId,tableNo,tableName,rreason,tableBatchTag) values
//       """;
//       String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
//         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//       //?????????????????????
//       var bufferOrderItem = new StringBuffer();
//       bufferOrderItem.write(templatePrefix);

//       // //????????????????????????
//       // var bufferOrderItemPromotion = new StringBuffer();
//       // //????????????????????????
//       // var bufferOrderItemMake = new StringBuffer();
//       // //??????????????????????????????
//       // var bufferOrderItemPay = new StringBuffer();

//       //????????????????????????????????????
//       var newItems = newItemList ?? orderObject.items;
//       for (var item in newItems) {
//         if (StringUtils.isBlank(item.id)) {
//           item.id = IdWorkerUtils.getInstance().generate().toString();
//         }

//         if (StringUtils.isBlank(item.tenantId)) {
//           item.tenantId = Global.instance.authc.tenantId;
//         }

//         item.finishDate = finishDate;
//         item.salesCode = orderObject.salesCode;
//         item.salesName = orderObject.salesName;

//         var sql = sprintf(templateSuffix, [
//           //?????????
//           item.id,
//           item.tenantId,
//           item.orderId,
//           item.tradeNo,
//           item.orderNo,
//           item.productId,
//           item.productName,
//           item.shortName,
//           item.specId,
//           item.specName,
//           //?????????
//           item.displayName,
//           item.quantity,
//           item.refundQuantity,
//           item.refundAmount,
//           item.orgItemId,
//           item.salePrice,
//           item.price,
//           item.bargainReason,
//           item.discountPrice,
//           item.vipPrice,
//           item.otherPrice,
//           //?????????
//           item.batchPrice,
//           item.postPrice,
//           item.purPrice,
//           item.minPrice,
//           item.giftQuantity,
//           item.giftAmount,
//           item.giftReason,
//           item.flavorCount,
//           item.flavorNames,
//           item.flavorAmount,
//           //?????????
//           item.flavorDiscountAmount,
//           item.flavorReceivableAmount,
//           item.amount,
//           item.totalAmount,
//           item.discountAmount,
//           item.receivableAmount,
//           item.totalDiscountAmount,
//           //?????????
//           item.totalReceivableAmount,
//           item.discountRate,
//           item.totalDiscountRate,
//           item.malingAmount,
//           item.remark,
//           item.saleDate,
//           item.finishDate,
//           item.cartDiscount,
//           item.underline,
//           //?????????
//           item.group,
//           item.parentId,
//           item.flavor,
//           item.scheme,
//           item.rowType.value,
//           item.suitId,
//           item.suitQuantity,
//           item.suitAddPrice,
//           item.suitAmount,
//           item.chuda,
//           item.chudaFlag,
//           item.chudaQty,
//           //?????????
//           item.chupin,
//           item.chupinFlag,
//           item.chupinQty,
//           item.productType,
//           item.barCode,
//           item.subNo ?? "",
//           item.batchNo,
//           item.productUnitId,
//           item.productUnitName,
//           item.categoryId,
//           item.categoryNo,
//           //?????????
//           item.categoryName,
//           item.brandId,
//           item.brandName,
//           item.foreDiscount,
//           item.weightFlag,
//           item.weightWay,
//           item.foreBargain,
//           item.pointFlag,
//           item.pointValue,
//           item.foreGift,
//           item.promotionFlag,
//           //?????????
//           item.stockFlag,
//           item.batchStockFlag,
//           item.labelPrintFlag,
//           item.labelQty,
//           item.purchaseTax,
//           item.saleTax,
//           item.supplierId,
//           item.supplierName,
//           item.managerType,
//           item.salesCode,
//           //?????????
//           item.salesName,
//           item.itemSource.value,
//           item.posNo,
//           item.addPoint,
//           item.refundPoint,
//           item.promotionInfo,
//           item.ext1,
//           item.ext2,
//           item.ext3,
//           item.createUser,
//           item.createDate,
//           item.lyRate,
//           item.chuDaLabel,
//           //????????????
//           item.chuDaLabelFlag,
//           item.chuDaLabelQty,
//           item.shareCouponLeastCost,
//           item.couponAmount,
//           item.totalReceivableRemoveCouponAmount,
//           //????????????
//           item.totalReceivableRemoveCouponLeastCost,
//           item.joinType.value,
//           item.labelAmount,
//           item.isPlusPrice,
//           item.realPayAmount,
//           item.shareMemberId,
//           item.orderRowStatus.value,
//           item.tableId,
//           item.tableNo,
//           item.tableName,
//           item.refundReason,
//           item.tableBatchTag,
//         ]);

//         //???????????????
//         var line = sql.replaceAll("\n", "");
//         bufferOrderItem.write(line.trim());

//         //pos_order_item_promotion??????SQL??????
//         var orderItemPromotion = await buildOrderItemPromotionSql(item, finishDate);
//         if (orderItemPromotion.item1) {
//           data.add(orderItemPromotion.item3);
//         }

//         //pos_order_item_make??????SQL??????
//         var orderItemMake = await _buildOrderItemMakeSql(item, finishDate);
//         if (orderItemMake.item1) {
//           data.add(orderItemMake.item3);
//         }

//         //pos_order_item_pay??????SQL??????
//         var orderItemPay = await _buildOrderItemPaySql(item, finishDate);
//         if (orderItemPay.item1) {
//           data.add(orderItemPay.item3);
//         }
//       }

//       ///?????????????????????SQL??????????????????,?????????;
//       String str = bufferOrderItem.toString();
//       //pos_order_item
//       data.add(str.substring(0, str.length - 1) + ";");
//     } catch (e, stack) {
//       result = false;
//       message = "???????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, List<String>>(result, message, data);
//   }

//   Future<Tuple3<bool, String, String>> buildOrderItemPromotionSql(OrderItem orderItem, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderItem.promotions != null && orderItem.promotions.length > 0) {
//         //??????pos_order_item_promotion??????
//         String templatePrefix = """
//           insert into pos_order_item_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,
//           scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,
//           receivableAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,ext1,ext2,ext3,createUser,
//           createDate,sourceSign,tableId,tableNo,tableName) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         orderItem.promotions.forEach((item) {
//           if (StringUtils.isBlank(item.id)) {
//             item.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           item.finishDate = finishDate;
//           var sql = sprintf(templateSuffix, [
//             //?????????
//             item.id,
//             item.tenantId,
//             item.orderId,
//             item.itemId,
//             item.tradeNo,
//             item.onlineFlag,
//             item.promotionType.value,
//             item.reason,
//             item.scheduleId,
//             //?????????
//             item.scheduleSn,
//             item.promotionId,
//             item.promotionSn,
//             item.promotionMode,
//             item.scopeType,
//             item.promotionPlan,
//             item.price,
//             item.bargainPrice,
//             item.amount,
//             item.discountAmount,
//             //?????????
//             item.receivableAmount,
//             item.discountRate,
//             item.enabled,
//             item.relationId,
//             item.couponId,
//             item.couponNo,
//             item.couponName,
//             item.finishDate,
//             item.ext1,
//             item.ext2,
//             item.ext3,
//             item.createUser,
//             //?????????
//             item.createDate,
//             item.sourceSign,
//             item.tableId,
//             item.tableNo,
//             item.tableName,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderItem.tradeNo}????????????????????????";
//         data = "";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Tuple3<bool, String, String> orderItemPromotionToSql(OrderItemPromotion item, String finishDate) {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (item != null) {
//         //??????pos_order_item_promotion??????
//         String templatePrefix = """
//           insert into pos_order_item_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,
//           scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,
//           receivableAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,ext1,ext2,ext3,createUser,
//           createDate,sourceSign,tableId,tableNo,tableName) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         if (StringUtils.isBlank(item.id)) {
//           item.id = IdWorkerUtils.getInstance().generate().toString();
//         }

//         item.finishDate = finishDate;
//         var sql = sprintf(templateSuffix, [
//           //?????????
//           item.id,
//           item.tenantId,
//           item.orderId,
//           item.itemId,
//           item.tradeNo,
//           item.onlineFlag,
//           item.promotionType.value,
//           item.reason,
//           item.scheduleId,
//           //?????????
//           item.scheduleSn,
//           item.promotionId,
//           item.promotionSn,
//           item.promotionMode,
//           item.scopeType,
//           item.promotionPlan,
//           item.price,
//           item.bargainPrice,
//           item.amount,
//           item.discountAmount,
//           //?????????
//           item.receivableAmount,
//           item.discountRate,
//           item.enabled,
//           item.relationId,
//           item.couponId,
//           item.couponNo,
//           item.couponName,
//           item.finishDate,
//           item.ext1,
//           item.ext2,
//           item.ext3,
//           item.createUser,
//           //?????????
//           item.createDate,
//           item.sourceSign,
//           item.tableId,
//           item.tableNo,
//           item.tableName,
//         ]);

//         //???????????????
//         var line = sql.replaceAll("\n", "");
//         buffer.write(line.trim());

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${item.tradeNo}????????????????????????";
//         data = "";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Future<Tuple3<bool, String, String>> _buildOrderItemMakeSql(OrderItem orderItem, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderItem.flavors != null && orderItem.flavors.length > 0) {
//         //??????pos_order_item_make??????
//         String templatePrefix = """
//           insert into pos_order_item_make(id,tenantId,tradeNo,orderId,itemId,makeId,code,name,qtyFlag,quantity,refund,
//           salePrice,price,amount,discountAmount,receivableAmount,discountRate,`type`,isRadio,description,hand,`group`,
//           baseQuantity,itemQuantity,finishDate,ext1,ext2,ext3,createUser,createDate,tableId,tableNo,tableName) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         orderItem.flavors.forEach((item) {
//           if (StringUtils.isBlank(item.id)) {
//             item.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           item.finishDate = finishDate;
//           var sql = sprintf(templateSuffix, [
//             //?????????
//             item.id,
//             item.tenantId,
//             item.tradeNo,
//             item.orderId,
//             item.itemId,
//             item.makeId,
//             item.code,
//             item.name,
//             item.qtyFlag,
//             item.quantity,
//             item.refundQuantity,
//             //?????????
//             item.salePrice,
//             item.price,
//             item.amount,
//             item.discountAmount,
//             item.receivableAmount,
//             item.discountRate,
//             item.type,
//             item.isRadio,
//             item.description,
//             item.hand,
//             item.group,
//             //?????????
//             item.baseQuantity,
//             item.itemQuantity,
//             item.finishDate,
//             item.ext1,
//             item.ext2,
//             item.ext3,
//             item.createUser,
//             item.createDate,
//             item.tableId,
//             item.tableNo,
//             item.tableName,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderItem.displayName}??????????????????";
//         data = "";

//         FLogger.debug(message);
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Future<Tuple3<bool, String, String>> _buildOrderItemPaySql(OrderItem orderItem, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderItem.itemPays != null && orderItem.itemPays.length > 0) {
//         //??????pos_order_item_pay??????
//         String templatePrefix = """
//           insert into pos_order_item_pay(id,tenantId,orderId,tradeNo,itemId,productId,specId,payId,no,name,couponId,couponNo,
//           couponName,faceAmount,shareCouponLeastCost,shareAmount,ramount,finishDate,ext1,ext2,ext3,createUser,createDate,sourceSign,incomeFlag) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         orderItem.itemPays.forEach((item) {
//           if (StringUtils.isBlank(item.id)) {
//             item.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           item.finishDate = finishDate;
//           var sql = sprintf(templateSuffix, [
//             //?????????
//             item.id,
//             item.tenantId,
//             item.orderId,
//             item.tradeNo,
//             item.itemId,
//             item.productId,
//             item.specId,
//             item.payId,
//             item.no,
//             item.name,
//             item.couponId,
//             item.couponNo,
//             //?????????
//             item.couponName,
//             item.faceAmount,
//             item.shareCouponLeastCost,
//             item.shareAmount,
//             item.refundAmount,
//             item.finishDate,
//             item.ext1,
//             item.ext2,
//             item.ext3,
//             item.createUser,
//             item.createDate,
//             item.sourceSign,
//             item.incomeFlag,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderItem.tradeNo}????????????????????????";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   //??????pos_order_pay???SQL??????
//   Future<Tuple3<bool, String, String>> _buildOrderPaySql(OrderObject orderObject, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderObject.pays != null && orderObject.pays.length > 0) {
//         //????????????pos_order_pay??????
//         String templatePrefix = """
//           insert into pos_order_pay (id,tenantId,tradeNo,orderId,orgPayId,orderNo,`no`,name,amount,inputAmount,faceAmount,
//           paidAmount,ramount,overAmount,changeAmount,platformDiscount,platformPaid,payNo,prePayNo,channelNo,voucherNo,status,
//           statusDesc,payTime,finishDate,payChannel,incomeFlag,pointFlag,subscribe,useConfirmed,accountName,bankType,memo,
//           cardNo,cardPreAmount,cardChangeAmount,cardAftAmount,cardPrePoint,cardChangePoint,cardAftPoint,memberMobileNo,
//           cardFaceNo,pointAmountRate,shiftId,shiftNo,shiftName,ext1,ext2,ext3,createUser,createDate,
//           couponId,couponNo,couponName,couponLeastCost,sourceSign) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'
//         ,'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'
//         ,'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;
//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);
//         orderObject.pays.forEach((item) {
//           if (StringUtils.isBlank(item.id)) {
//             item.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           item.shiftId = orderObject.shiftId;
//           item.shiftNo = orderObject.shiftNo;
//           item.shiftName = orderObject.shiftName;

//           item.finishDate = finishDate;

//           var sql = sprintf(templateSuffix, [
//             //?????????
//             item.id,
//             item.tenantId,
//             item.tradeNo,
//             item.orderId,
//             item.orgPayId,
//             item.orderNo,
//             item.no,
//             item.name,
//             item.amount,
//             item.inputAmount,
//             item.faceAmount,
//             //?????????
//             item.paidAmount,
//             item.refundAmount,
//             item.overAmount,
//             item.changeAmount,
//             item.platformDiscount,
//             item.platformPaid,
//             item.payNo,
//             item.prePayNo,
//             item.channelNo,
//             item.voucherNo,
//             item.status.value,
//             //?????????
//             item.statusDesc,
//             item.payTime,
//             item.finishDate,
//             item.payChannel.value,
//             item.incomeFlag,
//             item.pointFlag,
//             item.subscribe,
//             item.useConfirmed,
//             item.accountName,
//             item.bankType,
//             item.memo,
//             //?????????
//             item.cardNo,
//             item.cardPreAmount,
//             item.cardChangeAmount,
//             item.cardAftAmount,
//             item.cardPrePoint,
//             item.cardChangePoint,
//             item.cardAftPoint,
//             item.memberMobileNo,
//             //?????????
//             item.cardFaceNo,
//             item.pointAmountRate,
//             item.shiftId,
//             item.shiftNo,
//             item.shiftName,
//             item.ext1,
//             item.ext2,
//             item.ext3,
//             item.createUser,
//             item.createDate,
//             //?????????
//             item.couponId,
//             item.couponNo,
//             item.couponName,
//             item.couponLeastCost,
//             item.sourceSign,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderObject.tradeNo}??????????????????";
//         data = "";

//         FLogger.debug(message);
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "???????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Future<Tuple3<bool, String, String>> buildOrderPromotionSql(OrderObject orderObject, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderObject.promotions != null && orderObject.promotions.length > 0) {
//         //??????pos_order_promotion??????
//         String templatePrefix = """
//           insert into pos_order_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,receivableAmount,adjustAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,sourceSign,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         orderObject.promotions.forEach((entity) {
//           if (StringUtils.isBlank(entity.id)) {
//             entity.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           entity.finishDate = finishDate;
//           var sql = sprintf(templateSuffix, [
//             entity.id,
//             entity.tenantId,
//             entity.orderId,
//             entity.itemId,
//             entity.tradeNo,
//             entity.onlineFlag,
//             entity.promotionType.value,
//             entity.reason,
//             entity.scheduleId,
//             entity.scheduleSn,
//             entity.promotionId,
//             entity.promotionSn,
//             entity.promotionMode,
//             entity.scopeType,
//             entity.promotionPlan,
//             entity.price,
//             entity.bargainPrice,
//             entity.amount,
//             entity.discountAmount,
//             entity.receivableAmount,
//             entity.adjustAmount,
//             entity.discountRate,
//             entity.enabled,
//             entity.relationId,
//             entity.couponId,
//             entity.couponNo,
//             entity.couponName,
//             entity.finishDate,
//             entity.sourceSign,
//             entity.ext1,
//             entity.ext2,
//             entity.ext3,
//             entity.createUser,
//             entity.createDate,
//             entity.modifyUser,
//             entity.modifyDate,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderObject.tradeNo}????????????????????????";
//         data = "";

//         FLogger.debug(message);
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   Tuple3<bool, String, String> orderPromotionToSql(OrderPromotion item, String finishDate) {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (item != null) {
//         //??????pos_order_promotion??????
//         String templatePrefix = """
//           insert into pos_order_promotion(id,tenantId,orderId,itemId,tradeNo,onlineFlag,promotionType,reason,scheduleId,scheduleSn,promotionId,promotionSn,promotionMode,scopeType,promotionPlan,price,bargainPrice,amount,discountAmount,receivableAmount,adjustAmount,discountRate,enabled,relationId,couponId,couponNo,couponName,finishDate,sourceSign,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;

//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);

//         if (StringUtils.isBlank(item.id)) {
//           item.id = IdWorkerUtils.getInstance().generate().toString();
//         }

//         item.finishDate = finishDate;
//         var sql = sprintf(templateSuffix, [
//           item.id,
//           item.tenantId,
//           item.orderId,
//           item.itemId,
//           item.tradeNo,
//           item.onlineFlag,
//           item.promotionType.value,
//           item.reason,
//           item.scheduleId,
//           item.scheduleSn,
//           item.promotionId,
//           item.promotionSn,
//           item.promotionMode,
//           item.scopeType,
//           item.promotionPlan,
//           item.price,
//           item.bargainPrice,
//           item.amount,
//           item.discountAmount,
//           item.receivableAmount,
//           item.adjustAmount,
//           item.discountRate,
//           item.enabled,
//           item.relationId,
//           item.couponId,
//           item.couponNo,
//           item.couponName,
//           item.finishDate,
//           item.sourceSign,
//           item.ext1,
//           item.ext2,
//           item.ext3,
//           item.createUser,
//           item.createDate,
//           item.modifyUser,
//           item.modifyDate,
//         ]);

//         //???????????????
//         var line = sql.replaceAll("\n", "");
//         buffer.write(line.trim());

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${item.tradeNo}????????????????????????";
//         data = "";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   //??????pos_order_table???SQL??????
//   Future<Tuple3<bool, String, String>> buildOrderTableSql(OrderObject orderObject, String finishDate) async {
//     bool result = true;
//     String message = "????????????";
//     String data = "";
//     try {
//       if (orderObject.tables != null && orderObject.tables.length > 0) {
//         //????????????pos_order_pay??????
//         String templatePrefix = """
//           insert into pos_order_table(id,tenantId,orderId,tradeNo,tableId,tableNo,tableName,typeId,typeNo,typeName,areaId,areaNo,areaName,tableStatus,openTime,openUser,tableNumber,serialNo,tableAction,people,excessFlag,totalAmount,totalQuantity,discountAmount,totalRefund,totalRefundAmount,totalGive,totalGiveAmount,discountRate,receivableAmount,paidAmount,malingAmount,maxOrderNo,masterTable,perCapitaAmount,posNo,payNo,finishDate,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate) values
//           """;

//         String templateSuffix = """
//         ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),
//         """;
//         var buffer = new StringBuffer();
//         buffer.write(templatePrefix);
//         orderObject.tables.forEach((entity) {
//           if (StringUtils.isBlank(entity.id)) {
//             entity.id = IdWorkerUtils.getInstance().generate().toString();
//           }

//           entity.finishDate = finishDate;

//           var sql = sprintf(templateSuffix, [
//             entity.id,
//             entity.tenantId,
//             entity.orderId,
//             entity.tradeNo,
//             entity.tableId,
//             entity.tableNo,
//             entity.tableName,
//             entity.typeId,
//             entity.typeNo,
//             entity.typeName,
//             entity.areaId,
//             entity.areaNo,
//             entity.areaName,
//             entity.tableStatus,
//             entity.openTime,
//             entity.openUser,
//             entity.tableNumber,
//             entity.serialNo,
//             entity.tableAction,
//             entity.people,
//             entity.excessFlag,
//             entity.totalAmount,
//             entity.totalQuantity,
//             entity.discountAmount,
//             entity.totalRefund,
//             entity.totalRefundAmount,
//             entity.totalGive,
//             entity.totalGiveAmount,
//             entity.discountRate,
//             entity.receivableAmount,
//             entity.paidAmount,
//             entity.malingAmount,
//             entity.maxOrderNo,
//             entity.masterTable,
//             entity.perCapitaAmount,
//             entity.posNo,
//             entity.payNo,
//             entity.finishDate,
//             entity.ext1,
//             entity.ext2,
//             entity.ext3,
//             entity.createUser,
//             entity.createDate,
//             entity.modifyUser,
//             entity.modifyDate,
//           ]);

//           //???????????????
//           var line = sql.replaceAll("\n", "");
//           buffer.write(line.trim());
//         });

//         ///??????SQL??????????????????,?????????;
//         String str = buffer.toString();
//         data = str.substring(0, str.length - 1) + ";";
//       } else {
//         result = false;
//         message = "??????${orderObject.tradeNo}??????????????????";
//         data = "";
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "???????????????????????????";
//       FLogger.error("$message:" + e.toString());
//     }
//     return Tuple3<bool, String, String>(result, message, data);
//   }

//   //??????????????????
//   Future<Tuple2<bool, String>> builderItemPayShared(OrderObject orderObject) async {
//     bool result = false;
//     String message = "????????????";
//     try {
//       //??????????????????????????????
//       var waitSharedPay = orderObject.pays.where((x) => !(orderObject.items.any((y) => y.itemPays.any((z) => z.payId == x.id))));
//       print("????????????????????????:${waitSharedPay.length}");

//       if (waitSharedPay != null && waitSharedPay.length > 0) {
//         for (var pay in waitSharedPay) {
//           //??????????????????
//           var waitSharedAmount = pay.paidAmount;
//           //???????????????
//           double alreadyShared = 0;

//           //?????????????????????
//           var allItems = orderObject.items.where((x) => x.rowType != OrderItemRowType.Detail && x.rowType != OrderItemRowType.SuitDetail);
//           double allItemFineAmount = 0;
//           if (allItems != null && allItems.length > 0) {
//             //??????????????????????????????????????????-????????????
//             allItems.forEach((item) {
//               double totalShareAmount = item.itemPays.map((p) => p.shareAmount).fold(0, (prev, shareAmount) => prev + shareAmount);
//               allItemFineAmount += item.totalReceivableAmount - totalShareAmount;
//             });
//           }

//           print("?????????????????????:$allItemFineAmount");

//           for (int i = 0; i < orderObject.items.length; i++) {
//             var item = orderObject.items[i];
//             if (item.rowType == OrderItemRowType.Detail || item.rowType == OrderItemRowType.SuitDetail) {
//               continue;
//             }

//             double share = 0;
//             //?????????????????????????????????
//             var itemFineAmount = item.totalReceivableAmount - item.itemPays.map((p) => p.shareAmount).fold(0, (prev, shareAmount) => prev + shareAmount);
//             if (i + 1 == orderObject.items.length) {
//               //?????????????????????
//               share = waitSharedAmount - alreadyShared;
//             } else {
//               //??????????????????????????????
//               if (allItemFineAmount != 0) {
//                 var rate = itemFineAmount / allItemFineAmount;
//                 share = OrderUtils.instance.toRound(waitSharedAmount * rate, precision: 2);
//               } else {
//                 share = 0;
//               }
//             }

//             if (share == 0) {
//               //???????????????????????????????????????????????????????????????????????????????????????
//               continue;
//             }

//             OrderItemPay itemPay = OrderItemPay.newOrderItemPay();
//             itemPay.id = IdWorkerUtils.getInstance().generate().toString();
//             itemPay.tenantId = pay.tenantId;
//             itemPay.orderId = pay.orderId;
//             itemPay.tradeNo = pay.tradeNo;
//             itemPay.payId = pay.id;
//             itemPay.itemId = item.id;
//             itemPay.no = pay.no;
//             itemPay.name = pay.name;
//             itemPay.productId = item.productId;
//             itemPay.specId = item.specId;
//             itemPay.couponId = pay.couponId;
//             itemPay.couponNo = pay.couponNo;
//             itemPay.sourceSign = pay.sourceSign;
//             itemPay.couponName = pay.couponName;
//             itemPay.faceAmount = pay.faceAmount;
//             itemPay.shareAmount = share;
//             itemPay.shareCouponLeastCost = 0;
//             itemPay.refundAmount = 0;
//             itemPay.incomeFlag = pay.incomeFlag;

//             item.itemPays.add(itemPay);
//             alreadyShared += share;

//             print("??????<${item.displayName}>?????????????????????:${itemPay.toString()}");
//           }
//         }

//         //?????????????????????????????????????????????????????????????????????????????????????????????realPayAmount
//         if (orderObject.orderSource == OrderSource.CashRegister || orderObject.orderSource == OrderSource.SelfServiceCash) {
//           //????????????????????????????????????
//           for (var item in orderObject.items) {
//             OrderUtils.instance.calculateOrderItem(item);
//           }
//         } else {
//           // //???????????????????????????????????????????????????if???????????????????????????????????????????????????
//           // var payModeList = DataCacheManager.GetCacheList<PayMode>(DataCacheEnum.LIST_PAYMODE);
//           // if (payModeList != null)
//           // {
//           //   //???????????????
//           //   for (var item in orderObject.items)
//           //   {
//           //     item.RealPayAmount = item.ItemPayList.FindAll(x => payModeList.FirstOrDefault(y => y.No == x.No && y.IncomeFlag == 1) != null).Sum(x => x.ShareAmount);
//           //   }
//           // }
//         }
//       }

//       result = true;
//       message = "????????????????????????";
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";

//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return Tuple2<bool, String>(result, message);
//   }

//   //????????????????????????
//   Future<Tuple2<bool, String>> builderMalingPayMode(OrderObject orderObject) async {
//     bool result = false;
//     String message = "";
//     try {
//       if (orderObject.malingAmount != 0) {
//         if (orderObject.pays != null && orderObject.pays.any((x) => x.no == Constants.PAYMODE_CODE_MALING && x.statusDesc != Constants.PAYMODE_MALING_HAND)) {
//           //????????????????????????????????????
//           result = true;
//           message = "????????????????????????????????????????????????";
//         } else {
//           var malingPayMode = await OrderUtils.instance.getPayMode(Constants.PAYMODE_CODE_MALING);
//           if (malingPayMode == null) {
//             //????????????????????????????????????????????????????????????
//             malingPayMode = PayMode.newPayMode();
//             malingPayMode.no = Constants.PAYMODE_CODE_MALING;
//             malingPayMode.name = "??????";
//             malingPayMode.incomeFlag = 0;
//             malingPayMode.pointFlag = 0;
//           }

//           //????????????????????????
//           OrderPay pay = OrderPay.newOrderPay();
//           pay.id = IdWorkerUtils.getInstance().generate().toString();
//           pay.tenantId = Global.instance.authc.tenantId;
//           pay.tradeNo = orderObject.tradeNo;
//           pay.orderId = orderObject.id;
//           pay.orderNo = orderObject.pays.length + 1;
//           pay.no = malingPayMode.no;
//           pay.name = malingPayMode.name;
//           pay.amount = orderObject.malingAmount;
//           pay.inputAmount = orderObject.malingAmount;
//           pay.paidAmount = orderObject.malingAmount;
//           pay.overAmount = 0.00;
//           pay.changeAmount = 0.00;
//           pay.platformDiscount = 0.00;
//           pay.platformPaid = 0.00;
//           pay.payNo = null;
//           pay.status = OrderPaymentStatus.Paid;
//           pay.payTime = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
//           pay.incomeFlag = malingPayMode.incomeFlag;
//           pay.pointFlag = malingPayMode.pointFlag;
//           pay.shiftId = orderObject.shiftId;
//           pay.shiftNo = orderObject.shiftNo;
//           pay.shiftName = orderObject.shiftName;
//           pay.createUser = Global.instance.worker.no;
//           pay.createDate = DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

//           //??????????????????????????????????????????
//           orderObject.pays.add(pay);

//           result = true;
//           message = "??????????????????????????????";
//         }
//       }
//     } catch (e, stack) {
//       result = false;
//       message = "??????????????????????????????";

//       FLogger.error("????????????????????????????????????:" + e.toString());
//     }
//     return Tuple2<bool, String>(result, message);
//   }

//   ///????????????????????????
//   Future<Tuple2<bool, String>> deleteAllOrderObject() async {
//     bool result = true;
//     String message = "??????????????????";
//     try {
//       //"serverId", "uploadStatus", "uploadCode", "uploadMessage", "uploadErrors", "uploadTime", "modifyUser", "modifyDate"

//       var queues = new Queue<String>();

//       //??????pos_order???
//       queues.add("delete from pos_order;");
//       //??????pos_order_item???
//       queues.add("delete from pos_order_item;");
//       //??????pos_order_pay???
//       queues.add("delete from pos_order_pay;");
//       //??????pos_order_promotion???
//       queues.add("delete from pos_order_promotion;");
//       //??????pos_order_item_pay???
//       queues.add("delete from pos_order_item_pay;");
//       //??????pos_order_item_make???
//       queues.add("delete from pos_order_item_make;");
//       //??????pos_order_item_promotion???
//       queues.add("delete from pos_order_item_promotion;");
//       //??????pos_order_table???
//       queues.add("delete from pos_order_table;");

//       var database = await SqlUtils.instance.open();
//       await database.transaction((txn) async {
//         try {
//           var batch = txn.batch();
//           queues.forEach((obj) {
//             batch.rawInsert(obj);
//           });
//           await batch.commit(noResult: false);
//         } catch (e) {
//           FLogger.error("????????????????????????:" + e.toString());
//         }
//       });
//     } catch (e, stack) {
//       result = false;
//       message = "????????????????????????";
//       FlutterChain.printError(e, stack);
//       FLogger.error("$message:" + e.toString());
//     } finally {
//       //await SqlUtils.instance.close();
//     }
//     return Tuple2<bool, String>(result, message);
//   }

//   Tuple2<bool, String> buildUploadOrder(OrderObject order) {
//     bool result = false;
//     String message = "";
//     try {
//       var items = new List<Map<String, dynamic>>();
//       order.items.forEach((item) {
//         var it = new Map<String, dynamic>();
//         it["clientId"] = item.id;
//         it["clientOrderId"] = item.orderId;
//         it["tradeNo"] = item.tradeNo;
//         it["orderNo"] = item.orderNo;
//         it["productId"] = item.productId;
//         it["productName"] = item.productName;
//         it["shortName"] = item.shortName;
//         it["specId"] = item.specId;
//         it["specName"] = item.specName;
//         it["quantity"] = item.quantity;
//         it["rquantity"] = item.refundQuantity;
//         it["ramount"] = item.refundAmount;
//         it["salePrice"] = item.salePrice;
//         it["price"] = item.price;
//         it["bargainReason"] = item.bargainReason;
//         it["discountPrice"] = item.discountPrice;
//         it["vipPrice"] = item.vipPrice;
//         it["otherPrice"] = item.otherPrice;
//         it["minPrice"] = item.minPrice;
//         it["giftQuantity"] = item.giftQuantity;
//         it["giftAmount"] = item.giftAmount;
//         it["giftReason"] = item.giftReason;
//         it["flavorAmount"] = item.flavorAmount;
//         it["flavorDiscountAmount"] = item.flavorDiscountAmount;
//         it["flavorReceivableAmount"] = item.flavorReceivableAmount;
//         it["flavorNames"] = item.flavorNames;
//         it["amount"] = item.amount;
//         it["totalAmount"] = item.totalAmount;
//         it["discountAmount"] = item.discountAmount;
//         it["receivableAmount"] = item.receivableAmount;
//         it["totalDiscountAmount"] = item.totalDiscountAmount;
//         it["totalReceivableAmount"] = item.totalReceivableAmount;
//         it["discountRate"] = item.discountRate;
//         it["totalDiscountRate"] = item.totalDiscountRate;
//         it["saleDate"] = item.saleDate;
//         it["finishDate"] = item.finishDate;
//         it["remark"] = item.remark;
//         it["itemSource"] = item.itemSource.value;
//         it["posNo"] = item.posNo;
//         it["groupId"] = item.group;
//         it["parentId"] = item.parentId;
//         it["scheme"] = item.scheme;
//         it["rowType"] = item.rowType.value;
//         it["suitId"] = item.suitId;
//         it["suitQuantity"] = item.suitQuantity;
//         it["suitAddPrice"] = item.suitAddPrice;
//         it["suitAmount"] = item.suitAmount;
//         it["productType"] = item.productType;
//         it["barCode"] = item.barCode;
//         it["subNo"] = item.subNo ?? "";
//         it["batchNo"] = item.batchNo;
//         it["productUnitId"] = item.productUnitId;
//         it["productUnitName"] = item.productUnitName;
//         it["categoryId"] = item.categoryId;
//         it["categoryName"] = item.categoryName;
//         it["brandId"] = item.brandId;
//         it["brandName"] = item.brandName;
//         it["weightFlag"] = item.weightFlag;
//         it["weightWay"] = item.weightWay;
//         it["pointFlag"] = item.pointFlag;
//         it["pointValue"] = item.pointValue;
//         it["stockFlag"] = item.stockFlag;
//         it["batchStockFlag"] = item.batchStockFlag;
//         it["purchaseTax"] = item.purchaseTax;
//         it["saleTax"] = item.saleTax;
//         it["supplierId"] = item.supplierId;
//         it["supplierName"] = item.supplierName;
//         it["managerType"] = item.managerType;
//         it["salesCode"] = item.salesCode;
//         it["salesName"] = item.salesName;
//         it["addPoint"] = item.addPoint;
//         it["refundPoint"] = item.refundPoint;
//         it["promotionInfo"] = item.promotionInfo;
//         it["lyRate"] = item.lyRate;
//         it["orgItemId"] = item.orgItemId;
//         it["joinType"] = item.joinType.value;
//         it["labelAmount"] = item.labelAmount;
//         it["isPlusPrice"] = item.isPlusPrice;
//         it["shareCouponLeastCost"] = item.shareCouponLeastCost;
//         it["couponAmount"] = item.couponAmount;
//         it["totalReceivableRemoveCouponAmount"] = item.totalReceivableRemoveCouponAmount;
//         it["totalReceivableRemoveCouponLeastCost"] = item.totalReceivableRemoveCouponLeastCost;
//         it["realPayAmount"] = item.realPayAmount;
//         it["shareMemberId"] = item.shareMemberId;
//         it["tableId"] = item.tableId;
//         it["tableNo"] = item.tableNo;
//         it["tableName"] = item.tableName;
//         //????????????
//         var flavors = new List<Map<String, dynamic>>();
//         if (item.flavors != null && item.flavors.length > 0) {
//           item.flavors.forEach((f) {
//             var dic = new Map<String, dynamic>();
//             dic["clientId"] = f.id;
//             dic["clientOrderId"] = f.orderId;
//             dic["tradeNo"] = f.tradeNo;
//             dic["clientOrderItemId"] = f.itemId;
//             dic["makeId"] = f.makeId;
//             dic["code"] = f.code;
//             dic["name"] = f.name;
//             dic["qtyFlag"] = f.qtyFlag;
//             dic["quantity"] = f.quantity;
//             dic["refund"] = f.refundQuantity;
//             dic["salePrice"] = f.salePrice;
//             dic["price"] = f.price;
//             dic["type"] = f.type;
//             dic["isRadio"] = f.isRadio;
//             dic["finishDate"] = f.finishDate;
//             dic["groupId"] = f.group;
//             dic["amount"] = f.amount;
//             dic["discountAmount"] = f.discountAmount;
//             dic["discountRate"] = f.discountRate;
//             dic["receivableAmount"] = f.receivableAmount;
//             dic["hand"] = f.hand;
//             dic["baseQuantity"] = f.baseQuantity;
//             dic["description"] = f.description;

//             flavors.add(dic);
//           });
//         }
//         it["makes"] = flavors;

//         //??????????????????
//         var itemPromotions = new List<Map<String, dynamic>>();
//         if (item.promotions != null && item.promotions.length > 0) {
//           item.promotions.forEach((p) {
//             var dic = new Map<String, dynamic>();
//             dic["clientId"] = p.id;
//             dic["clientOrderId"] = p.orderId;
//             dic["tradeNo"] = p.tradeNo;
//             dic["clientOrderItemId"] = p.itemId;
//             dic["onlineFlag"] = p.onlineFlag;
//             dic["promotionType"] = p.promotionType.value;
//             dic["scheduleId"] = p.scheduleId;
//             dic["scheduleSn"] = p.scheduleSn;
//             dic["promotionId"] = p.promotionId;
//             dic["promotionSn"] = p.promotionSn;
//             dic["promotionMode"] = p.promotionMode;
//             dic["scopeType"] = p.scopeType;
//             dic["promotionPlan"] = p.promotionPlan;
//             dic["amount"] = p.amount;
//             dic["discountAmount"] = p.discountAmount;
//             dic["receivableAmount"] = p.receivableAmount;
//             dic["discountRate"] = p.discountRate;
//             dic["enabled"] = p.enabled;
//             dic["couponId"] = p.couponId;
//             dic["couponNo"] = p.couponNo;
//             dic["couponName"] = p.couponName;
//             dic["finishDate"] = p.finishDate;
//             dic["relationId"] = p.relationId;

//             itemPromotions.add(dic);
//           });
//         }
//         it["promotions"] = itemPromotions;

//         //????????????????????????
//         var itemPays = new List<Map<String, dynamic>>();
//         if (item.itemPays != null && item.itemPays.length > 0) {
//           item.itemPays.forEach((p) {
//             var dic = new Map<String, dynamic>();
//             dic["clientId"] = p.id;
//             dic["clientOrderId"] = p.orderId;
//             dic["tradeNo"] = p.tradeNo;
//             dic["clientOrderItemId"] = p.itemId;
//             dic["clientPayId"] = p.payId;
//             dic["no"] = p.no;
//             dic["name"] = p.name;
//             dic["storeId"] = order.storeId;
//             dic["storeNo"] = order.storeNo;
//             dic["storeName"] = order.storeName;
//             dic["productId"] = p.productId;
//             dic["productName"] = item.productName;
//             dic["specId"] = p.specId;
//             dic["specName"] = item.specName;
//             dic["couponId"] = p.couponId;
//             dic["couponNo"] = p.couponNo;
//             dic["couponName"] = p.couponName;
//             dic["faceAmount"] = p.faceAmount;
//             dic["shareCouponLeastCost"] = p.shareCouponLeastCost;
//             dic["shareAmount"] = p.shareAmount;
//             dic["refundAmount"] = p.refundAmount;
//             dic["finishDate"] = p.finishDate;

//             itemPays.add(dic);
//           });
//         }
//         it["itemPays"] = itemPays;

//         items.add(it);
//       });

//       //??????????????????
//       var orderPromotions = new List<Map<String, dynamic>>();
//       if (order.promotions != null && order.promotions.length > 0) {
//         order.promotions.forEach((p) {
//           var dic = new Map<String, dynamic>();
//           dic["clientId"] = p.id;
//           dic["clientOrderId"] = p.orderId;
//           dic["tradeNo"] = p.tradeNo;
//           dic["clientOrderItemId"] = p.itemId;
//           dic["onlineFlag"] = p.onlineFlag;
//           dic["promotionType"] = p.promotionType.value;
//           dic["scheduleId"] = p.scheduleId;
//           dic["scheduleSn"] = p.scheduleSn;
//           dic["promotionId"] = p.promotionId;
//           dic["promotionSn"] = p.promotionSn;
//           dic["promotionMode"] = p.promotionMode;
//           dic["scopeType"] = p.scopeType;
//           dic["promotionPlan"] = p.promotionPlan;
//           dic["amount"] = p.amount;
//           dic["discountAmount"] = p.discountAmount;
//           dic["receivableAmount"] = p.receivableAmount;
//           dic["discountRate"] = p.discountRate;
//           dic["enabled"] = p.enabled;
//           dic["couponId"] = p.couponId;
//           dic["couponNo"] = p.couponNo;
//           dic["couponName"] = p.couponName;
//           dic["finishDate"] = p.finishDate;
//           dic["relationId"] = p.relationId;

//           orderPromotions.add(dic);
//         });
//       }

//       //????????????
//       var pays = new List<Map<String, dynamic>>();
//       if (order.pays != null && order.pays.length > 0) {
//         order.pays.forEach((p) {
//           var dic = new Map<String, dynamic>();
//           dic["clientId"] = p.id;
//           dic["clientOrderId"] = p.orderId;
//           dic["tradeNo"] = p.tradeNo;
//           dic["orderNo"] = p.orderNo;
//           dic["no"] = p.no;
//           dic["name"] = p.name;
//           dic["amount"] = p.amount;
//           dic["inputAmount"] = p.inputAmount;
//           dic["faceAmount"] = p.faceAmount;
//           dic["paidAmount"] = p.paidAmount;
//           dic["overAmount"] = p.overAmount;
//           dic["changeAmount"] = p.changeAmount;
//           dic["platformDiscount"] = p.platformDiscount;
//           dic["platformPaid"] = p.platformPaid;
//           dic["payNo"] = p.payNo;
//           dic["prePayNo"] = p.prePayNo;
//           dic["channelNo"] = p.channelNo;
//           dic["voucherNo"] = p.voucherNo;
//           dic["status"] = p.status.value;
//           dic["statusDesc"] = p.statusDesc;
//           dic["subscribe"] = p.subscribe;
//           dic["useConfirmed"] = p.useConfirmed;
//           dic["accountName"] = p.accountName;
//           dic["bankType"] = p.bankType;
//           dic["memo"] = p.memo;
//           dic["payTime"] = p.payTime;
//           dic["finishDate"] = p.finishDate;
//           dic["payChannel"] = p.payChannel.value;
//           dic["pointFlag"] = p.pointFlag;
//           dic["incomeFlag"] = p.incomeFlag;
//           dic["cardNo"] = p.cardNo;
//           dic["cardPreAmount"] = p.cardPreAmount;
//           dic["cardAftAmount"] = p.cardAftAmount;
//           dic["cardChangeAmount"] = p.cardChangeAmount;
//           dic["cardPrePoint"] = p.cardPrePoint;
//           dic["cardChangePoint"] = p.cardChangePoint;
//           dic["cardAftPoint"] = p.cardAftPoint;
//           dic["memberMobileNo"] = p.memberMobileNo;
//           dic["cardFaceNo"] = p.cardFaceNo;
//           dic["shiftId"] = p.shiftId;
//           dic["shiftNo"] = p.shiftNo;
//           dic["shiftName"] = p.shiftName;
//           dic["couponId"] = p.couponId;

//           dic["couponNo"] = p.couponNo;
//           dic["couponName"] = p.couponName;
//           dic["couponLeastCost"] = p.couponLeastCost;

//           pays.add(dic);
//         });
//       }

//       //??????????????????
//       var tables = new List<Map<String, dynamic>>();
//       if (order.tables != null && order.tables.length > 0) {
//         for (var table in order.tables) {
//           var it = new Map<String, dynamic>();
//           it["clientId"] = table.id;
//           it["clientOrderId"] = table.orderId;
//           it["tradeNo"] = table.tradeNo;
//           it["tableId"] = table.tableId;
//           it["tableNo"] = table.tableNo;
//           it["tableName"] = table.tableName;
//           it["typeId"] = table.typeId;
//           it["typeNo"] = table.typeNo;
//           it["typeName"] = table.typeName;
//           it["areaId"] = table.areaId;
//           it["areaNo"] = table.areaNo;
//           it["areaName"] = table.areaName;
//           it["tableStatus"] = table.tableStatus;
//           it["openTime"] = table.openTime;
//           it["openUser"] = table.openUser;
//           it["tableNumber"] = table.tableNumber;
//           it["serialNo"] = table.serialNo;
//           it["tableAction"] = table.tableAction;
//           it["people"] = table.people;
//           it["excessFlag"] = table.excessFlag;
//           it["totalAmount"] = table.totalAmount;
//           it["totalQuantity"] = table.totalQuantity;
//           it["discountAmount"] = table.discountAmount;
//           it["totalRefund"] = table.totalRefund;
//           it["totalRefundAmount"] = table.totalRefundAmount;
//           it["totalGive"] = table.totalGive;
//           it["totalGiveAmount"] = table.totalGiveAmount;
//           it["discountRate"] = table.discountRate;
//           it["receivableAmount"] = table.receivableAmount;
//           it["paidAmount"] = table.paidAmount;
//           it["malingAmount"] = table.malingAmount;
//           it["maxOrderNo"] = table.maxOrderNo;
//           it["masterTable"] = table.masterTable;
//           it["perCapitaAmount"] = table.perCapitaAmount;
//           it["posNo"] = table.posNo;
//           it["payNo"] = table.payNo;
//           it["finishDate"] = table.finishDate;

//           tables.add(it);
//         }
//       }

//       //??????????????????
//       var data = new Map<String, dynamic>();

//       data["clientId"] = order.id;
//       data["storeId"] = order.storeId;
//       data["storeNo"] = order.storeNo;
//       data["storeName"] = order.storeName;
//       data["objectId"] = order.objectId;
//       data["tradeNo"] = order.tradeNo;
//       data["orderNo"] = order.orderNo;

//       data["workerNo"] = order.workerNo;
//       data["workerName"] = order.workerName;
//       data["posNo"] = order.posNo;
//       data["deviceName"] = order.deviceName;
//       data["macAddress"] = order.macAddress;
//       data["ipAddress"] = order.ipAddress;
//       data["salesCode"] = order.salesCode;
//       data["salesName"] = order.salesName;
//       data["tableNo"] = order.tableNo;
//       data["tableName"] = order.tableName;

//       data["people"] = order.people;
//       data["shiftId"] = order.shiftId;
//       data["shiftNo"] = order.shiftNo;
//       data["shiftName"] = order.shiftName;
//       data["saleDate"] = order.saleDate;
//       data["finishDate"] = order.finishDate;
//       data["weeker"] = order.weeker;
//       data["weather"] = order.weather;
//       data["totalQuantity"] = order.totalQuantity;
//       data["itemCount"] = order.itemCount;
//       data["payCount"] = order.payCount;
//       data["amount"] = order.amount;
//       data["discountAmount"] = order.discountAmount;
//       data["receivableAmount"] = order.receivableAmount;
//       data["paidAmount"] = order.paidAmount;
//       data["receivedAmount"] = order.receivedAmount;
//       data["malingAmount"] = order.malingAmount;
//       data["changeAmount"] = order.changeAmount;

//       data["invoicedAmount"] = order.invoicedAmount;
//       data["overAmount"] = order.overAmount;
//       data["isMember"] = order.isMember;
//       data["memberName"] = order.memberName ?? "";
//       data["memberMobileNo"] = order.memberMobileNo ?? "";
//       data["memberNo"] = order.memberNo ?? "";
//       data["memberId"] = order.memberId ?? "";
//       data["cardFaceNo"] = order.cardFaceNo ?? "";
//       data["prePoint"] = order.prePoint;
//       data["addPoint"] = order.addPoint;
//       data["aftPoint"] = order.aftPoint;
//       data["remark"] = order.remark;
//       data["discountRate"] = order.discountRate;
//       data["postWay"] = order.postWay.value;
//       data["orderSource"] = order.orderSource.value;

//       data["orderStatus"] = order.orderStatus.value;
//       data["paymentStatus"] = order.paymentStatus.value;
//       data["orgTradeNo"] = order.orgTradeNo;
//       data["refundCause"] = order.refundCause;
//       data["receivableRemoveCouponAmount"] = order.receivableRemoveCouponAmount;
//       data["isPlus"] = order.isPlus;
//       data["freightAmount"] = order.freightAmount;
//       data["realPayAmount"] = order.realPayAmount;
//       data["orderItems"] = items;
//       data["pays"] = pays;
//       data["orderPromotions"] = orderPromotions;
//       data["orderUploadSource"] = order.orderUploadSource.value;
//       data["orderTables"] = tables;

//       ///zhangy 2020-10-28 Add ????????????????????????
//       data["refundStatus"] = order.refundStatus.value;

//       return Tuple2<bool, String>(true, json.encode(data));
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       return Tuple2<bool, String>(false, "????????????");
//     }
//   }

//   ///????????????????????????
//   Future<List<ProductCategory>> getCategoryList() async {
//     List<ProductCategory> result = new List<ProductCategory>();
//     try {
//       String sql = sprintf("select id,tenantId,parentId,name,code,path,categoryType,english,returnRate,description,orderNo,deleteFlag,products,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_product_category where deleteFlag = 0  and products > 0 order by orderNo asc;", []);

//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       result = ProductCategory.toList(lists);
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///????????????????????????
//   Future<List<Module>> getModule({List<String> moduleNames, bool orderBy = true}) async {
//     List<Module> result = new List<Module>();
//     try {
//       String sql = "select * from pos_module ";

//       if (moduleNames != null && moduleNames.length > 0) {
//         String whereCondition = JsonEncoder().convert(moduleNames);
//         whereCondition = whereCondition.substring(1, whereCondition.length - 1);
//         sql += " where `name` in ($whereCondition) ";
//       }

//       if (orderBy) {
//         sql += " order by orderNo asc; ";
//       }

//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       result = Module.toList(lists);
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????POS????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///????????????????????????
//   Future<List<Module>> getShortcutModule() async {
//     List<Module> result = new List<Module>();
//     try {
//       String sql = sprintf("select id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate from pos_module where area = '%s' order by orderNo asc;", ["??????"]);
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       result = Module.toList(lists);
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????POS????????????????????????:" + e.toString());
//     }
//     return result;
//   }

//   ///????????????????????????
//   Future<List<Module>> getMoreModule() async {
//     List<Module> result = new List<Module>();
//     try {
//       String sql = sprintf("select id,tenantId,area,name,alias,keycode,keydata,color1,color2,color3,color4,fontSize,shortcut,orderNo,icon,enable,permission,createUser,createDate,modifyUser,modifyDate from pos_module where area = '%s' order by orderNo asc;", ["??????"]);
//       var database = await SqlUtils.instance.open();
//       List<Map<String, dynamic>> lists = await database.rawQuery(sql);

//       result = Module.toList(lists);
//     } catch (e, stack) {
//       FlutterChain.printError(e, stack);
//       FLogger.error("??????POS????????????????????????:" + e.toString());
//     }
//     return result;
//   }
// }
