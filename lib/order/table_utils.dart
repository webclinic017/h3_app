import 'dart:collection';
import 'dart:convert';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/pos_store_table.dart';
import 'package:h3_app/enums/order_row_status.dart';
import 'package:h3_app/enums/order_source_type.dart';
import 'package:h3_app/enums/order_table_action.dart';
import 'package:h3_app/enums/order_table_status.dart';
import 'package:h3_app/enums/order_upload_source.dart';
import 'package:h3_app/enums/post_way_type.dart';
import 'package:h3_app/enums/promotion_type.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_promotion.dart';
import 'package:h3_app/order/promotion_utils.dart';
import 'package:h3_app/utils/api_utils.dart';
import 'package:h3_app/utils/date_utils.dart';
import 'package:h3_app/utils/http_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/objectid_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/tuple.dart';
import 'package:sprintf/sprintf.dart';

import 'order_item.dart';
import 'order_item_make.dart';
import 'order_item_promotion.dart';
import 'order_object.dart';
import 'order_table.dart';
import 'order_utils.dart';

class TableUtils {
  // 工厂模式
  factory TableUtils() => _getInstance();

  static TableUtils get instance => _getInstance();
  static TableUtils _instance;

  static TableUtils _getInstance() {
    if (_instance == null) {
      _instance = new TableUtils._internal();
    }
    return _instance;
  }

  TableUtils._internal();

  OrderTable builderOrderTable(StoreTable table, int people,
      {String memo = ""}) {
    var entity = new OrderTable();

    entity.id = IdWorkerUtils.getInstance().generate().toString();

    entity.tenantId = table.tenantId;
    //桌台信息
    entity.tableId = table.id;
    entity.tableNo = table.no;
    entity.tableName = table.name;
    //桌台类型信息
    entity.typeId = table.typeId;
    entity.typeNo = table.tableType == null ? "" : table.tableType.no;
    entity.typeName = table.tableType == null ? "" : table.tableType.name;
    //桌台区域信息
    entity.areaId = table.areaId;
    entity.areaNo = table.tableArea == null ? "" : table.tableArea.no;
    entity.areaName = table.tableArea == null ? "" : table.tableArea.name;
    //桌台定义的座位数
    entity.tableNumber = table.number;
    //实际上座的人数
    entity.people = people;
    //是否超额的标识,实际上座人数 高于 设置的位置
    entity.excessFlag = (entity.people > entity.tableNumber) ? 1 : 0;

    entity.tableStatus = OrderTableStatus.Occupied.value;
    entity.openTime =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
    entity.openUser = Global.instance.worker.no;
    entity.createUser = Global.instance.worker.name;

    entity.posNo = Global.instance.authc.posNo;

    //普通开台
    entity.tableAction = OrderTableAction.Open.value;
    entity.serialNo = "";

    entity.ext1 = "";
    entity.ext2 = "";
    entity.ext3 = "";

    entity.createUser = Global.instance.worker.name;
    entity.createDate =
        DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

    entity.modifyUser = "";
    entity.modifyDate = "";

    return entity;
  }

  //开台
  Future<Tuple3<bool, String, OrderObject>> saveOrderObjectFromOrderTable(
      OrderTable orderTable,
      {bool onlineFlag = false}) async {
    bool result = false;
    String message = "";
    //生成新的退单对象
    OrderObject newOrderObject;
    try {
      newOrderObject = OrderObject.newOrderObject();
      //生成新的退单单号
      var ticketNoResult = await OrderUtils.instance.generateTicketNo();
      if (ticketNoResult.item1) {
        newOrderObject.tradeNo = ticketNoResult.item3;
      }

      //中餐单
      newOrderObject.orderUploadSource = OrderUploadSource.ChineseFood;

      newOrderObject.postWay = PostWay.ForHere;
      if (onlineFlag) {
        newOrderObject.orderSource = OrderSource.OnlineStore;
      }

      //订单ID赋值到桌台信息
      orderTable.orderId = newOrderObject.id;
      //订单号赋值到桌台信息
      orderTable.tradeNo = newOrderObject.tradeNo;
      //桌台的操作模式
      orderTable.tableAction = OrderTableAction.Open.value;

      //桌台的消费金额，不包含套餐明细
      orderTable.totalAmount = 0;
      //桌台的数量合计，不包含套餐明细
      orderTable.totalQuantity = 0;
      //桌台的总退量
      orderTable.totalRefund = 0;
      //桌台的总退金额
      orderTable.totalRefundAmount = 0;
      //桌台的优惠金额，不包含套餐明细
      orderTable.discountAmount = 0;
      //抹零金额
      orderTable.malingAmount = 0;
      //桌台的应收金额
      orderTable.receivableAmount = 0;
      //桌台的实收金额
      orderTable.paidAmount = 0;
      //桌台的优惠率,包含商品+加价
      orderTable.discountRate = 0;

      orderTable.totalGive = 0;
      orderTable.totalGiveAmount = 0;

      orderTable.masterTable = 0;
      orderTable.maxOrderNo = 0;
      orderTable.perCapitaAmount = 0.0;
      orderTable.posNo = Global.instance.authc.posNo;
      orderTable.payNo = "";

      orderTable.ext1 = "";
      orderTable.ext2 = "";
      orderTable.ext3 = "";

      orderTable.createUser = Global.instance.worker.name;
      orderTable.createDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
      orderTable.modifyUser = "";
      orderTable.modifyDate = "";

      //将当前桌台压入订单对象中
      newOrderObject.tables.add(orderTable);

      //桌台编号
      newOrderObject.tableNo = orderTable.tableNo;
      //桌台名称
      newOrderObject.tableName = orderTable.tableName;
      //桌台实际座的人数
      newOrderObject.people = orderTable.people;

      //桌台订单的时间不依据这里，订单最终结账的时候
      var finishDate =
          DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
      //重置订单完成时间
      newOrderObject.finishDate = finishDate;

      var queues = new Queue<String>();

      //pos_order表的SQL语句
      var order = await OrderUtils.instance
          .buildOrderObjectSql(newOrderObject, finishDate);
      if (order.item1) {
        queues.add(order.item3);
      }

      //pos_order_table表的SQL语句
      var table = await OrderUtils.instance
          .buildOrderTableSql(newOrderObject, finishDate);
      if (table.item1) {
        queues.add(table.item3);
      }

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("保存开台订单异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "开台保存失败...";
      } else {
        result = true;
        message = "开台保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存开台信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple3<bool, String, OrderObject>(result, message, newOrderObject);
  }

  //清台,变更桌台状态
  Future<Tuple2<bool, String>> clearOrderTable(OrderTable table) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      table.tableStatus = OrderTableStatus.Free.value;
      table.tableAction = OrderTableAction.Clear.value;

      //清除pos_order_table表
      queues.add(
          "update pos_order_table set tableStatus='${table.tableStatus}',tableAction='${table.tableAction}' where id = '${table.id}';");

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("清台发生异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "清台失败...";
      } else {
        result = true;
        message = "清台成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "清台发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //清台,开了台尚未点单，直接删除数据
  Future<Tuple2<bool, String>> clearOrderTableFromOrderObject(
      OrderObject orderObject) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      //清除pos_order表
      queues.add("delete from pos_order where id = '${orderObject.id}';");
      //清除pos_order_table表
      queues.add(
          "delete from pos_order_table where orderId = '${orderObject.id}';");

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("清台发生异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "清台失败...";
      } else {
        result = true;
        message = "清台成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "清台发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //转台
  Future<Tuple4<bool, String, OrderObject, StoreTable>>
      updateOrderObjectForTransferTable(
          StoreTable sourceTable, StoreTable targetTable) async {
    bool result = false;
    String message = "";
    OrderObject newOrderObject;
    try {
      var tableId = targetTable.id;
      var tableName = targetTable.name;
      var tableNo = targetTable.no;

      var queues = new Queue<String>();

      //加载转台前的订单信息
      newOrderObject = await OrderUtils.instance
          .builderOrderObject(sourceTable.orderTable.orderId);

      //更新桌台信息中要转台的桌子，其他并台桌子是不能更新的
      if (newOrderObject.tables != null &&
          newOrderObject.tables.any((x) => x.tableId == sourceTable.id)) {
        var table =
            newOrderObject.tables.lastWhere((x) => x.tableId == sourceTable.id);
        table.tableId = tableId;
        table.tableName = tableName;
        table.tableNo = tableNo;

        //更新pos_order_table表的SQL语句
        var orderTableSql =
            "update pos_order_table set tableId = '${table.tableId}',tableNo = '${table.tableNo}',tableName = '${table.tableName}' where id = '${table.id}';";
        queues.add(orderTableSql);
      }

      //更新桌台数据
      newOrderObject.tableId = tableId;
      newOrderObject.tableName = tableName;
      newOrderObject.tableNo = tableNo;
      //更新pos_order表的SQL语句
      var orderSql =
          "update pos_order set tableId = '${newOrderObject.tableId}',tableNo = '${newOrderObject.tableNo}',tableName = '${newOrderObject.tableName}' where id = '${newOrderObject.id}';";
      queues.add(orderSql);

      for (var x in newOrderObject.items) {
        x.tableId = tableId;
        x.tableName = tableName;
        x.tableNo = tableNo;

        var orderItemSql =
            "update pos_order_item set tableId = '${x.tableId}',tableNo = '${x.tableNo}',tableName = '${x.tableName}' where id = '${x.id}' and tableId = '${sourceTable.id}';";
        queues.add(orderItemSql);

        if (x.promotions != null && x.promotions.length > 0) {
          for (var y in x.promotions) {
            y.tableId = tableId;
            y.tableName = tableName;
            y.tableNo = tableNo;

            var orderItemPromotionSql =
                "update pos_order_item_promotion set tableId = '${y.tableId}',tableNo = '${y.tableNo}',tableName = '${y.tableName}' where id = '${y.id}' and tableId = '${sourceTable.id}';";
            queues.add(orderItemPromotionSql);
          }
        }

        if (x.flavors != null && x.flavors.length > 0) {
          for (var z in x.flavors) {
            z.tableId = tableId;
            z.tableName = tableName;
            z.tableNo = tableNo;

            var orderItemMakeSql =
                "update pos_order_item_make set tableId = '${z.tableId}',tableNo = '${z.tableNo}',tableName = '${z.tableName}' where id = '${z.id}' and tableId = '${sourceTable.id}';";
            queues.add(orderItemMakeSql);
          }
        }
      }

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.execute(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("保存转台信息异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "转台保存失败...";
      } else {
        result = true;
        message = "转台保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "保存转台信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple4<bool, String, OrderObject, StoreTable>(
        result, message, newOrderObject, targetTable);
  }

  //并台
  Future<Tuple3<bool, String, OrderObject>> updateOrderObjectForMergeTable(
      StoreTable masterTable, List<StoreTable> mergeList) async {
    bool result = false;
    String message = "";
    OrderObject newOrderObject;
    try {
      String mergeNo = "";
      //生成并台的当天序号
      var mergeNoResult = await OrderUtils.instance.generateMergeNo();
      result = mergeNoResult.item1;
      message = mergeNoResult.item2;
      if (result) {
        //生成并台序号
        mergeNo = mergeNoResult.item3;
        //主单ID
        var orderId = masterTable.orderTable.orderId;
        //主单的订单编号
        var tradeNo = masterTable.orderTable.tradeNo;
        //主单桌台操作
        int tableAction = OrderTableAction.Merge.value;
        //修改人
        String modifyUser = Global.instance.worker.no;
        //修改日期
        String modifyDate =
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");

        //主单的桌台Id,并台后附加了桌台，采用','分割
        var masterTableId = masterTable.orderTable.tableId;
        //主单的桌台编号
        var masterTableNo = masterTable.orderTable.tableNo;
        //主单的桌台名称
        var masterTableName = masterTable.orderTable.tableName;

        var queues = new Queue<String>();

        //桌台当前模式为并台模式
        masterTable.orderTable.tableAction = tableAction;
        //给桌台添加并数字序列
        masterTable.orderTable.serialNo = mergeNo;
        //置为主单
        masterTable.orderTable.masterTable = 1;

        //更新主单开台信息
        queues.add(
            "update pos_order_table set tableAction='$tableAction',serialNo='$mergeNo',masterTable='${masterTable.orderTable.masterTable}',modifyUser='$modifyUser', modifyDate='$modifyDate' where id = '${masterTable.orderTable.id}';");

        FLogger.info("主单：${masterTable.orderTable}");

        mergeList.forEach((element) {
          FLogger.info("并台：$element");
        });

        //遍历待合并的桌台清单：1)主单据合并为一个；2）被合并单据的汇总数据并入主单；3）删除被合并桌台对应的主单
        for (var table in mergeList) {
          //将待合并桌台的信息，汇总到主单
          masterTableId += ",${table.orderTable.tableId}";
          masterTableNo += ",${table.orderTable.tableNo}";
          masterTableName += ",${table.orderTable.tableName}";

          ///删除合并桌台后的主单信息
          if (masterTable.orderTable.orderId != table.orderTable.orderId) {
            queues.add(
                "delete from pos_order where id = '${table.orderTable.orderId}';");
          }

          ///被合并的桌台包含菜品，同时转移菜品
          if (table.orderTable.totalQuantity > 0) {
            //菜品信息转移到主单
            queues.add(
                "update pos_order_item set orderId='$orderId',tradeNo='$tradeNo',modifyUser='$modifyUser', modifyDate='$modifyDate' where tableId = '${table.orderTable.tableId}' and orderId ='${table.orderTable.orderId}';");

            //菜品做法转移到主单
            queues.add(
                "update pos_order_item_make set orderId='$orderId',tradeNo='$tradeNo',modifyUser='$modifyUser', modifyDate='$modifyDate' where tableId = '${table.orderTable.tableId}' and orderId ='${table.orderTable.orderId}';");

            //菜品优惠转移到主单  Promotion
            queues.add(
                "update pos_order_item_promotion set orderId='$orderId',tradeNo='$tradeNo',modifyUser='$modifyUser', modifyDate='$modifyDate' where tableId = '${table.orderTable.tableId}' and orderId ='${table.orderTable.orderId}';");

            //每桌的整单优惠转移到主单
            queues.add(
                "update pos_order_promotion set orderId='$orderId',tradeNo='$tradeNo',modifyUser='$modifyUser', modifyDate='$modifyDate' where tableId = '${table.orderTable.tableId}' and orderId ='${table.orderTable.orderId}';");
          }

          //修改桌台的订单ID
          table.orderTable.orderId = orderId;
          //修改桌台的订单编号
          table.orderTable.tradeNo = tradeNo;
          //桌台当前模式为并台模式
          table.orderTable.tableAction = tableAction;
          //给桌台添加并数字序列
          table.orderTable.serialNo = mergeNo;
          //置为非主单
          table.orderTable.masterTable = 0;

          //更新开台信息
          queues.add(
              "update pos_order_table set orderId='$orderId',tradeNo='$tradeNo',tableAction='$tableAction',serialNo='$mergeNo',masterTable='${table.orderTable.masterTable}',modifyUser='$modifyUser', modifyDate='$modifyDate' where id = '${table.orderTable.id}';");
        }

        ///将待合并的桌台的消费数据合并到主桌
        //并台后主单的总数量
        var totalQuantity = masterTable.orderTable.totalQuantity +
            mergeList
                .map((p) => p.orderTable.totalQuantity)
                .fold(0, (prev, quantity) => prev + quantity);
        //并台后主单的总金额
        var totalAmount = masterTable.orderTable.totalAmount +
            mergeList
                .map((p) => p.orderTable.totalAmount)
                .fold(0, (prev, amount) => prev + amount);
        //并台后主单的总退数量
        var totalRefundQuantity = masterTable.orderTable.totalRefund +
            mergeList
                .map((p) => p.orderTable.totalRefund)
                .fold(0, (prev, refund) => prev + refund);
        //并台后主单的总退金额
        var totalRefundAmount = masterTable.orderTable.totalRefundAmount +
            mergeList
                .map((p) => p.orderTable.totalRefundAmount)
                .fold(0, (prev, refundAmount) => prev + refundAmount);
        //并台后主单的总优惠金额
        var discountAmount = masterTable.orderTable.discountAmount +
            mergeList
                .map((p) => p.orderTable.discountAmount)
                .fold(0, (prev, discountAmount) => prev + discountAmount);
        //并台后主单的总应收金额
        var receivableAmount = masterTable.orderTable.receivableAmount +
            mergeList
                .map((p) => p.orderTable.receivableAmount)
                .fold(0, (prev, receivableAmount) => prev + receivableAmount);
        //并台后主单的总赠送数量
        var totalGiveQuantity = masterTable.orderTable.totalGive +
            mergeList
                .map((p) => p.orderTable.totalGive)
                .fold(0, (prev, totalGive) => prev + totalGive);
        //并台后主单的总赠送金额
        var totalGiveAmount = masterTable.orderTable.totalGiveAmount +
            mergeList
                .map((p) => p.orderTable.totalGiveAmount)
                .fold(0, (prev, giveAmount) => prev + giveAmount);
        //并台后主单的总人数
        var totalPeople = masterTable.orderTable.people +
            mergeList
                .map((p) => p.orderTable.people)
                .fold(0, (prev, people) => prev + people);

        //桌台的消费总金额
        queues.add(
            "update pos_order set totalQuantity='$totalQuantity',amount='$totalAmount',discountAmount='$discountAmount',receivableAmount='$receivableAmount',tableNo='$masterTableNo',tableName='$masterTableName',people='$totalPeople',modifyUser='$modifyUser', modifyDate='$modifyDate' where id = '$orderId';");

        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.execute(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e) {
            FLogger.error("保存并台信息异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "并台保存失败...";
        } else {
          result = true;
          message = "并台保存成功,共<${queues.length}>条...";
        }
      }
    } catch (e, stack) {
      result = false;
      message = "保存并台信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple3<bool, String, OrderObject>(result, message, newOrderObject);
  }

  //拆台
  Future<Tuple2<bool, String>> splitOrderTableFromOrderObject(
      OrderObject orderObject) async {
    bool result = false;
    String message = "";
    try {
      //复制新对象,处理主桌数据
      OrderObject masterOrderObject = OrderObject.clone(orderObject);

      var queues = new Queue<String>();

      var finishDate = masterOrderObject.finishDate;

      orderObject.tables.sort((a, b) => b.masterTable.compareTo(a.masterTable));

      for (var orderTable in orderObject.tables) {
        if (orderTable.masterTable == 1) {
          //主桌，当前订单就是主桌的，只需要重算就可以
          orderTable.masterTable = 0;
          orderTable.tableAction = OrderTableAction.Open.value;
          orderTable.serialNo = "";
          orderTable.modifyUser = Global.instance.worker.name;
          orderTable.modifyDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");

          masterOrderObject.tableNo = orderTable.tableNo;
          masterOrderObject.tableName = orderTable.tableName;
          masterOrderObject.tables = <OrderTable>[];
          masterOrderObject.tables.add(orderTable);
          masterOrderObject.modifyUser = Global.instance.worker.name;
          masterOrderObject.modifyDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");

          //对主桌重算订单
          OrderUtils.instance.calculateOrderObject(masterOrderObject);

          //更新主桌订单信息
          queues.add(
              "update pos_order set tableNo='${masterOrderObject.tableNo}',tableName='${masterOrderObject.tableName}',modifyUser='${masterOrderObject.modifyUser}', modifyDate='${masterOrderObject.modifyDate}' where id = '${masterOrderObject.id}';");
          //更新主桌开台信息
          queues.add(
              "update pos_order_table set tableAction='${orderTable.tableAction}',serialNo='${orderTable.serialNo}',masterTable='${orderTable.masterTable}',modifyUser='${orderTable.modifyUser}', modifyDate='${orderTable.modifyDate}' where id = '${orderTable.id}';");

          continue;
        }

        //构建新订单
        var newOrderObject = OrderObject.newOrderObject();
        //生成新的退单单号
        var ticketNoResult = await OrderUtils.instance.generateTicketNo();
        if (ticketNoResult.item1) {
          newOrderObject.tradeNo = ticketNoResult.item3;
          //中餐单
          newOrderObject.orderUploadSource = OrderUploadSource.ChineseFood;
          newOrderObject.postWay = PostWay.ForHere;
          newOrderObject.orderSource = OrderSource.CashRegister;

          //orderTable.id = IdWorkerUtils.getInstance().generate().toString();
          //订单ID赋值到桌台信息
          orderTable.orderId = newOrderObject.id;
          //订单号赋值到桌台信息
          orderTable.tradeNo = newOrderObject.tradeNo;
          //桌台的操作模式
          orderTable.tableAction = OrderTableAction.Open.value;
          orderTable.serialNo = "";
          orderTable.masterTable = 0;

          orderTable.modifyUser = Global.instance.worker.name;
          orderTable.modifyDate = DateUtils.formatDate(DateTime.now(),
              format: "yyyy-MM-dd HH:mm:ss");

          //变更订单对应的桌台信息
          queues.add(
              "update pos_order_table set orderId='${orderTable.orderId}',tradeNo='${orderTable.tradeNo}',tableAction='${orderTable.tableAction}',masterTable='${orderTable.masterTable}',serialNo='${orderTable.serialNo}',modifyUser='${orderTable.modifyUser}', modifyDate='${orderTable.modifyDate}' where id = '${orderTable.id}';");

          //桌台编号
          newOrderObject.tableNo = orderTable.tableNo;
          //桌台名称
          newOrderObject.tableName = orderTable.tableName;
          //桌台实际座的人数
          newOrderObject.people = orderTable.people;

          //将当前桌台压入订单对象中
          newOrderObject.tables.add(orderTable);

          //修改item订单归属
          var items = orderObject.items
              .where((x) => x.tableId == orderTable.tableId)
              .toList();

          for (var x in items) {
            x.orderId = newOrderObject.id;
            x.tradeNo = newOrderObject.tradeNo;

            //变更桌台商品的订单归属
            queues.add(
                "update pos_order_item set orderId='${x.orderId}',tradeNo='${x.tradeNo}' where id = '${x.id}';");

            //修改商品做法
            for (var f in x.flavors) {
              f.orderId = newOrderObject.id;
              f.tradeNo = newOrderObject.tradeNo;

              //变更桌台商品的订单归属
              queues.add(
                  "update pos_order_item_make set orderId='${f.orderId}',tradeNo='${f.tradeNo}' where id = '${f.id}';");
            }
            //单品促销
            for (var d in x.promotions) {
              d.orderId = newOrderObject.id;
              d.tradeNo = newOrderObject.tradeNo;

              //变更桌台商品的订单归属
              queues.add(
                  "update pos_order_item_promotion set orderId='${d.orderId}',tradeNo='${d.tradeNo}' where id = '${d.id}';");
            }
          }
          newOrderObject.items = items;

          //重算新订单的主单
          OrderUtils.instance.calculateOrderObject(newOrderObject);

          //pos_order表的SQL语句,创建一个新的订单
          var orderSql = await OrderUtils.instance
              .buildOrderObjectSql(newOrderObject, finishDate);
          if (orderSql.item1) {
            queues.add(orderSql.item3);
          }
        }
      }

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.rawInsert(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("保存拆台订单异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "拆台保存失败...";
      } else {
        result = true;
        message = "拆台保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "拆台信息异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  /// 下单操作，goBack参数标识是点击下单事件还是返回事件
  Future<Tuple3<bool, String, List<OrderItem>>> tryOrder(
      OrderObject orderObject, List<OrderTable> tables,
      {bool goBack = false}) async {
    bool result = true;
    String message = "尝试下单发生错误";
    List<OrderItem> newItemsList = <OrderItem>[];
    try {
      var queues = new Queue<String>();

      //订单中已经下单的商品
      var orderList = orderObject.items
          .where((x) => x.orderRowStatus == OrderRowStatus.Order)
          .toList();
      print("已经下单的商品数量：${orderList.length}");
      //订单中新增的商品
      var newOrderList = orderObject.items
          .where((x) => x.orderRowStatus == OrderRowStatus.New)
          .toList();
      print("订单中新增未保存的数量：${newOrderList.length}");

      //待存储的全部单品明细
      List<OrderItem> items = <OrderItem>[];
      //待存储的全部单品做法明细
      List<OrderItemMake> flavors = <OrderItemMake>[];
      //待存储的全部单品优惠明细
      List<OrderItemPromotion> promotions = <OrderItemPromotion>[];

      //并台点单的情况下需要标识批量为桌台添加菜品的标志，主要解决删除和修改数量的时候，并台处理
      var tableBatchTag = ObjectIdUtils.getInstance().generate();

      //菜品下单针对多桌或单桌，统一采用集合模式处理
      for (var table in tables) {
        print(">>>>#####处理桌台：${table.tableName}");

        //订单中等待下单的商品
        var waitOrderList = orderObject.items
            .where((x) =>
                x.tableId == table.tableId &&
                x.orderRowStatus == OrderRowStatus.Save)
            .toList();

        //遍历新增单品信息，进行数据加工处理,单桌点单过程中单品ID、做法ID、单品优惠ID已经生成
        if (newOrderList.length > 0) {
          //相同规格的数据叠加
          int specNo = 0;
          for (var item in newOrderList) {
            //桌台菜名最大序号,新增的菜品序号自动+1
            table.maxOrderNo += 1;
            //复制新增的菜品行对象
            //var item = OrderItem.clone(x);
            //生成新的ID,避免多桌操作引发的ID重复
            item.id = IdWorkerUtils.getInstance().generate().toString();
            //设置桌台ID
            item.tableId = table.tableId;
            //设置桌台名称
            item.tableName = table.tableName;
            //设置桌台编号
            item.tableNo = table.tableNo;
            //设置行显示序号
            item.orderNo = table.maxOrderNo;
            //不是返回操作，设置为下单状态
            item.orderRowStatus =
                goBack ? OrderRowStatus.Save : OrderRowStatus.Order;
            //并台,多桌台情况下，重置批号，确保统一批号添加的
            if (tables.length > 1) {
              //如果订单中有相同规格ID的商品,标识后面附加相同规格的数量合计
              var specCount =
                  orderObject.items.count((x) => x.specId == item.specId);
              specNo++;
              item.tableBatchTag =
                  "$tableBatchTag${specCount > 0 ? '_${specCount + specNo}' : ''}";
              print("相同规格情况下同一批点单：${item.tableBatchTag}");
            }

            //将待保存的OrderItem对象压入列表
            items.add(item);

            //修改做法对应的ID和ItemId
            if (item.flavors != null) {
              for (var f in item.flavors) {
                //生成新的ID,避免多桌操作引发的ID重复
                f.id = IdWorkerUtils.getInstance().generate().toString();
                //重置ItemId
                f.itemId = item.id;
                //设置桌台ID
                f.tableId = table.tableId;
                //设置桌台名称
                f.tableName = table.tableName;
                //设置桌台编号
                f.tableNo = table.tableNo;

                //将待保存的FlavorItem对象压入列表
                flavors.add(f);
              }
            }

            //修改单品优惠对应的ItemId
            if (item.promotions != null) {
              for (var p in item.promotions) {
                //生成新的ID,避免多桌操作引发的ID重复
                p.id = IdWorkerUtils.getInstance().generate().toString();
                //重置ItemId
                p.itemId = item.id;
                //设置桌台ID
                p.tableId = table.tableId;
                //设置桌台名称
                p.tableName = table.tableName;
                //设置桌台编号
                p.tableNo = table.tableNo;
                //将待保存的PromotionItem对象压入列表
                promotions.add(p);
              }
            }
            //行重算
            OrderUtils.instance.calculateOrderItem(item);

            ///通知购物车
            changeShopCart(orderObject, table, item);
          }
          //pos_order_item表的SQL语句,构建本次新增商品的下单
          var orderItemSql = await OrderUtils.instance.buildOrderItemSql(
              orderObject, orderObject.finishDate,
              newItemList: newOrderList);
          if (orderItemSql.item1) {
            queues.addAll(orderItemSql.item3);
          }
        }

        //直接操作的下单，有等待下单的数据
        if (!goBack && waitOrderList.length > 0) {
          for (var item in waitOrderList) {
            item.orderRowStatus = OrderRowStatus.Order;
            queues.add(
                "update pos_order_item set orderRowStatus = '${item.orderRowStatus.value}' where id = '${item.id}';");
          }
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        double placeOrders = 0;
        if (goBack) {
          placeOrders = orderList
              .where((x) => x.tableId == table.tableId)
              .map((e) => e.quantity)
              .fold(0, (prev, quantity) => prev + quantity);
        } else {
          placeOrders = orderObject.items
              .where((x) => x.tableId == table.tableId)
              .map((e) => e.quantity)
              .fold(0, (prev, quantity) => prev + quantity);
        }
        table.placeOrders = placeOrders;

        //保存影响桌台数据信息
        String orderTableSql = sprintf(
            "update pos_order_table set placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s' where id = '%s';",
          [
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      bool hasFailed = true;
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        try {
          var batch = txn.batch();
          queues.forEach((obj) {
            batch.execute(obj);
          });
          await batch.commit(noResult: false);
          hasFailed = false;
        } catch (e) {
          FLogger.error("桌台点单异常:" + e.toString());
        }
      });

      if (hasFailed) {
        result = false;
        message = "点单保存失败...";
      } else {
        result = true;
        message = "点单保存成功,共<${queues.length}>条...";
      }
    } catch (e, stack) {
      result = false;
      message = "尝试下单发生错误";

      FlutterChain.printError(e, stack);
      FLogger.error("尝试下单发生异常:" + e.toString());
    } finally {
      for (var table in tables) {
        print(">>>>#####通知桌台：${table.tableName}");

        notifyShopCart(orderObject, table);
      }
    }

    return Tuple3(result, message, newItemsList);
  }

  ///购物车变更通知
  Future<Tuple2<bool, String>> changeShopCart(
      OrderObject orderObject, OrderTable table, OrderItem item) async {
    bool result = false;
    String message = "";

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Meal);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "meal.shopcart.change";

      var data = {
        "storeId": Global.instance.authc?.storeId,
        "storeNo": Global.instance.authc?.storeNo,
        "tableId": table.tableId,
        "tableNo": table.tableNo,
        "tableName": table.tableName,
        "productId": item.productId,
        "name": item.productName,
        "barCode": item.barCode,
        "specId": item.specId,
        "specName": item.specName,
        "storageAddress": "",
        "salePrice": item.salePrice,
        "vipPrice": item.vipPrice,
        "price": item.price,
        "quantity": item.quantity,
        "flavorDescription": item.flavorNames,
        "flavorAmount": item.flavorAmount,
        "openId": orderObject.id,
        "addUser": Global.instance.worker.name,
        "headimgUrl": "",
      };
      List<Map<String, dynamic>> makes = [];
      for (var flavor in item.flavors) {
        var f = {
          "makeId": flavor.id,
          "code": flavor.code,
          "name": flavor.name,
          "qtyFlag": flavor.qtyFlag,
          "quantity": flavor.quantity,
          "salePrice": flavor.salePrice,
          "type": flavor.type,
          "isRadio": flavor.isRadio,
          "groupId": flavor.group,
          "amount": flavor.amount,
          "hand": flavor.hand,
          "baseQuantity": flavor.baseQuantity,
          "description": flavor.description,
        };

        makes.add(f);
      }

      data["makes"] = makes;

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var resp =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      print("@@@@@@@@@@@@@@@####>>>>>$resp");
    } catch (e, stack) {
      result = false;
      message = "购物车变更通知发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  ///购物车变更通知
  Future<Tuple2<bool, String>> notifyShopCart(
      OrderObject orderObject, OrderTable table) async {
    bool result = false;
    String message = "";

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Meal);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "meal.shopcart.notify";

      var data = {
        "orderId": orderObject.id,
        "tradeNo": orderObject.tradeNo,
        "storeId": Global.instance.authc?.storeId,
        "storeNo": Global.instance.authc?.storeNo,
        "tableId": table.tableId,
      };

      print("@@@@@@@@@@@@@@@####>>>>>$data");

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var resp =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      print("@@@@@@@@@@@@@@@####>>>>>$resp");
    } catch (e, stack) {
      result = false;
      message = "桌台通知发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  ///支付完成通知
  Future<Tuple2<bool, String>> notifyPayOrder(OrderObject orderObject) async {
    bool result = false;
    String message = "";

    try {
      for (var table in orderObject.tables) {
        OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Meal);
        var parameters = OpenApiUtils.instance.newParameters(api: api);
        parameters["name"] = "meal.payorder.notify";

        var data = {
          "tradeNo": orderObject.tradeNo,
          "storeId": Global.instance.authc?.storeId,
          "tableId": table.tableId,
        };

        print("@@@@@@@@@@@@@@@####>>>>>$data");

        parameters["data"] = json.encode(data);
        List<String> ignoreParameters = new List<String>();
        var sign =
            OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
        parameters["sign"] = sign;

        var resp =
            await HttpUtils.instance.post(api, api.url, params: parameters);

        print("@@@@@@@@@@@@@@@####>>>>>$resp");
      }
    } catch (e, stack) {
      result = false;
      message = "桌台通知发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //删除单品
  Future<Tuple2<bool, String>> deleteOrderItem(OrderObject orderObject,
      OrderItem orderItem, List<OrderTable> tables) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      List<OrderItem> newItems = <OrderItem>[];
      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //商品规格ID
        var specId = orderItem.specId;
        //商品数量
        var quantity = orderItem.quantity;
        //并台同一批添加商品的标识
        var tableBatchTag = orderItem.tableBatchTag;

        ///获取桌台的未下单商品的清单，同一张桌台、规格、数量、并台标识都相同的条件
        var newOrderList = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.specId == specId &&
                x.quantity == quantity &&
                x.tableBatchTag == tableBatchTag &&
                (x.orderRowStatus == OrderRowStatus.New ||
                    x.orderRowStatus == OrderRowStatus.Save))
            .toList();

        if (newOrderList.length > 0) {
          newItems.addAll(newOrderList);
        }
      }

      //复制新对象，为桌台和整单重算做准备
      var newOrderObject = OrderObject.clone(orderObject);
      //开始删除
      for (var item in newItems) {
        //清除pos_order_item表
        queues.add(
            "delete from pos_order_item where orderId='${newOrderObject.id}' and id='${item.id}';");

        //删除主单对象中的行记录
        newOrderObject.items.removeWhere((x) => x.id == item.id);

        //清除pos_order_item_make表
        if (item.flavors.length > 0) {
          queues.add(
              "delete from pos_order_item_make where orderId='${newOrderObject.id}' and itemId='${item.id}';");
          //删除订单明细对应的做法
          newOrderObject.items.map((e) {
            e.flavors.removeWhere(
                (f) => f.orderId == newOrderObject.id && f.itemId == item.id);
          });
        }
        //清除pos_order_item_promotion表
        if (item.promotions.length > 0) {
          queues.add(
              "delete from pos_order_item_promotion where orderId='${newOrderObject.id}' and itemId='${item.id}';");
          //删除订单明细对应的优惠
          newOrderObject.items.map((e) {
            e.promotions.removeWhere(
                (p) => p.orderId == newOrderObject.id && p.itemId == item.id);
          });
        }
      }

      //重算桌台和主单
      for (var table in tables) {
        //桌台重算
        OrderUtils.instance.calculateTable(newOrderObject, table);

        //已经下单的商品数量
        table.placeOrders = newOrderObject.items
            .where((x) =>
                x.tableId == table.tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);

        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(newOrderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            newOrderObject.receivedAmount,
            newOrderObject.paidAmount,
            newOrderObject.totalQuantity,
            newOrderObject.amount,
            newOrderObject.totalGiftQuantity,
            newOrderObject.totalGiftAmount,
            newOrderObject.totalRefundQuantity,
            newOrderObject.totalRefundAmount,
            newOrderObject.discountAmount,
            newOrderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            newOrderObject.items.length,
            newOrderObject.pays.length,
            newOrderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e) {
            FLogger.error("删除单品发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "删除单品失败...";
        } else {
          result = true;
          message = "删除单品成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "删除单品发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //修改数量
  Future<Tuple2<bool, String>> changeQuantity(OrderObject orderObject,
      OrderItem orderItem, List<OrderTable> tables, double inputValue) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //商品规格ID
        var specId = orderItem.specId;
        //商品数量
        var quantity = orderItem.quantity;
        //并台同一批添加商品的标识
        var tableBatchTag = orderItem.tableBatchTag;

        ///获取桌台的未下单商品的清单，桌台、规格、数量、批量添加标识、修改数量的商品ID
        var newOrderList = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.specId == specId &&
                x.quantity == quantity &&
                x.tableBatchTag == tableBatchTag &&
                (x.orderRowStatus == OrderRowStatus.New ||
                    x.orderRowStatus == OrderRowStatus.Save))
            .toList();

        for (var item in newOrderList) {
          item.quantity = inputValue;

          ///重新计算行小计
          OrderUtils.instance.calculateOrderItem(item);

          String orderItemSql = sprintf(
              "update pos_order_item set rquantity='%s',ramount='%s',rreason='%s',giftQuantity='%s',giftAmount='%s',giftReason='%s', totalReceivableAmount='%s', totalDiscountAmount='%s', receivableAmount='%s',discountAmount='%s', flavorNames='%s', flavorReceivableAmount='%s', flavorDiscountAmount='%s', flavorAmount='%s', flavorCount='%s',  totalAmount='%s', quantity='%s',amount='%s' where id='%s';",
              [
                item.refundQuantity,
                item.refundAmount,
                item.refundReason,
                item.giftQuantity,
                item.giftAmount,
                item.giftReason,
                item.totalReceivableAmount,
                item.totalDiscountAmount,
                item.receivableAmount,
                item.discountAmount,
                item.flavorNames,
                item.flavorReceivableAmount,
                item.flavorDiscountAmount,
                item.flavorAmount,
                item.flavors.length,
                item.totalAmount,
                item.quantity,
                item.amount,
                item.id,
              ]);

          queues.add(orderItemSql);
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        table.placeOrders = orderObject.items
            .where((x) =>
                x.tableId == table.tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);

        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            orderObject.receivedAmount,
            orderObject.paidAmount,
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.pays.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e) {
            FLogger.error("修改单品数量发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "修改单品数量失败...";
        } else {
          result = true;
          message = "修改单品数量成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "修改单品数量发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //赠送
  Future<Tuple2<bool, String>> changeGift(
      OrderObject orderObject,
      OrderItem orderItem,
      List<OrderTable> tables,
      double giftQuantity,
      String giftReason,
      {bool cancelGift = false}) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //商品规格ID
        var specId = orderItem.specId;
        //商品数量
        var quantity = orderItem.quantity;
        //并台同一批添加商品的标识
        var tableBatchTag = orderItem.tableBatchTag;

        ///获取桌台的未下单商品的清单，桌台、规格、数量、批量添加标识、修改数量的商品ID
        var newOrderList = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.specId == specId &&
                x.quantity == quantity &&
                x.tableBatchTag == tableBatchTag)
            .toList();

        for (var orderItem in newOrderList) {
          //复制优惠计算前已经有的优惠活动，主要处理新增、修改、删除SQL语句
          var historyPromotions = orderItem.promotions
              .map((e) => OrderItemPromotion.clone(e))
              .toList();

          //修改行记录的赠送信息
          orderItem.giftQuantity = giftQuantity;
          //赠菜原因
          orderItem.giftReason = giftReason;
          //取消赠送
          if (cancelGift) {
            orderItem.giftQuantity = 0;
            orderItem.giftReason = "";
          }

          //重新计算行小计
          OrderUtils.instance.calculateOrderItem(orderItem);

          //赠送优先级最高，需要清除之前的优惠
          for (var p in historyPromotions) {
            //删除数据库的行记录对应的赠送优惠记录
            queues.add(
                "delete from pos_order_item_promotion where orderId='${orderItem.orderId}' and itemId='${orderItem.id}';");
          }

          for (var promotion in orderItem.promotions) {
            //添加行记录的赠送优惠pos_order_item_promotion表的SQL语句
            var orderItemPromotion = OrderUtils.instance
                .orderItemPromotionToSql(promotion, orderItem.finishDate);
            if (orderItemPromotion.item1) {
              queues.add(orderItemPromotion.item3);
            }
          }

          String orderItemSql = sprintf(
              "update pos_order_item set rquantity='%s',ramount='%s',rreason='%s',giftQuantity='%s',giftAmount='%s',giftReason='%s', totalReceivableAmount='%s', totalDiscountAmount='%s', receivableAmount='%s',discountAmount='%s', flavorNames='%s', flavorReceivableAmount='%s', flavorDiscountAmount='%s', flavorAmount='%s', flavorCount='%s',  totalAmount='%s', quantity='%s',amount='%s' where id='%s';",
              [
                orderItem.refundQuantity,
                orderItem.refundAmount,
                orderItem.refundReason,
                orderItem.giftQuantity,
                orderItem.giftAmount,
                orderItem.giftReason,
                orderItem.totalReceivableAmount,
                orderItem.totalDiscountAmount,
                orderItem.receivableAmount,
                orderItem.discountAmount,
                orderItem.flavorNames,
                orderItem.flavorReceivableAmount,
                orderItem.flavorDiscountAmount,
                orderItem.flavorAmount,
                orderItem.flavors.length,
                orderItem.totalAmount,
                orderItem.quantity,
                orderItem.amount,
                orderItem.id,
              ]);

          queues.add(orderItemSql);
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        table.placeOrders = orderObject.items
            .where((x) =>
                x.tableId == table.tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);
        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            orderObject.receivedAmount,
            orderObject.paidAmount,
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.pays.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e) {
            FLogger.error("赠送单品发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "赠送单品失败...";
        } else {
          result = true;
          message = "赠送单品成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "赠送单品发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //退菜
  Future<Tuple2<bool, String>> changeRefundQuantity(
      OrderObject orderObject,
      OrderItem orderItem,
      List<OrderTable> tables,
      double refundQuantity,
      String refundReason) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //商品规格ID
        var specId = orderItem.specId;
        //商品数量
        var quantity = orderItem.quantity;
        //并台同一批添加商品的标识
        var tableBatchTag = orderItem.tableBatchTag;

        ///获取桌台的未下单商品的清单，桌台、规格、数量、批量添加标识、修改数量的商品ID
        var newOrderList = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.specId == specId &&
                x.quantity == quantity &&
                x.tableBatchTag == tableBatchTag &&
                x.orderRowStatus == OrderRowStatus.Order)
            .toList();

        for (var orderItem in newOrderList) {
          //修改行记录的赠送信息
          orderItem.refundQuantity = refundQuantity;
          //赠菜原因,如果退数量为0，视为清除退菜
          orderItem.refundReason = refundReason;

          //如果全部退,清理赠送，清理优惠列表
          if (orderItem.quantity == orderItem.refundQuantity) {
            //删除数据库的行记录对应的赠送优惠记录
            queues.add(
                "delete from pos_order_item_promotion where orderId='${orderItem.orderId}' and itemId='${orderItem.id}';");
          } else {
            //退数量+赠数量，如果大于总数量，删除赠送的优惠
            if ((orderItem.refundQuantity + orderItem.giftQuantity) >
                orderItem.quantity) {
              //删除数据库的行记录对应的赠送优惠记录
              queues.add(
                  "delete from pos_order_item_promotion where orderId='${orderItem.orderId}' and itemId='${orderItem.id}' and promotionType = '${PromotionType.Gift.value}';");
            }
          }

          //重新计算行小计
          OrderUtils.instance.calculateOrderItem(orderItem);

          String orderItemSql = sprintf(
              "update pos_order_item set rquantity='%s',ramount='%s',rreason='%s',giftQuantity='%s',giftAmount='%s',giftReason='%s', totalReceivableAmount='%s', totalDiscountAmount='%s', receivableAmount='%s',discountAmount='%s', flavorNames='%s', flavorReceivableAmount='%s', flavorDiscountAmount='%s', flavorAmount='%s', flavorCount='%s',  totalAmount='%s', quantity='%s',amount='%s' where id='%s';",
              [
                orderItem.refundQuantity,
                orderItem.refundAmount,
                orderItem.refundReason,
                orderItem.giftQuantity,
                orderItem.giftAmount,
                orderItem.giftReason,
                orderItem.totalReceivableAmount,
                orderItem.totalDiscountAmount,
                orderItem.receivableAmount,
                orderItem.discountAmount,
                orderItem.flavorNames,
                orderItem.flavorReceivableAmount,
                orderItem.flavorDiscountAmount,
                orderItem.flavorAmount,
                orderItem.flavors.length,
                orderItem.totalAmount,
                orderItem.quantity,
                orderItem.amount,
                orderItem.id,
              ]);

          queues.add(orderItemSql);
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        table.placeOrders = orderObject.items
            .where((x) =>
                x.tableId == table.tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);

        //保存影响桌台数据信息
        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            orderObject.receivedAmount,
            orderObject.paidAmount,
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.pays.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e) {
            FLogger.error("单品退货发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "单品退货失败...";
        } else {
          result = true;
          message = "单品退货成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "单品退货发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //整单折扣
  Future<Tuple2<bool, String>> changeOrderDiscount(
      OrderObject orderObject, double discountRate, String discountReason,
      {bool restoreOriginalPrice = false}) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      //整单折扣
      OrderPromotion orderPromotion;
      //取消整单折扣
      if (restoreOriginalPrice) {
        if (orderObject.promotions != null &&
            orderObject.promotions
                .any((x) => x.promotionType == PromotionType.OrderDiscount)) {
          orderPromotion = orderObject.promotions
              .lastWhere((x) => x.promotionType == PromotionType.OrderDiscount);
        }
        //存在整单折扣，清理主表整单折扣信息和明细表折扣信息
        if (orderPromotion != null) {
          String promotionId = orderPromotion.id;
          queues
              .add("delete from pos_order_promotion where id='$promotionId';");
          orderObject.promotions.removeWhere((x) => x.id == promotionId);

          for (var item in orderObject.items) {
            item.promotions.removeWhere((x) => x.relationId == promotionId);
          }
          queues.add(
              "delete from pos_order_item_promotion where relationId='$promotionId';");
        }
      } else {
        if (orderObject.promotions != null &&
            orderObject.promotions
                .any((x) => x.promotionType == PromotionType.OrderDiscount)) {
          orderPromotion = orderObject.promotions
              .lastWhere((x) => x.promotionType == PromotionType.OrderDiscount);
        } else {
          orderPromotion = PromotionUtils.instance.newOrderPromotion(
              orderObject,
              promotionType: PromotionType.OrderDiscount);
          orderObject.promotions.add(orderPromotion);
        }

        orderPromotion.onlineFlag = 0;
        orderPromotion.reason = discountReason;
        orderPromotion.amount = orderObject.amount;
        orderPromotion.discountRate =
            OrderUtils.instance.toRound(discountRate / 100);
        orderPromotion.discountAmount = OrderUtils.instance
            .toRound(orderObject.amount * orderPromotion.discountRate);
        orderPromotion.enabled = 0;

        PromotionUtils.instance.calculate(orderObject, orderPromotion);

        //先去除已经存在的整单折扣优惠
        queues.add(
            "delete from pos_order_promotion where id='${orderPromotion.id}';");
        queues.add(
            "delete from pos_order_item_promotion where relationId='${orderPromotion.id}';");

        //将重算后的整单折扣入库,pos_order_promotion表的SQL语句
        var orderPromotionSql = OrderUtils.instance
            .orderPromotionToSql(orderPromotion, orderObject.finishDate);
        if (orderPromotionSql.item1) {
          queues.add(orderPromotionSql.item3);
        }
      }

      var tables = orderObject.tables;
      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //当前桌台的全部点单商品
        var tableOrderItemList =
            orderObject.items.where((x) => x.tableId == tableId).toList();
        //桌台的单品中包含整单折扣的优惠计入数据库
        for (var orderItem in tableOrderItemList) {
          if (orderItem.promotions
              .any((x) => x.promotionType == PromotionType.OrderDiscount)) {
            var promotion = orderItem.promotions.lastWhere(
                (x) => x.promotionType == PromotionType.OrderDiscount);

            var orderItemPromotionSql = OrderUtils.instance
                .orderItemPromotionToSql(promotion, orderObject.finishDate);
            if (orderItemPromotionSql.item1) {
              queues.add(orderItemPromotionSql.item3);
            }
          }

          //重新计算行小计
          OrderUtils.instance.calculateOrderItem(orderItem);

          String orderItemSql = sprintf(
              "update pos_order_item set rquantity='%s',ramount='%s',rreason='%s',giftQuantity='%s',giftAmount='%s',giftReason='%s', totalReceivableAmount='%s', totalDiscountAmount='%s', receivableAmount='%s',discountAmount='%s', flavorNames='%s', flavorReceivableAmount='%s', flavorDiscountAmount='%s', flavorAmount='%s', flavorCount='%s',  totalAmount='%s', quantity='%s',amount='%s' where id='%s';",
              [
                orderItem.refundQuantity,
                orderItem.refundAmount,
                orderItem.refundReason,
                orderItem.giftQuantity,
                orderItem.giftAmount,
                orderItem.giftReason,
                orderItem.totalReceivableAmount,
                orderItem.totalDiscountAmount,
                orderItem.receivableAmount,
                orderItem.discountAmount,
                orderItem.flavorNames,
                orderItem.flavorReceivableAmount,
                orderItem.flavorDiscountAmount,
                orderItem.flavorAmount,
                orderItem.flavors.length,
                orderItem.totalAmount,
                orderItem.quantity,
                orderItem.amount,
                orderItem.id,
              ]);

          queues.add(orderItemSql);
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        table.placeOrders = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);

        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            orderObject.receivedAmount,
            orderObject.paidAmount,
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.pays.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e, stack) {
            FlutterChain.printError(e, stack);
            FLogger.error("整单折扣发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "整单折扣失败...";
        } else {
          result = true;
          message = "整单折扣成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "整单折扣发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }

  //整单议价
  Future<Tuple2<bool, String>> changeOrderBargain(
      OrderObject orderObject, double inputAmount, String bargainReason,
      {bool restoreOriginalPrice = false}) async {
    bool result = false;
    String message = "";
    try {
      var queues = new Queue<String>();

      //整单议价
      OrderPromotion orderPromotion;
      //取消整单议价
      if (restoreOriginalPrice) {
        if (orderObject.promotions != null &&
            orderObject.promotions
                .any((x) => x.promotionType == PromotionType.OrderBargain)) {
          orderPromotion = orderObject.promotions
              .lastWhere((x) => x.promotionType == PromotionType.OrderBargain);
        }
        //存在整单议价，清理主表整单议价信息和明细表议价信息
        if (orderPromotion != null) {
          String promotionId = orderPromotion.id;
          queues
              .add("delete from pos_order_promotion where id='$promotionId';");
          orderObject.promotions.removeWhere((x) => x.id == promotionId);

          for (var item in orderObject.items) {
            item.promotions.removeWhere((x) => x.relationId == promotionId);
          }
          queues.add(
              "delete from pos_order_item_promotion where relationId='$promotionId';");
        }
      } else {
        if (orderObject.promotions != null &&
            orderObject.promotions
                .any((x) => x.promotionType == PromotionType.OrderBargain)) {
          orderPromotion = orderObject.promotions
              .lastWhere((x) => x.promotionType == PromotionType.OrderBargain);
        } else {
          orderPromotion = PromotionUtils.instance.newOrderPromotion(
              orderObject,
              promotionType: PromotionType.OrderBargain);
          orderObject.promotions.add(orderPromotion);
        }

        orderPromotion.onlineFlag = 0;
        orderPromotion.reason = bargainReason;
        orderPromotion.bargainPrice = inputAmount;
        orderPromotion.amount = inputAmount;

        if (orderObject.amount == 0) {
          orderPromotion.discountRate = 100;
        } else {
          orderPromotion.discountRate =
              OrderUtils.instance.toRound(inputAmount / orderObject.amount);
        }

        orderPromotion.discountAmount =
            OrderUtils.instance.toRound(orderObject.amount - inputAmount);
        orderPromotion.enabled = 0;

        PromotionUtils.instance.calculate(orderObject, orderPromotion);

        //先去除已经存在的整单折扣优惠
        queues.add(
            "delete from pos_order_promotion where id='${orderPromotion.id}';");
        queues.add(
            "delete from pos_order_item_promotion where relationId='${orderPromotion.id}';");

        //将重算后的整单议价入库,pos_order_promotion表的SQL语句
        var orderPromotionSql = OrderUtils.instance
            .orderPromotionToSql(orderPromotion, orderObject.finishDate);
        if (orderPromotionSql.item1) {
          queues.add(orderPromotionSql.item3);
        }
      }

      var tables = orderObject.tables;
      for (var table in tables) {
        print("桌台名称:${table.tableName}");

        //桌台ID
        var tableId = table.tableId;
        //当前桌台的全部点单商品
        var tableOrderItemList =
            orderObject.items.where((x) => x.tableId == tableId).toList();
        //桌台的单品中包含整单折扣的优惠计入数据库
        for (var orderItem in tableOrderItemList) {
          if (orderItem.promotions
              .any((x) => x.promotionType == PromotionType.OrderBargain)) {
            var promotion = orderItem.promotions.lastWhere(
                (x) => x.promotionType == PromotionType.OrderBargain);

            var orderItemPromotionSql = OrderUtils.instance
                .orderItemPromotionToSql(promotion, orderObject.finishDate);
            if (orderItemPromotionSql.item1) {
              queues.add(orderItemPromotionSql.item3);
            }
          }

          //重新计算行小计
          OrderUtils.instance.calculateOrderItem(orderItem);

          String orderItemSql = sprintf(
              "update pos_order_item set price='%s',bargainReason='%s',rquantity='%s',ramount='%s',rreason='%s',giftQuantity='%s',giftAmount='%s',giftReason='%s', totalReceivableAmount='%s', totalDiscountAmount='%s', receivableAmount='%s',discountAmount='%s', flavorNames='%s', flavorReceivableAmount='%s', flavorDiscountAmount='%s', flavorAmount='%s', flavorCount='%s',  totalAmount='%s', quantity='%s',amount='%s' where id='%s';",
              [
                orderItem.price,
                orderItem.bargainReason,
                orderItem.refundQuantity,
                orderItem.refundAmount,
                orderItem.refundReason,
                orderItem.giftQuantity,
                orderItem.giftAmount,
                orderItem.giftReason,
                orderItem.totalReceivableAmount,
                orderItem.totalDiscountAmount,
                orderItem.receivableAmount,
                orderItem.discountAmount,
                orderItem.flavorNames,
                orderItem.flavorReceivableAmount,
                orderItem.flavorDiscountAmount,
                orderItem.flavorAmount,
                orderItem.flavors.length,
                orderItem.totalAmount,
                orderItem.quantity,
                orderItem.amount,
                orderItem.id,
              ]);

          queues.add(orderItemSql);
        }

        //桌台重算
        OrderUtils.instance.calculateTable(orderObject, table);

        //已经下单的商品数量
        table.placeOrders = orderObject.items
            .where((x) =>
                x.tableId == tableId &&
                x.orderRowStatus == OrderRowStatus.Order)
            .map((e) => e.quantity)
            .fold(0, (prev, quantity) => prev + quantity);

        //人均
        double perCapitaAmount = table.people > 0
            ? OrderUtils.instance.toRound(table.totalAmount / table.people)
            : 0;
        //优惠率
        double discountRate = table.totalAmount > 0
            ? OrderUtils.instance
                .toRound(table.discountAmount / table.totalAmount)
            : 0;
        //保存影响桌台汇总数据
        String orderTableSql = sprintf(
            "update pos_order_table set perCapitaAmount='%s',  malingAmount='%s', paidAmount='%s', discountRate='%s',  placeOrders='%s', totalQuantity='%s',totalAmount='%s',totalRefund='%s',totalRefundAmount='%s',totalGive='%s',totalGiveAmount='%s',discountAmount='%s',receivableAmount='%s',maxOrderNo='%s',modifyUser='%s',modifyDate='%s' where id = '%s';",
            [
              perCapitaAmount,
              table.malingAmount,
              table.paidAmount,
              discountRate,
              table.placeOrders,
              table.totalQuantity,
              table.totalAmount,
              table.totalRefund,
              table.totalRefundAmount,
              table.totalGive,
              table.totalGiveAmount,
              table.discountAmount,
              table.receivableAmount,
              table.maxOrderNo,
              Global.instance.worker.no,
              DateUtils.formatDate(DateTime.now(),
                  format: "yyyy-MM-dd HH:mm:ss"),
              table.id,
            ]);
        queues.add(orderTableSql);
      }

      //整单重算
      OrderUtils.instance.calculateOrderObject(orderObject);

      //保存主单变动信息
      String orderObjectSql = sprintf(
          "update pos_order set receivedAmount='%s', paidAmount='%s', totalQuantity='%s',amount='%s',totalGiftQuantity='%s',totalGiftAmount='%s',totalRefundQuantity='%s',totalRefundAmount='%s',discountAmount='%s',receivableAmount='%s',modifyUser='%s',modifyDate='%s',itemCount='%s',payCount='%s' where id = '%s';",
          [
            orderObject.receivedAmount,
            orderObject.paidAmount,
            orderObject.totalQuantity,
            orderObject.amount,
            orderObject.totalGiftQuantity,
            orderObject.totalGiftAmount,
            orderObject.totalRefundQuantity,
            orderObject.totalRefundAmount,
            orderObject.discountAmount,
            orderObject.receivableAmount,
            Global.instance.worker.no,
            DateUtils.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss"),
            orderObject.items.length,
            orderObject.pays.length,
            orderObject.id,
          ]);
      queues.add(orderObjectSql);

      if (queues.length > 0) {
        bool hasFailed = true;
        var database = await SqlUtils.instance.open();
        await database.transaction((txn) async {
          try {
            var batch = txn.batch();
            queues.forEach((obj) {
              batch.rawInsert(obj);
            });
            await batch.commit(noResult: false);
            hasFailed = false;
          } catch (e, stack) {
            FlutterChain.printError(e, stack);
            FLogger.error("整单议价发生异常:" + e.toString());
          }
        });

        if (hasFailed) {
          result = false;
          message = "整单议价失败...";
        } else {
          result = true;
          message = "整单议价成功,共<${queues.length}>条...";
        }
      } else {
        result = true;
        message = "执行成功,无变更数据...";
      }
    } catch (e, stack) {
      result = false;
      message = "整单议价发生异常";
      FlutterChain.printError(e, stack);
      FLogger.error("$message:" + e.toString());
    }

    return Tuple2<bool, String>(result, message);
  }
}
