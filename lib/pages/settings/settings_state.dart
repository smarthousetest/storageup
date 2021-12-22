import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/user.dart';

class SettingsState extends Equatable {
  final User? user;
  final FormzStatus status;
  final bool needToLogout;

  SettingsState({
    this.user,
    this.status = FormzStatus.pure,
    this.needToLogout = false,
  });

  SettingsState copyWith({
    User? user,
    FormzStatus? status,
    bool? needToLogout,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      needToLogout: needToLogout ?? false,
    );
  }

  @override
  List<Object?> get props => [user, status, needToLogout];
}
