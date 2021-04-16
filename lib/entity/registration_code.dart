import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

class RegistrationCode {
  ///租户ID
  String tenantId;

  ///授权码
  String authCode;

  ///应用Key
  String appKey;

  ///应用密钥
  String appSecret;

  ///门店ID
  String storeId;

  ///门店编号
  String storeNo;

  ///门店名称
  String storeName;

  ///---------------------------------兼容老版本------------------
  ///POSID
  String posId = "";

  ///POS编号
  String posNo = "";

  RegistrationCode();

  factory RegistrationCode.fromJson(Map<String, dynamic> map) {
    return RegistrationCode()
      ..tenantId = map["tenantId"] as String
      ..authCode = map["authCode"] as String
      ..appKey = map["appKey"] as String
      ..appSecret = map["appSecret"] as String
      ..storeId = map["storeId"] as String
      ..storeNo = map["storeNo"] as String
      ..storeName = map["storeName"] as String
      ..posId = Convert.toStr(map["posId"], "")
      ..posNo = Convert.toStr(map["posNo"], "");
  }

  Map<String, dynamic> toJson() {
    var map = {
      "tenantId": this.tenantId,
      "authCode": this.authCode,
      "appKey": this.appKey,
      "appSecret": this.appSecret,
      "storeId": this.storeId,
      "storeNo": this.storeNo,
      "storeName": this.storeName,
      "posId": this.posId,
      "posNo": this.posNo,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
