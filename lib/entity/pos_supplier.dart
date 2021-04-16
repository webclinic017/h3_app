import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class Supplier extends BaseEntity {
  ///表名称
  static final String tableName = "pos_supplier";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnNo = "no";
  static final String columnName = "name";
  static final String columnRem = "rem";
  static final String columnPurchaseCycle = "purchaseCycle";
  static final String columnManagerType = "managerType";
  static final String columnDealOrganize = "dealOrganize";
  static final String columnDefaultPrice = "defaultPrice";
  static final String columnDealType = "dealType";
  static final String columnDealCycle = "dealCycle";
  static final String columnDealDate = "dealDate";
  static final String columnCostRate = "costRate";
  static final String columnMinAmount = "minAmount";
  static final String columnContacts = "contacts";
  static final String columnTel = "tel";
  static final String columnAddress = "address";
  static final String columnFax = "fax";
  static final String columnPostcode = "postcode";
  static final String columnEmail = "email";
  static final String columnBankName = "bankName";
  static final String columnBankCardNo = "bankCardNo";
  static final String columnTaxId = "taxId";
  static final String columnCompanyType = "companyType";
  static final String columnFrozenMoney = "frozenMoney";
  static final String columnFrozenBusiness = "frozenBusiness";
  static final String columnBusStorageType = "busStorageType";
  static final String columnBusinessPic = "businessPic";
  static final String columnLicStorageType = "licStorageType";
  static final String columnLicensePic = "licensePic";
  static final String columnPrePayAmount = "prePayAmount";
  static final String columnOrderNo = "orderNo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateUser = "createUser";
  static final String columnCreateDate = "createDate";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String no;
  String name;
  String rem;
  int purchaseCycle;
  String managerType;
  String dealOrganize;
  int defaultPrice;
  int dealType;
  int dealCycle;
  int dealDate;
  double costRate;
  double minAmount;
  String contacts;
  String tel;
  String address;
  String fax;
  String postcode;
  String email;
  String bankName;
  String bankCardNo;
  String taxId;
  int companyType;
  int frozenMoney;
  int frozenBusiness;
  int busStorageType;
  String businessPic;
  int licStorageType;
  String licensePic;
  double prePayAmount;
  int orderNo;

  ///默认构造
  Supplier();

  ///Map转实体对象
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..no = Convert.toStr(map[columnNo])
      ..name = Convert.toStr(map[columnName])
      ..rem = Convert.toStr(map[columnRem])
      ..purchaseCycle = Convert.toInt(map[columnPurchaseCycle])
      ..managerType = Convert.toStr(map[columnManagerType])
      ..dealOrganize = Convert.toStr(map[columnDealOrganize])
      ..defaultPrice = Convert.toInt(map[columnDefaultPrice])
      ..dealType = Convert.toInt(map[columnDealType])
      ..dealCycle = Convert.toInt(map[columnDealCycle])
      ..dealDate = Convert.toInt(map[columnDealDate])
      ..costRate = Convert.toDouble(map[columnCostRate])
      ..minAmount = Convert.toDouble(map[columnMinAmount])
      ..contacts = Convert.toStr(map[columnContacts])
      ..tel = Convert.toStr(map[columnTel])
      ..address = Convert.toStr(map[columnAddress])
      ..fax = Convert.toStr(map[columnFax])
      ..postcode = Convert.toStr(map[columnPostcode])
      ..email = Convert.toStr(map[columnEmail])
      ..bankName = Convert.toStr(map[columnBankName])
      ..bankCardNo = Convert.toStr(map[columnBankCardNo])
      ..taxId = Convert.toStr(map[columnTaxId])
      ..companyType = Convert.toInt(map[columnCompanyType])
      ..frozenMoney = Convert.toInt(map[columnFrozenMoney])
      ..frozenBusiness = Convert.toInt(map[columnFrozenBusiness])
      ..busStorageType = Convert.toInt(map[columnBusStorageType])
      ..businessPic = Convert.toStr(map[columnBusinessPic])
      ..licStorageType = Convert.toInt(map[columnLicStorageType])
      ..licensePic = Convert.toStr(map[columnLicensePic])
      ..prePayAmount = Convert.toDouble(map[columnPrePayAmount])
      ..orderNo = Convert.toInt(map[columnOrderNo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///转List集合
  static List<Supplier> toList(List<Map<String, dynamic>> lists) {
    var result = new List<Supplier>();
    lists.forEach((map) => result.add(Supplier.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnNo: this.no,
      columnName: this.name,
      columnRem: this.rem,
      columnPurchaseCycle: this.purchaseCycle,
      columnManagerType: this.managerType,
      columnDealOrganize: this.dealOrganize,
      columnDefaultPrice: this.defaultPrice,
      columnDealType: this.dealType,
      columnDealCycle: this.dealCycle,
      columnDealDate: this.dealDate,
      columnCostRate: this.costRate,
      columnMinAmount: this.minAmount,
      columnContacts: this.contacts,
      columnTel: this.tel,
      columnAddress: this.address,
      columnFax: this.fax,
      columnPostcode: this.postcode,
      columnEmail: this.email,
      columnBankName: this.bankName,
      columnBankCardNo: this.bankCardNo,
      columnTaxId: this.taxId,
      columnCompanyType: this.companyType,
      columnFrozenMoney: this.frozenMoney,
      columnFrozenBusiness: this.frozenBusiness,
      columnBusStorageType: this.busStorageType,
      columnBusinessPic: this.businessPic,
      columnLicStorageType: this.licStorageType,
      columnLicensePic: this.licensePic,
      columnPrePayAmount: this.prePayAmount,
      columnOrderNo: this.orderNo,
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
