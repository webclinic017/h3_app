import "dart:collection";
import 'dart:convert';

import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/entity/pos_payment_parameter.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/crypto_utils.dart';
import 'package:h3_app/utils/objectid_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:http/http.dart' as http;

import 'leshua/leshua_payment_result.dart';
import 'leshua/leshua_query_result.dart';

class LeshuaPayUtils {
  LeshuaPayUtils._();

  static Future<Tuple4<bool, String, bool, ScanPayResult>> paymentResult(
      PayMode payMode,
      PaymentParameter payParameter,
      String payCode,
      String tradeNo,
      double amount) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起支付";
    //是否需要查询结果
    bool isQuery = false;
    //第三方平台支付结果
    LeShuaPaymentResult leshuaPaymentResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = parameter.containsKey("channel")
          ? Convert.toStr(parameter["channel"])
          : "";
      String merchantId = parameter.containsKey("merchant_id")
          ? Convert.toStr(parameter["merchant_id"])
          : "";
      String payKey = parameter.containsKey("payKey")
          ? Convert.toStr(parameter["payKey"])
          : "";
      String notifyKey = parameter.containsKey("notifyKey")
          ? Convert.toStr(parameter["notifyKey"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      Map<String, String> keyValues = new SplayTreeMap<String, String>();
      //接口名
      keyValues["service"] = "upload_authcode";
      //付款码
      keyValues["auth_code"] = "$payCode";
      //商户号
      keyValues["merchant_id"] = "$merchantId";
      //商户订单号
      keyValues["third_order_id"] =
          OrderUtils.instance.generatePayNo(tradeNo, separator: "");
      //订单金额
      int totalFee = (amount * 100).toInt();
      keyValues["amount"] = "$totalFee";
      //随机字符串
      keyValues["nonce_str"] = "${ObjectIdUtils.getInstance().generate()}";
      //签名
      keyValues["sign"] = LeshuaPayUtils.sign(keyValues, payKey);

      String requestUrl = _buildQueryParams(gatewayUrl, keyValues);

      FLogger.info("支付请求参数:${keyValues.toString()}");

      //发送请求
      var response = await http.post(requestUrl);
      var respString = utf8.decode(response.bodyBytes);
      //处理应答结果
      leshuaPaymentResult = LeShuaPaymentResult.fromXml(respString);
      //支付成功
      if (leshuaPaymentResult != null &&
          leshuaPaymentResult.resp_code == "0" &&
          leshuaPaymentResult.result_code == "0") {
        result = true;

        var statusResult = getStatus(leshuaPaymentResult.status);
        //支付中，需要重新查询支付结果
        if (statusResult.item1 == "0") {
          //支付中
          isQuery = true;
          message = "${leshuaPaymentResult.error_msg}";
        } else if (statusResult.item1 == "8") {
          //支付失败
          isQuery = false;
          message = "${leshuaPaymentResult.error_msg}";
        } else {
          isQuery = false;

          message = "${leshuaPaymentResult.error_msg}";
        }
      } else {
        result = false;
        message =
            "${leshuaPaymentResult.resp_msg}<${leshuaPaymentResult.resp_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "支付发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("乐刷支付发生异常:" + e.toString());
    }

    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromLeShuaPaymentResult(
          leshuaPaymentResult, tradeNo, payMode);
    }

    return Tuple4(result, message, isQuery, payResult);
  }

  static Tuple2<String, String> getStatus(String status) {
    String stausDesc = "";
    switch (status) {
      case "0":
        {
          stausDesc = "支付中";
        }
        break;
      case "2":
        {
          stausDesc = "支付成功";
        }
        break;
      case "6":
        {
          stausDesc = "订单关闭";
        }
        break;
      case "8":
        {
          stausDesc = "支付失败";
        }
        break;
      case "10":
        {
          stausDesc = "退款中";
        }
        break;
      case "11":
        {
          stausDesc = "退款成功";
        }
        break;
      case "12":
        {
          stausDesc = "退款失败";
        }
        break;
    }

    return Tuple2(status, stausDesc);
  }

  //构建Http请求参数
  static String _buildQueryParams(String url, Map<String, String> paramsMap) {
    String queryParams = "";
    if (paramsMap != null && paramsMap.length > 0) {
      StringBuffer str = new StringBuffer();
      for (var key in paramsMap.keys) {
        String pKey = "$key";
        String pValue = "${paramsMap[key]}";
        str.write(pKey + "=" + pValue + "&");
      }
      queryParams = str.toString().substring(0, str.toString().length - 1);
    }

    return "$url?$queryParams";
  }

  static Future<Tuple3<bool, String, ScanPayResult>> queryPayment(
      PayMode payMode,
      PaymentParameter payParameter,
      String tradeNo,
      String payNo) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起查询";
    //第三方平台支付结果
    LeShuaQueryResult leshuaQueryResult;

    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = parameter.containsKey("channel")
          ? Convert.toStr(parameter["channel"])
          : "";
      String merchantId = parameter.containsKey("merchant_id")
          ? Convert.toStr(parameter["merchant_id"])
          : "";
      String payKey = parameter.containsKey("payKey")
          ? Convert.toStr(parameter["payKey"])
          : "";
      String notifyKey = parameter.containsKey("notifyKey")
          ? Convert.toStr(parameter["notifyKey"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      Map<String, String> keyValues = new SplayTreeMap<String, String>();
      //接口名
      keyValues["service"] = "query_status";
      //商户号
      keyValues["merchant_id"] = "$merchantId";
      //商户订单号
      keyValues["third_order_id"] = payNo;
      //随机字符串
      keyValues["nonce_str"] = "${ObjectIdUtils.getInstance().generate()}";
      //签名
      keyValues["sign"] = LeshuaPayUtils.sign(keyValues, payKey);

      String requestUrl = _buildQueryParams(gatewayUrl, keyValues);

      FLogger.info(">>>>乐刷请求Url>>>>>$requestUrl");

      //发送请求
      var response = await http.post(requestUrl);
      var respString = utf8.decode(response.bodyBytes);

      FLogger.info(">>>>乐刷应答参数>>>>>$respString");

      //处理应答结果
      leshuaQueryResult = LeShuaQueryResult.fromXml(respString);
      //支付成功
      if (leshuaQueryResult != null &&
          leshuaQueryResult.resp_code == "0" &&
          leshuaQueryResult.result_code == "0") {
        var statusResult = getStatus(leshuaQueryResult.status);

        //查询支付结果
        if (statusResult.item1 == "0") {
          result = false;
          message = "提示顾客确认支付";
        } else if (statusResult.item1 == "8") {
          result = true;
          message = "顾客取消支付";
        } else if (statusResult.item1 == "2") {
          result = true;
          message = "${statusResult.item2}";
        } else {
          result = false;
          message = "${leshuaQueryResult.error_msg}";
        }
      } else {
        result = false;
        message =
            "${leshuaQueryResult.resp_msg}<${leshuaQueryResult.resp_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "支付发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("乐刷支付发生异常:" + e.toString());
    }

    FLogger.info(">>>>乐刷支付结果>>>>>$leshuaQueryResult");

    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromLeShuaQueryResult(
          leshuaQueryResult, tradeNo, payMode);
    }

    FLogger.info(">>>>乐刷支付结果>>>>>$payResult");

    return Tuple3(result, message, payResult);
  }

  static Future<Tuple4<bool, String, bool, ScanPayResult>> refundResult(
      PayMode payMode,
      PaymentParameter payParameter,
      String tradeNo,
      String payNo,
      double amount) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起退单";
    //是否需要查询结果
    bool isQuery = false;
    //第三方平台支付结果
    LeShuaPaymentResult leshuaPaymentResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = parameter.containsKey("channel")
          ? Convert.toStr(parameter["channel"])
          : "";
      String merchantId = parameter.containsKey("merchant_id")
          ? Convert.toStr(parameter["merchant_id"])
          : "";
      String payKey = parameter.containsKey("payKey")
          ? Convert.toStr(parameter["payKey"])
          : "";
      String notifyKey = parameter.containsKey("notifyKey")
          ? Convert.toStr(parameter["notifyKey"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      Map<String, String> keyValues = new SplayTreeMap<String, String>();
      //接口名
      keyValues["service"] = "unified_refund";
      //商户号
      keyValues["merchant_id"] = "$merchantId";
      //商户订单号
      keyValues["third_order_id"] = payNo;
      //商户退款号
      keyValues["merchant_refund_id"] = "T" + payNo;
      //退款金额
      int totalRefundAmount = (amount * 100).toInt();
      keyValues["refund_amount"] = "$totalRefundAmount";
      //随机字符串
      keyValues["nonce_str"] = "${ObjectIdUtils.getInstance().generate()}";
      //签名
      keyValues["sign"] = LeshuaPayUtils.sign(keyValues, payKey);

      String requestUrl = _buildQueryParams(gatewayUrl, keyValues);

      FLogger.info("支付请求参数:${keyValues.toString()}");

      //发送请求
      var response = await http.post(requestUrl);
      var respString = utf8.decode(response.bodyBytes);

      FLogger.info("支付应答结果:\n$respString");

      //处理应答结果
      leshuaPaymentResult = LeShuaPaymentResult.fromXml(respString);
      //支付成功
      if (leshuaPaymentResult != null &&
          leshuaPaymentResult.resp_code == "0" &&
          leshuaPaymentResult.result_code == "0") {
        result = true;

        var statusResult = getStatus(leshuaPaymentResult.status);
        //支付中，需要重新查询支付结果
        if (statusResult.item1 == "0") {
          //支付中
          isQuery = true;
          message = "${leshuaPaymentResult.error_msg}";
        } else if (statusResult.item1 == "8") {
          //支付失败
          isQuery = false;
          message = "${leshuaPaymentResult.error_msg}";
        } else {
          isQuery = false;

          message = "${leshuaPaymentResult.error_msg}";
        }
      } else {
        result = false;
        message =
            "${leshuaPaymentResult.error_msg}<${leshuaPaymentResult.error_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "退款发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("乐刷退款发生异常:" + e.toString());
    }

    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromLeShuaPaymentResult(
          leshuaPaymentResult, tradeNo, payMode);
    }

    return Tuple4(result, message, isQuery, payResult);
  }

  static String sign(SplayTreeMap<String, String> paramsMap, String key) {
    StringBuffer str = new StringBuffer();
    for (var key in paramsMap.keys) {
      String pKey = "$key";
      String pValue = "${paramsMap[key]}";

      if (StringUtils.isBlank(pValue) ||
          pKey == "leshua" ||
          pKey == "resp_code" ||
          pKey == "sign") {
        continue;
      }
      str.write(pKey + "=" + pValue + "&");
    }
    String result = str.toString().substring(0, str.toString().length - 1);

    return Md5Utils.md5(result + "&key=" + key);
  }
}
