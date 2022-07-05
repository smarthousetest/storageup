import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/user.dart';

class SettingsState extends Equatable {
  final User? user;
  final FormzStatus status;
  final bool needToLogout;
  final String language;
  final ValueNotifier<User?>? valueNotifier;

  SettingsState({
    this.user,
    this.status = FormzStatus.pure,
    this.needToLogout = false,
    this.language = '',
    this.valueNotifier,
  });

  SettingsState copyWith({
    User? user,
    FormzStatus? status,
    String? language,
    bool? needToLogout,
    ValueNotifier<User?>? valueNotifier,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      needToLogout: needToLogout ?? false,
      language: language ?? this.language,
      valueNotifier: valueNotifier ?? this.valueNotifier,
    );
  }

  @override
  List<Object?> get props => [
        user,
        status,
        needToLogout,
        language,
        valueNotifier,
      ];
}
