import 'dart:async';

import 'package:h3_app/enums/online_pay_bus_type_enum.dart';
import 'package:h3_app/enums/pay_parameter_sign_enum.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/payment/leshua_pay_utils.dart';
import 'package:h3_app/payment/saobei_pay_utils.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/payment/xiaobei_pay_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';

import 'order_object.dart';
import 'order_utils.dart';

///支付类
class PayUtils {
  // 工厂模式
  factory PayUtils() => _getInstance();

  static PayUtils get instance => _getInstance();
  static PayUtils _instance;

  static PayUtils _getInstance() {
    if (_instance == null) {
      _instance = new PayUtils._internal();
    }
    return _instance;
  }

  PayUtils._internal();

  ///发起扫码支付
  Future<Tuple3<bool, String, ScanPayResult>> scanPayResult(
      String payCode, OrderObject orderObject,
      {OnLinePayBusTypeEnum busType = OnLinePayBusTypeEnum.Sale}) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起查询";
    //支付结果
    ScanPayResult scanPayResult;

    try {
      //获取当前支付方式
      var currentPayMode =
          await OrderUtils.instance.getPayModeByPayCode(payCode);
      //支付参数
      var payParameterResult = await OrderUtils.instance
          .getPayParameterByPayMode(currentPayMode, busType);
      //获取支付参数失败
      if (!payParameterResult.item1) {
        result = false;
        message = payParameterResult.item2;
      } else {
        FLogger.info("适配到支付通道:$payParameterResult");
        var payParameter = payParameterResult.item3;
        var paySign = PayParameterSignEnum.fromName(payParameter.sign);
        switch (paySign) {
          case PayParameterSignEnum.LeshuaPay:
            {
              FLogger.info("适配到乐刷支付通道");
              var payResult = await LeshuaPayUtils.paymentResult(
                  currentPayMode,
                  payParameter,
                  payCode,
                  orderObject.tradeNo,
                  orderObject.unreceivableAmount);
              //支付不成功
              if (!payResult.item1) {
                result = false;
                message = payResult.item2;
                FLogger.info("扣款不成功,原因:$message");
              } else {
                //查询状态
                if (payResult.item3) {
                  var payNo = payResult.item4.payNo;
                  FLogger.info("查询支付状态:$payNo");
                  var queryResult = await LeshuaPayUtils.queryPayment(
                      currentPayMode, payParameter, orderObject.tradeNo, payNo);

                  if (!queryResult.item1) {
                    //第一次查询支付结果失败,每500毫秒执行一次，重试60次，大约30秒
                    for (int i = 0; i < 60; i++) {
                      queryResult = await LeshuaPayUtils.queryPayment(
                          currentPayMode,
                          payParameter,
                          orderObject.tradeNo,
                          payNo);
                      FLogger.info(
                          "第${i + 1}次查询支付状态:${queryResult.item1},${queryResult.item2}");
                      //扣款成功
                      if (queryResult.item1) {
                        //查询扣款结果成功
                        result = true;
                        message = queryResult.item2;
                        scanPayResult = queryResult.item3;
                        break;
                      } else {
                        //查询扣款结果超时
                        result = false;
                        message = queryResult.item2;

                        Future.delayed(Duration(milliseconds: 500));
                      }
                    }
                  } else {
                    //查询扣款结果成功
                    result = true;
                    message = queryResult.item2;
                    scanPayResult = queryResult.item3;
                  }
                } else {
                  //扣款成功
                  result = true;
                  message = payResult.item2;
                  scanPayResult = payResult.item4;
                }
              }
            }
            break;
          case PayParameterSignEnum.SaobeiPay:
            {
              FLogger.info(
                  "适配到扫呗支付通道,支付码:$payCode,订单号:${orderObject.tradeNo},待支付金额:${orderObject.unreceivableAmount}");
              var payResult = await SaobeiPayUtils.paymentResult(
                  currentPayMode,
                  payParameter,
                  payCode,
                  orderObject.tradeNo,
                  orderObject.unreceivableAmount);
              //支付不成功
              if (!payResult.item1) {
                result = false;
                message = payResult.item2;
                FLogger.info("扣款不成功,原因:$message");
              } else {
                //查询状态
                if (payResult.item3) {
                  var payNo = payResult.item4.payNo;
                  String voucherNo = payResult.item4.voucherNo;
                  String payTime = payResult.item4.payTime;

                  FLogger.info("查询支付状态:$payNo");

                  var queryResult = await SaobeiPayUtils.queryPayment(
                      currentPayMode,
                      payParameter,
                      orderObject.tradeNo,
                      payNo,
                      voucherNo,
                      payTime);

                  if (!queryResult.item1) {
                    //第一次查询支付结果失败,每500毫秒执行一次，重试60次，大约30秒
                    for (int i = 0; i < 60; i++) {
                      queryResult = await SaobeiPayUtils.queryPayment(
                          currentPayMode,
                          payParameter,
                          orderObject.tradeNo,
                          payNo,
                          voucherNo,
                          payTime);
                      FLogger.info(
                          "第${i + 1}次查询支付状态:${queryResult.item1},${queryResult.item2}");
                      //扣款成功
                      if (queryResult.item1) {
                        //查询扣款结果成功
                        result = true;
                        message = queryResult.item2;
                        scanPayResult = queryResult.item3;
                        break;
                      } else {
                        //查询扣款结果超时
                        result = false;
                        message = queryResult.item2;

                        Future.delayed(Duration(milliseconds: 500));
                      }
                    }
                  } else {
                    //查询扣款结果成功
                    result = true;
                    message = queryResult.item2;
                    scanPayResult = queryResult.item3;
                  }
                } else {
                  //扣款成功
                  result = true;
                  message = payResult.item2;
                  scanPayResult = payResult.item4;
                }
              }
            }
            break;
          case PayParameterSignEnum.XiaobeiPay:
            {
              FLogger.info(
                  "适配到小呗支付通道,支付码:$payCode,订单号:${orderObject.tradeNo},待支付金额:${orderObject.unreceivableAmount}");
              var payResult = await XiaobeiPayUtils.paymentResult(
                  currentPayMode,
                  payParameter,
                  payCode,
                  orderObject.tradeNo,
                  orderObject.unreceivableAmount);
              //支付不成功
              if (!payResult.item1) {
                result = false;
                message = payResult.item2;
                FLogger.info("扣款不成功,原因:$message");
              } else {
                //查询状态
                if (payResult.item3) {
                  var payNo = payResult.item4.payNo;
                  String voucherNo = payResult.item4.voucherNo;
                  String payTime = payResult.item4.payTime;

                  FLogger.info("查询支付状态:$payNo");

                  var queryResult = await XiaobeiPayUtils.queryPayment(
                      currentPayMode,
                      payParameter,
                      orderObject.tradeNo,
                      payNo,
                      voucherNo,
                      payTime);

                  if (!queryResult.item1) {
                    //第一次查询支付结果失败,每500毫秒执行一次，重试60次，大约30秒
                    for (int i = 0; i < 60; i++) {
                      queryResult = await XiaobeiPayUtils.queryPayment(
                          currentPayMode,
                          payParameter,
                          orderObject.tradeNo,
                          payNo,
                          voucherNo,
                          payTime);
                      FLogger.info(
                          "第${i + 1}次查询支付状态:${queryResult.item1},${queryResult.item2}");
                      //扣款成功
                      if (queryResult.item1) {
                        //查询扣款结果成功
                        result = true;
                        message = queryResult.item2;
                        scanPayResult = queryResult.item3;
                        break;
                      } else {
                        //查询扣款结果超时
                        result = false;
                        message = queryResult.item2;

                        Future.delayed(Duration(milliseconds: 500));
                      }
                    }
                  } else {
                    //查询扣款结果成功
                    result = true;
                    message = queryResult.item2;
                    scanPayResult = queryResult.item3;
                  }
                } else {
                  //扣款成功
                  result = true;
                  message = payResult.item2;
                  scanPayResult = payResult.item4;
                }
              }
            }
            break;
          default:
            {
              result = false;
              message = "暂不支持的支付通道";
            }
            break;
        }
      }
    } catch (e, stack) {
      result = false;
      message = "扫码支付发生异常";

      FlutterChain.printError(e, stack);
      FLogger.error("扫码支付发生异常:" + e.toString());
    }
    return Tuple3(result, message, scanPayResult);
  }
}
