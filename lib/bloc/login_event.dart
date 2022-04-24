part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class VerifyLoginEvent extends LoginEvent {}

class GoogleLoginEvent extends LoginEvent {}

class SignOutLoginEvent extends LoginEvent {}
