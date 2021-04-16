import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/constants.dart';
import 'package:h3_app/entity/pos_authc.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/device_utils.dart';
import 'package:h3_app/utils/sql_utils.dart';

class AuthcBloc extends Bloc<AuthcEvent, AuthcState> {
  AuthcRepository _authcRepository;

  AuthcBloc() : super(AuthcState.init()) {
    this._authcRepository = new AuthcRepository();
  }

  @override
  Stream<AuthcState> mapEventToState(AuthcEvent event) async* {
    if (event is AuthcStarted) {
      yield* _mapAuthcStartedToState();
    }
  }

  Stream<AuthcState> _mapAuthcStartedToState() async* {
    try {
      //判断硬件是否登记
      final bool isRegisted = await _authcRepository.hasRegisted();
      yield state.copyWith(
        status: isRegisted ? AuthcStatus.Registed : AuthcStatus.Unregisted,
      );
    } catch (_) {
      yield state.copyWith(
        status: AuthcStatus.Unregisted,
      );
    }
  }
}

enum AuthcStatus {
  Unknow,
  Registed,
  Unregisted,
}

class AuthcState extends Equatable {
  final AuthcStatus status;
  const AuthcState({
    this.status,
  });

  factory AuthcState.init() {
    return AuthcState(
      status: AuthcStatus.Unknow,
    );
  }

  AuthcState copyWith({
    AuthcStatus status,
  }) {
    return AuthcState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [this.status];
}

abstract class AuthcEvent extends Equatable {}

//提交，开始认证事件
class AuthcStarted extends AuthcEvent {
  @override
  List<Object> get props => [];
}

class AuthcRepository {
  ///验证硬件是否已经注册
  Future<bool> hasRegisted() async {
    bool result = false;
    try {
      //临时过渡使用的方法
      // await addActiveCodeColumn();

      //获取系统唯一ID,做为判断依据
      var macAddress = Constants.VIRTUAL_MAC_ADDRESS;
      var diskSerialNumber = await DeviceUtils.instance.getSerialId();
      FLogger.debug(
          "本机硬件特征:MacAddress<$macAddress>,SerialId<$diskSerialNumber>");

      String sql =
          "select id,tenantId,compterName,macAddress,diskSerialNumber,cpuSerialNumber,storeId,storeNo,storeName,posId,posNo,ext1,ext2,ext3,createUser,createDate,modifyUser,modifyDate,activeCode from pos_authc where diskSerialNumber='$diskSerialNumber' and macAddress = '$macAddress';";
      var database = await SqlUtils.instance.open();
      List<Map<String, dynamic>> lists = await database.rawQuery(sql);

      if (lists.length > 0) {
        Global.instance.authc = Authc.fromMap(lists.first);
      } else {
        Global.instance.authc = null;
      }
      result = Global.instance.authc != null &&
          (Global.instance.authc.macAddress.contains(macAddress) ||
              Global.instance.authc.diskSerialNumber
                  .contains(diskSerialNumber));
    } catch (e) {
      FLogger.error("检测硬件是否注册发生异常:" + e.toString());

      result = false;
    }

    return result;
  }

  //启用新的认证机制
  Future<void> addActiveCodeColumn() async {
    try {
      // //判断pos_authc表中是否已经存在activeCode列
      // String sql = "select count(*) as count from sqlite_master where name = 'pos_authc' and sql like '%activeCode%'";
      // List<Map<String, dynamic>> lists = await database.rawQuery(sql);
      // if (lists != null && lists.length == 0) {
      //
      // } else {
      //   FLogger.info("#########################################################################");
      // }
      var database = await SqlUtils.instance.open();
      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.execute("alter table pos_authc add column activeCode text;");
        await batch.commit(noResult: false);
      });

      FLogger.info("激活码数据列更新成功");
    } catch (e) {
      FLogger.error("激活码列已经存在,忽略本错误");
    }
  }
}
