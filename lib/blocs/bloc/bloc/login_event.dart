part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

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

class WorkerLogin extends LoginEvent {
  final bool offline;
  WorkerLogin({this.offline = false});
  @override
  List<Object> get props => [];
}

enum LoginStatus { None, Initial, Loading, Confirm, Success, Failure }
