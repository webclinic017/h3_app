import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/open_response.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/string_utils.dart';

import 'api_utils.dart';
import 'device_utils.dart';

class HttpUtils {
  ///服务器链接超时，毫秒
  static const int connect_timeout = 10000;

  ///响应流上前后两次接受到数据的间隔，毫秒
  static const int receive_timeout = 3000;

  // 工厂模式
  factory HttpUtils() => _getInstance();
  static HttpUtils get instance => _getInstance();
  static HttpUtils _instance;

  static HttpUtils _getInstance() {
    if (_instance == null) {
      _instance = new HttpUtils._internal();
    }
    return _instance;
  }

  Map<ApiType, Dio> _clients;

  HttpUtils._internal() {
    FLogger.debug("初始化HttpUtils对象");

    _clients = new Map<ApiType, Dio>();
  }

  Future<void> startup() async {
    await _init();
  }

  Future _init() async {}

  Dio _getDio(OpenApi api) {
    if (!_clients.containsKey(api.apiType)) {
      BaseOptions options = new BaseOptions(
        connectTimeout: connect_timeout,
        receiveTimeout: receive_timeout,
        headers: {
          HttpHeaders.userAgentHeader:
              "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36",
          HttpHeaders.acceptHeader: "*/*",
          HttpHeaders.acceptEncodingHeader: "gzip, deflate",
          HttpHeaders.acceptLanguageHeader: "zh-cn,en-us;q=0.7,en;q=0.3",
          HttpHeaders.pragmaHeader: "no-cache",
          HttpHeaders.cacheControlHeader: "no-cache",
          "ES-API-VERSION": "1.0.0",
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) {
          //不使用http状态码判断状态，使用AdapterInterceptor来处理
          return true;
        },
      );
      var _dio = new Dio(options);

      var adapter = _dio.httpClientAdapter as DefaultHttpClientAdapter;
      adapter.onHttpClientCreate = (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };

      _dio.interceptors.add(new LoggingInterceptor());
      _dio.interceptors.add(new AdapterInterceptor());
      _clients[api.apiType] = _dio;
    }
    return _clients[api.apiType];
  }

  Future<OpenResponse> post(OpenApi api, String url,
      {Map<String, dynamic> params, Options options}) async {
    final watch = Stopwatch()..start();
    try {
      var client = this._getDio(api);
      Response response =
          await client.post(url, data: params, options: options);
      return response.data;
    } catch (e) {
      return HttpExceptionHandle.handleException(e);
    } finally {
      String methodName = "Unknow";
      if (params.containsKey("name")) {
        methodName = params["name"];
      }
      FLogger.info("调用方法[$methodName]耗时<${watch.elapsedMilliseconds}>");
    }
  }

  Future<void> posMonitor(
      {String terminalType = Constants.TERMINAL_TYPE}) async {
    if (!Global.instance.online || Global.instance.authc == null) return;

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "pos.info.monitor";

      String appVersion = await DeviceUtils.instance.getAppVersion();

      var storeInfo = await Global.instance.getStoreInfo();
      var storeName =
          storeInfo != null ? storeInfo.name : Global.instance.authc.storeName;

      var computerName = await DeviceUtils.instance.getMode();
      var macAddress = Constants.VIRTUAL_MAC_ADDRESS;
      var serialNumber = await DeviceUtils.instance.getSerialId();
      var systemVersion = await DeviceUtils.instance.getSystemVersion();
      var cpuNumber = StringUtils.reverse(serialNumber).toUpperCase();

      var data = {
        "storeId": Global.instance.authc.storeId,
        "storeNo": Global.instance.authc.storeNo,
        "appSign": Constants.APP_SIGN,
        "terminalType": terminalType,
        "posNo": Global.instance.authc.posNo,
        "os": "$computerName $systemVersion",
        "osType": "64",
        "softwareVersion": "$appVersion",
        "memoryTotalSize": DeviceUtils.instance.getTotalPhysicalMemory(),
        "memoryFreeSize": DeviceUtils.instance.getFreePhysicalMemory(),
        "diskName": "",
        "diskTotalSize": "0",
        "diskFreeSize": "0",
        "cpuSize": DeviceUtils.instance.getProcessors(),
        "storeName": "$storeName",
        "aliasName": Global.instance.authc.posNo,
        "cpuNumber": "$cpuNumber",
        "name": "$computerName",
        "MACAddress": "$macAddress",
        "serialNumber": "$serialNumber",
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;
      var resp =
          await HttpUtils.instance.post(api, api.url, params: parameters);
      FLogger.info("监控上报结果:$resp");
    } catch (e) {
      FLogger.error("连接运维平台发生异常:$e");
    }
  }
}

class HttpExceptionHandle {
  static const int unknown_error = 9999;
  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;

  static OpenResponse handleException(dynamic error) {
    if (error is DioError) {
      if (error.type == DioErrorType.DEFAULT ||
          error.type == DioErrorType.RESPONSE) {
        dynamic e = error.error;
        if (e is SocketException) {
          return OpenResponse(socket_error, "网络异常，请检查你的网络", null);
        }
        if (e is HttpException) {
          return OpenResponse(http_error, "服务器异常", null);
        }
        return OpenResponse(net_error, "网络异常，请检查你的网络", null);
      } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.SEND_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        return OpenResponse(unknown_error, "连接超时", null);
      } else if (error.type == DioErrorType.CANCEL) {
        return OpenResponse(cancel_error, "", null);
      } else {
        return OpenResponse(unknown_error, "未知异常", null);
      }
    } else {
      return OpenResponse(unknown_error, "未知异常", null);
    }
  }
}

class LoggingInterceptor extends InterceptorsWrapper {
  ///请求的开始时间
  DateTime _startTime;

  ///请求的结束时间
  DateTime _endTime;

  @override
  Future onRequest(RequestOptions options) async {
    _startTime = DateTime.now();
    //FLogger.debug("请求Url：${options.path}");
    //FLogger.trace("请求Header: " + options.headers.toString());
    if (options.data != null) {
      //FLogger.debug("请求参数: " + options.data.toString());
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    //FLogger.debug("请求耗时：$duration");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    FLogger.error('请求异常: ' + err.toString());
    FLogger.error('异常信息: ' + err.response?.toString() ?? "");

    return super.onError(err);
  }
}

class AdapterInterceptor extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) async {
    int status = response.statusCode;

    ///只需要处理200的情况，300、400、500保留错误信息
    if (200 == status || 201 == status) {
      Map<String, dynamic> map = response.data;

      int _code = int.tryParse(map["code"]);
      String _msg = map.containsKey("msg") ? map["msg"] : "";
      if (_code == 0) {
        if (!map.containsKey("data")) return OpenResponse(_code, _msg, null);

        var _data = map["data"];
        if (_data is Map) {
          return OpenResponse(_code, _msg, Map<String, dynamic>.from(_data));
        } else if (_data is List) {
          return OpenResponse(
              _code, _msg, List<Map<String, dynamic>>.from(_data));
        } else if (_data is String) {
          return OpenResponse(_code, _msg, _data.toString());
        } else {
          return OpenResponse(_code, _msg, _data);
        }
      } else {
        return OpenResponse(_code, _msg, null);
      }
    } else {
      FLogger.warn("Http响应状态码:$status,详细信息:${response.toString()}");

      String _msg = "Oops!!";
      switch (status) {
        case 401:
          _msg = "account or password error ";
          break;
        case 403:
          _msg = "forbidden ";
          break;
        case 404:
          _msg = "account or password error";
          break;
        case 500:
          _msg = "Server internal error";
          break;
        case 503:
          _msg = "Server Updating";
          break;
      }

      return OpenResponse(status, _msg, null);
    }
  }
}
