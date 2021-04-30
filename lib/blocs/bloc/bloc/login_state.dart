part of 'login_bloc.dart';

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
