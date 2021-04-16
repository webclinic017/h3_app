import 'package:equatable/equatable.dart';

import 'base_entity.dart';

class Apis extends BaseEntity with EquatableMixin {
  static final String tableName = "pos_apis";

  static final String columnId = "id";
  static final String columnTenantId = "tenantId";

  static final String columnApiType = "apiType";
  static final String columnAppKey = "appKey";
  static final String columnAppSecret = "appSecret";
  static final String columnLocale = "locale";
  static final String columnFormat = "format";
  static final String columnClient = "client";
  static final String columnVersion = "version";
  static final String columnRouting = "routing";
  static final String columnMemo = "memo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext3";
  static final String columnExt3 = "ext3";

  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  Apis();

  ///接口类型
  String apiType;

  ///应用标识
  String appKey;

  ///应用密钥
  String appSecret;

  ///本地化类型，默认zh_CN
  String locale = "zh_CN";

  ///报文的格式，支持XML和JSON，默认JSON
  String format = "json";

  ///客户端类型(apple,iPad,iPhone,Android,desktop,WP,web)
  String client;

  ///服务端版本号
  String version;

  ///负载均衡策略
  int routing;

  ///备注说明
  String memo;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnApiType: this.apiType,
      columnAppKey: this.appKey,
      columnAppSecret: this.appSecret,
      columnLocale: this.locale,
      columnFormat: this.format,
      columnVersion: this.version,
      columnClient: this.client,
      columnRouting: this.routing,
      columnMemo: this.memo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
    };
    return map;
  }

  factory Apis.fromMap(Map<String, dynamic> map) {
    return Apis()
      ..id = map[columnId] as String
      ..tenantId = map[columnTenantId] as String
      ..apiType = map[columnApiType] as String
      ..appKey = map[columnAppKey] as String
      ..appSecret = map[columnAppSecret] as String
      ..locale = map[columnLocale] as String
      ..format = map[columnFormat] as String
      ..version = map[columnVersion] as String
      ..client = map[columnClient] as String
      ..routing = map[columnRouting] as int
      ..memo = map[columnMemo] as String
      ..ext1 = map[columnExt1] as String
      ..ext2 = map[columnExt2] as String
      ..ext3 = map[columnExt3] as String
      ..createUser = map[columnCreateUser] as String
      ..createDate = map[columnCreateDate] as String
      ..modifyUser = map[columnModifyUser] as String
      ..modifyDate = map[columnModifyDate] as String;
  }

  @override
  List<Object> get props {
    return [appKey, appSecret];
  }
}
