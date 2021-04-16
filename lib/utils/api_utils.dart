import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/pos_apis.dart';
import 'package:h3_app/entity/pos_urls.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:flutter/foundation.dart';

import 'crypto_utils.dart';
import 'date_utils.dart';
import 'enum_utils.dart';
import 'http_utils.dart';

class OpenApiUtils {
  // 工厂模式
  factory OpenApiUtils() => _getInstance();
  static OpenApiUtils get instance => _getInstance();
  static OpenApiUtils _instance;

  static OpenApiUtils _getInstance() {
    if (_instance == null) {
      _instance = new OpenApiUtils._internal();
    }
    return _instance;
  }

  Map<String, Apis> _apis;
  Map<String, List<OpenApi>> _urls;

  OpenApiUtils._internal() {
    FLogger.debug("初始化OpenApiUtils对象");

    _apis = new Map<String, Apis>();
    _urls = new Map<String, List<OpenApi>>();

    init();
  }

  Future init() async {
    ///打开数据库
    var database = await SqlUtils.instance.open();

    ///获取系统登记的全部可用访问地址
    var urlMaps = await database.rawQuery(
        "select id,tenantId,apiType,protocol,url,contextPath,userDefined,enable,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_urls;");
    List<Urls> urls = new List<Urls>();
    urlMaps.forEach((map) {
      var obj = Urls.fromMap(map);
      urls.add(obj);
    });

    ///数据表中获取Map对象
    var apiMaps = await database.rawQuery(
        "select id,tenantId,apiType,appKey,appSecret,locale,format,client,version,routing,memo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate from pos_apis;");
    apiMaps.forEach((map) {
      ///获取对象
      var api = Apis.fromMap(map);

      ///
      this._apis[api.apiType] = api;

      ///查找ApiType匹配的访问地址列表
      var servers = urls
          .where((obj) => Comparable.compare(obj.apiType, api.apiType) == 0)
          .toList();
      var list = new List<OpenApi>();
      servers.forEach((url) {
        var openApi = new OpenApi();

        openApi.url = "${url.protocol}://${url.url}/${url.contextPath}";
        openApi.open = "${url.protocol}://${url.url}/${url.contextPath}/extend";

        openApi.apiType = EnumUtils.fromString(ApiType.values, api.apiType);

        openApi.appKey = api.appKey;
        openApi.appSecret = api.appSecret;
        openApi.client = api.client;
        openApi.locale = api.locale;
        openApi.format = api.format;
        openApi.version = api.version;
        openApi.memo = api.memo;

        list.add(openApi);
      });
      this._urls[api.apiType] = list;
    });
  }

  Future<bool> isAvailable() async {
    bool connected = false;
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "ruok";
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;
      var resp =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      connected = resp.success;
    } catch (e) {
      FLogger.error("连接开放平台发生异常:" + e.toString());

      connected = false;
    }

    return connected;
  }

  OpenApi getOpenApi(ApiType api) {
    try {
      var key = EnumUtils.parse(api);
      return this._urls[key][0];
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      throw e;
    }
  }

  Map<String, String> newParameters({OpenApi api}) {
    try {
      Map<String, String> parameters = new Map<String, String>();

      parameters["timestamp"] =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

      if (api != null) {
        parameters["app_key"] = api.appKey;
        parameters["format"] = api.format;

        parameters["version"] = api.version;
        parameters["client"] = api.client;
      }

      return parameters;
    } catch (e) {
      throw e;
    }
  }

  String sign(OpenApi api, Map<String, String> parameters,
      List<String> ignoreParameters) {
    try {
      if (api == null || parameters == null) return "";
      List<String> keys = parameters.keys.toList();
      keys.sort();
      var paramNames = new List<String>();
      paramNames.addAll(keys);
      if (ignoreParameters != null && ignoreParameters.length > 0) {
        for (String ignore in ignoreParameters) {
          paramNames.remove(ignore);
        }
      }
      StringBuffer input = new StringBuffer();
      input.write(api.appSecret);
      for (String key in paramNames) {
        input.write(key + parameters[key]);
      }
      input.write(api.appSecret);
      return Md5Utils.md5(input.toString()).toUpperCase();
    } catch (e) {
      throw e;
    }
  }
}
