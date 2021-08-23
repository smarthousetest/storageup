import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegisterEmailChanged extends AuthEvent {
  final String email;

  AuthRegisterEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthLoginEmailChanged extends AuthEvent {
  final String email;

  AuthLoginEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthRegisterPasswordChanged extends AuthEvent {
  final String password;

  AuthRegisterPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class AuthLoginPasswordChanged extends AuthEvent {
  final String password;

  AuthLoginPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class AuthNameChanged extends AuthEvent {
  final String name;

  AuthNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class AuthSendEmailVerify extends AuthEvent {
  AuthSendEmailVerify();
}

class AuthClear extends AuthEvent {
  AuthClear();
}

class AuthRememberMeChanged extends AuthEvent {
  AuthRememberMeChanged();
}

class AuthAcceptTermsOfUseChanged extends AuthEvent {
  AuthAcceptTermsOfUseChanged();
}

class AuthLoginConfirmed extends AuthEvent {
  AuthLoginConfirmed();
}

class AuthRegisterConfirmed extends AuthEvent {
  AuthRegisterConfirmed();
}
