import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/user.dart';

class SettingsState extends Equatable {
  final User? user;
  final FormzStatus status;
  final bool needToLogout;
  final String language;

  SettingsState({
    this.user,
    this.status = FormzStatus.pure,
    this.needToLogout = false,
    this.language = '',
  });

  SettingsState copyWith({
    User? user,
    FormzStatus? status,
    String? language,
    bool? needToLogout,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      needToLogout: needToLogout ?? false,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [user, status, needToLogout, language];
}
