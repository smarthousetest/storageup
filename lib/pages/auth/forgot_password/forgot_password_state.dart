import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/pages/auth/models/email.dart';

class ForgotPasswordState extends Equatable {
  final Email email;

  final FormzStatus status;

  ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  ForgotPasswordState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
      ];
}
