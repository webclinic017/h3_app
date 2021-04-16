import 'base_entity.dart';

class Urls extends BaseEntity {
  static final String tableName = "pos_urls";

  static final String columnId = "id";
  static final String columnTenantId = "tenantId";

  static final String columnApiType = "apiType";
  static final String columnProtocol = "protocol";
  static final String columnUrl = "url";
  static final String columnContextPath = "contextPath";
  static final String columnUserDefined = "userDefined";
  static final String columnEnable = "enable";
  static final String columnMemo = "memo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext3";
  static final String columnExt3 = "ext3";

  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  Urls();

  ///接口类型
  String apiType;

  ///Http或者Https
  String protocol;

  ///服务器地址，包含端口
  String url;

  ///ContextPath
  String contextPath;

  ///用户自定义
  int userDefined;

  ///是否启用
  int enable;

  ///服务器备注说明
  String memo;

  factory Urls.fromMap(Map<String, dynamic> map) {
    return Urls()
      ..id = map[columnId] as String
      ..tenantId = map[columnTenantId] as String
      ..ext1 = map[columnExt1] as String
      ..ext2 = map[columnExt2] as String
      ..ext3 = map[columnExt3] as String
      ..createUser = map[columnCreateUser] as String
      ..createDate = map[columnCreateDate] as String
      ..modifyUser = map[columnModifyUser] as String
      ..modifyDate = map[columnModifyDate] as String
      ..apiType = map[columnApiType] as String
      ..protocol = map[columnProtocol] as String
      ..url = map[columnUrl] as String
      ..contextPath = map[columnContextPath] as String
      ..userDefined = map[columnUserDefined] as int
      ..enable = map[columnEnable] as int
      ..memo = map[columnMemo] as String;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnApiType: this.apiType,
      columnProtocol: this.protocol,
      columnUrl: this.url,
      columnContextPath: this.contextPath,
      columnUserDefined: this.userDefined,
      columnEnable: this.enable,
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
}

//class UrlsBuilder {
//
//  UrlsBuilder();
//
//  Urls build() {
//    return new Urls();
//  }
//}
