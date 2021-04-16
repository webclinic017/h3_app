import 'dart:convert';
import 'dart:io';

import 'package:h3_app/constants.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'order_item.dart';
import 'order_object.dart';
import 'order_table.dart';

class AssistantUtils {
  // 工厂模式
  factory AssistantUtils() => _getInstance();

  static AssistantUtils get instance => _getInstance();
  static AssistantUtils _instance;

  static AssistantUtils _getInstance() {
    if (_instance == null) {
      _instance = new AssistantUtils._internal();
    }
    return _instance;
  }

  AssistantUtils._internal();

  String get baseUrl {
    return "http://${Global.instance.globalConfigStringValue(ConfigConstant.ASSISTANT_PARAMETER)}:9966/api/v1/pos";
  }

  ///预结单
  Future<Tuple2<bool, String>> printPrePay(Map<String, dynamic> map) async {
    bool result = false;
    String message = "";
    try {
      var jsonRequest = json.encode(map);

      String requestUrl = "$baseUrl/printPrePay";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
      } else {
        result = false;
        message = errorMessage;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("预结单操作异常:" + e.toString());

      result = false;
      message = "预结单操作出错了";
    }
    return Tuple2(result, message);
  }

  ///赠菜
  Future<Tuple3<bool, String, OrderObject>> giftItem(
      Map<String, dynamic> map) async {
    bool result = false;
    String message = "";
    OrderObject data;
    try {
      var jsonRequest = json.encode(map);

      String requestUrl = "$baseUrl/giftItem";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
        data = OrderObject.fromMap(responseBody['data']);
      } else {
        result = false;
        message = errorMessage;
        data = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("赠送操作异常:" + e.toString());

      result = false;
      message = "赠送操作出错了";
      data = null;
    }
    return Tuple3(result, message, data);
  }

  ///退菜
  Future<Tuple3<bool, String, OrderObject>> returnItem(
      Map<String, dynamic> map) async {
    bool result = false;
    String message = "";
    OrderObject data;
    try {
      var jsonRequest = json.encode(map);

      String requestUrl = "$baseUrl/returnItem";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
        data = OrderObject.fromMap(responseBody['data']);
      } else {
        result = false;
        message = errorMessage;
        data = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("退菜操作异常:" + e.toString());

      result = false;
      message = "退菜操作出错了";
      data = null;
    }
    return Tuple3(result, message, data);
  }

  ///点菜宝清台
  Future<Tuple2<bool, String>> checkout(OrderObject orderObject) async {
    bool result = false;
    String message = "";
    try {
      var jsonRequest = json.encode(orderObject);

      String requestUrl = "$baseUrl/checkout";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
      } else {
        result = false;
        message = errorMessage;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取桌台订单异常:" + e.toString());

      result = false;
      message = "获取桌台订单出错了";
    }
    return Tuple2(result, message);
  }

  ///点菜宝清台
  Future<Tuple2<bool, String>> tryOrder(List<OrderItem> items) async {
    bool result = false;
    String message = "";
    try {
      var jsonRequest = json.encode(items);

      String requestUrl = "$baseUrl/tryOrder";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
      } else {
        result = false;
        message = errorMessage;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取桌台订单异常:" + e.toString());

      result = false;
      message = "获取桌台订单出错了";
    }
    return Tuple2(result, message);
  }

  ///点菜宝清台
  Future<Tuple2<bool, String>> clearTable(List<String> orderIds) async {
    bool result = false;
    String message = "";
    try {
      var jsonRequest = json.encode(orderIds);

      String requestUrl = "$baseUrl/clearTable";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
      } else {
        result = false;
        message = errorMessage;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取桌台订单异常:" + e.toString());

      result = false;
      message = "获取桌台订单出错了";
    }
    return Tuple2(result, message);
  }

  ///点菜宝开台
  Future<Tuple3<bool, String, OrderObject>> openTable(
      Map<String, dynamic> map) async {
    bool result = false;
    String message = "";
    OrderObject data;
    try {
      var jsonRequest = json.encode(map);

      String requestUrl = "$baseUrl/openTable";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
        data = OrderObject.fromMap(responseBody['data']);
      } else {
        result = false;
        message = errorMessage;
        data = null;
      }
    } on SocketException catch (e) {
      debugPrint(e.toString());
      result = false;
      message = "无法连接到收银台,操作无效";
      data = null;
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("点菜宝开台异常:" + e.toString());

      result = false;
      message = "开台出错了,无法连接到收银台";
      data = null;
    }
    return Tuple3(result, message, data);
  }

  ///获取桌台订单信息
  Future<Tuple3<bool, String, OrderObject>> getOrderObject(
      String orderId) async {
    bool result = false;
    String message = "";
    OrderObject data;
    try {
      Map<String, dynamic> reqDic = new Map<String, dynamic>();
      //参数
      reqDic["orderId"] = orderId;
      var jsonRequest = json.encode(reqDic);

      String requestUrl = "$baseUrl/getOrder";
      //发送请求
      var response = await http.post(requestUrl,
          headers: {"content-type": "application/json"},
          body: jsonRequest,
          encoding: Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
        data = OrderObject.fromMap(responseBody['data']);
      } else {
        result = false;
        message = errorMessage;
        data = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取桌台订单异常:" + e.toString());

      result = false;
      message = "获取桌台订单出错了";
      data = null;
    }
    return Tuple3(result, message, data);
  }

  ///获取收银台状态信息
  Future<Tuple3<bool, String, List<OrderTable>>> getTables() async {
    bool result = false;
    String message = "";
    List<OrderTable> data = <OrderTable>[];
    try {
      Map<String, dynamic> reqDic = new Map<String, dynamic>();
      //参数
      reqDic["tableStatus"] = "1";
      var jsonRequest = json.encode(reqDic);

      String requestUrl = "$baseUrl/getTables";
      //发送请求
      var response = await http.post(requestUrl,
          /*headers: {"content-type": "application/json"}, body: jsonRequest,*/ encoding:
              Encoding.getByName("utf-8"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;

        List<Map<String, dynamic>> lists = List.from(responseBody['data']);

        FLogger.info("获取到桌台数量:${lists.length}");

        for (var obj in lists) {
          if (obj.containsKey("open") && obj["open"] != null) {
            OrderTable orderTable = OrderTable.fromMap(obj["open"]);
            data.add(orderTable);

            // FLogger.debug("桌台[${orderTable.tableName}]信息:$orderTable");
          }
        }
        FLogger.info("已开台的桌台数量:${data.length}");
      } else {
        result = false;
        message = errorMessage;
        data = null;
      }
    } on ClientException catch (error) {
      debugPrint(error.toString());
      result = false;
      message = "无法连接到收银台";
      data = null;
    } catch (error) {
      debugPrint('$error');
      FLogger.error("获取收银台桌台发生异常:" + error.toString());

      result = false;
      message = "获取收银台的桌台出错了";
      data = null;
    }
    return Tuple3(result, message, data);
  }

  ///点菜宝清台
  Future<Tuple2<bool, String>> sayHello() async {
    bool result = false;
    String message = "";
    try {
      String requestUrl = "$baseUrl/sayHello";
      //发送请求
      var response = await http.post(requestUrl);
      Map<String, dynamic> responseBody = json.decode(response.body);
      String errorCode =
          (responseBody != null && responseBody.containsKey("code")
              ? Convert.toStr(responseBody["code"])
              : "");
      String errorMessage =
          (responseBody != null && responseBody.containsKey("msg")
              ? Convert.toStr(responseBody["msg"])
              : "缺失[msg]参数");

      if (StringUtils.isNotBlank(errorCode) && errorCode == "0") {
        result = true;
        message = errorMessage;
      } else {
        result = false;
        message = errorMessage;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("检测收银台连接异常:" + e.toString());

      result = false;
      message = "检测收银台连接出错了";
    }
    return Tuple2(result, message);
  }
}
