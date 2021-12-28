import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/settings/settings_event.dart';
import 'package:upstorage_desktop/pages/settings/settings_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/utilites/services/files_service.dart';
import 'package:image_picker/image_picker.dart';

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
      }
    });
  }

  TokenRepository _tokenRepository = getIt<TokenRepository>();
  FilesService _filesService = getIt<FilesService>();
  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  UserController _userController = getIt<UserController>();

  Future _mapSettingsPageOpened(
    SettingsPageOpened event,
    SettingsState state,
    Emitter<SettingsState> emit,
  ) async {
    User? user = await _userController.getUser;
    emit(state.copyWith(user: user));
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
        var result = await _filesService.setProfilePic(
            url: publicUrl, user: state.user!);
        if (result == ResponseStatus.ok) {
          User? user = await _userController.updateUser();
          emit(state.copyWith(
            user: user,
            status: FormzStatus.submissionSuccess,
          ));
        } else
          emit(state.copyWith(status: FormzStatus.submissionFailure));
      } else
        emit(state.copyWith(status: FormzStatus.submissionFailure));
    } else
      emit(state.copyWith(status: FormzStatus.submissionFailure));
  }
}
