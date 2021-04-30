import 'dart:async';
import 'dart:html';
import 'package:h3_app/entity/pos_worker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/authz_utils.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

import '../../../global.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.init());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is WorkerNoChanged) {
      yield state.copyWith(
        status: LoginStatus.Initial,
        workerNo: event.workerNo,
        workerNoValid: _isWorkerNoValid(event.workerNo),
      );
    } else if (event is PasswordChanged) {
      yield state.copyWith(
        status: LoginStatus.Initial,
        password: event.password,
        passwordValid: _isPasswordValid(event.password),
      );
    } else if (event is WorkerLogin) {
      yield* _mapWorkerLoginToState(event);
    }
  }

  Stream<LoginState> _mapWorkerLoginToState(WorkerLogin event) async* {
    try {
      var offline = event.offline ?? Global.instance.online;

      yield state.loading();

      Tuple3 response;
      // Tuple3<bool, String, Worker> response;
      //脱机登录
      if (offline) {
        FLogger.info("收银员${state.workerNo}脱机登录中....");
        response = await AuthzUtils.instance
            .databaseLogin(state.workerNo, state.password);
      } else {
        FLogger.info("收银员${state.workerNo}联机登录中....");
        response =
            await AuthzUtils.instance.httpLogin(state.workerNo, state.password);
      }

      String message = response.item2;

      ///用户验证成功
      if (response.item1) {
        Global.instance.worker = Worker.clone(response.item3);

        var shiftLog = await Global.instance.getShiftLog();

        print("登陆用户:${shiftLog.workerName},当前班次:${shiftLog.id}");

        yield state.success();
      } else {
        yield state.failure(message: message);
      }
    } catch (_) {
      yield state.failure(message: "操作员登录发生错误");
    }
  }

  ///工号输入验证，不为空，长度<=12
  bool _isWorkerNoValid(String workerNo) {
    return StringUtils.isNotBlank(workerNo) && workerNo.length <= 12;
  }

  ///工号输入验证，不为空，长度等<=12
  bool _isPasswordValid(String password) {
    return StringUtils.isNotBlank(password) && password.length <= 12;
  }
}
