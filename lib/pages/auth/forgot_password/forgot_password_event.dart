import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  final bool needValidation;

  ForgotPasswordEmailChanged({
    required this.email,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordConfirmed extends ForgotPasswordEvent {
  ForgotPasswordConfirmed();
}
