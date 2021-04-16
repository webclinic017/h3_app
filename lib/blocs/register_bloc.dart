import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/open_api.dart';
import 'package:h3_app/entity/pos_apis.dart';
import 'package:h3_app/entity/pos_authc.dart';
import 'package:h3_app/entity/registration_code.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/api_utils.dart';
import 'package:h3_app/utils/converts.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/enum_utils.dart';
import 'package:h3_app/utils/http_utils.dart';
import 'package:h3_app/utils/idworker_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterRepository _registerRepository;

  RegisterBloc() : super(RegisterState.init()) {
    this._registerRepository = new RegisterRepository();
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is ActiveCodeChanged) {
      yield state.copyWith(
        activeCode: event.activeCode,
        activeCodeValid: _isActiveCodeValid(event.activeCode),
        status: RegisterStatus.None,
      );
    } else if (event is Submitted) {
      yield* _mapSubmittedToState();
    } else if (event is ActiveSuccessful) {
      yield* _mapSuccessfulToState();
    }
  }

  Stream<RegisterState> _mapSuccessfulToState() async* {
    try {
      yield state.waiting();

      Tuple3<bool, String, Authc>
          response; //= await this._registerRepository.httpRegistApi(state.registrationCode, state.authc);

      if (state.activeCode.startsWith("57110")) {
        response = await this
            ._registerRepository
            .oldHttpRegistApi(state.registrationCode, state.authc);
      } else {
        response = await this
            ._registerRepository
            .httpRegistApi(state.registrationCode, state.authc);
      }

      if (response.item1) {
        Global.instance.authc = response.item3;

        Tuple2<bool, String>
            result; //= await this._registerRepository.saveRegister(state.registrationCode, Global.instance.authc);

        if (state.activeCode.startsWith("57110")) {
          result = await this
              ._registerRepository
              .oldSaveRegister(state.registrationCode, Global.instance.authc);
        } else {
          result = await this
              ._registerRepository
              .saveRegister(state.registrationCode, Global.instance.authc);
        }

        if (result.item1) {
          yield state.success();
        } else {
          yield state.failure(
            message: result.item2,
          );
        }
      } else {
        yield state.failure(
          message: response.item2,
        );
      }
    } catch (_) {
      yield state.failure(message: "激活码验证出错了");
    }
  }

  Stream<RegisterState> _mapSubmittedToState() async* {
    yield state.loading();

    try {
      Tuple4<bool, String, RegistrationCode, Authc>
          response; //= await this._registerRepository.httpActiveApi(state.activeCode);
      if (state.activeCode.startsWith("57110")) {
        response =
            await this._registerRepository.oldHttpActiveApi(state.activeCode);
      } else {
        response =
            await this._registerRepository.httpActiveApi(state.activeCode);
      }

      ///激活码验证成功
      if (response.item1) {
        yield state.confirm(
          message: response.item2,
          registrationCode: response.item3,
          authc: response.item4,
        );
      } else {
        yield state.failure(
          message: response.item2,
        );
      }
    } catch (_) {
      yield state.failure(message: "激活码验证出错");
    }
  }

  ///激活码输入验证，不为空，长度等于12
  bool _isActiveCodeValid(String activeCode) {
    return StringUtils.isNotBlank(activeCode) && activeCode.length >= 10;
  }
}

///------------------------------------------------------------------------------------///

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

///激活码输入事件
class ActiveCodeChanged extends RegisterEvent {
  final String activeCode;
  final bool isActiveCodeValid;
  const ActiveCodeChanged({
    this.activeCode,
    this.isActiveCodeValid,
  });

  @override
  List<Object> get props => [activeCode, isActiveCodeValid];
}

///提交事件
class Submitted extends RegisterEvent {}

///激活成功事件
class ActiveSuccessful extends RegisterEvent {}

///------------------------------------------------------------------------------------///

enum RegisterStatus {
  None,
  Initial,
  Loading,
  Confirm,
  Waiting,
  Success,
  Failure
}

class RegisterState extends Equatable {
  ///用户输入的激活码
  final String activeCode;

  ///激活码输入内容的校验
  final bool activeCodeValid;

  ///加载遮罩层的通知
  final RegisterStatus status;

  final String message;

  final RegistrationCode registrationCode;

  final Authc authc;

  const RegisterState({
    this.activeCode,
    this.activeCodeValid,
    this.status,
    this.message,
    this.registrationCode,
    this.authc,
  });

  ///初始化
  factory RegisterState.init() {
    return RegisterState(
      activeCode: "",
      activeCodeValid: false,
      status: RegisterStatus.None,
      message: "",
      registrationCode: null,
      authc: null,
    );
  }

  RegisterState loading() {
    return copyWith(
      status: RegisterStatus.Loading,
      message: "",
      registrationCode: null,
      authc: null,
    );
  }

  RegisterState failure({String message}) {
    return copyWith(
      status: RegisterStatus.Failure,
      message: message,
      registrationCode: null,
      authc: null,
    );
  }

  RegisterState confirm({
    String message,
    RegistrationCode registrationCode,
    Authc authc,
  }) {
    return copyWith(
      status: RegisterStatus.Confirm,
      message: message,
      registrationCode: registrationCode,
      authc: authc,
    );
  }

  RegisterState waiting() {
    return copyWith(
      status: RegisterStatus.Waiting,
    );
  }

  RegisterState success() {
    return copyWith(
      status: RegisterStatus.Success,
    );
  }

  RegisterState copyWith({
    String activeCode,
    bool activeCodeValid,
    RegisterStatus status,
    String message,
    RegistrationCode registrationCode,
    Authc authc,
  }) {
    return RegisterState(
      activeCode: activeCode ?? this.activeCode,
      activeCodeValid: activeCodeValid ?? this.activeCodeValid,
      status: status ?? this.status,
      message: message ?? this.message,
      registrationCode: registrationCode ?? this.registrationCode,
      authc: authc ?? this.authc,
    );
  }

  bool get isValid => this.activeCodeValid;

  @override
  List<Object> get props => [
        this.activeCode,
        this.activeCodeValid,
        this.status,
        this.message,
        this.registrationCode,
        this.authc
      ];
}

///------------------------------------------------------------------------------------///

class RegisterRepository {
  ///提交激活码到服务端
  Future<Tuple4<bool, String, RegistrationCode, Authc>> httpActiveApi(
      String activeCode) async {
    FLogger.debug("收到注册请求:$activeCode");

    bool result = false;
    String msg = "";
    RegistrationCode registrationCode;
    Authc authc;
    try {
      var computerName = await DeviceUtils.instance.getMode();
      var macAddress = Constants.VIRTUAL_MAC_ADDRESS;
      var serialNumber = await DeviceUtils.instance.getSerialId();
      var systemVersion = await DeviceUtils.instance.getSystemVersion();
      var cpuNumber = StringUtils.reverse(serialNumber).toUpperCase();
      FLogger.debug(
          "computerName=$computerName,macAddress=$macAddress,serialNumber=$serialNumber,cpuNumber=$cpuNumber,systemVersion=$systemVersion");

      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "regist4scrm";

      parameters["appSign"] = Constants.APP_SIGN;
      parameters["terminalType"] = Constants.TERMINAL_TYPE;
      parameters["computerName"] = "$computerName";
      parameters["macAddress"] = macAddress;
      parameters["serialNumber"] = serialNumber;
      parameters["cpuNumber"] = cpuNumber;
      parameters["authCode"] = activeCode;

      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      FLogger.debug("请求地址:${api.open}");
      FLogger.debug("请求参数:$parameters");

      var response =
          await HttpUtils.instance.post(api, api.open, params: parameters);

      print(response);

      result = response.success;
      msg = response.msg;
      if (response.success) {
        registrationCode = RegistrationCode.fromJson(response.data);

        authc = new Authc()
          ..id = IdWorkerUtils.getInstance().generate().toString()
          ..tenantId = registrationCode.tenantId
          ..compterName = computerName
          ..macAddress = macAddress
          ..diskSerialNumber = serialNumber
          ..cpuSerialNumber = cpuNumber
          ..storeId = registrationCode.storeId
          ..storeNo = registrationCode.storeNo
          ..storeName = registrationCode.storeName
          ..createUser = Constants.DEFAULT_CREATE_USER
          ..modifyUser = Constants.DEFAULT_MODIFY_USER;
      } else {
        registrationCode = null;
        authc = null;
      }
    } catch (e) {
      FLogger.error("激活码验证异常:" + e.toString());

      result = false;
      msg = "激活码验证出错";
      registrationCode = null;
      authc = null;
    }
    return Tuple4<bool, String, RegistrationCode, Authc>(
        result, msg, registrationCode, authc);
  }

  Future<Tuple3<bool, String, Authc>> httpRegistApi(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      //重置当前的应用密钥
      api.appKey = registrationCode.appKey;
      api.appSecret = registrationCode.appSecret;
      var appVersion = await DeviceUtils.instance.getAppVersion();
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "scrm.pos.regist";
      var data = {
        "appSign": Constants.APP_SIGN,
        "terminalType": Constants.TERMINAL_TYPE,
        "authCode": registrationCode.authCode,
        "compterName": authc.compterName,
        "serialNumber": authc.diskSerialNumber,
        "cpuNumber": authc.cpuSerialNumber,
        "macAddress": authc.macAddress,
        "appVersion": appVersion,
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      result = response.success;
      msg = response.msg;
      if (result) {
        var registInfo = PosRegist.fromJson(response.data);
        authc.tenantId = registInfo.tenantId;
        authc.posId = registInfo.posId;
        authc.posNo = registInfo.posNo;
        authc.activeCode = registInfo.activeCode;
      }
    } catch (e) {
      FLogger.error("POS登记发生异常:" + e.toString());
      result = false;
      msg = "POS登记出错了";
      authc = null;
    }
    return Tuple3<bool, String, Authc>(result, msg, authc);
  }

  Future<Tuple2<bool, String>> saveRegister(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";

    try {
      ///构建业务平台访问参数
      var businessApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId ?? "373001"
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.Business)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统默认业务地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      ///构建外卖平台访问参数
      var waimaiApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId ?? "373001"
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.WaiMai)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统默认外卖地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      var transportApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId ?? "373001"
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.Transport)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统默认外卖地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      //桌台点单访问参数
      var mealApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId ?? "373001"
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.Meal)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统桌台点单地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      var database = await SqlUtils.instance.open();

      await database.transaction((txn) async {
        ///删除pos_authc表数据
        await txn.delete(Authc.tableName);

        ///删除pos_apis表数据
        await txn.delete(Apis.tableName);

        ///保存pos_authc数据
        await txn.insert(Authc.tableName, authc.toMap());

        ///保存pos_apis表业务参数
        await txn.insert(Apis.tableName, businessApis.toMap());
        await txn.insert(Apis.tableName, waimaiApis.toMap());
        await txn.insert(Apis.tableName, transportApis.toMap());
        await txn.insert(Apis.tableName, mealApis.toMap());
      });

      result = true;
      msg = "POS注册成功";
    } catch (e) {
      FLogger.error("POS登记发生异常:" + e.toString());
      result = false;
      msg = "POS登记出错了";
    }
    return Tuple2<bool, String>(result, msg);
  }

  ///----------------------------------------------兼容老版本----------------------------------------

  ///提交激活码到服务端
  Future<Tuple4<bool, String, RegistrationCode, Authc>> oldHttpActiveApi(
      String activeCode) async {
    FLogger.debug("收到注册请求:$activeCode");

    bool result = false;
    String msg = "";
    RegistrationCode registrationCode;
    Authc authc;
    try {
      var computerName = await DeviceUtils.instance.getMode();
      var macAddress = Constants.VIRTUAL_MAC_ADDRESS;
      var serialNumber = await DeviceUtils.instance.getSerialId();
      var systemVersion = await DeviceUtils.instance.getSystemVersion();

      FLogger.debug(
          "computerName=$computerName,macAddress=$macAddress,serialNumber=$serialNumber,systemVersion=$systemVersion");

      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "regist";

      parameters["appSign"] = Constants.APP_SIGN;
      parameters["terminalType"] = Constants.TERMINAL_TYPE;
      parameters["computerName"] = "$computerName $systemVersion";
      parameters["macAddress"] = macAddress;
      parameters["serialNumber"] = serialNumber;
      parameters["cpuNumber"] = StringUtils.reverse(serialNumber).toUpperCase();
      parameters["authCode"] = activeCode;

      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      FLogger.debug("请求地址:${api.open}");
      FLogger.debug("请求参数:$parameters");

      var response =
          await HttpUtils.instance.post(api, api.open, params: parameters);

      result = response.success;
      msg = response.msg;
      if (response.success) {
        registrationCode = RegistrationCode.fromJson(response.data);

        authc = new Authc()
          ..id = IdWorkerUtils.getInstance().generate().toString()
          ..tenantId = registrationCode.tenantId
          ..compterName = computerName
          ..macAddress = macAddress
          ..diskSerialNumber = serialNumber
          ..cpuSerialNumber = systemVersion
          ..storeId = registrationCode.storeId
          ..storeNo = registrationCode.storeNo
          ..storeName = registrationCode.storeName
          ..posId = registrationCode.posId
          ..posNo = registrationCode.posNo
          ..createUser = Constants.DEFAULT_CREATE_USER
          ..modifyUser = Constants.DEFAULT_MODIFY_USER;
      } else {
        registrationCode = null;
        authc = null;
      }
    } catch (e) {
      FLogger.error("激活码验证异常:" + e.toString());

      result = false;
      msg = "激活码验证出错";
      registrationCode = null;
      authc = null;
    }
    return Tuple4<bool, String, RegistrationCode, Authc>(
        result, msg, registrationCode, authc);
  }

  Future<Tuple3<bool, String, Authc>> oldHttpRegistApi(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";
    try {
      OpenApi api = OpenApiUtils.instance.getOpenApi(ApiType.Business);
      //重置当前的应用密钥
      api.appKey = registrationCode.appKey;
      api.appSecret = registrationCode.appSecret;
      var parameters = OpenApiUtils.instance.newParameters(api: api);
      parameters["name"] = "pos.regist";
      var data = {
        "posId": registrationCode.posId,
        "posNo": registrationCode.posNo,
        "appSign": Constants.APP_SIGN,
        "terminalType": Constants.TERMINAL_TYPE,
        "authCode": registrationCode.authCode,
        "compterName": authc.compterName,
        "serialNumber": authc.diskSerialNumber,
        "cpuNumber": authc.cpuSerialNumber,
        "macAddress": authc.macAddress
      };

      parameters["data"] = json.encode(data);
      List<String> ignoreParameters = new List<String>();
      var sign = OpenApiUtils.instance.sign(api, parameters, ignoreParameters);
      parameters["sign"] = sign;

      var response =
          await HttpUtils.instance.post(api, api.url, params: parameters);

      print(response);

      result = response.success;
      msg = response.msg;
      if (result) {
        authc.tenantId = registrationCode.tenantId;
      }
    } catch (e) {
      FLogger.error("POS登记发生异常:" + e.toString());
      result = false;
      msg = "POS登记出错了";
      authc = null;
    }
    return Tuple3<bool, String, Authc>(result, msg, authc);
  }

  Future<Tuple2<bool, String>> oldSaveRegister(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";

    try {
      ///构建业务平台访问参数
      var businessApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.Business)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统默认业务地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      ///构建外卖平台访问参数
      var waimaiApis = new Apis()
        ..id = IdWorkerUtils.getInstance().generate().toString()
        ..tenantId = authc.tenantId
        ..appKey = registrationCode.appKey
        ..appSecret = registrationCode.appSecret
        ..apiType = EnumUtils.parse(ApiType.WaiMai)
        ..locale = "zh-CN"
        ..format = "json"
        ..client = "android"
        ..version = "1.0"
        ..routing = 0
        ..memo = "系统默认外卖地址"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      print("数据库操作开始");
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        ///删除pos_authc表数据
        await txn.delete(Authc.tableName);

        ///删除pos_apis表数据
        await txn.delete(Apis.tableName);

        ///保存pos_authc数据
        await txn.insert(Authc.tableName, authc.toMap());

        ///保存pos_apis表业务参数
        await txn.insert(Apis.tableName, businessApis.toMap());

        ///保存pos_apis表外卖参数
        await txn.insert(Apis.tableName, waimaiApis.toMap());
      });

      print("数据库操作结束");

      result = true;
      msg = "POS注册成功";
    } catch (e) {
      FLogger.error("POS登记发生异常:" + e.toString());
      result = false;
      msg = "POS登记出错了";
    }
    return Tuple2<bool, String>(result, msg);
  }
}

class PosRegist {
  //租户ID
  String tenantId = "";
  //POSID
  String posId = "";
  //POS编号
  String posNo = "";
  //认证信息
  ActiveCodeEntity activeCode;

  PosRegist();

  factory PosRegist.fromJson(Map<String, dynamic> map) {
    return PosRegist()
      ..tenantId = Convert.toStr(map["tenantId"])
      ..posId = Convert.toStr(map["posId"])
      ..posNo = Convert.toStr(map["posNo"])
      ..activeCode = ActiveCodeEntity.fromJson(map["activeCode"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "tenantId": this.tenantId,
      "posId": this.posId,
      "posNo": this.posNo,
      "activeCode": this.activeCode,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

class ActiveCodeEntity {
  // 激活码ID
  String id = "";

  // 激活码
  String activeCode = "";

  // 激活时间
  String activeDate = "";

  String activeTenantCode = "";

  String activeTenantId = "";

  String activeTenantName = "";

  String activeTenantPosId = "";

  String activeTenantPosName = "";

  String activeTenantPosNo = "";

  String activeTenantShortName = "";

  String activeTenantStoreCode = "";

  String activeTenantStoreId = "";

  String activeTenantStoreName = "";

  String agentId = "";

  String batchNo = "";

  /// 有效期
  String expiryDate = "";

  /// 试用天数
  int trialDays = 0;

  /// 试用标识
  int trialFlag = 0;

  /// 最长脱机时长
  int maxOfflineDay = 0;

  /// 提醒时间
  int remindDay = 0;

  /// 版本
  String version = "";

  /// 状态 0未试用 1已使用  2已中止  3已停用
  int status = 0;

  ActiveCodeEntity();

  factory ActiveCodeEntity.fromJson(Map<String, dynamic> map) {
    return ActiveCodeEntity()
      ..id = Convert.toStr(map["id"])
      ..activeCode = Convert.toStr(map["activeCode"])
      ..activeDate = Convert.toStr(map["activeDate"])
      ..activeTenantCode = Convert.toStr(map["activeTenantCode"])
      ..activeTenantId = Convert.toStr(map["activeTenantId"])
      ..activeTenantName = Convert.toStr(map["activeTenantName"])
      ..activeTenantPosId = Convert.toStr(map["activeTenantPosId"])
      ..activeTenantPosName = Convert.toStr(map["activeTenantPosName"])
      ..activeTenantPosNo = Convert.toStr(map["activeTenantPosNo"])
      ..activeTenantShortName = Convert.toStr(map["activeTenantShortName"])
      ..activeTenantStoreCode = Convert.toStr(map["activeTenantStoreCode"])
      ..activeTenantStoreId = Convert.toStr(map["activeTenantStoreId"])
      ..activeTenantStoreName = Convert.toStr(map["activeTenantStoreName"])
      ..agentId = Convert.toStr(map["agentId"])
      ..batchNo = Convert.toStr(map["batchNo"])
      ..expiryDate = Convert.toStr(map["expiryDate"])
      ..trialDays = Convert.toInt(map["trialDays"])
      ..trialFlag = Convert.toInt(map["trialFlag"])
      ..maxOfflineDay = Convert.toInt(map["maxOfflineDay"])
      ..remindDay = Convert.toInt(map["remindDay"])
      ..version = Convert.toStr(map["version"])
      ..status = Convert.toInt(map["status"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": this.id,
      "activeCode": this.activeCode,
      "activeDate": this.activeDate,
      "activeTenantCode": this.activeTenantCode,
      "activeTenantId": this.activeTenantId,
      "activeTenantName": this.activeTenantName,
      "activeTenantPosId": this.activeTenantPosId,
      "activeTenantPosName": this.activeTenantPosName,
      "activeTenantPosNo": this.activeTenantPosNo,
      "activeTenantShortName": this.activeTenantShortName,
      "activeTenantStoreCode": this.activeTenantStoreCode,
      "activeTenantStoreId": this.activeTenantStoreId,
      "activeTenantStoreName": this.activeTenantStoreName,
      "agentId": this.agentId,
      "batchNo": this.batchNo,
      "expiryDate": this.expiryDate,
      "trialDays": this.trialDays,
      "trialFlag": this.trialFlag,
      "maxOfflineDay": this.maxOfflineDay,
      "remindDay": this.remindDay,
      "version": this.version,
      "status": this.status,
    };

    return map;
  }

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
