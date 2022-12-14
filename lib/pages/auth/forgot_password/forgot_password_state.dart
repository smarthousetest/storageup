import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/models/email.dart';

class ForgotPasswordState extends Equatable {
  final Email email;

  final FormzStatus status;

  final AuthError? error;

  ForgotPasswordState(
      {this.email = const Email.pure(),
      this.status = FormzStatus.pure,
      this.error});

  ForgotPasswordState copyWith({
    Email? email,
    FormzStatus? status,
    AuthError? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        error,
      ];
}
