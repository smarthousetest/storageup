import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsPageOpened extends SettingsEvent {
  const SettingsPageOpened();
}

class SettingsNameChanged extends SettingsEvent {
  final String name;

  const SettingsNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class SettingsPasswordChanged extends SettingsEvent {
  final String oldPassword;
  final String newPassword;

  const SettingsPasswordChanged({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class LanguageChanged extends SettingsEvent {
  final String newLanguage;

  LanguageChanged({
    required this.newLanguage,
  });

  @override
  List<Object?> get props => [newLanguage];
}

class SettingsLogOut extends SettingsEvent {
  const SettingsLogOut();
}

class SettingsChangeProfileImage extends SettingsEvent {
  const SettingsChangeProfileImage();
}

class SettingsDeleteProfileImage extends SettingsEvent {
  const SettingsDeleteProfileImage();
}
