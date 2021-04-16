import 'dart:collection';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:h3_app/entity/pos_pay_mode.dart';
import 'package:h3_app/entity/pos_payment_parameter.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/payment/scan_pay_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_constant.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_payment_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_query_result.dart';
import 'package:h3_app/payment/xiaobei/xiaobei_refund_result.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/crypto_utils.dart';
import 'package:h3_app/utils/hex_codec.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;
import 'package:string_unescape/string_unescape.dart';

class XiaobeiPayUtils {
  XiaobeiPayUtils._();

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
    XiaobeiPaymentResult xiaobeiPaymentResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String open_id = parameter.containsKey("open_id")
          ? Convert.toStr(parameter["open_id"])
          : "";
      String open_key = parameter.containsKey("open_key")
          ? Convert.toStr(parameter["open_key"])
          : "";
      String url =
          parameter.containsKey("url") ? Convert.toStr(parameter["url"]) : "";
      String shop_pass = parameter.containsKey("shop_pass")
          ? Convert.toStr(parameter["shop_pass"])
          : "";

      //支付方式 微信WECHAT、支付宝ALIPAY
      String payWay = "WeixinJXYL";
      if (payMode.no == "04") {
        payWay = "AlipayJXYL";
      }

      var keyValues = new SplayTreeMap<String, String>();
      //开发者流水号，确认同一门店内唯一，只允许使用数字、字母
      keyValues["out_no"] =
          OrderUtils.instance.generatePayNo(tradeNo, separator: "");
      //付款方式编号
      keyValues["pmt_tag"] = payWay;
      keyValues["ord_name"] = Global.instance.authc.storeName + "-店内消费";
      //条码支付的授权码
      keyValues["auth_code"] = payCode;
      //原始交易金额（以分为单位，没有小数点）
      int totalFee = (amount * 100).toInt();
      keyValues["original_amount"] = "$totalFee";
      //实际交易金额（以分为单位，没有小数点）= 原始交易金额 - 折扣金额 - 抹零金额
      keyValues["trade_amount"] = "$totalFee";

      var jsonString = json.encode(keyValues);

      var param = XiaobeiPayUtils.newParameters(open_id);
      param["data"] = XiaobeiPayUtils.dataEncrypt(jsonString, open_key);
      param["sign"] = XiaobeiPayUtils.sign(param, open_key);
      FLogger.info(
          "订单[${keyValues["out_no"]}]发起江西农商银行支付（$payWay）支付:<${keyValues["trade_amount"]}>分");

      //发送请求
      var requestUrl = sprintf("%s%s", [url, XiaobeiConstant.PAY_ORDER_URL]);
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/x-www-form-urlencoded"},
          body: param,
          encoding: Encoding.getByName("utf-8"));
      var responseBody = json.decode(response.body);

      FLogger.info(
          "订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay结果:$responseBody");

      if (responseBody.containsKey("errcode")) {
        String errcode = Convert.toStr(responseBody["errcode"], "");
        //失败的响应
        String errormsg = "缺失msg标识";
        if (responseBody.containsKey("msg")) {
          var msg = responseBody["msg"];
          //unicode 转码
          errormsg = unescape(msg);
        }

        FLogger.info("订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay结果:$errcode");

        if (errcode == "0") {
          //包含data需要验签
          if (responseBody.containsKey("data")) {
            FLogger.info(
                "订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay结果:$errcode");

            if (XiaobeiPayUtils.verifySign(
                SplayTreeMap.from(responseBody), open_key)) {
              var encrptData = responseBody["data"];
              var decodeData = XiaobeiPayUtils.dataDecode(encrptData, open_key);
              FLogger.info(
                  "订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay结果:$decodeData");
              var data = json.decode(decodeData);
              if (data != null) {
                //处理应答结果
                xiaobeiPaymentResult = XiaobeiPaymentResult.fromPaymentJson(
                    errcode, errormsg, data);

                //1 交易成功，2 待支付，4 已取消，9 等待用户输入密码确认
                var status = xiaobeiPaymentResult.status;
                if (1 == status) {
                  result = true;
                  isQuery = false;
                  message = "$errormsg<$errcode>";
                } else if (2 == status) {
                  result = true;
                  isQuery = true;
                  message = "$errormsg<$errcode>";
                } else if (4 == status) {
                  result = false;
                  isQuery = false;
                  message = "用户取消交易";
                } else if (9 == status) {
                  result = true;
                  isQuery = true;
                  message = "等待用户输入密码确认";
                } else {
                  result = false;
                  isQuery = false;
                  message = "未知错误<$errcode>";
                }
              } else {
                FLogger.info(
                    "订单[${keyValues["out_no"]}]收到江西农商银行支付结果未能转化为有效的json对象");
                result = false;
                isQuery = false;
                message = "应答数据非法";
              }
            } else {
              result = false;
              message = "支付结果验签失败";
              isQuery = false;
              //验签失败
              FLogger.info(
                  "订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay支付结果:验签失败");
            }
          } else {
            result = false;
            message = "缺失data标识";
            isQuery = false;
            //验签失败
            FLogger.info(
                "订单[${keyValues["out_no"]}]收到江西农商银行支付$payWay支付结果:$message");
          }
        } else {
          result = false;
          message = "<$errcode>$errormsg";
          isQuery = false;

          FLogger.info("订单[${keyValues["out_no"]}]支付失败:$message");
        }
      } else {
        result = false;
        message = "请求应答报文非法";
        isQuery = false;
        //验签失败
        FLogger.info(
            "订单[${keyValues["out_no"]}]收到$payWay支付结果:请求应答报文非法,缺失errcode标识");
      }
    } catch (e, stack) {
      result = false;
      message = "支付发生错误";
      isQuery = false;

      FlutterChain.printError(e, stack);
      FLogger.error("小呗支付发生异常:" + e.toString());
    }
    ScanPayResult payResult;
    //支付成功，并且也返回了成功的状态
    if (result) {
      payResult = ScanPayResult.fromXiaobeiPaymentResult(
          xiaobeiPaymentResult, tradeNo, payMode);
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
    XiaobeiQueryResult xiaobeiQueryResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String open_id = parameter.containsKey("open_id")
          ? Convert.toStr(parameter["open_id"])
          : "";
      String open_key = parameter.containsKey("open_key")
          ? Convert.toStr(parameter["open_key"])
          : "";
      String url =
          parameter.containsKey("url") ? Convert.toStr(parameter["url"]) : "";
      String shop_pass = parameter.containsKey("shop_pass")
          ? Convert.toStr(parameter["shop_pass"])
          : "";

      Map<String, String> keyValues = new Map<String, String>();
      keyValues["out_no"] = payNo;

      var jsonString = json.encode(keyValues);

      var param = XiaobeiPayUtils.newParameters(open_id);
      param["data"] = XiaobeiPayUtils.dataEncrypt(jsonString, open_key);
      param["sign"] = XiaobeiPayUtils.sign(param, open_key);
      FLogger.info("订单[${keyValues["out_no"]}]发起支付结果查询");

      //发送请求
      var requestUrl = sprintf("%s%s", [url, XiaobeiConstant.PAY_STATUS]);
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/x-www-form-urlencoded"},
          body: param,
          encoding: Encoding.getByName("utf-8"));
      var responseBody = json.decode(response.body);

      FLogger.info("小呗扫码支付查询结果:$responseBody");

      if (responseBody.containsKey("errcode")) {
        var errcode = Convert.toStr(responseBody["errcode"], "");
        //失败的响应
        String errormsg = "缺失msg标识";
        if (responseBody.containsKey("msg")) {
          String msg = responseBody["msg"];
          //unicode 转码
          errormsg = unescape(msg);
        }

        if (errcode == "0") {
          //包含data需要验签
          if (responseBody.containsKey("data")) {
            if (XiaobeiPayUtils.verifySign(
                SplayTreeMap.from(responseBody), open_key)) {
              var encrptData = responseBody["data"];
              var decodeData = XiaobeiPayUtils.dataDecode(encrptData, open_key);
              FLogger.info(
                  "订单[${keyValues["out_no"]}]收到江西农商银行支付查询结果:$decodeData");
              var data = json.decode(decodeData);
              if (data != null) {
                //处理应答结果
                xiaobeiQueryResult =
                    XiaobeiQueryResult.fromQueryJson(errcode, errormsg, data);

                //1 交易成功，2 待支付，4 已取消，9 等待用户输入密码确认
                var status = xiaobeiQueryResult.status;
                if (1 == status) {
                  result = true;
                  message = "$errormsg<$errcode>";
                } else if (2 == status) {
                  result = false;
                  message = "$errormsg<$errcode>";
                } else if (4 == status) {
                  result = false;
                  message = "用户取消交易";
                } else if (9 == status) {
                  result = false;
                  message = "等待用户输入密码确认";
                } else {
                  result = false;
                  message = "未知错误<$errcode>";
                }
              } else {
                FLogger.info(
                    "订单[${keyValues["out_no"]}]收到江西农商银行支付查询结果未能转化为有效的对象");
                result = false;
                message = "应答数据非法";
              }
            } else {
              result = false;
              message = "支付结果验签失败";
              //验签失败
              FLogger.info("订单[${keyValues["out_no"]}]收到江西农商银行支付查询结果:验签失败");
            }
          } else {
            result = false;
            message = "缺失data标识";
            //验签失败
            FLogger.info("订单[${keyValues["out_no"]}]收到江西农商银行支付查询结果:$message");
          }
        } else {
          result = false;
          message = "<$errcode>$errormsg";

          FLogger.info("订单[${keyValues["out_no"]}]支付失败:$message");
        }
      } else {
        result = false;
        message = "请求应答报文非法";
        //验签失败
        FLogger.info("订单[${keyValues["out_no"]}]收到支付查询结果:请求应答报文非法,缺失errcode标识");
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
      payResult = ScanPayResult.fromXiaoaobeiQueryResult(
          xiaobeiQueryResult, tradeNo, payMode);
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
    XiaobeiRefundResult xiaobeiRefundResult;
    try {
      //获取支付参数
      Map<String, dynamic> parameter = json.decode(payParameter.pbody);
      //支付参数
      String channel = payParameter.sign; //支付通道标识
      String open_id = parameter.containsKey("open_id")
          ? Convert.toStr(parameter["open_id"])
          : "";
      String open_key = parameter.containsKey("open_key")
          ? Convert.toStr(parameter["open_key"])
          : "";
      String url =
          parameter.containsKey("url") ? Convert.toStr(parameter["url"]) : "";
      String shop_pass = parameter.containsKey("shop_pass")
          ? Convert.toStr(parameter["shop_pass"])
          : "123456";

      var keyValues = new SplayTreeMap<String, String>();
      //原始订单的开发者交易流水号
      keyValues["out_no"] = payNo;
      //新退款订单的开发者流水号，同一门店内唯一
      keyValues["refund_out_no"] = tradeNo;
      //原始交易金额（以分为单位，没有小数点）
      int refundFee = (refundAmound * 100).toInt();
      keyValues["refund_amount"] = "$refundFee";
      keyValues["shop_pass"] = Sha1Utils.sha1("$shop_pass").toLowerCase();

      var jsonString = json.encode(keyValues);

      var param = XiaobeiPayUtils.newParameters(open_id);
      param["data"] = XiaobeiPayUtils.dataEncrypt(jsonString, open_key);
      param["sign"] = XiaobeiPayUtils.sign(param, open_key);
      FLogger.info(
          "订单[${keyValues["out_no"]}]发起退款:<${keyValues["refund_amount"]}>分");

      //发送请求
      var requestUrl = sprintf("%s%s", [url, XiaobeiConstant.PAY_REFUND]);
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/x-www-form-urlencoded"},
          body: param,
          encoding: Encoding.getByName("utf-8"));
      var responseBody = json.decode(response.body);

      FLogger.info("订单[${keyValues["out_no"]}]收到退款结果:$responseBody");

      if (responseBody.containsKey("errcode")) {
        String errcode = Convert.toStr(responseBody["errcode"], "");
        //失败的响应
        String errormsg = "缺失msg标识";
        if (responseBody.containsKey("msg")) {
          var msg = responseBody["msg"];
          //unicode 转码
          errormsg = unescape(msg);
        }

        FLogger.info("订单[${keyValues["out_no"]}]收到退款状态:$errcode");

        if (errcode == "0") {
          //包含data需要验签
          if (responseBody.containsKey("data")) {
            if (XiaobeiPayUtils.verifySign(
                SplayTreeMap.from(responseBody), open_key)) {
              var encrptData = responseBody["data"];
              var decodeData = XiaobeiPayUtils.dataDecode(encrptData, open_key);
              FLogger.info("订单[${keyValues["out_no"]}]收到退款结果:$decodeData");
              var data = json.decode(decodeData);
              if (data != null) {
                //处理应答结果
                xiaobeiRefundResult =
                    XiaobeiRefundResult.fromRefundJson(errcode, errormsg, data);

                //状态(1 成功，其它值为不成功)
                var status = xiaobeiRefundResult.status;
                if (1 == status) {
                  result = true;
                  isQuery = false;
                  message = "$errormsg<$errcode>";
                } else {
                  result = false;
                  isQuery = false;
                  message = "$errormsg<$errcode>";
                }
              } else {
                FLogger.info("订单[${keyValues["out_no"]}]收到退款结果未能转化为有效的JSON对象");
                result = false;
                isQuery = false;
                message = "应答数据非法";
              }
            } else {
              result = false;
              message = "支付结果验签失败";
              isQuery = false;
              //验签失败
              FLogger.info("订单[${keyValues["out_no"]}]收到退款结果:验签失败");
            }
          } else {
            result = false;
            message = "缺失data标识";
            isQuery = false;
            //验签失败
            FLogger.info("订单[${keyValues["out_no"]}]收到退款结果:$message");
          }
        } else {
          result = false;
          message = "<$errcode>$errormsg";
          isQuery = false;

          FLogger.info("订单[${keyValues["out_no"]}]支付失败:$message");
        }
      } else {
        result = false;
        message = "请求应答报文非法";
        isQuery = false;
        //验签失败
        FLogger.info("订单[${keyValues["out_no"]}]收到退款结果:请求应答报文非法,缺失errcode标识");
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
      payResult = ScanPayResult.fromXiaobeiRefundResult(
          xiaobeiRefundResult, tradeNo, payMode);
    }

    return Tuple4(result, message, isQuery, payResult);
  }

  /// <summary>
  /// 请求参数初始化
  /// </summary>
  /// <returns></returns>
  static SplayTreeMap<String, dynamic> newParameters(String openId) {
    SplayTreeMap<String, dynamic> parameters = initParameters();

    parameters["open_id"] = openId;

    return parameters;
  }

  /// <summary>
  /// 请求参数初始化
  /// </summary>
  /// <returns></returns>
  static SplayTreeMap<String, dynamic> initParameters() {
    SplayTreeMap<String, dynamic> parameters =
        new SplayTreeMap<String, dynamic>();

    parameters["timestamp"] = getTimestamp4Unix();

    return parameters;
  }

  /// <summary>
  /// 获取Unix当前时间戳
  /// </summary>
  /// <returns></returns>
  static String getTimestamp4Unix() {
    return "${(DateTime.now().toUtc().millisecondsSinceEpoch / 1000).floor()}";
  }

  static String dataEncrypt(String plainText, String key) {
    var aesKey = Key.fromUtf8(key);
    var encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb, padding: 'PKCS7'));
    var encrypted = encrypter.encrypt(plainText);
    return HexEncoder().convert(encrypted.bytes);
  }

  /// <summary>
  /// data解密
  /// </summary>
  /// <param name="data"></param>
  /// <param name="key"></param>
  /// <returns></returns>
  static String dataDecode(String input, String key) {
    var aesKey = Key.fromUtf8(key);
    var encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb, padding: 'PKCS7'));
    List<int> data = HexDecoder().convert(input);
    Encrypted context = Encrypted(data);
    return encrypter.decrypt(context);
  }

  static bool verifySign(SplayTreeMap<String, dynamic> param, String openKey) {
    if (param == null) return false;

    String respSign;
    if (param.containsKey("sign")) {
      respSign = param["sign"];
    } else {
      return false;
    }

    //去除sign 排序
    SplayTreeMap<String, dynamic> sortList =
        new SplayTreeMap<String, dynamic>();
    param.forEach((key, value) {
      if ("sign" != key) {
        sortList[key] = value;
      }
    });
    sortList["open_key"] = openKey;

    print(">>>>>>验签的内容:$sortList");

    var newSign = sign(sortList, openKey);

    print(">>>>>>newSign:$newSign");
    print(">>>>>>respSign:$respSign");

    return respSign == newSign;
  }

  /// <summary>
  /// 签名
  /// </summary>
  /// <param name="parameters"></param>
  /// <param name="openKey"></param>
  /// <returns></returns>
  static String sign(SplayTreeMap<String, dynamic> parameters, String openKey) {
    if (parameters == null) return "";

    var obj = SplayTreeMap.from(parameters);
    //加入openKey
    obj["open_key"] = openKey;

    StringBuffer str = new StringBuffer();
    for (var key in obj.keys) {
      String pKey = "$key";
      String pValue = "${obj[key]}";
      str.write(pKey + "=" + pValue + "&");
    }
    String parameterStr =
        str.toString().substring(0, str.toString().length - 1);
    var sha1Str = Sha1Utils.sha1(parameterStr);
    return Md5Utils.md5(sha1Str).toLowerCase();
  }

  static void testSign() {
    SplayTreeMap<String, String> list = new SplayTreeMap<String, String>();
    list["open_id"] = "87f46f5db1b65f0ac195285f49ee6958";
    list["timestamp"] = "1497957842";
    list["data"] = "3304A5EC2CDEB4D12ED3338B5C01BF6B";

    var result = sign(list, "0828e83720fdbe3685a7b94214af04f9");
    print(result);
  }
}
