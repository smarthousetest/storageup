import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthPageOpened extends AuthEvent {
  AuthPageOpened();
}

class AuthRegisterEmailChanged extends AuthEvent {
  final String email;
  final bool needValidation;

  AuthRegisterEmailChanged({
    required this.email,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [email];
}

class AuthLoginEmailChanged extends AuthEvent {
  final String email;
  final bool needValidation;

  AuthLoginEmailChanged({
    required this.email,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [email];
}

class AuthRegisterPasswordChanged extends AuthEvent {
  final String password;
  final bool needValidation;

  AuthRegisterPasswordChanged({
    required this.password,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [password];
}

class AuthLoginPasswordChanged extends AuthEvent {
  final String password;
  final bool needValidation;

  AuthLoginPasswordChanged({
    required this.password,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [password];
}

class AuthNameChanged extends AuthEvent {
  final String name;
  final bool needValidation;

  AuthNameChanged({
    required this.name,
    this.needValidation = false,
  });

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
