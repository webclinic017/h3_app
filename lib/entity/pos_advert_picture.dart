import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class AdvertPicture extends BaseEntity {
  ///表名称
  static final String tableName = "pos_advert_picture";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnOrderNo = "orderNo";
  static final String columnWidth = "width";
  static final String columnHeight = "height";
  static final String columnName = "name";
  static final String columnStorageType = "storageType";
  static final String columnStorageAddress = "storageAddress";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  int orderNo;
  int width;
  int height;
  String name;
  String storageType;
  String storageAddress;

  ///默认构造
  AdvertPicture();

  ///Map转实体对象
  factory AdvertPicture.fromMap(Map<String, dynamic> map) {
    return AdvertPicture()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..width = Convert.toInt(map[columnWidth])
      ..height = Convert.toInt(map[columnHeight])
      ..name = Convert.toStr(map[columnName])
      ..storageType = Convert.toStr(map[columnStorageType])
      ..storageAddress = Convert.toStr(map[columnStorageAddress])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///转List集合
  static List<AdvertPicture> toList(List<Map<String, dynamic>> lists) {
    var result = new List<AdvertPicture>();
    lists.forEach((map) => result.add(AdvertPicture.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnOrderNo: this.orderNo,
      columnWidth: this.width,
      columnHeight: this.height,
      columnName: this.name,
      columnStorageType: this.storageType,
      columnStorageAddress: this.storageAddress,
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

  @override
  String toString() {
    return json.encode(this.toMap());
  }
}
