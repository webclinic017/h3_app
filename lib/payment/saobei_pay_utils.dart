import 'dart:convert';

import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/entity/pos_payment_parameter.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/payment/saobei/saobei_payment_result.dart';
import 'package:h3_app/payment/saobei/saobei_query_result.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/crypto_utils.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

class SaobeiPayUtils {
  SaobeiPayUtils._();

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
    SaobeiPaymentResult saobeiPaymentResult;

    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String merchant_no = parameter.containsKey("merchant_no")
          ? Convert.toStr(parameter["merchant_no"])
          : "";
      String signKey = parameter.containsKey("signKey")
          ? Convert.toStr(parameter["signKey"])
          : "";
      String terminal_id = parameter.containsKey("terminal_id")
          ? Convert.toStr(parameter["terminal_id"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      // 支付方式 微信010、支付宝020、银联云闪付110
      String payType = "010";
      switch (payMode.no) {
        case "04":
          {
            payType = "020";
          }
          break;
        case "05":
          {
            payType = "010";
          }
          break;
        case "09":
          {
            payType = "110";
          }
          break;
      }

      Map<String, String> keyValues = new Map<String, String>();

      keyValues["pay_ver"] = "100";
      keyValues["pay_type"] = payType;
      keyValues["service_id"] = "010";
      keyValues["merchant_no"] = merchant_no;
      keyValues["terminal_id"] = terminal_id;
      keyValues["terminal_trace"] =
          OrderUtils.instance.generatePayNo(tradeNo, separator: "");
      keyValues["terminal_time"] =
          DateUtils.formatDate(DateTime.now(), format: "yyyyMMddHHmmss");
      keyValues["auth_no"] = payCode;
      int totalFee = (amount * 100).toInt();
      keyValues["total_fee"] = "$totalFee";
      var ignoreParameters = new List<String>();
      keyValues["key_sign"] = sign(signKey, keyValues, ignoreParameters);

      var jsonRequest = json.encode(keyValues);
      //发送请求
      var requestUrl = sprintf("%s%s", ["$gatewayUrl", "pay/100/barcodepay"]);
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      var responseBody = json.decode(response.body);

      FLogger.info("扫呗扫码支付结果:$responseBody");

      //处理应答结果
      saobeiPaymentResult = SaobeiPaymentResult.fromPaymentJson(responseBody);

      //支付成功
      if (saobeiPaymentResult != null &&
          saobeiPaymentResult.return_code == "01") {
        // 01成功 02失败 ，03支付中，99该条码暂不支持支付类型自动匹配 01的成功就是支付成功
        var reusltCode = saobeiPaymentResult.result_code;
        if ("01" == reusltCode) {
          result = true;
          isQuery = true;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("02" == reusltCode) {
          result = false;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("03" == reusltCode) {
          result = true;
          isQuery = true;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("99" == reusltCode) {
          result = false;
          message = "该条码暂不支持支付类型自动匹配<${saobeiPaymentResult.return_code}>";
        } else {
          result = false;
          message = "未知错误<${saobeiPaymentResult.return_code}>";
        }
      } else {
        result = false;
        message =
            "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "支付发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("扫呗支付发生异常:" + e.toString());
    }

    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromSaobeiPaymentResult(
          saobeiPaymentResult, tradeNo, payMode);
    }

    return Tuple4(result, message, isQuery, payResult);
  }

  static Future<Tuple3<bool, String, ScanPayResult>> queryPayment(
      PayMode payMode,
      PaymentParameter payParameter,
      String tradeNo,
      String payNo,
      String voucherNo,
      String payTime) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起查询";
    //第三方平台支付结果
    SaobeiQueryResult saobeiQueryResult;

    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String merchant_no = parameter.containsKey("merchant_no")
          ? Convert.toStr(parameter["merchant_no"])
          : "";
      String signKey = parameter.containsKey("signKey")
          ? Convert.toStr(parameter["signKey"])
          : "";
      String terminal_id = parameter.containsKey("terminal_id")
          ? Convert.toStr(parameter["terminal_id"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      // 支付方式 微信010、支付宝020、银联云闪付110
      String payType = "010";
      switch (payMode.no) {
        case "04":
          {
            payType = "020";
          }
          break;
        case "05":
          {
            payType = "010";
          }
          break;
        case "09":
          {
            payType = "110";
          }
          break;
      }

      Map<String, String> keyValues = new Map<String, String>();

      keyValues["pay_ver"] = "100";
      keyValues["pay_type"] = payType;
      keyValues["service_id"] = "020";
      keyValues["merchant_no"] = merchant_no;
      keyValues["terminal_id"] = terminal_id;
      keyValues["terminal_trace"] = payNo;
      keyValues["terminal_time"] =
          DateUtils.formatDate(DateTime.now(), format: "yyyyMMddHHmmss");
      keyValues["pay_trace"] = payNo;
      keyValues["pay_time"] = payTime;
      keyValues["out_trade_no"] = voucherNo;

      var ignoreParameters = new List<String>();
      ignoreParameters.add("pay_trace");
      ignoreParameters.add("pay_time");
      keyValues["key_sign"] = sign(signKey, keyValues, ignoreParameters);

      var jsonRequest = json.encode(keyValues);

      //发送请求
      var requestUrl = sprintf("%s%s", ["$gatewayUrl", "pay/100/query"]);
      print("请求参数=======>$requestUrl");

      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      var responseBody = json.decode(response.body);

      //处理应答结果
      saobeiQueryResult = SaobeiQueryResult.fromJson(responseBody);

      //支付成功
      if (saobeiQueryResult != null && saobeiQueryResult.return_code == "01") {
        // 01成功 02失败 ，03支付中，99该条码暂不支持支付类型自动匹配 01的成功就是支付成功
        var reusltCode = saobeiQueryResult.result_code;
        if ("01" == reusltCode) {
          result = true;
          message =
              "${saobeiQueryResult.return_msg}<${saobeiQueryResult.return_code}>";
        } else if ("02" == reusltCode) {
          result = false;
          message =
              "${saobeiQueryResult.return_msg}<${saobeiQueryResult.return_code}>";
        } else if ("03" == reusltCode) {
          result = true;
          message =
              "${saobeiQueryResult.return_msg}<${saobeiQueryResult.return_code}>";
        } else if ("99" == reusltCode) {
          result = false;
          message = "该条码暂不支持支付类型自动匹配<${saobeiQueryResult.return_code}>";
        } else {
          result = false;
          message = "未知错误<${saobeiQueryResult.return_code}>";
        }
      } else {
        result = false;
        message =
            "${saobeiQueryResult.return_msg}<${saobeiQueryResult.return_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "支付结果查询发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("扫呗支付结果发生异常:" + e.toString());
    }

    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromSaobeiQueryResult(
          saobeiQueryResult, tradeNo, payMode);
    }

    return Tuple3(result, message, payResult);
  }

  static Future<Tuple4<bool, String, bool, ScanPayResult>> refundResult(
      PayMode payMode,
      PaymentParameter payParameter,
      String payNo,
      String tradeNo,
      double refundAmound) async {
    //执行结果
    bool result = false;
    //提醒消息
    String message = "发起退单";
    //是否需要查询结果
    bool isQuery = false;
    //第三方平台支付结果
    SaobeiPaymentResult saobeiPaymentResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);

      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String merchant_no = parameter.containsKey("merchant_no")
          ? Convert.toStr(parameter["merchant_no"])
          : "";
      String signKey = parameter.containsKey("signKey")
          ? Convert.toStr(parameter["signKey"])
          : "";
      String terminal_id = parameter.containsKey("terminal_id")
          ? Convert.toStr(parameter["terminal_id"])
          : "";
      String gatewayUrl = parameter.containsKey("gatewayUrl")
          ? Convert.toStr(parameter["gatewayUrl"])
          : "";

      // 支付方式 微信010、支付宝020、银联云闪付110
      String payType = "010";
      switch (payMode.no) {
        case "04":
          {
            payType = "020";
          }
          break;
        case "05":
          {
            payType = "010";
          }
          break;
        case "09":
          {
            payType = "110";
          }
          break;
      }

      Map<String, String> keyValues = new Map<String, String>();

      keyValues["pay_ver"] = "100";
      keyValues["pay_type"] = payType;
      keyValues["service_id"] = "030";
      keyValues["merchant_no"] = merchant_no;
      keyValues["terminal_id"] = terminal_id;
      keyValues["terminal_trace"] =
          OrderUtils.instance.generatePayNo(tradeNo, separator: "");
      keyValues["terminal_time"] =
          DateUtils.formatDate(DateTime.now(), format: "yyyyMMddHHmmss");
      int refundFee = (refundAmound * 100).toInt();
      keyValues["refund_fee"] = "$refundFee";
      keyValues["out_trade_no"] = payNo;
      var ignoreParameters = new List<String>();
      keyValues["key_sign"] = sign(signKey, keyValues, ignoreParameters);

      var jsonRequest = json.encode(keyValues);
      //发送请求
      var requestUrl = sprintf("%s%s", ["$gatewayUrl", "pay/100/refund"]);
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));

      FLogger.info("扫呗退款结果:${response.body}");

      var responseBody = json.decode(response.body);

      FLogger.info("扫呗退款结果:$responseBody");

      //处理应答结果
      saobeiPaymentResult = SaobeiPaymentResult.fromRefundJson(responseBody);

      //支付成功
      if (saobeiPaymentResult != null &&
          saobeiPaymentResult.return_code == "01") {
        // 01成功 02失败 ，03支付中，99该条码暂不支持支付类型自动匹配 01的成功就是支付成功
        var reusltCode = saobeiPaymentResult.result_code;
        if ("01" == reusltCode) {
          result = true;
          isQuery = true;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("02" == reusltCode) {
          result = false;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("03" == reusltCode) {
          result = true;
          isQuery = true;
          message =
              "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
        } else if ("99" == reusltCode) {
          result = false;
          message = "该条码暂不支持支付类型自动匹配<${saobeiPaymentResult.return_code}>";
        } else {
          result = false;
          message = "未知错误<${saobeiPaymentResult.return_code}>";
        }
      } else {
        result = false;
        message =
            "${saobeiPaymentResult.return_msg}<${saobeiPaymentResult.return_code}>";
      }
    } catch (e, stack) {
      result = false;
      message = "退款发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("扫呗退款发生异常:" + e.toString());
    }
    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromSaobeiRefundResult(
          saobeiPaymentResult, tradeNo, payMode);
    }

    return Tuple4(result, message, isQuery, payResult);
  }

  static String sign(String access_token, Map<String, String> parameters,
      List<String> ignoreParameters) {
    var keys = parameters.keys;
    var paramNames = new List<String>();
    paramNames.addAll(keys);
    if (ignoreParameters != null && ignoreParameters.length > 0) {
      for (String ignore in ignoreParameters) {
        paramNames.remove(ignore);
      }
    }

    StringBuffer input = new StringBuffer();
    for (String key in paramNames) {
      input.write(key + "=" + parameters[key] + "&");
    }
    input.write("access_token=" + access_token);
    String sign = Md5Utils.md5(input.toString());

    return sign;
  }
}
