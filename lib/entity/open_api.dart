import 'dart:convert';

import 'package:h3_app/utils/enum_utils.dart';

///API接口类型
enum ApiType {
  None,
  Business,
  Card,
  WaiMai,
  Transport,
  Meal,
}

class OpenApi {
  ///租户ID
  String tenantId;

  ///接口类型
  ApiType apiType;

  ///应用标识
  String appKey;

  ///应用密钥
  String appSecret;

  ///服务器地址，包含端口,依赖appKey参数的访问地址
  String url;

  ///服务器地址，包含端口,不依赖appKey参数的访问地址
  String open;

  ///本地化类型，默认zh_CN
  String locale;

  ///报文的格式，支持XML和JSON，默认JSON
  String format;

  ///客户端类型(apple,iPad,iPhone,Android,desktop,WP,web)
  String client;

  ///服务端版本号
  String version;

  ///负载均衡策略
  String routing;

  ///备注说明
  String memo;

  OpenApi();

  factory OpenApi.fromMap(Map<String, dynamic> map) {
    return OpenApi()
      ..tenantId = map['tenantId'] as String
      ..apiType = EnumUtils.fromString(ApiType.values, map['apiType'] as String)
      ..appKey = map['appKey'] as String
      ..appSecret = map['appSecret'] as String
      ..url = map['url'] as String
      ..open = map['open'] as String
      ..locale = map['locale'] as String
      ..format = map['format'] as String
      ..client = map['client'] as String
      ..version = map['version'] as String
      ..routing = map['routing'] as String
      ..memo = map['memo'] as String;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'tenantId': this.tenantId,
      'apiType': EnumUtils.parse(this.apiType),
      'appKey': this.appKey,
      'appSecret': this.appSecret,
      'url': this.url,
      'open': this.open,
      'locale': this.locale,
      'format': this.format,
      'version': this.version,
      'client': this.client,
      'routing': this.routing,
      'memo': this.memo,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
