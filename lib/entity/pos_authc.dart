import 'dart:convert';

import 'package:h3_app/blocs/register_bloc.dart';

import 'base_entity.dart';

class Authc extends BaseEntity {
  static final String tableName = "pos_authc";

  static final String columnId = "id";
  static final String columnTenantId = "tenantId";

  static final String columnCompterName = "compterName";
  static final String columnMacAddress = "macAddress";
  static final String columnDiskSerialNumber = "diskSerialNumber";
  static final String columnCpuSerialNumber = "cpuSerialNumber";
  static final String columnStoreId = "storeId";
  static final String columnStoreNo = "storeNo";
  static final String columnStoreName = "storeName";
  static final String columnPosNo = "posNo";
  static final String columnPosId = "posId";

  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext3";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";
  static final String columnActiveCode = "activeCode";

  ///计算机名称
  String compterName;

  ///Mac地址
  String macAddress;

  ///硬盘序列号
  String diskSerialNumber;

  ///CPU序列号
  String cpuSerialNumber;

  ///认证的门店ID
  String storeId;

  ///认证的门店编号
  String storeNo;

  ///认证的门店名称
  String storeName;

  ///认证的POS编号
  String posNo;

  ///认证的POS的ID
  String posId;

  //认证信息
  ActiveCodeEntity activeCode;

  Authc();

  Authc.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId] as String;
    this.tenantId = map[columnTenantId] as String;

    this.compterName = map[columnCompterName] as String;
    this.macAddress = map[columnMacAddress] as String;
    this.diskSerialNumber = map[columnDiskSerialNumber] as String;
    this.cpuSerialNumber = map[columnCpuSerialNumber] as String;
    this.storeId = map[columnStoreId] as String;
    this.storeNo = map[columnStoreNo] as String;
    this.storeName = map[columnStoreName] as String;
    this.posNo = map[columnPosNo] as String;
    this.posId = map[columnPosId] as String;
    this.ext1 = map[columnExt1] as String;
    this.ext2 = map[columnExt2] as String;
    this.ext3 = map[columnExt3] as String;
    this.createUser = map[columnCreateUser] as String;
    this.createDate = map[columnCreateDate] as String;
    this.modifyUser = map[columnModifyUser] as String;
    this.modifyDate = map[columnModifyDate] as String;

    this.activeCode = map[columnActiveCode] != null
        ? ActiveCodeEntity.fromJson(json.decode(map[columnActiveCode]))
        : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnCompterName: this.compterName,
      columnMacAddress: this.macAddress,
      columnDiskSerialNumber: this.diskSerialNumber,
      columnCpuSerialNumber: this.cpuSerialNumber,
      columnStoreId: this.storeId,
      columnStoreNo: this.storeNo,
      columnStoreName: this.storeName,
      columnPosNo: this.posNo,
      columnPosId: this.posId,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateUser: this.createUser,
      columnCreateDate: this.createDate,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnActiveCode: this.activeCode.toString(),
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
