import 'dart:async';

import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/order/order_utils.dart';
import 'package:h3_app/order/order_utils.dart';

import 'api_utils.dart';
import 'cron.dart';
import 'date_utils.dart';
import 'http_utils.dart';
import 'order_utils.dart';

typedef periodicCallBack = void Function(Timer periodicTime);

class SchedulerUtils {
  // 工厂模式
  factory SchedulerUtils() => _getInstance();

  static SchedulerUtils get instance => _getInstance();
  static SchedulerUtils _instance;

  SchedulerUtils._internal() {
    // 初始化
  }

  static SchedulerUtils _getInstance() {
    if (_instance == null) {
      _instance = new SchedulerUtils._internal();
    }

    return _instance;
  }

  Future init() async {
    //订单上送任务
    this.setInterval((time) async {
      Global.instance.online = await OpenApiUtils.instance.isAvailable();

      if (!Global.instance.online) {
        FLogger.warn("脱机状态暂不上送数据");
        return;
      }

      var waitingUpload = await OrderUtils.instance.getUploadOrderObject();
      if (waitingUpload != null && waitingUpload.length > 0) {
        FLogger.info("待上传订单........${waitingUpload.length}.........");

        for (var order in waitingUpload) {
          var orderObject =
              await OrderUtils.instance.builderOrderObject(order.id);

          FLogger.info("开始上传销售订单<${orderObject.items}>");
          var buildResult = OrderUtils.instance.buildUploadOrder(orderObject);
          if (buildResult.item1) {
            OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
            var parameters = OpenApiUtils.instance.newParameters(api: api);
            parameters["name"] = "upload.business.order";
            parameters["data"] = buildResult.item2;
            List<String> ignoreParameters = new List<String>();
            var sign =
                OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
            parameters["sign"] = sign;

            var resp =
                await HttpUtils.instance.post(api, api.url, params: parameters);

            //"serverId", "uploadStatus", "uploadCode", "uploadMessage", "uploadErrors", "uploadTime", "modifyUser", "modifyDate"
            var uploadResult = new Map<String, dynamic>();
            //订单ID
            uploadResult["id"] = orderObject.id;
            //订单编号
            uploadResult["tradeNo"] = orderObject.tradeNo;
            //uploadTime
            uploadResult["uploadTime"] = DateUtils.formatDate(DateTime.now(),
                format: "yyyy-MM-dd HH:mm:ss");
            //modifyUser
            uploadResult["modifyUser"] = Global.instance.worker != null
                ? Global.instance.worker.no
                : Constants.DEFAULT_MODIFY_USER;
            //modifyDate
            uploadResult["modifyDate"] = DateUtils.formatDate(DateTime.now(),
                format: "yyyy-MM-dd HH:mm:ss");
            //uploadCode
            uploadResult["uploadCode"] = resp.code;
            //uploadMessage
            uploadResult["uploadMessage"] = resp.msg;
            //uploadErrors
            uploadResult["uploadErrors"] = (orderObject.uploadErrors == null
                ? 0
                : orderObject.uploadErrors);
            //serverId
            uploadResult["serverId"] = "";

            if (resp.success) {
              //上传成功
              uploadResult["uploadStatus"] = 1;
              var respData = Map<String, dynamic>.from(resp.data);
              //服务端ID
              if (respData.containsKey("serverId")) {
                uploadResult["serverId"] = respData["serverId"];
              }
            } else {
              //上传失败
              uploadResult["uploadStatus"] = 0;
              //错误次数+1
              uploadResult["uploadErrors"] = (orderObject.uploadErrors == null
                      ? 0
                      : orderObject.uploadErrors) +
                  1;
            }

            await OrderUtils.instance.updateUploadStatus(uploadResult);
          }
        }
      }
    }, 20 * 1000);
    //每分钟定时执行任务
    var cron = new Cron();
    //每5分钟执行1次POS状态上报
    cron.schedule(new Schedule.parse('*/5 * * * *'), () async {
      await HttpUtils.instance.posMonitor();
    });

    //每1分钟执行1次桌台状态刷新
    cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
      //TODO REFRESH_TABLE_STATUS_CHANNEL的注释
      // DartNotificationCenter.post(channel: Constants.REFRESH_TABLE_STATUS_CHANNEL, options: Constants.REFRESH_TABLE_STATUS_CHANNEL);
    });
  }

  void setTimeout(callback, time) {
    Duration timeDelay = Duration(milliseconds: time);
    Timer(timeDelay, callback);
  }

  void setInterval(periodicCallBack, time) {
    Duration periodic = Duration(milliseconds: time);
    Timer.periodic(periodic, (intervalTime) {
      periodicCallBack(intervalTime);
    });
  }
}
