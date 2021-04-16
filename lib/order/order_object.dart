import 'dart:convert';
import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/enums/cashier_action_type.dart';
import 'package:h3_app/enums/order_payment_status_type.dart';
import 'package:h3_app/enums/order_point_deal_status.dart';
import 'package:h3_app/enums/order_print_status_type.dart';
import 'package:h3_app/enums/order_refund_status.dart';
import 'package:h3_app/enums/order_source_type.dart';
import 'package:h3_app/enums/order_status_type.dart';
import 'package:h3_app/enums/order_upload_source.dart';
import 'package:h3_app/enums/post_way_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/member/member.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/objectid_utils.dart';
import 'package:meta/meta.dart';

import 'order_item.dart';
import 'order_pay.dart';
import 'order_promotion.dart';
import 'order_table.dart';

@immutable
class OrderObject extends Equatable {
  ///订单ID
  String id = "";

  ///租户编码
  String tenantId = "";

  ///内部订单号
  String objectId = "";

  ///单据编号
  String tradeNo = "";

  ///订单序号
  String orderNo = "0";

  /// 门店ID
  String storeId = "";

  /// 门店编号
  String storeNo = "";

  /// 门店名称
  String storeName = "";

  /// 操作员工号
  String workerNo = "";

  /// 操作员名称
  String workerName = "";

  /// POS
  String posNo = "";

  /// 收银设备名称
  String deviceName = "";

  /// 收银设备Mac地址
  String macAddress = "";

  /// 收银设备IP地址
  String ipAddress = "";

  /// 营业员编码
  String salesCode = "";

  /// 营业员名称
  String salesName = "";

  /// 餐桌ID
  String tableId = "";

  /// 餐桌号
  String tableNo = "";

  /// 餐桌名称
  String tableName = "";

  /// 人数
  int people = 0;

  ///收银操作或者无单退货操作
  CashierAction cashierAction = CashierAction.Cashier;

  /// 班次ID
  String shiftId = "";

  /// 班次编号
  String shiftNo = "";

  /// 班次名称
  String shiftName = "";

  /// 销售订单创建时间
  String saleDate = "";

  /// 订单完成时间(格式:yyyy-MM-dd HH:mm:ss)
  String finishDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 星期
  String weeker = "";

  /// 天气
  String weather = "";

  ///配送方式
  PostWay postWay = PostWay.Picked;

  ///订单来源
  OrderSource orderSource = OrderSource.CashRegister;

  ///订单状态
  OrderStatus orderStatus = OrderStatus.WaitForPayment;

  ///订单支付状态
  OrderPaymentStatus paymentStatus = OrderPaymentStatus.NonPayment;

  ///订单退单状态
  /// zhangy 2020-10-28 Add
  OrderRefundStatus refundStatus = OrderRefundStatus.NonRefund;

  ///打印状态
  OrderPrintStatus printStatus = OrderPrintStatus.Wait;

  ///打印次数
  int printTimes = 0;

  ///订单明细
  List<OrderItem> items = <OrderItem>[];

  ///订单明细行数
  int itemCount = 0;

  /// 整单的数量合计，不包含套餐明细
  double totalQuantity = 0;

  ///整单的消费金额，不包含套餐明细
  double amount = 0;

  ///支付明细行数
  int payCount = 0;

  ///支付明细
  List<OrderPay> pays = <OrderPay>[];

  ///整单的优惠金额，不包含套餐明细
  double discountAmount = 0;

  ///应收金额 = 消费金额 - 优惠金额
  double receivableAmount = 0;

  ///未收金额 = 应收金额 - 已收金额
  double unreceivableAmount = 0;

  ///券后应收
  double receivableRemoveCouponAmount = 0;

  ///实收金额 = 应收金额 - 抹零金额
  double paidAmount = 0;

  ///已收金额，各种支付明细的实收金额合计
  double receivedAmount = 0;

  ///抹零金额
  double malingAmount = 0;

  ///找零金额
  double changeAmount = 0;

  ///开票金额
  double invoicedAmount = 0;

  ///溢收金额
  double overAmount = 0;

  ///plus优惠金额
  double plusDiscountAmount = 0;

  /// 支付实收，支付方式中是否实收为是的支付合计
  double realPayAmount = 0;

  /// 总优惠率
  double discountRate = 0;

  /// 运费、配送费
  double freightAmount = 0;

  /// 原单号
  String orgTradeNo = "";

  /// 退单原因
  String refundCause = "";

  /// 是否使用会员卡(0否1是)
  int isMember = 0;

  /// 会员Id
  String memberId = "";

  /// 会员卡号
  String memberNo = "";

  /// 会员名称
  String memberName = "";

  /// 会员手机号
  String memberMobileNo = "";

  /// 会员卡面号
  String cardFaceNo = "";

  /// 消费前积分
  double prePoint = 0;

  /// 本单积分
  double addPoint = 0;

  /// 已退积分，原单使用
  double refundPoint = 0;

  /// 消费后积分
  double aftPoint = 0;

  /// 单独增加积分的卡余额，如果使用了会员卡支付，不能使用该字段
  double aftAmount = 0;

  /// 数据上传状态
  int uploadStatus = 0;

  /// 数据上传错误次数
  int uploadErrors = 0;

  /// 数据上传消息说明
  String uploadMessage = "";

  /// 数据上传返回码
  String uploadCode = "";

  /// 上传成功后服务端ID
  String serverId = "";

  /// 数据上传成功的时间
  String uploadTime = "";

  /// 单注
  String remark = "";

  /// 是否为plus会员 0-否 1-是
  int isPlus = 0;

  ///扩展字段1
  String ext1 = "";

  ///扩展字段2
  String ext2 = "";

  ///扩展字段3
  String ext3 = "";

  ///创建人
  String createUser = Constants.DEFAULT_CREATE_USER;

  ///创建日期
  String createDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  ///修改人
  String modifyUser = Constants.DEFAULT_MODIFY_USER;

  ///修改日期
  String modifyDate =
      DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

  /// 订单优惠列表
  List<OrderPromotion> promotions = <OrderPromotion>[];

  /// 订单会员信息
  Member member;

  /// 订单实款实收标识(抹零和(结账时，以下支付方式为实款实收：微信、支付宝、储值卡、银行卡、扫码付)开关都开启的情况下)
  bool payRealAmountFlag = false;

  /// 重打标识
  bool reprint = false;

  /// 订单
  OrderUploadSource orderUploadSource = OrderUploadSource.FastFood;

  ///订单对应的桌台,存在多个桌台
  List<OrderTable> tables = <OrderTable>[];

  ///积分处理状态
  OrderPointDealStatus pointDealStatus = OrderPointDealStatus.None;

  ///后台上传单单号(小程序点餐上传销售数据时使用)
  String uploadNo = "";

  ///制作状态(餐饮叫号系统使用) 0-待制作 1-制作完成,待取餐 2-已取餐 3-待叫号已取消
  int makeStatus = 0;

  ///制作完成时间(餐饮叫号系统使用)
  String makeFinishDate = "";

  ///取餐时间(餐饮叫号系统使用)
  String takeMealDate = "";

  /// 桌台的总退量
  double totalRefundQuantity = 0.0;

  /// 桌台退菜总金额
  double totalRefundAmount = 0.0;

  /// 桌台的总赠量
  double totalGiftQuantity = 0.0;

  /// 桌台赠总金额
  double totalGiftAmount = 0.0;

  ///默认构造
  OrderObject();

  factory OrderObject.newOrderObject() {
    return OrderObject()
      ..id = IdWorkerUtils.getInstance().generate().toString()
      ..tenantId = Global.instance.authc?.tenantId
      ..objectId = ObjectIdUtils.getInstance().generate()
      ..storeId = Global.instance.authc?.storeId
      ..storeNo = Global.instance.authc?.storeNo
      ..storeName = Global.instance.authc?.storeName
      ..orderNo = "0"
      ..workerNo = Global.instance.worker?.no
      ..workerName = Global.instance.worker?.name
      ..posNo = Global.instance.authc?.posNo
      ..cashierAction = CashierAction.Cashier
      ..saleDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..tableId = ""
      ..tableNo = ""
      ..tableName = ""
      ..salesCode = ""
      ..salesName = ""
      ..shiftId = ""
      ..shiftNo = ""
      ..shiftName = ""
      ..deviceName = ""
      ..macAddress = ""
      ..ipAddress = ""
      ..weather = ""
      ..weeker = DateUtils.getZHWeekDay(DateTime.now())
      ..postWay = PostWay.Picked
      ..orderSource = OrderSource.CashRegister
      ..orderStatus = OrderStatus.WaitForPayment
      ..paymentStatus = OrderPaymentStatus.NonPayment
      ..printStatus = OrderPrintStatus.Wait
      ..printTimes = 0
      ..items = <OrderItem>[]
      ..itemCount = 0
      ..totalQuantity = 0
      ..amount = 0
      ..payCount = 0
      ..pays = <OrderPay>[]
      ..discountAmount = 0
      ..receivableAmount = 0
      ..unreceivableAmount = 0
      ..receivableRemoveCouponAmount = 0
      ..paidAmount = 0
      ..receivedAmount = 0
      ..malingAmount = 0
      ..changeAmount = 0
      ..invoicedAmount = 0
      ..overAmount = 0
      ..plusDiscountAmount = 0
      ..realPayAmount = 0
      ..discountRate = 0
      ..freightAmount = 0
      ..orgTradeNo = ""
      ..refundCause = ""
      ..isMember = 0
      ..memberId = ""
      ..memberNo = ""
      ..memberName = ""
      ..memberMobileNo = ""
      ..cardFaceNo = ""
      ..prePoint = 0
      ..addPoint = 0
      ..refundPoint = 0
      ..aftPoint = 0
      ..aftAmount = 0
      ..uploadStatus = 0
      ..uploadCode = ""
      ..uploadMessage = ""
      ..uploadErrors = 0
      ..uploadTime = ""
      ..serverId = ""
      ..remark = ""
      ..finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..isPlus = 0
      ..ext1 = ""
      ..ext2 = ""
      ..ext3 = ""
      ..createUser = Constants.DEFAULT_CREATE_USER
      ..createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..modifyUser = Constants.DEFAULT_MODIFY_USER
      ..modifyDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss")
      ..promotions = <OrderPromotion>[]
      ..member = null
      ..payRealAmountFlag = false
      ..refundStatus = OrderRefundStatus.NonRefund
      ..orderUploadSource = OrderUploadSource.FastFood
      ..tables = <OrderTable>[]
      ..pointDealStatus = OrderPointDealStatus.None
      ..uploadNo = ""
      ..makeStatus = 0
      ..makeFinishDate = ""
      ..takeMealDate = ""
      ..totalRefundQuantity = 0.0
      ..totalRefundAmount = 0.0
      ..totalGiftQuantity = 0.0
      ..totalGiftAmount = 0.0;
  }

  ///Map转实体对象
  factory OrderObject.fromMap(Map<String, dynamic> map) {
    OrderObject orderObject = OrderObject()
      ..id = Convert.toStr(map["id"])
      ..tenantId = Convert.toStr(map["tenantId"])
      ..objectId = Convert.toStr(map["objectId"])
      ..tradeNo = Convert.toStr(map["tradeNo"])
      ..storeId = Convert.toStr(map["storeId"])
      ..storeNo = Convert.toStr(map["storeNo"])
      ..storeName = Convert.toStr(map["storeName"])
      ..orderNo = Convert.toStr(map["orderNo"])
      ..workerNo = Convert.toStr(map["workerNo"])
      ..workerName = Convert.toStr(map["workerName"])
      ..posNo = Convert.toStr(map["posNo"])
      ..cashierAction =
          CashierAction.fromValue(Convert.toStr(map["cashierAction"]))
      ..saleDate = Convert.toStr(map["saleDate"])
      ..tableId = Convert.toStr(map["tableId"])
      ..tableNo = Convert.toStr(map["tableNo"])
      ..tableName = Convert.toStr(map["tableName"])
      ..salesCode = Convert.toStr(map["salesCode"])
      ..salesName = Convert.toStr(map["salesName"])
      ..shiftId = Convert.toStr(map["shiftId"])
      ..shiftNo = Convert.toStr(map["shiftNo"])
      ..shiftName = Convert.toStr(map["shiftName"])
      ..deviceName = Convert.toStr(map["deviceName"])
      ..macAddress = Convert.toStr(map["macAddress"])
      ..ipAddress = Convert.toStr(map["ipAddress"])
      ..weather = Convert.toStr(map["weather"])
      ..weeker = Convert.toStr(map["weeker"])
      ..postWay = PostWay.fromValue(Convert.toStr(map["postWay"]))
      ..orderSource = OrderSource.fromValue(Convert.toStr(map["orderSource"]))
      ..orderStatus = OrderStatus.fromValue(Convert.toStr(map["orderStatus"]))
      ..paymentStatus =
          OrderPaymentStatus.fromValue(Convert.toStr(map["paymentStatus"]))
      ..printStatus =
          OrderPrintStatus.fromValue(Convert.toStr(map["printStatus"]))
      ..printTimes = Convert.toInt(map["printTimes"])
      ..items = map["items"] != null
          ? List<OrderItem>.from(
              List<Map<String, dynamic>>.from(map["items"] is String ? json.decode(map["items"]) : map["items"])
                  .map((x) => OrderItem.fromJson(x)))
          : <OrderItem>[]
      ..itemCount = Convert.toInt(map["itemCount"])
      ..totalQuantity = Convert.toDouble(map["totalQuantity"])
      ..amount = Convert.toDouble(map["amount"])
      ..pays = map["pays"] != null
          ? List<OrderPay>.from(
              List<Map<String, dynamic>>.from(map["pays"] is String ? json.decode(map["pays"]) : map["pays"])
                  .map((x) => OrderPay.fromJson(x)))
          : <OrderPay>[]
      ..payCount = Convert.toInt(map["payCount"])
      ..promotions = map["promotions"] != null
          ? List<OrderPromotion>.from(
              List<Map<String, dynamic>>.from(map["promotions"] is String ? json.decode(map["promotions"]) : map["promotions"])
                  .map((x) => OrderPromotion.fromJson(x)))
          : <OrderPromotion>[]
      ..discountAmount = Convert.toDouble(map["discountAmount"])
      ..receivableAmount = Convert.toDouble(map["receivableAmount"])
      ..unreceivableAmount = Convert.toDouble(map["unreceivableAmount"])
      ..receivableRemoveCouponAmount =
          Convert.toDouble(map["receivableRemoveCouponAmount"])
      ..paidAmount = Convert.toDouble(map["paidAmount"])
      ..receivedAmount = Convert.toDouble(map["receivedAmount"])
      ..malingAmount = Convert.toDouble(map["malingAmount"])
      ..changeAmount = Convert.toDouble(map["changeAmount"])
      ..invoicedAmount = Convert.toDouble(map["invoicedAmount"])
      ..overAmount = Convert.toDouble(map["overAmount"])
      ..plusDiscountAmount = Convert.toDouble(map["plusDiscountAmount"])
      ..realPayAmount = Convert.toDouble(map["realPayAmount"])
      ..discountRate = Convert.toDouble(map["discountRate"])
      ..freightAmount = Convert.toDouble(map["freightAmount"])
      ..orgTradeNo = Convert.toStr(map["orgTradeNo"])
      ..refundCause = Convert.toStr(map["refundCause"])
      ..isMember = Convert.toInt(map["isMember"])
      ..memberId = Convert.toStr(map["memberId"])
      ..memberNo = Convert.toStr(map["memberNo"])
      ..memberName = Convert.toStr(map["memberName"])
      ..memberMobileNo = Convert.toStr(map["memberMobileNo"])
      ..cardFaceNo = Convert.toStr(map["cardFaceNo"])
      ..prePoint = Convert.toDouble(map["prePoint"])
      ..addPoint = Convert.toDouble(map["addPoint"])
      ..refundPoint = Convert.toDouble(map["refundPoint"])
      ..aftPoint = Convert.toDouble(map["aftPoint"])
      ..aftAmount = Convert.toDouble(map["aftAmount"])
      ..uploadStatus = Convert.toInt(map["uploadStatus"])
      ..uploadCode = Convert.toStr(map["uploadCode"])
      ..uploadMessage = Convert.toStr(map["uploadMessage"])
      ..uploadErrors = Convert.toInt(map["uploadErrors"])
      ..uploadTime = Convert.toStr(map["uploadTime"])
      ..serverId = Convert.toStr(map["serverId"])
      ..remark = Convert.toStr(map["remark"])
      ..finishDate = Convert.toStr(map["finishDate"])
      ..isPlus = Convert.toInt(map["isPlus"])
      ..ext1 = Convert.toStr(map["ext1"])
      ..ext2 = Convert.toStr(map["ext2"])
      ..ext3 = Convert.toStr(map["ext3"])
      ..createUser = Convert.toStr(map["createUser"])
      ..createDate = Convert.toStr(map["createDate"])
      ..modifyUser = Convert.toStr(map["modifyUser"])
      ..modifyDate = Convert.toStr(map["modifyDate"])
      ..refundStatus =
          OrderRefundStatus.fromValue(Convert.toStr(map["refundStatus"]))
      ..orderUploadSource = OrderUploadSource.fromValue(Convert.toInt(map["orderUploadSource"]))
      ..pointDealStatus = OrderPointDealStatus.fromValue(Convert.toStr(map["pointDealStatus"]))
      ..uploadNo = Convert.toStr(map["uploadNo"])
      ..makeStatus = Convert.toInt(map["makeStatus"])
      ..makeFinishDate = Convert.toStr(map["makeFinishDate"])
      ..takeMealDate = Convert.toStr(map["takeMealDate"])
      ..tables = map["tables"] != null ? List<OrderTable>.from(List<Map<String, dynamic>>.from(map["tables"] is String ? json.decode(map["tables"]) : map["tables"]).map((x) => OrderTable.fromMap(x))) : <OrderTable>[]
      ..totalRefundQuantity = Convert.toDouble(map["totalRefundQuantity"])
      ..totalRefundAmount = Convert.toDouble(map["totalRefundAmount"])
      ..totalGiftQuantity = Convert.toDouble(map["totalGiftQuantity"])
      ..totalGiftAmount = Convert.toDouble(map["totalGiftAmount"]);

    if (map["member"] != null) {
      orderObject.member = Member.fromJson(
          map["member"] is String ? json.decode(map["member"]) : map["member"]);
    }

    return orderObject;
  }

  ///转List集合
  static List<OrderObject> toList(List<Map<String, dynamic>> lists) {
    var result = new List<OrderObject>();
    lists.forEach((map) => result.add(OrderObject.fromMap(map)));
    return result;
  }

  factory OrderObject.clone(OrderObject obj) {
    return OrderObject()
      ..id = obj.id
      ..tenantId = obj.tenantId
      ..objectId = obj.objectId
      ..tradeNo = obj.tradeNo
      ..storeId = obj.storeId
      ..storeNo = obj.storeNo
      ..storeName = obj.storeName
      ..workerNo = obj.workerNo
      ..workerName = obj.workerName
      ..posNo = obj.posNo
      ..cashierAction = obj.cashierAction
      ..saleDate = obj.saleDate
      ..tableId = obj.tableId
      ..tableNo = obj.tableNo
      ..tableName = obj.tableName
      ..salesCode = obj.salesCode
      ..salesName = obj.salesName
      ..shiftId = obj.shiftId
      ..shiftNo = obj.shiftNo
      ..shiftName = obj.shiftName
      ..deviceName = obj.deviceName
      ..macAddress = obj.macAddress
      ..ipAddress = obj.ipAddress
      ..people = obj.people
      ..weather = obj.weather
      ..weeker = obj.weeker
      ..postWay = obj.postWay
      ..orderSource = obj.orderSource
      ..orderStatus = obj.orderStatus
      ..paymentStatus = obj.paymentStatus
      ..printStatus = obj.printStatus
      ..printTimes = obj.printTimes
      ..items = obj.items.map((item) => OrderItem.clone(item)).toList()
      ..itemCount = obj.itemCount
      ..totalQuantity = obj.totalQuantity
      ..amount = obj.amount
      ..payCount = obj.payCount
      ..pays = obj.pays.map((item) => OrderPay.clone(item)).toList()
      ..discountAmount = obj.discountAmount
      ..receivableAmount = obj.receivableAmount
      ..unreceivableAmount = obj.unreceivableAmount
      ..receivableRemoveCouponAmount = obj.receivableRemoveCouponAmount
      ..paidAmount = obj.paidAmount
      ..receivedAmount = obj.receivedAmount
      ..malingAmount = obj.malingAmount
      ..changeAmount = obj.changeAmount
      ..invoicedAmount = obj.invoicedAmount
      ..overAmount = obj.overAmount
      ..plusDiscountAmount = obj.plusDiscountAmount
      ..realPayAmount = obj.realPayAmount
      ..discountRate = obj.discountRate
      ..freightAmount = obj.freightAmount
      ..orgTradeNo = obj.orgTradeNo
      ..refundCause = obj.refundCause
      ..isMember = obj.isMember
      ..memberId = obj.memberId
      ..memberNo = obj.memberNo
      ..memberName = obj.memberName
      ..memberMobileNo = obj.memberMobileNo
      ..cardFaceNo = obj.cardFaceNo
      ..prePoint = obj.prePoint
      ..addPoint = obj.addPoint
      ..refundPoint = obj.refundPoint
      ..aftPoint = obj.aftPoint
      ..aftAmount = obj.aftAmount
      ..uploadStatus = obj.uploadStatus
      ..uploadCode = obj.uploadCode
      ..uploadMessage = obj.uploadMessage
      ..uploadErrors = obj.uploadErrors
      ..uploadTime = obj.uploadTime
      ..serverId = obj.serverId
      ..remark = obj.remark
      ..finishDate = obj.finishDate
      ..isPlus = obj.isPlus
      ..ext1 = obj.ext1
      ..ext2 = obj.ext2
      ..ext3 = obj.ext3
      ..createUser = obj.createUser
      ..createDate = obj.createDate
      ..modifyUser = obj.modifyUser
      ..modifyDate = obj.modifyDate
      ..promotions =
          obj.promotions.map((item) => OrderPromotion.clone(item)).toList()
      ..member = obj.member
      ..payRealAmountFlag = obj.payRealAmountFlag
      ..refundStatus = obj.refundStatus
      ..orderUploadSource = obj.orderUploadSource
      ..pointDealStatus = obj.pointDealStatus
      ..uploadNo = obj.uploadNo
      ..makeStatus = obj.makeStatus
      ..makeFinishDate = obj.makeFinishDate
      ..takeMealDate = obj.takeMealDate
      ..tables = obj.tables.map((item) => OrderTable.clone(item)).toList()
      ..totalRefundQuantity = obj.totalRefundQuantity
      ..totalRefundAmount = obj.totalRefundAmount
      ..totalGiftQuantity = obj.totalGiftQuantity
      ..totalGiftAmount = obj.totalGiftAmount;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "tenantId": this.tenantId,
      "objectId": this.objectId,
      "tradeNo": this.tradeNo,
      "storeId": this.storeId,
      "storeNo": this.storeNo,
      "storeName": this.storeName,
      "orderNo": this.orderNo,
      "workerNo": this.workerNo,
      "workerName": this.workerName,
      "posNo": this.posNo,
      "cashierAction": this.cashierAction.value,
      "deviceName": this.deviceName ?? "",
      "macAddress": this.macAddress ?? "",
      "ipAddress": this.ipAddress ?? "",
      "salesCode": this.salesCode ?? "",
      "salesName": this.salesName ?? "",
      "tableId": this.tableId ?? "",
      "tableNo": this.tableNo ?? "",
      "tableName": this.tableName ?? "",
      "people": this.people,
      "shiftId": this.shiftId,
      "shiftNo": this.shiftNo,
      "shiftName": this.shiftName,
      "saleDate": this.saleDate,
      "finishDate": this.finishDate,
      "weeker": this.weeker,
      "weather": this.weather,
      "postWay": this.postWay.value,
      "orderSource": this.orderSource.value,
      "orderStatus": this.orderStatus.value,
      "paymentStatus": this.paymentStatus.value,
      "printStatus": this.printStatus.value,
      "printTimes": this.printTimes,
      "items": this.items, //.toString(),
      "itemCount": this.itemCount,
      "totalQuantity": this.totalQuantity,
      "amount": this.amount,
      "pays": this.pays, //.toString(),
      "payCount": this.payCount,
      "realPayAmount": this.realPayAmount,
      "paidAmount": this.paidAmount,
      "receivedAmount": this.receivedAmount,
      "discountAmount": this.discountAmount,
      "changeAmount": this.changeAmount,
      "receivableAmount": this.receivableAmount,
      "unreceivableAmount": this.unreceivableAmount,
      "discountRate": this.discountRate,
      "freightAmount": this.freightAmount,
      "orgTradeNo": this.orgTradeNo,
      "refundCause": this.refundCause,
      "isMember": this.isMember,
      "memberId": this.memberId,
      "memberNo": this.memberNo,
      "memberName": this.memberName,
      "memberMobileNo": this.memberMobileNo,
      "cardFaceNo": this.cardFaceNo,
      "prePoint": this.prePoint,
      "addPoint": this.addPoint,
      "refundPoint": this.refundPoint,
      "aftPoint": this.aftPoint,
      "aftAmount": this.aftAmount,
      "uploadStatus": this.uploadStatus,
      "uploadCode": this.uploadCode,
      "uploadMessage": this.uploadMessage,
      "uploadErrors": this.uploadErrors,
      "uploadTime": this.uploadTime,
      "serverId": this.serverId,
      "remark": this.remark,
      "isPlus": this.isPlus,
      "ext1": this.ext1,
      "ext2": this.ext2,
      "ext3": this.ext3,
      "createUser": this.createUser,
      "createDate": this.createDate,
      "modifyUser": this.modifyUser,
      "modifyDate": this.modifyDate,
      "promotions": this.promotions, //.toString(),
      "refundStatus": this.refundStatus.value,
      "orderUploadSource": this.orderUploadSource.value,
      "pointDealStatus": this.pointDealStatus.value,
      "uploadNo": this.uploadNo,
      "makeStatus": this.makeStatus,
      "makeFinishDate": this.makeFinishDate,
      "takeMealDate": this.takeMealDate,
      "tables": this.tables,
      "totalRefundQuantity": this.totalRefundQuantity,
      "totalRefundAmount": this.totalRefundAmount,
      "totalGiftQuantity": this.totalGiftQuantity,
      "totalGiftAmount": this.totalGiftAmount,
    };

    if (this.member != null) {
      map["member"] = this.member; //.toString();
    }

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }

  @override
  List<Object> get props => [
        this.id,
        this.tenantId,
        this.objectId,
        this.tradeNo,
        this.storeId,
        this.storeNo,
        this.storeName,
        this.orderNo,
        this.workerNo,
        this.workerName,
        this.posNo,
        this.cashierAction,
        this.deviceName,
        this.macAddress,
        this.ipAddress,
        this.salesCode,
        this.salesName,
        this.tableId,
        this.tableNo,
        this.tableName,
        this.people,
        this.shiftId,
        this.shiftNo,
        this.shiftName,
        this.saleDate,
        this.finishDate,
        this.weeker,
        this.weather,
        this.postWay,
        this.orderSource,
        this.orderStatus,
        this.paymentStatus,
        this.printStatus,
        this.printTimes,
        this.items,
        this.itemCount,
        this.totalQuantity,
        this.amount,
        this.pays,
        this.payCount,
        this.realPayAmount,
        this.changeAmount,
        this.unreceivableAmount,
        this.discountRate,
        this.freightAmount,
        this.orgTradeNo,
        this.refundCause,
        this.isMember,
        this.memberId,
        this.memberNo,
        this.memberName,
        this.memberMobileNo,
        this.cardFaceNo,
        this.prePoint,
        this.addPoint,
        this.refundPoint,
        this.aftPoint,
        this.aftAmount,
        this.uploadStatus,
        this.uploadCode,
        this.uploadMessage,
        this.uploadErrors,
        this.uploadTime,
        this.serverId,
        this.remark,
        this.isPlus,
        this.ext1,
        this.ext2,
        this.ext3,
        this.createUser,
        this.createDate,
        this.modifyUser,
        this.modifyDate,
        this.promotions,
        this.member,
        this.refundStatus,
        this.orderUploadSource,
        this.pointDealStatus,
        this.uploadNo,
        this.makeFinishDate,
        this.makeStatus,
        this.takeMealDate,
        this.tables,
        this.totalRefundQuantity,
        this.totalRefundAmount,
        this.totalGiftQuantity,
        this.totalGiftAmount,
      ];
}
