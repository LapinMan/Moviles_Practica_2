part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginUnAuthState extends LoginState {}

class LogOutSucessState extends LoginState {}

class LoginErrState extends LoginState {}

class LoginWaitState extends LoginState {}
