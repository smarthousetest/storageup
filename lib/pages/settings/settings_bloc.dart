import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/settings/settings_event.dart';
import 'package:storageup/pages/settings/settings_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/language_locale.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';
import 'package:storageup/utilities/services/auth_service.dart';
import 'package:storageup/utilities/services/files_service.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<SettingsEvent>((event, emit) async {
      if (event is SettingsPageOpened) {
        await _mapSettingsPageOpened(event, state, emit);
      } else if (event is SettingsNameChanged) {
        await _mapSettingNameChanged(event, state, emit);
      } else if (event is SettingsLogOut) {
        await _logout(state, emit);
      } else if (event is SettingsChangeProfileImage) {
        await _changeProfilePic(state, emit);
      } else if (event is SettingsPasswordChanged) {
        await _changePassword(event, state, emit);
      } else if (event is LanguageChanged) {
        await _mapLanguageChanged(event, state, emit);
      } else if (event is SettingsDeleteProfileImage) {
        await _deleteAvatars(event, state, emit);
      }
    });
  }

  TokenRepository _tokenRepository = getIt<TokenRepository>();
  FilesService _filesService = getIt<FilesService>();
  late FilesController _filesController;

  UserController _userController = getIt<UserController>();

  AuthService _authController = getIt<AuthService>();

  Future _mapSettingsPageOpened(
    SettingsPageOpened event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    _filesController = await GetIt.I.getAsync<FilesController>();
    var locale = await getLocale();
    var valueNotifier = _userController.getValueNotifier();
    emit(state.copyWith(
      language: locale.languageCode,
      valueNotifier: valueNotifier,
    ));
  }

  Future _mapSettingNameChanged(
    SettingsNameChanged event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    await _userController.changeName(event.name);

    User? user = await _userController.getUser;
    emit(state.copyWith(
      user: user,
      status: FormzStatus.submissionSuccess,
    ));
  }

  Future<SettingsState> _mapLanguageChanged(
    LanguageChanged event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    return state.copyWith(language: event.newLanguage);
  }

  Future _changePassword(
    SettingsPasswordChanged event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    var result = await _authController.changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );
    if (result == AuthenticationStatus.authenticated) {}

    print(result);
    emit(state.copyWith(
      status: FormzStatus.submissionSuccess,
      needToLogout: true,
    ));
  }

  Future _logout(
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    _filesController.clearAll();
    await _tokenRepository.setApiToken('');

    emit(state.copyWith(
      status: FormzStatus.submissionSuccess,
      needToLogout: true,
    ));
  }

  Future _deleteAvatars(
    SettingsDeleteProfileImage event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    var publicUrl = await _filesService.deleteProfilePic(user: state.user!);
    User? user = await _userController.updateUser();
    if (publicUrl.name == "failed") {
      emit(state.copyWith(status: FormzStatus.submissionFailure, user: user));
    }
    if (publicUrl.name == "noInternet") {
      emit(state.copyWith(status: FormzStatus.submissionCanceled, user: user));
    }
    emit(state.copyWith(status: FormzStatus.submissionSuccess, user: user));
  }

  Future _changeProfilePic(
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    //var picker = FilePicker();
    var img = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    print(img);
    // var img = await FilePicker.platform.pickFiles(allowMultiple: true,
    //   type: FileType.image,);

    if (img != null) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      var file = File(img.paths.first!);
      print(file);

      var publicUrl = await _filesService.uploadProfilePic(file: file);

      if (publicUrl != null) {
        var result = await _userController.changeProfilePic(publicUrl);
        if (result == ResponseStatus.ok) {
          User? user = await _userController.updateUser();
          emit(state.copyWith(
            user: user,
            status: FormzStatus.submissionSuccess,
          ));
        } else
          emit(state.copyWith(status: FormzStatus.submissionFailure));
      } else
        emit(state.copyWith(status: FormzStatus.submissionCanceled));
    } else
      emit(state.copyWith(status: FormzStatus.pure));
  }
}
