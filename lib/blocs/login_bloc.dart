import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/entity/pos_worker.dart';
import 'package:h3_app/global.dart';
import 'package:h3_app/logger/logger.dart';
import 'package:h3_app/utils/active_code_utils.dart';
import 'package:h3_app/utils/authz_utils.dart';
import 'package:h3_app/utils/string_utils.dart';
import 'package:h3_app/utils/tuple.dart';

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

      Tuple3<bool, String, Worker> response;
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

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

///激活码输入事件
class WorkerNoChanged extends LoginEvent {
  final String workerNo;
  final bool workerNoValid;
  const WorkerNoChanged({
    this.workerNo,
    this.workerNoValid,
  });

  @override
  List<Object> get props => [workerNo, workerNoValid];
}

///操作员密码输入
class PasswordChanged extends LoginEvent {
  final String password;
  final bool passwordValid;
  const PasswordChanged({
    this.password,
    this.passwordValid,
  });

  @override
  List<Object> get props => [password, passwordValid];
}

///登录操作事件
class WorkerLogin extends LoginEvent {
  final bool offline;
  WorkerLogin({this.offline = false});
  @override
  List<Object> get props => [];
}

enum LoginStatus { None, Initial, Loading, Confirm, Success, Failure }

class LoginState extends Equatable {
  ///操作员工号
  final String workerNo;

  ///操作员工号校验
  final bool workerNoValid;

  ///操作员密码
  final String password;

  ///操作员工号校验
  final bool passwordValid;

  ///当前页面的状态
  final LoginStatus status;

  ///提醒消息
  final String message;

  const LoginState({
    this.status,
    this.workerNo,
    this.workerNoValid,
    this.password,
    this.passwordValid,
    this.message,
  });

  ///表单初始化
  factory LoginState.init() {
    return LoginState(
      status: LoginStatus.None,
      workerNo: "",
      workerNoValid: false,
      password: "",
      passwordValid: false,
      message: "",
    );
  }

  LoginState loading() {
    return copyWith(
      status: LoginStatus.Loading,
    );
  }

  LoginState success() {
    return copyWith(
      status: LoginStatus.Success,
    );
  }

  LoginState failure({String message}) {
    return copyWith(
      status: LoginStatus.Failure,
      message: message,
    );
  }

  LoginState copyWith({
    LoginStatus status,
    String workerNo,
    bool workerNoValid,
    String password,
    bool passwordValid,
    String message,
  }) {
    return LoginState(
      status: status ?? this.status,
      workerNo: workerNo ?? this.workerNo,
      workerNoValid: workerNoValid ?? this.workerNoValid,
      password: password ?? this.password,
      passwordValid: passwordValid ?? this.passwordValid,
      message: message ?? this.message,
    );
  }

  bool get isValid => (this.workerNoValid && this.passwordValid);

  @override
  List<Object> get props => [
        this.workerNo,
        this.workerNoValid,
        this.password,
        this.passwordValid,
        this.status,
        this.message
      ];
}
