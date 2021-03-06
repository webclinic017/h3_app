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
      yield state.failure(message: "????????????????????????");
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

      ///?????????????????????
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
      yield state.failure(message: "?????????????????????");
    }
  }

  ///????????????????????????????????????????????????12
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

///?????????????????????
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

///????????????
class Submitted extends RegisterEvent {}

///??????????????????
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
  ///????????????????????????
  final String activeCode;

  ///??????????????????????????????
  final bool activeCodeValid;

  ///????????????????????????
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

  ///?????????
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
  ///???????????????????????????
  Future<Tuple4<bool, String, RegistrationCode, Authc>> httpActiveApi(
      String activeCode) async {
    FLogger.debug("??????????????????:$activeCode");

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

      FLogger.debug("????????????:${api.open}");
      FLogger.debug("????????????:$parameters");

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
      FLogger.error("?????????????????????:" + e.toString());

      result = false;
      msg = "?????????????????????";
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
      //???????????????????????????
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
      FLogger.error("POS??????????????????:" + e.toString());
      result = false;
      msg = "POS???????????????";
      authc = null;
    }
    return Tuple3<bool, String, Authc>(result, msg, authc);
  }

  Future<Tuple2<bool, String>> saveRegister(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";

    try {
      ///??????????????????????????????
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
        ..memo = "????????????????????????"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      ///??????????????????????????????
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
        ..memo = "????????????????????????"
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
        ..memo = "????????????????????????"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      //????????????????????????
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
        ..memo = "????????????????????????"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      var database = await SqlUtils.instance.open();

      await database.transaction((txn) async {
        ///??????pos_authc?????????
        await txn.delete(Authc.tableName);

        ///??????pos_apis?????????
        await txn.delete(Apis.tableName);

        ///??????pos_authc??????
        await txn.insert(Authc.tableName, authc.toMap());

        ///??????pos_apis???????????????
        await txn.insert(Apis.tableName, businessApis.toMap());
        await txn.insert(Apis.tableName, waimaiApis.toMap());
        await txn.insert(Apis.tableName, transportApis.toMap());
        await txn.insert(Apis.tableName, mealApis.toMap());
      });

      result = true;
      msg = "POS????????????";
    } catch (e) {
      FLogger.error("POS??????????????????:" + e.toString());
      result = false;
      msg = "POS???????????????";
    }
    return Tuple2<bool, String>(result, msg);
  }

  ///----------------------------------------------???????????????----------------------------------------

  ///???????????????????????????
  Future<Tuple4<bool, String, RegistrationCode, Authc>> oldHttpActiveApi(
      String activeCode) async {
    FLogger.debug("??????????????????:$activeCode");

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

      FLogger.debug("????????????:${api.open}");
      FLogger.debug("????????????:$parameters");

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
      FLogger.error("?????????????????????:" + e.toString());

      result = false;
      msg = "?????????????????????";
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
      //???????????????????????????
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
      FLogger.error("POS??????????????????:" + e.toString());
      result = false;
      msg = "POS???????????????";
      authc = null;
    }
    return Tuple3<bool, String, Authc>(result, msg, authc);
  }

  Future<Tuple2<bool, String>> oldSaveRegister(
      RegistrationCode registrationCode, Authc authc) async {
    bool result = false;
    String msg = "";

    try {
      ///??????????????????????????????
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
        ..memo = "????????????????????????"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      ///??????????????????????????????
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
        ..memo = "????????????????????????"
        ..createUser = Constants.DEFAULT_CREATE_USER
        ..modifyUser = Constants.DEFAULT_MODIFY_USER;

      print("?????????????????????");
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        ///??????pos_authc?????????
        await txn.delete(Authc.tableName);

        ///??????pos_apis?????????
        await txn.delete(Apis.tableName);

        ///??????pos_authc??????
        await txn.insert(Authc.tableName, authc.toMap());

        ///??????pos_apis???????????????
        await txn.insert(Apis.tableName, businessApis.toMap());

        ///??????pos_apis???????????????
        await txn.insert(Apis.tableName, waimaiApis.toMap());
      });

      print("?????????????????????");

      result = true;
      msg = "POS????????????";
    } catch (e) {
      FLogger.error("POS??????????????????:" + e.toString());
      result = false;
      msg = "POS???????????????";
    }
    return Tuple2<bool, String>(result, msg);
  }
}

class PosRegist {
  //??????ID
  String tenantId = "";
  //POSID
  String posId = "";
  //POS??????
  String posNo = "";
  //????????????
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
  // ?????????ID
  String id = "";

  // ?????????
  String activeCode = "";

  // ????????????
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

  /// ?????????
  String expiryDate = "";

  /// ????????????
  int trialDays = 0;

  /// ????????????
  int trialFlag = 0;

  /// ??????????????????
  int maxOfflineDay = 0;

  /// ????????????
  int remindDay = 0;

  /// ??????
  String version = "";

  /// ?????? 0????????? 1?????????  2?????????  3?????????
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
