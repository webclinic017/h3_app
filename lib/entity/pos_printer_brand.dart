import 'dart:convert';

import 'package:h3_app/utils/converts.dart';

import 'base_entity.dart';

class PrinterBrand extends BaseEntity {
  ///表名称
  static final String tableName = "pos_printer_brand";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnBrandName = "brandName";
  static final String columnDynamic = "dynamic";
  static final String columnType = "type";
  static final String columnPort = "port";
  static final String columnPageWidth = "pageWidth";
  static final String columnCutType = "cutType";
  static final String columnDpi = "dpi";
  static final String columnBaudRate = "baudRate";
  static final String columnDataBit = "dataBit";
  static final String columnInit = "init";
  static final String columnDoubleWidth = "doubleWidth";
  static final String columnCutPage = "cutPage";
  static final String columnDoubleHeight = "doubleHeight";
  static final String columnNormal = "normal";
  static final String columnDoubleWidthHeight = "doubleWidthHeight";
  static final String columnCashbox = "cashbox";
  static final String columnAlignLeft = "alignLeft";
  static final String columnAlignCenter = "alignCenter";
  static final String columnAlignRight = "alignRight";
  static final String columnFeed = "feed";
  static final String columnBeep = "beep";
  static final String columnHeaderLines = "headerLines";
  static final String columnFooterLines = "footerLines";
  static final String columnBackLines = "backLines";
  static final String columnDelay = "delay";
  static final String columnUserDefined = "userDefined";
  static final String columnMemo = "memo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  ///字段名称
  String brandName;
  String dynamicLib;
  int type;
  String port;
  int pageWidth;
  String cutType;
  int dpi;
  int baudRate;
  int dataBit;
  String init;
  String doubleWidth;
  String cutPage;
  String doubleHeight;
  String normal;
  String doubleWidthHeight;
  String cashbox;
  String alignLeft;
  String alignCenter;
  String alignRight;
  String feed;
  String beep;
  int headerLines;
  int footerLines;
  int backLines;
  int delay;
  int userDefined;
  String memo;

  ///默认构造
  PrinterBrand();

  ///Map转实体对象
  factory PrinterBrand.fromMap(Map<String, dynamic> map) {
    return PrinterBrand()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..brandName = Convert.toStr(map[columnBrandName])
      ..dynamicLib = Convert.toStr(map[columnDynamic])
      ..type = Convert.toInt(map[columnType])
      ..port = Convert.toStr(map[columnPort])
      ..pageWidth = Convert.toInt(map[columnPageWidth])
      ..cutType = Convert.toStr(map[columnCutType])
      ..dpi = Convert.toInt(map[columnDpi])
      ..baudRate = Convert.toInt(map[columnBaudRate])
      ..dataBit = Convert.toInt(map[columnDataBit])
      ..init = Convert.toStr(map[columnInit])
      ..doubleWidth = Convert.toStr(map[columnDoubleWidth])
      ..cutPage = Convert.toStr(map[columnCutPage])
      ..doubleHeight = Convert.toStr(map[columnDoubleHeight])
      ..normal = Convert.toStr(map[columnNormal])
      ..doubleWidthHeight = Convert.toStr(map[columnDoubleWidthHeight])
      ..cashbox = Convert.toStr(map[columnCashbox])
      ..alignLeft = Convert.toStr(map[columnAlignLeft])
      ..alignCenter = Convert.toStr(map[columnAlignCenter])
      ..alignRight = Convert.toStr(map[columnAlignRight])
      ..feed = Convert.toStr(map[columnFeed])
      ..beep = Convert.toStr(map[columnBeep])
      ..headerLines = Convert.toInt(map[columnHeaderLines])
      ..footerLines = Convert.toInt(map[columnFooterLines])
      ..backLines = Convert.toInt(map[columnBackLines])
      ..delay = Convert.toInt(map[columnDelay])
      ..userDefined = Convert.toInt(map[columnUserDefined])
      ..memo = Convert.toStr(map[columnMemo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate]);
  }

  ///转List集合
  static List<PrinterBrand> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PrinterBrand>();
    lists.forEach((map) => result.add(PrinterBrand.fromMap(map)));
    return result;
  }

  factory PrinterBrand.clone(PrinterBrand obj) {
    return PrinterBrand()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..brandName = obj.brandName
      ..dynamicLib = obj.dynamicLib
      ..type = obj.type
      ..port = obj.port
      ..pageWidth = obj.pageWidth
      ..cutType = obj.cutType
      ..dpi = obj.dpi
      ..baudRate = obj.baudRate
      ..dataBit = obj.dataBit
      ..init = obj.init
      ..doubleWidth = obj.doubleWidth
      ..cutPage = obj.cutPage
      ..doubleHeight = obj.doubleHeight
      ..normal = obj.normal
      ..doubleWidthHeight = obj.doubleWidthHeight
      ..cashbox = obj.cashbox
      ..alignLeft = obj.alignLeft
      ..alignCenter = obj.alignCenter
      ..alignRight = obj.alignRight
      ..feed = obj.feed
      ..beep = obj.beep
      ..headerLines = obj.headerLines
      ..footerLines = obj.footerLines
      ..backLines = obj.backLines
      ..delay = obj.delay
      ..userDefined = obj.userDefined
      ..memo = obj.memo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnBrandName: this.brandName,
      columnDynamic: this.dynamicLib,
      columnType: this.type,
      columnPort: this.port,
      columnPageWidth: this.pageWidth,
      columnCutType: this.cutType,
      columnDpi: this.dpi,
      columnBaudRate: this.baudRate,
      columnDataBit: this.dataBit,
      columnInit: this.init,
      columnDoubleWidth: this.doubleWidth,
      columnCutPage: this.cutPage,
      columnDoubleHeight: this.doubleHeight,
      columnNormal: this.normal,
      columnDoubleWidthHeight: this.doubleWidthHeight,
      columnCashbox: this.cashbox,
      columnAlignLeft: this.alignLeft,
      columnAlignCenter: this.alignCenter,
      columnAlignRight: this.alignRight,
      columnFeed: this.feed,
      columnBeep: this.beep,
      columnHeaderLines: this.headerLines,
      columnFooterLines: this.footerLines,
      columnBackLines: this.backLines,
      columnDelay: this.delay,
      columnUserDefined: this.userDefined,
      columnMemo: this.memo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
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
