import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent();

  @override
  List<Object?> get props => [];
}

// class AuthRegisterEmailChanged extends HomeEvent {
//   final String email;
//
//   AuthRegisterEmailChanged({required this.email});
//
//   @override
//   List<Object?> get props => [email];
// }
//
// class AuthLoginEmailChanged extends HomeEvent {
//   final String email;
//
//   AuthLoginEmailChanged({required this.email});
//
//   @override
//   List<Object?> get props => [email];
// }
//
// class AuthRegisterPasswordChanged extends AuthEvent {
//   final String password;
//
//   AuthRegisterPasswordChanged({required this.password});
//
//   @override
//   List<Object?> get props => [password];
// }
//
// class AuthLoginPasswordChanged extends AuthEvent {
//   final String password;
//
//   AuthLoginPasswordChanged({required this.password});
//
//   @override
//   List<Object?> get props => [password];
// }
//
// class AuthNameChanged extends AuthEvent {
//   final String name;
//
//   AuthNameChanged({required this.name});
//
//   @override
//   List<Object?> get props => [name];
// }
//
// class AuthRememberMeChanged extends AuthEvent {
//   AuthRememberMeChanged();
// }
//
// class AuthAcceptTermsOfUseChanged extends AuthEvent {
//   AuthAcceptTermsOfUseChanged();
// }
//
// class AuthLoginConfirmed extends AuthEvent {
//   AuthLoginConfirmed();
// }
//
// class AuthRegisterConfirmed extends AuthEvent {
//   AuthRegisterConfirmed();
// }
