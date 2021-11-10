import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/pages/auth/models/email.dart';
import 'package:upstorage_desktop/pages/auth/models/password.dart';
import 'package:upstorage_desktop/utilities/enums.dart';

import 'models/name.dart';

enum RequestedAction { registration, login }

class AuthState extends Equatable {
  final Password passwordLogin;
  final Email emailLogin;

  final Password passwordRegister;
  final Email emailRegister;
  final Name name;

  final bool acceptedTermsOfUse;
  final bool rememberMe;

  final FormzStatus status;

  final AuthError? error;

  final RequestedAction? action;

  AuthState({
    this.emailLogin = const Email.pure(),
    this.passwordLogin = const Password.pure(),
    this.emailRegister = const Email.pure(),
    this.passwordRegister = const Password.pure(),
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.acceptedTermsOfUse = false,
    this.rememberMe = false,
    this.error,
    this.action,
  });

  AuthState copyWith({
    Password? passwordLogin,
    Email? emailLogin,
    Password? passwordRegister,
    Email? emailRegister,
    Name? name,
    bool? acceptedTermsOfUse,
    bool? rememberMe,
    FormzStatus? status,
    AuthError? error,
    RequestedAction? action,
  }) {
    return AuthState(
      acceptedTermsOfUse: acceptedTermsOfUse ?? this.acceptedTermsOfUse,
      emailLogin: emailLogin ?? this.emailLogin,
      name: name ?? this.name,
      passwordLogin: passwordLogin ?? this.passwordLogin,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      emailRegister: emailRegister ?? this.emailRegister,
      passwordRegister: passwordRegister ?? this.passwordRegister,
      error: error,
      action: action,
    );
  }

  @override
  List<Object?> get props => [
        acceptedTermsOfUse,
        emailLogin,
        passwordLogin,
        emailRegister,
        passwordRegister,
        name,
        rememberMe,
        status,
        error,
        action,
      ];
}
