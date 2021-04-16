import 'dart:convert';

import 'package:h3_app/constants.dart';
import 'package:h3_app/printer/plugins/printer_constant.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';

import 'base_entity.dart';

class PrinterItem extends BaseEntity {
  ///表名称
  static final String tableName = "pos_printer_item";

  ///列名称定义
  static final String columnId = "id";
  static final String columnTenantId = "tenantId";
  static final String columnBrandId = "brandId";
  static final String columnBrandName = "brandName";
  static final String columnTicketType = "ticketType";
  static final String columnName = "name";
  static final String columnDynamic = "dynamic";
  static final String columnType = "type";
  static final String columnPort = "port";
  static final String columnPortOrDriver = "portOrDriver";
  static final String columnPageWidth = "pageWidth";
  static final String columnCutType = "cutType";
  static final String columnBeepType = "beepType";
  static final String columnDpi = "dpi";
  static final String columnSerialPort = "serialPort";
  static final String columnBaudRate = "baudRate";
  static final String columnDataBit = "dataBit";
  static final String columnParallelPort = "parallelPort";
  static final String columnIpAddress = "ipAddress";
  static final String columnDriverName = "driverName";
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
  static final String columnRotation = "rotation";
  static final String columnUserDefined = "userDefined";
  static final String columnStatus = "status";
  static final String columnStatusDesc = "statusDesc";
  static final String columnMemo = "memo";
  static final String columnExt1 = "ext1";
  static final String columnExt2 = "ext2";
  static final String columnExt3 = "ext3";
  static final String columnCreateDate = "createDate";
  static final String columnCreateUser = "createUser";
  static final String columnModifyUser = "modifyUser";
  static final String columnModifyDate = "modifyDate";

  static final String columnVidpid = "vidpid";
  static final String columnPrintBarcodeFlag = "printBarcodeFlag";
  static final String columnPrintQrcodeFlag = "printQrcodeFlag";
  static final String columnPrintBarcodeByImage = "printBarcodeByImage";
  static final String columnPosNo = "posNo";

  ///字段名称
  String brandId;
  String brandName;
  String ticketType;
  String name;
  String dynamicLib;
  int type;
  String port;
  int portOrDriver;
  int pageWidth;
  String cutType;
  String beepType;
  int dpi;
  String serialPort;
  int baudRate;
  int dataBit;
  String parallelPort;
  String ipAddress;
  String driverName;
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
  int rotation;
  int userDefined;
  int status;
  String statusDesc;
  String memo;

  String vidpid;
  int printBarcodeFlag;
  int printQrcodeFlag;
  int printBarcodeByImage;
  String posNo;

  ///默认构造
  PrinterItem();

  ///Map转实体对象
  factory PrinterItem.fromMap(Map<String, dynamic> map) {
    return PrinterItem()
      ..id = Convert.toStr(map[columnId])
      ..tenantId = Convert.toStr(map[columnTenantId])
      ..brandId = Convert.toStr(map[columnBrandId])
      ..brandName = Convert.toStr(map[columnBrandName])
      ..ticketType = Convert.toStr(map[columnTicketType])
      ..name = Convert.toStr(map[columnName])
      ..dynamicLib = Convert.toStr(map[columnDynamic])
      ..type = Convert.toInt(map[columnType])
      ..port = Convert.toStr(map[columnPort])
      ..portOrDriver = Convert.toInt(map[columnPortOrDriver])
      ..pageWidth = Convert.toInt(map[columnPageWidth])
      ..cutType = Convert.toStr(map[columnCutType])
      ..beepType = Convert.toStr(map[columnBeepType])
      ..dpi = Convert.toInt(map[columnDpi])
      ..serialPort = Convert.toStr(map[columnSerialPort])
      ..baudRate = Convert.toInt(map[columnBaudRate])
      ..dataBit = Convert.toInt(map[columnDataBit])
      ..parallelPort = Convert.toStr(map[columnParallelPort])
      ..ipAddress = Convert.toStr(map[columnIpAddress])
      ..driverName = Convert.toStr(map[columnDriverName])
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
      ..rotation = Convert.toInt(map[columnRotation])
      ..userDefined = Convert.toInt(map[columnUserDefined])
      ..status = Convert.toInt(map[columnStatus])
      ..statusDesc = Convert.toStr(map[columnStatusDesc])
      ..memo = Convert.toStr(map[columnMemo])
      ..ext1 = Convert.toStr(map[columnExt1])
      ..ext2 = Convert.toStr(map[columnExt2])
      ..ext3 = Convert.toStr(map[columnExt3])
      ..createDate = Convert.toStr(map[columnCreateDate])
      ..createUser = Convert.toStr(map[columnCreateUser])
      ..modifyUser = Convert.toStr(map[columnModifyUser])
      ..modifyDate = Convert.toStr(map[columnModifyDate])
      ..vidpid = Convert.toStr(map[columnVidpid])
      ..printBarcodeFlag = Convert.toInt(map[columnPrintBarcodeFlag])
      ..printQrcodeFlag = Convert.toInt(map[columnPrintQrcodeFlag])
      ..printBarcodeByImage = Convert.toInt(map[columnPrintBarcodeByImage])
      ..posNo = Convert.toStr(map[columnPosNo]);
  }

  factory PrinterItem.clone(PrinterItem obj) {
    return PrinterItem()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..brandId = obj.brandId
      ..brandName = obj.brandName
      ..ticketType = obj.ticketType
      ..name = obj.name
      ..dynamicLib = obj.dynamicLib
      ..type = obj.type
      ..port = obj.port
      ..portOrDriver = obj.portOrDriver
      ..pageWidth = obj.pageWidth
      ..cutType = obj.cutType
      ..beepType = obj.beepType
      ..dpi = obj.dpi
      ..serialPort = obj.serialPort
      ..baudRate = obj.baudRate
      ..dataBit = obj.dataBit
      ..parallelPort = obj.parallelPort
      ..ipAddress = obj.ipAddress
      ..driverName = obj.driverName
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
      ..rotation = obj.rotation
      ..userDefined = obj.userDefined
      ..status = obj.status
      ..statusDesc = obj.statusDesc
      ..memo = obj.memo
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..vidpid = obj.vidpid
      ..printBarcodeFlag = obj.printBarcodeFlag
      ..printQrcodeFlag = obj.printQrcodeFlag
      ..printBarcodeByImage = obj.printBarcodeByImage
      ..posNo = obj.posNo;
  }

  factory PrinterItem.newPrinterItem() {
    return PrinterItem()
      ..id = ""
      ..tenantId = ""
      ..brandId = ""
      ..brandName = "外置打印机"
      ..ticketType = "前台小票"
      ..name = "前台小票打印机"
      ..dynamicLib = "通用打印模式"
      ..type = 1
      ..port = "网口"
      ..portOrDriver = 0
      ..pageWidth = 80
      ..cutType = "全切"
      ..beepType = "不蜂鸣"
      ..dpi = 200
      ..serialPort = ""
      ..baudRate = 9600
      ..dataBit = 8
      ..parallelPort = ""
      ..ipAddress = ""
      ..driverName = PrinterEmbedEunm.SunmiV1.name
      ..init = "27,64"
      ..doubleWidth = "27,33,32,28,33,4"
      ..cutPage = "29,86,66"
      ..doubleHeight = "27,33,16,28,33,8"
      ..normal = "27,33,2,28,33,2"
      ..doubleWidthHeight = "27,33,48,28,33,12"
      ..cashbox = "27,112,48,100,100"
      ..alignLeft = "27,97,48"
      ..alignCenter = "27,97,49"
      ..alignRight = "27,97,50"
      ..feed = "27,101,n"
      ..beep = "27,66,3,1"
      ..headerLines = 0
      ..footerLines = 0
      ..backLines = 0
      ..delay = 1
      ..rotation = 0
      ..userDefined = 0
      ..status = 1
      ..statusDesc = ""
      ..memo = ""
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..modifyUser = ""
      ..modifyDate = ""
      ..vidpid = ""
      ..printBarcodeFlag = 0
      ..printQrcodeFlag = 0
      ..printBarcodeByImage = 0
      ..posNo = "";
  }

  ///转List集合
  static List<PrinterItem> toList(List<Map<String, dynamic>> lists) {
    var result = new List<PrinterItem>();
    lists.forEach((map) => result.add(PrinterItem.fromMap(map)));
    return result;
  }

  ///实体对象转Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnId: this.id,
      columnTenantId: this.tenantId,
      columnBrandId: this.brandId,
      columnBrandName: this.brandName,
      columnTicketType: this.ticketType,
      columnName: this.name,
      columnDynamic: this.dynamicLib,
      columnType: this.type,
      columnPort: this.port,
      columnPortOrDriver: this.portOrDriver,
      columnPageWidth: this.pageWidth,
      columnCutType: this.cutType,
      columnBeepType: this.beepType,
      columnDpi: this.dpi,
      columnSerialPort: this.serialPort,
      columnBaudRate: this.baudRate,
      columnDataBit: this.dataBit,
      columnParallelPort: this.parallelPort,
      columnIpAddress: this.ipAddress,
      columnDriverName: this.driverName,
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
      columnRotation: this.rotation,
      columnUserDefined: this.userDefined,
      columnStatus: this.status,
      columnStatusDesc: this.statusDesc,
      columnMemo: this.memo,
      columnExt1: this.ext1,
      columnExt2: this.ext2,
      columnExt3: this.ext3,
      columnCreateDate: this.createDate,
      columnCreateUser: this.createUser,
      columnModifyUser: this.modifyUser,
      columnModifyDate: this.modifyDate,
      columnVidpid: this.vidpid,
      columnPosNo: this.posNo,
      columnPrintBarcodeFlag: this.printBarcodeFlag,
      columnPrintQrcodeFlag: this.printQrcodeFlag,
      columnPrintBarcodeByImage: this.printBarcodeByImage,
    };
    return map;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }

  @override
  List<Object> get props => [
        this.id,
        this.tenantId,
        this.brandId,
        this.brandName,
        this.ticketType,
        this.name,
        this.dynamicLib,
        this.type,
        this.port,
        this.portOrDriver,
        this.pageWidth,
        this.cutType,
        this.beepType,
        this.dpi,
        this.serialPort,
        this.baudRate,
        this.dataBit,
        this.parallelPort,
        this.ipAddress,
        this.driverName,
        this.init,
        this.doubleWidth,
        this.cutPage,
        this.doubleHeight,
        this.normal,
        this.doubleWidthHeight,
        this.cashbox,
        this.alignLeft,
        this.alignCenter,
        this.alignRight,
        this.feed,
        this.beep,
        this.headerLines,
        this.footerLines,
        this.backLines,
        this.delay,
        this.rotation,
        this.userDefined,
        this.status,
        this.statusDesc,
        this.memo,
        this.ext1,
        this.ext2,
        this.ext3,
        this.createUser,
        this.createDate,
        this.modifyUser,
        this.modifyDate,
        this.vidpid,
        this.printBarcodeFlag,
        this.printQrcodeFlag,
        this.printBarcodeByImage,
        this.posNo,
      ];
}
