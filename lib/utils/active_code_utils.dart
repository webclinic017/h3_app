// TODO Implement this library.
//
//

import 'dart:convert';

import 'package:h3_app/blocs/register_bloc.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/pos_authc.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/crypto_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/stack_trace.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

import 'api_utils.dart';
import 'http_utils.dart';

class ActiveCodeUtils {
  // 工厂模式
  factory ActiveCodeUtils() => _getInstance();
  static ActiveCodeUtils get instance => _getInstance();
  static ActiveCodeUtils _instance;

  static ActiveCodeUtils _getInstance() {
    if (_instance == null) {
      _instance = new ActiveCodeUtils._internal();
    }
    return _instance;
  }

  ActiveCodeUtils._internal();

  /// <summary>
  /// 生成认证校验key
  /// </summary>
  /// <param name="activeCode"></param>
  /// <param name="activeDate"></param>
  /// <param name="expiryDate"></param>
  /// <returns></returns>
  String generateValidKey(Authc auth) {
    var obj = auth.activeCode ?? null;
    if (obj != null) {
      var sourceStr = "${obj.activeCode}${obj.activeDate}${obj.expiryDate}";
      return StringUtils.reverse(Md5Utils.md5(sourceStr).substring(16))
          .toLowerCase();
    }
    return null;
  }

  /// 更新认证信息
  Future<Tuple2<bool, String>> updateActiveCode(Authc auth) async {
    bool result = false;
    String message = "更新失败";
    try {
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.update(Authc.tableName, auth.toMap());
        await batch.commit(noResult: false);
      });

      result = true;
      String message = "更新成功";
    } catch (e) {
      FLogger.error("更新激活码异常:" + e.toString());
    }

    return Tuple2(result, message);
  }

  /// 获取最新认证信息
  Future<Tuple4<bool, int, String, ActiveCodeEntity>> getActiveInfo(
      Authc auth) async {
    bool result = false;
    int code = -1;
    String message = "获取认证异常";
    ActiveCodeEntity entity;

    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "scrm.pos.activecode.info";

      var activeCodeEntity = auth.activeCode;
      var data = {
        "appSign": Constants.APP_SIGN,
        "terminalType": Constants.TERMINAL_TYPE,
        "authCode": activeCodeEntity.activeCode,
        "authCodeId": activeCodeEntity.id,
        "posId": auth.posId,
        "posNo": auth.posNo,
        "storeId": auth.storeId,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      FLogger.debug("获取激活码认证结果:$response");

      result = response.success;
      code = response.code;
      message = response.msg;

      if (result) {
        entity = ActiveCodeEntity.fromJson(response.data);
      } else {
        entity = null;
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("获取认证异常:" + e.toString());
    }

    return Tuple4(result, code, message, entity);
  }

  /// 校验认证信息
  Tuple3<bool, bool, String> validActiveCode(DateTime now) {
    //是否可用，是否提示， 提示内容
    bool result = true;
    bool notify = false;
    String message = "未知";
    try {
      if (Global.instance.authc == null) {
        return Tuple3(result, notify, message);
      }
      if (Global.instance.authc.activeCode == null) {
        return Tuple3(result, notify, message);
      }

      var activeCodeObj = Global.instance.authc.activeCode;

      print("@@@@@@>>>>>>>$activeCodeObj");

      if (activeCodeObj != null) {
        if (activeCodeObj.status == 2 || activeCodeObj.status == 3) {
          result = false;
          notify = true;
          message = "服务已到期,请续费。如已续费,请重新打开应用";
        }

        //过期时间
        var expiryDate = DateTime.fromMillisecondsSinceEpoch(
            int.tryParse("${activeCodeObj.expiryDate}"));
        //剩余时间
        int remainDays = expiryDate.difference(now).inDays;
        if (remainDays > 0 && remainDays <= activeCodeObj.remindDay) {
          result = true;
          notify = true;
          message =
              "您的账号将于${remainDays == 0 ? '今天' : '$remainDays天后'}${activeCodeObj.trialFlag == 1 ? '试用' : ''}到期，\n请提前安排续费";
        } else if (remainDays <= 0) {
          result = false;
          notify = true;
          message =
              "您的账号${activeCodeObj.trialFlag == 1 ? '试用' : ''}已到期，请续费，\n\n如已续费，请重新打开应用。";
        } else {
          result = true;
          notify = false;
          message = "正常";
        }
      }
    } catch (e, stack) {
      FlutterChain.printError(e, stack);
      FLogger.error("校验账号使用情况异常" + e.toString());

      result = false;
      notify = true;
      message = "校验异常";
    }
    return Tuple3(result, notify, message);
  }
}
