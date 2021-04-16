import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/open_response.dart';
import 'package:h3_app/enums/member_card_no_type.dart';
import 'package:h3_app/enums/order_item_row_type.dart';
import 'package:h3_app/enums/order_payment_status_type.dart';
import 'package:h3_app/enums/pay_channel_type.dart';
import 'package:h3_app/enums/promotion_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_item.dart';
import 'package:h3_app/order/order_item_pay.dart';
import 'package:h3_app/order/order_object.dart';
import 'package:h3_app/order/order_pay.dart';
import 'package:h3_app/order/order_promotion.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/order/promotion_utils.dart';
import 'package:h3_app/utils/api_utils.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/http_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

import 'member.dart';
import 'member_card_pay_entity.dart';
import 'member_card_recharge_scheme.dart';
import 'member_elec_coupon.dart';
import 'member_elec_coupon_check_detail.dart';
import 'member_trade_pay_response.dart';
import 'member_trade_refund_response.dart';

class MemberUtils {
  // 工厂模式
  factory MemberUtils() => _getInstance();

  static MemberUtils get instance => _getInstance();
  static MemberUtils _instance;

  static MemberUtils _getInstance() {
    if (_instance == null) {
      _instance = new MemberUtils._internal();
    }
    return _instance;
  }

  MemberUtils._internal();

  /// 查询会员信息
  /// 返回
  Future<Tuple4<bool, String, MemberCardNoType, Member>> httpQueryMemberInfo(
      String inputValue,
      {MemberCardNoType type = MemberCardNoType.None}) async {
    bool result = false;
    String msg = "无法识别该内容，请确认是否正确";
    Member member;
    try {
      type = MemberCardNoType.judgeCardWay(
          Global.instance.authc.tenantId, inputValue);

      String property = "";

      switch (type) {
        case MemberCardNoType.SurfaceNo:
          {
            property = "surfaceNo";
          }
          break;
        case MemberCardNoType.Mobile:
          {
            property = "mobile";
          }
          break;
        case MemberCardNoType.CardNo:
          {
            property = "cardNo";
          }
          break;
        case MemberCardNoType.ScanCode:
          {
            property = "scanCode";
          }
          break;
        case MemberCardNoType.MemberNo:
          {
            property = "memberNo";
          }
          break;
      }

      //卡号适配
      if (StringUtils.isNotBlank(property)) {
        OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
        var parameters = OpenApiUtils.instance.newParameters(api: api);
        parameters["name"] = "member.query";

        var data = {
          "property": property,
          "keyword": inputValue,
          "storeNo": Global.instance.authc.storeNo,
          "posNo": Global.instance.authc.posNo,
          "workerNo": Global.instance.worker.no,
          "sourceSign": Constants.TERMINAL_TYPE,
        };

        parameters["data"] = json.encode(data);
        List<String> ignoreParameters = new List<String>();
        var sign =
            OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
        parameters["sign"] = sign;

        var response =
            await HttpUtils.instance.post(api, api.url, params: parameters);

        result = response.success;
        msg = response.msg;

        if (result) {
          member = Member.fromJson(response.data);
        } else {
          member = null;
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);

      FLogger.error("获取会员信息异常:" + e.toString());

      result = false;
      msg = "获取会员信息出错了";
      member = null;
    }

    return Tuple4<bool, String, MemberCardNoType, Member>(
        result, msg, type, member);
  }

  //查询会员充值方案
  Future<Tuple4<bool, int, String, MemberCardRechargeScheme>>
      httpMemberCardRechargeSchemeQuery(String cardNo) async {
    bool result = false;
    int code = -1;
    String msg = "会员卡充值方案查询发生错误";
    MemberCardRechargeScheme scheme;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "member.card.recharge.scheme.query";

      var data = {
        "cardNo": cardNo,
        "onlineFlag": 0,
        "shopNo": Global.instance.authc.storeNo,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "sourceSign": Constants.TERMINAL_TYPE,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      result = response.success;
      code = response.code;
      msg = response.msg;

      if (result) {
        scheme = MemberCardRechargeScheme.fromJson(response.data);
      } else {
        scheme = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("会员卡充值方案查询发生异常:" + e.toString());

      result = false;
      code = -1;
      msg = "会员卡充值方案查询发生异常";
      scheme = null;
    }
    return Tuple4<bool, int, String, MemberCardRechargeScheme>(
        result, code, msg, scheme);
  }

  Future<Tuple3<bool, String, MemberTradePayResponse>> httpMemberConsume(
      String tradeNo,
      String memberId,
      String mobile,
      String cardNo,
      int isNoPwd,
      String passwd,
      int totalAmount,
      int pointValue) async {
    bool result = false;
    String msg = "会员卡支付发生异常";
    MemberTradePayResponse entity;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "member.trade.pay";

      var data = {
        "tradeNo": tradeNo,
        "memberId": memberId,
        "mobile": mobile,
        "cardNo": cardNo,
        "isNoPwd": isNoPwd,
        "passwd": passwd,
        "totalAmount": totalAmount,
        "pointValue": pointValue,
        "shopNo": Global.instance.authc.storeNo,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "sourceSign": Constants.TERMINAL_TYPE,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      FLogger.info(
          "会员<ID:$memberId 手机号:$mobile>卡<$cardNo>发起支付金额<$totalAmount>积分<$pointValue>");
      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info("会员<ID:$memberId 手机号:$mobile>卡<$cardNo>支付返回结果:$response");

      result = response.success;
      msg = response.msg;

      if (result) {
        entity = MemberTradePayResponse.fromJson(response.data);
      } else {
        entity = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("会员卡支付发生异常:" + e.toString());

      result = false;
      msg = "会员卡支付发生异常";
      entity = null;
    }

    return Tuple3(result, msg, entity);
  }

  Future<Tuple3<bool, String, MemberTradeRefundResponse>> httpMemberRefund(
      String refundTradeNo,
      String tradeNo,
      String reason,
      int totalAmount,
      int pointValue,
      String marketRefundNo) async {
    bool result = false;
    String msg = "会员卡退款发生异常";
    MemberTradeRefundResponse entity;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "member.trade.refund";

      var data = {
        "outTradeNo": refundTradeNo,
        "tradeNo": tradeNo,
        "totalAmount": totalAmount,
        "pointValue": pointValue,
        "reason": reason,
        "shopNo": Global.instance.authc.storeNo,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "sourceSign": Constants.TERMINAL_TYPE,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      FLogger.info("订单[$tradeNo]发起退款[$totalAmount]退积分[￥pointValue]请求");
      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info(
          "订单[$tradeNo]发起退款[$totalAmount]退积分[￥pointValue]返回结果：$response");

      result = response.success;
      msg = response.msg;

      if (result) {
        entity = MemberTradeRefundResponse.fromJson(response.data);
      } else {
        entity = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("会员卡退款发生异常:" + e.toString());

      result = false;
      msg = "会员卡退款发生异常";
      entity = null;
    }

    return Tuple3(result, msg, entity);
  }

  //查询会员优惠券
  Future<Tuple3<bool, String, List<MemberElecCoupon>>> httpElecCouponList(
      String memberId,
      String couponNo,
      int status,
      int pageNumber,
      int pageSize) async {
    bool result = false;
    String msg = "会员优惠券查询发生错误";
    List<MemberElecCoupon> coupons;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "member.elecCoupon.query";

      var data = <String, dynamic>{
        "status": status,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };

      if (StringUtils.isNotBlank(couponNo)) {
        data["couponNo"] = couponNo; //查询单张券
      } else {
        data["memberId"] = memberId; //查询会员所有优惠券
      }

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      result = response.success;
      msg = response.msg;

      if (result) {
        //解析分页数据
        var respResult = OpenResponse.parsePagerResponse(response.data);
        coupons = MemberElecCoupon.toList(respResult.item1);
      } else {
        coupons = <MemberElecCoupon>[];
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("会员卡充值方案查询发生异常:" + e.toString());

      result = false;
      msg = "会员卡充值方案查询发生异常";
      coupons = <MemberElecCoupon>[];
    }
    return Tuple3<bool, String, List<MemberElecCoupon>>(result, msg, coupons);
  }

  Future<Tuple3<bool, String, Map<String, dynamic>>> httpMemberConsumeCheck(
      MemberCardPayEntity pay) async {
    bool result = false;
    String msg = "会员卡余额校验异常";
    Map<String, dynamic> dataMap;

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "member.trade.pay.check";

      var data = {
        "tradeNo": pay.tradeNo,
        "memberId": pay.memberId,
        "mobile": pay.mobile,
        "cardNo": pay.cardNo,
        "isNoPwd": pay.isNoPwd,
        "passwd": Uri.decodeComponent(pay.passwd),
        "totalAmount": pay.totalAmount,
        "pointValue": pay.pointValue,
        "shopNo": Global.instance.authc.storeNo,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "sourceSign": Constants.TERMINAL_TYPE,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      FLogger.info(
          "会员<ID:${pay.memberId} 手机号:${pay.mobile}>卡<${pay.cardNo}>发起支付校验金额<${pay.totalAmount}>积分<${pay.pointValue}>");
      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info(
          "会员<ID:${pay.memberId} 手机号:${pay.mobile}>卡<${pay.cardNo}>支付校验返回结果：$response");

      result = response.success;
      msg = response.msg;
      if (result) {
        dataMap = Map.from(response.data);
        msg = dataMap["msg"];
      } else {
        dataMap = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("会员卡余额校验异常:" + e.toString());

      result = false;
      msg = "会员卡余额校验异常";
    }

    return Tuple3(result, msg, dataMap);
  }

  ///优惠券核销
  Future<Tuple3<bool, String, Map<String, dynamic>>> httpElecCouponChargeOff(
      String orderId,
      String orderNo,
      String memberId,
      String cardNo,
      List<ElecCouponCheckDetail> details) async {
    bool result = false;
    String msg = "优惠券核销异常";
    Map<String, dynamic> dataMap;

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "order.elecCoupon.check.extend";

      var data = {
        "orderId": orderId,
        "orderNo": orderNo,
        "details": details,
        "memberId": memberId,
        "cardNo": cardNo,
        "storeId": Global.instance.authc.storeId,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "sourceSign": Constants.TERMINAL_TYPE,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info("优惠券核销返回结果:$response");
      result = response.success;
      msg = response.msg;
      if (result) {
        dataMap = Map.from(response.data);
      } else {
        dataMap = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("优惠券核销异常:" + e.toString());

      result = false;
      msg = "优惠券核销异常";
    }

    return Tuple3(result, msg, dataMap);
  }

  Future<Tuple3<bool, String, Map<String, dynamic>>> orderElecCouponChargeOff(
      OrderObject order) async {
    if (order == null || order.member == null) {
      return Tuple3(false, "没有会员信息，忽略发电子小票", {});
    }

    var details = new List<ElecCouponCheckDetail>();
    //折扣券
    var promotionCouponList = order.promotions.where((x) =>
        x.promotionType == PromotionType.Coupon &&
        StringUtils.isNotBlank(x.couponId));
    if (promotionCouponList != null && promotionCouponList.length > 0) {
      promotionCouponList.forEach((x) {
        var detail = new ElecCouponCheckDetail();
        detail.couponId = x.couponId;
        //实际用券金额
        detail.consumAmount = x.discountAmount;
        details.add(detail);
      });
    }
    //代金券
    var payCouponList = order.pays.where((x) =>
        x.no == Constants.PAYMODE_CODE_COUPON &&
        StringUtils.isNotBlank(x.couponId));
    if (payCouponList != null && payCouponList.length > 0) {
      payCouponList.forEach((x) {
        var detail = new ElecCouponCheckDetail();
        detail.couponId = x.couponId;
        //实际用券金额
        detail.consumAmount = x.paidAmount;
        details.add(detail);
      });
    }

    var cardNo = "";
    var memberId = "";
    if (null != order.member) {
      memberId = order.member.id;
    }
    if (null != order.member.defaultCard) {
      cardNo = order.member.defaultCard.cardNo;
    }

    return httpElecCouponChargeOff(
        order.id, order.tradeNo, memberId, cardNo, details);
  }

  Future<Tuple3<bool, String, Map<String, dynamic>>> sendOrderTicket(
      OrderObject orderObject) async {
    if (orderObject.member == null) {
      return Tuple3(true, "非会员交易,忽略电子小票", {});
    }

    bool result = false;
    String msg = "优惠券核销异常";
    Map<String, dynamic> dataMap;

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "eorder.send";

      var data = {
        "storeId": Global.instance.authc.storeId,
        "memberId": orderObject.member != null ? orderObject.member.id : "",
        "orderNo": orderObject.tradeNo,
        "posNo": Global.instance.authc.posNo,
        "workerNo": Global.instance.worker.no,
        "salesTime": orderObject.saleDate,
        "totalQuantity": orderObject.totalQuantity,
        "amount": orderObject.amount,
        "discountAmount": orderObject.discountAmount,
        "receivableAmount": orderObject.receivableAmount,
        "paidAmount": orderObject.paidAmount,
        "orderItems": orderObject.items,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info("订单<${orderObject.tradeNo}>发送电子小票返回结果:$response");
      result = response.success;
      msg = response.msg;
      if (result) {
        dataMap = Map.from(response.data);
      } else {
        dataMap = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("发送电子小票发生异常:" + e.toString());

      result = false;
      msg = "发送电子小票发生异常";
    }

    return Tuple3(result, msg, dataMap);
  }

  /// 获取优惠券可用订单明细
  List<OrderItem> getFineCouponItem(
      OrderObject orderObject, MemberElecCoupon coupon) {
    List<OrderItem> fineOrderItem;
    if (orderObject != null && orderObject.items.length > 0) {
      //待分摊商品
      fineOrderItem = orderObject.items
          .where((x) =>
              x.rowType != OrderItemRowType.Detail &&
              x.rowType != OrderItemRowType.SuitDetail &&
              x.totalReceivableRemoveCouponLeastCost > 0 &&
              (coupon.discountType == 1 ? true : x.foreDiscount == 1))
          .toList();

      switch (coupon.fitRange) {
        case 1:
          {
            // 全场通用
            if (coupon.exgoodsList != null && coupon.exgoodsList.length > 0) {
              //排除黑名单中的商品
              fineOrderItem = fineOrderItem
                  .where((x) =>
                      !coupon.exgoodsList.any((y) => y.specId == x.specId))
                  .toList();
            }
          }
          break;
        case 2:
          {
            // 部分商品
            if (null != coupon.goodsList && coupon.goodsList.length > 0) {
              fineOrderItem = fineOrderItem
                  .where(
                      (x) => coupon.goodsList.any((y) => y.specId == x.specId))
                  .toList();
            }
          }
          break;
        case 3:
          {
            // 部分类别
            List<ElecCouponCategory> couponCategorys = coupon.categoryList;
            if (null != couponCategorys && couponCategorys.length > 0) {
              //类别且排除黑名单商品的应收金额
              fineOrderItem = fineOrderItem
                  .where((x) =>
                      couponCategorys
                          .any((y) => y.categoryId == x.categoryId) &&
                      (coupon.exgoodsList == null ||
                          !coupon.exgoodsList.any((z) => z.specId == x.specId)))
                  .toList();
            }
          }
          break;
        case 4:
          {
            // 部分品牌
            List<ElecCouponBrand> couponBrands = coupon.brandList;
            if (null != couponBrands && couponBrands.length > 0) {
              //类别且排除黑名单商品的应收金额
              fineOrderItem = fineOrderItem
                  .where((x) =>
                      couponBrands.any((y) => y.brandId == x.brandId) &&
                      (coupon.exgoodsList == null ||
                          !coupon.exgoodsList.any((z) => z.specId == x.specId)))
                  .toList();
            }
          }
          break;
        default:
          {
            //未匹配的特殊情况，到这里说明有了1-4之外的范围了，未适配
            fineOrderItem = <OrderItem>[];
          }
          break;
      }

      if (fineOrderItem == null) {
        fineOrderItem = <OrderItem>[];
      }
    } else {
      fineOrderItem = <OrderItem>[];
    }
    return fineOrderItem;
  }

  /// 应用折扣券
  Tuple2<bool, String> applyDiscountCoupon(
      OrderObject orderObject, MemberElecCoupon coupon) {
    bool result = false;
    String message = "折扣券应用失败";

    try {
      if (orderObject != null && orderObject.items.length > 0) {
        var fineOrderItem = getFineCouponItem(orderObject, coupon);
        if (fineOrderItem.length > 0) {
          //主单优惠
          OrderPromotion promotion;
          if (orderObject.promotions != null &&
              orderObject.promotions
                  .any((x) => x.promotionType == PromotionType.Coupon)) {
            //移除已用折扣券
            orderObject.promotions
                .removeWhere((x) => x.promotionType == PromotionType.Coupon);
            orderObject.items.forEach((x) {
              x.promotions
                  .removeWhere((y) => y.promotionType == PromotionType.Coupon);
              //重算价格
              OrderUtils.instance.calculateOrderItem(x);
            });
            //重算订单
            OrderUtils.instance.calculateOrderObject(orderObject);
          }

          promotion = PromotionUtils.instance.newOrderPromotion(orderObject,
              promotionType: PromotionType.Coupon);
          promotion.couponId = coupon.id; //每张券的ID
          promotion.couponNo = coupon.couponNo;
          promotion.sourceSign = coupon.sourceSign;
          promotion.couponName = coupon.name;
          promotion.onlineFlag = 0;
          promotion.reason = coupon.name;
          promotion.amount = orderObject.amount;
          promotion.discountRate =
              OrderUtils.instance.toRound(coupon.discountValue / 100);
          promotion.discountAmount = OrderUtils.instance
              .toRound(orderObject.amount * promotion.discountRate);
          promotion.enabled = 0;

          promotion.promotionId = coupon.couponPlanId;
          promotion.promotionSn = coupon.couponPlanCode;
          promotion.promotionMode = "D"; //促销模式 D:折扣；T:特价；F：买满送；

          orderObject.promotions.add(promotion);

          PromotionUtils.instance.calculate(orderObject, promotion);

          // //操作说明
          // var logInfo = string.Format("门店:{0},[{1}]执行了[优惠券]操作,券号为[{2}],折扣为[{3}]", Global.Instance.Store.Name, Global.Instance.Worker.Name, coupon.CouponNo, coupon.DiscountValue);
          // //本地操作日志记录整单折扣
          // LogUtils.WriteLog(LogAction.点单操作, ModuleKeyCode.会员折扣券, logInfo, "", orderObject.TradeNo, orderObject.ReceivableAmount);

        } else {
          result = false;
          message = "没有适用的商品";
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("应用折扣券发生异常:" + e.toString());
      result = false;
      message = "应用折扣券发生异常";
    }

    return Tuple2(result, message);
  }

  /// 分摊代金券到商品
  Tuple2<bool, String> applyMoneyCoupon(OrderObject orderObject, OrderPay pay) {
    bool result = false;
    String message = "代金券应用失败";
    try {
      if (orderObject != null && orderObject.items.length > 0) {
        //排除当前支付方式的剩余支付金额
        var orderBalancePay = orderObject.paidAmount -
            orderObject.pays
                .where((x) => x.id != pay.id)
                .map((e) => e.paidAmount)
                .fold(0, (prev, paidAmount) => prev + paidAmount);

        //待分摊商品
        var fineOrderItem = getFineCouponItem(orderObject, pay.coupon);

        if (fineOrderItem.length > 0) {
          //参与商品净额（商品应收 - 券占金额）
          var totalAmount = fineOrderItem
              .map((e) => e.totalReceivableRemoveCouponLeastCost)
              .fold(0, (prev, leastCost) => prev + leastCost);

          //面值分摊
          var discountAmountSum = pay.faceAmount;
          //分摊最低消费金额(考虑满足0元就可以使用的券，取面值、最低金额最大值)
          var discountLeastCostSum = pay.couponLeastCost > pay.faceAmount
              ? pay.couponLeastCost
              : pay.faceAmount;

          //已经分摊的最低消费金额
          var sharedLeastCostSum = 0.0;
          //已经分摊的金额
          var sharedAmountSum = 0.0;
          int i = 0;
          for (var item in fineOrderItem) {
            i++;
            if (item.rowType == OrderItemRowType.Detail ||
                item.rowType == OrderItemRowType.SuitDetail) {
              //套餐明细不允许分摊
              continue;
            }
            double share = 0.0;
            double shareLeastCost = 0.0;
            if (i >= fineOrderItem.length) {
              //最后一个，做减法
              share = discountAmountSum - sharedAmountSum;

              shareLeastCost = discountLeastCostSum - sharedLeastCostSum;
            } else {
              if (totalAmount != 0) {
                //这里使用去券金额，表示这个还能够用券
                var rate =
                    item.totalReceivableRemoveCouponLeastCost / totalAmount;

                share = OrderUtils.instance.toRound(discountAmountSum * rate);

                shareLeastCost =
                    OrderUtils.instance.toRound(discountLeastCostSum * rate);
              }
            }

            //分摊金额如果超过去券总应收，则取剩余去券总应收
            if (share > item.totalReceivableRemoveCouponAmount) {
              share = item.totalReceivableRemoveCouponAmount;
            }

            //分摊金额大于剩余应付金额，比如之前我先用了人民币支付了一部分，后用券，则也会影响券使用金额
            if (share > orderBalancePay) {
              share = orderBalancePay;
            }

            //异常，停止计算
            if (discountAmountSum <= 0 || share <= 0) {
              continue;
            }

            //计算支付方式分摊
            OrderItemPay itemPay = new OrderItemPay()
              ..id = IdWorkerUtils.getInstance().generate().toString()
              ..tenantId = pay.tenantId
              ..orderId = pay.orderId
              ..tradeNo = pay.tradeNo
              ..payId = pay.id
              ..itemId = item.id
              ..no = pay.no
              ..name = pay.name
              ..productId = item.productId
              ..specId = item.specId
              ..couponId = pay.couponId
              ..couponNo = pay.couponNo
              ..sourceSign = pay.sourceSign
              ..couponName = pay.couponName
              ..faceAmount = pay.faceAmount
              ..shareAmount = share
              ..shareCouponLeastCost = shareLeastCost
              ..refundAmount = 0.0;

            item.itemPays.add(itemPay);
            //重新计算订单明细值
            OrderUtils.instance.calculateOrderItem(item);
            sharedAmountSum += share;
            sharedLeastCostSum += shareLeastCost;
          }
          //重算整单，重点是券后应收
          OrderUtils.instance.calculateOrderObject(orderObject);

          if (sharedAmountSum != pay.faceAmount) {
            pay.amount = sharedAmountSum;
            pay.inputAmount = sharedAmountSum;
            pay.paidAmount = sharedAmountSum;
            //券溢收了
            pay.overAmount = pay.faceAmount - sharedAmountSum;
          }

          result = true;
          message = "success";
        } else {
          //没有适用的商品，都不应该到这里
          FLogger.error("代金券分摊，没有适用的商品，都不应该到这里");

          result = false;
          message = "没有适用的商品";
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("应用代金券发生异常:" + e.toString());
      result = false;
      message = "应用代金券发生异常";
    }
    return Tuple2(result, message);
  }

  ///检测优惠券的可用情况
  void checkCouponEffect(List<MemberElecCoupon> couponList,
      List<MemberElecCoupon> couponSelected, OrderObject orderObject,
      {bool topSelect = false}) {
    try {
      //没有优惠券，直接返回
      if (couponList == null || couponList.length == 0) return;

      //当前时间，用于处理优惠券可用时段的判断
      var now = DateTime.now();

      //已经选择的卡券编号
      var coupons = [];
      couponSelected.forEach((x) {
        coupons.add(x.couponNo);
      });

      //只校验未选中的
      var noSelectedCoupons =
          couponList.where((x) => !coupons.contains(x.couponNo));
      noSelectedCoupons.forEach((coupon) {
        bool isGo = true;
        StringBuffer reason = new StringBuffer();
        if (isGo && coupon.status != 1) {
          isGo = false;
          reason.write("${coupon.statusDes};");
        }
        if (isGo && coupon.isFreeze == 1) {
          isGo = false;
          reason.write("已冻结;");
        }
        //由于返回的当天已核销数量得核销后才可以获得，对于未核销前的选择优惠券情况，需要记录当前选择的优惠券数量，来判断是否超过限制的优惠券数量
        var count = couponSelected.where((x) => x.id == coupon.id).length;
        if (isGo &&
            coupon.dayLimitQuantity != 0 &&
            coupon.usedNum + count >= coupon.dayLimitQuantity) {
          isGo = false;
          reason.write("今日已使用${coupon.dayLimitQuantity}次;");
        }
        DateTime endEffectiveTime = DateTime.parse(coupon.endEffectiveTime);
        if (isGo && now.compareTo(endEffectiveTime) >= 0) {
          isGo = false;
          reason.write("已过期;");
        }
        if (isGo && coupon.useTimeFlag == 1) {
          List<ElecCouponUseTime> couponTimes = coupon.useTimeList;
          if (null != couponTimes && couponTimes.length > 0) {
            bool timeCheck = false;
            for (ElecCouponUseTime time in couponTimes) {
              time.currentTime =
                  DateUtils.formatDate(now, format: "yyyy-MM-dd HH:mm:ss");
              if (time.checkTime) {
                timeCheck = true;
                break;
              }
            }
            if (!timeCheck) {
              isGo = false;
              reason.write("不在可用时段;");
            }
          }
        }

        // 核销门店
        if (isGo && coupon.consumeStoreFlag == 1) {
          var storeCheck = coupon.consumeStoreList
              .any((x) => x.storeId == Global.instance.authc.storeId);
          if (!storeCheck) {
            isGo = false;
            reason.write("该门店不允许核销;");
          }
        }

        //商品适用范围
        if (isGo && null != orderObject && orderObject.items.length > 0) {
          //待分摊商品
          var fineOrderItem = orderObject.items.where((x) =>
              x.rowType != OrderItemRowType.Detail &&
              x.rowType != OrderItemRowType.SuitDetail &&
              x.totalReceivableRemoveCouponLeastCost > 0 &&
              (coupon.discountType == 1 ? true : x.foreDiscount == 1));
          switch (coupon.fitRange) {
            case 1: // 全场通用
              {
                //券后应收金额
                var receivableAmount = 0.0;
                if (coupon.exgoodsList != null &&
                    coupon.exgoodsList.length > 0) {
                  var currentFineOrderItems = fineOrderItem.where((x) =>
                      !coupon.exgoodsList.any((y) => y.specId == x.specId));
                  if (currentFineOrderItems != null &&
                      currentFineOrderItems.length > 0) {
                    //排除黑名单中的商品的剩余应收金额
                    receivableAmount = currentFineOrderItems
                        .map((e) => e.totalReceivableRemoveCouponLeastCost)
                        .fold(0, (prev, leastCost) => prev + leastCost);
                  } else {
                    isGo = false;
                    reason.write("没有可用商品;");
                  }
                } else {
                  receivableAmount = fineOrderItem
                      .map((e) => e.totalReceivableRemoveCouponLeastCost)
                      .fold(0, (prev, leastCost) => prev + leastCost);
                }

                //剩余券后应收为零
                if (isGo && receivableAmount == 0) {
                  isGo = false;
                  reason.write("可用券金额为0;");
                }

                if (isGo && receivableAmount < coupon.leastCost) {
                  isGo = false;
                  reason.write("消费未满${coupon.leastCost}元;");
                }
              }
              break;
            case 2: // 部分商品
              {
                if (null != coupon.goodsList && coupon.goodsList.length > 0) {
                  var currentFineOrderItems = fineOrderItem.where(
                      (x) => coupon.goodsList.any((y) => y.specId == x.specId));
                  if (currentFineOrderItems != null &&
                      currentFineOrderItems.length > 0) {
                    var receivableAmount = currentFineOrderItems
                        .map((e) => e.totalReceivableRemoveCouponLeastCost)
                        .fold(0, (prev, leastCost) => prev + leastCost);

                    //剩余券后应收为零
                    if (receivableAmount == 0) {
                      isGo = false;
                      reason.write("可用券金额为0;");
                    }

                    if (isGo && receivableAmount < coupon.leastCost) {
                      isGo = false;
                      reason.write(
                          "部分商品未满${coupon.leastCost}元;"); //,参与金额[$receivableAmount]元
                    }
                  } else {
                    isGo = false;
                    reason.write("没有可用商品;");
                  }
                } else {
                  isGo = false;
                  reason.write("没有用商品;");
                }
              }
              break;
            case 3: // 部分类别
              {
                List<ElecCouponCategory> couponCategorys = coupon.categoryList;
                if (null != couponCategorys && couponCategorys.length > 0) {
                  var currentFineOrderItems = fineOrderItem.where((x) =>
                      couponCategorys
                          .any((y) => y.categoryId == x.categoryId) &&
                      (coupon.exgoodsList == null ||
                          !coupon.exgoodsList
                              .any((z) => z.specId == x.specId)));
                  if (currentFineOrderItems != null &&
                      currentFineOrderItems.length > 0) {
                    //类别且排除黑名单商品的应收金额
                    var receivableAmount = currentFineOrderItems
                        .map((e) => e.totalReceivableRemoveCouponLeastCost)
                        .fold(0, (prev, leastCost) => prev + leastCost);
                    //剩余券后应收为零
                    if (receivableAmount == 0) {
                      isGo = false;
                      reason.write("可用券金额为0;");
                    }

                    if (isGo && receivableAmount < coupon.leastCost) {
                      isGo = false;
                      reason.write(
                          "部分品类消费未满${coupon.leastCost}元;"); //,当前参与金额[$receivableAmount]
                    }
                  } else {
                    isGo = false;
                    reason.write("品类折扣不满足条件;");
                  }
                } else {
                  isGo = false;
                  reason.write("品类折扣不满足条件;");
                }
              }
              break;
            case 4: // 部分品牌
              {
                List<ElecCouponBrand> couponBrands = coupon.brandList;
                if (null != couponBrands && couponBrands.length > 0) {
                  var currentFineOrderItems = fineOrderItem.where((x) =>
                      couponBrands.any((y) => y.brandId == x.brandId) &&
                      (coupon.exgoodsList == null ||
                          !coupon.exgoodsList
                              .any((z) => z.specId == x.specId)));
                  if (currentFineOrderItems != null &&
                      currentFineOrderItems.length > 0) {
                    //类别且排除黑名单商品的应收金额
                    var receivableAmount = currentFineOrderItems
                        .map((e) => e.totalReceivableRemoveCouponLeastCost)
                        .fold(0, (prev, leastCost) => prev + leastCost);
                    //剩余券后应收为零
                    if (receivableAmount == 0) {
                      isGo = false;
                      reason.write("可用券金额为0;");
                    }

                    if (isGo && receivableAmount < coupon.leastCost) {
                      isGo = false;
                      reason.write(
                          "部分品牌消费未满[${coupon.leastCost}]元;"); //,当前参与金额[$receivableAmount]
                    }
                  } else {
                    isGo = false;
                    reason.write("品牌折扣不满足条件;");
                  }
                } else {
                  isGo = false;
                  reason.write("品牌折扣不满足条件;");
                }
              }
              break;
            default:
              {
                isGo = false;
                reason.write("不支持的优惠券;");
              }
              break;
          }
        }

        if (isGo) {
          coupon.enable = true;
          coupon.reason = "";
        } else {
          //不通过
          coupon.enable = false;
          coupon.reason = reason.toString();
        }
      });

      //根据已使用的券验证其他券
      if (couponSelected.length > 0) {
        //第一张券，一旦选择了一个能共用的，其他不能用的都不会被选中了，第一个不能共用的，就不会有第二个了
        MemberElecCoupon firstCoupon = couponSelected.first;
        //未选择的券中获取可用的券
        var enableCouponList =
            noSelectedCoupons.where((x) => x.enable).toList();
        for (MemberElecCoupon useCoupon in enableCouponList) {
          //第一张券不能与其他券共用，需要将其他券全部置为不可用
          if (firstCoupon.canUnionUse == 0) {
            useCoupon.enable = false;
            useCoupon.reason = "不能与已选券共用";
          } else if (useCoupon.canUnionUse == 0) {
            //第一张券可以和其他券共用，需要将其他不能与其他券共用的券置为不可用
            useCoupon.enable = false;
            useCoupon.reason = "不能与已选券共用";
          }
        }

        //没有被选中 && 启用 && 折扣券 统统否决掉
        var discountCoupons =
            noSelectedCoupons.where((x) => x.enable && x.discountType == 2);
        if (discountCoupons != null && discountCoupons.length > 0) {
          discountCoupons.forEach((x) {
            x.enable = false;
            if (firstCoupon.discountType == 1) {
              //使用了代金券导致折扣券不能用
              x.reason = "折扣券请优先使用";
            } else {
              x.reason = "仅支持用一张折扣券";
            }
          });
        }
      }

      // //对优惠券进行排序后的结果,已选、可用、不可用
      // List<MemberElecCoupon> result = [];
      //
      // //可选择
      // if (noSelectedCoupons.where((x) => x.enable).length > 0) {
      //   result.addAll(noSelectedCoupons.where((x) => x.enable));
      // }
      // //不可选择
      // if (noSelectedCoupons.where((x) => !x.enable).length > 0) {
      //   result.addAll(noSelectedCoupons.where((x) => !x.enable));
      // }
      //
      // if (topSelect) {
      //   //已经选择
      //   if (couponSelected.length > 0) {
      //     result.insertAll(0, couponSelected);
      //   }
      // }
      // couponList.clear();
      // couponList.addAll(result);
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("计算券是否可用异常:" + e.toString());
    }
  }

  //处理折扣券
  Future<void> processDiscountCoupon(List<MemberElecCoupon> couponList,
      List<MemberElecCoupon> couponSelected, OrderObject orderObject) async {
    //获取选中的全部折扣券
    List<MemberElecCoupon> allDiscountCoupons =
        couponSelected.where((x) => x.discountType == 2).toList();
    print("已经选择的折扣券数量:${allDiscountCoupons.length}");
    if (allDiscountCoupons.length > 0) {
      //校验是否已使用
      allDiscountCoupons.forEach((coupon) {
        var couponPromotion = orderObject.promotions.firstWhere(
            (x) => coupon.couponNo == x.couponNo,
            orElse: () => null);
        if (couponPromotion != null) {
          //已使用，不处理
        } else {
          //加入使用
          MemberUtils.instance.applyDiscountCoupon(orderObject, coupon);
          //重算订单明细，订单汇总
          updateAllRow(orderObject);
        }
      });
    } else {
      //删除主单和明细的折扣券优惠
      orderObject.promotions
          .removeWhere((x) => x.promotionType == PromotionType.Coupon);
      orderObject.items.forEach((x) => x.promotions
          .removeWhere((y) => y.promotionType == PromotionType.Coupon));
      //重算订单明细，订单汇总
      updateAllRow(orderObject);
    }
  }

  void updateAllRow(OrderObject orderObject, {bool fullOrderObject = false}) {
    if (orderObject != null) {
      for (var item in orderObject.items) {
        //当前为整单折扣/议价操作，传输true的标识是为了在整单议价/折扣时不进行商品促销价与更改后价格的比较
        OrderUtils.instance.calculateOrderItem(item, allOrder: true);
      }
      //是否重算整单
      if (fullOrderObject) {
        OrderUtils.instance.calculateOrderObject(orderObject);
      }
    }
  }

  //处理代金券,代金券记入支付方式
  Future<void> processCashCoupon(List<MemberElecCoupon> couponList,
      List<MemberElecCoupon> couponSelected, OrderObject orderObject) async {
    //删除取消的优惠券
    if (couponSelected.length > 0) {
      var couponPayList = orderObject.pays.where((x) =>
          x.no == Constants.PAYMODE_CODE_COUPON &&
          StringUtils.isNotBlank(x.couponNo));
      if (couponPayList.length > 0) {
        //找到已删除的优惠券，删除支付方式分摊
        var delPayList = couponPayList
            .where((x) => !couponSelected.any((y) => y.couponNo == x.couponNo));
        if (delPayList != null && delPayList.length > 0) {
          orderObject.pays
              .removeWhere((x) => delPayList.any((y) => y.id == x.id));
          //删除支付方式分摊
          orderObject.items.forEach((x) => x.itemPays
              .removeWhere((y) => delPayList.any((z) => z.id == y.payId)));
          //重算订单明细，订单汇总
          updateAllRow(orderObject);
        }
      }
    }

    //识别出需要本次新增的代金券
    if (couponSelected != null && couponSelected.length > 0) {
      for (var coupon in couponSelected) {
        if (coupon.discountType == 2) {
          //过滤折扣券
          continue;
        }

        if (orderObject.pays.any((x) =>
            x.no == Constants.PAYMODE_CODE_COUPON &&
            x.couponNo == coupon.couponNo)) {
          //该代金券支付方式已存在
          continue;
        }

        if (coupon.discountType == 1) {
          //代金券
          var couponPay = orderObject.pays.firstWhere(
              (x) => x.couponNo == coupon.couponNo,
              orElse: () => null);
          if (couponPay == null) {
            //新增
            var payMode = await OrderUtils.instance
                .getPayMode(Constants.PAYMODE_CODE_COUPON);
            if (payMode == null) {
              return;
            }

            var pay = OrderPay.fromPayMode(orderObject, payMode);
            pay.couponId = coupon.id;
            pay.couponNo = coupon.couponNo;
            pay.sourceSign = coupon.sourceSign;
            pay.couponName = coupon.name;
            pay.faceAmount = coupon.discountValue;
            pay.couponLeastCost = coupon.leastCost;
            pay.amount = coupon.discountValue;
            pay.inputAmount = coupon.discountValue;
            pay.paidAmount = coupon.discountValue;
            pay.overAmount = 0;
            pay.changeAmount = 0;
            pay.platformDiscount = 0;
            pay.platformPaid = 0;
            //更换为带门店的支付单号
            pay.payNo = orderObject.tradeNo;
            pay.payChannel = PayChannelEnum.None;
            pay.status = OrderPaymentStatus.NonPayment;
            pay.coupon = coupon;

            orderObject.pays.add(pay);

            //分摊该代金券
            MemberUtils.instance.applyMoneyCoupon(orderObject, pay);
          }
        }
      }
    } else {
      //清空卡券支付方式
      orderObject.pays.removeWhere((x) =>
          x.no == Constants.PAYMODE_CODE_COUPON &&
          StringUtils.isNotBlank(x.couponId));
    }
  }
}
