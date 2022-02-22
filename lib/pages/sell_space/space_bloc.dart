import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceState()) {
    on<SpaceEvent>((event, emit) async {
      if (event is SpacePageOpened) {
        await _mapSpacePageOpened(event, state, emit);
      }
      if (event is RunSoft) {
        await _mapRunSoft(event, state, emit);
      }
      if (event is SaveDirPath) {
        await _mapSaveDirPath(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();

  Future _mapSpacePageOpened(
    SpacePageOpened event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    User? user = await _userController.getUser;
    emit(state.copyWith(user: user));
  }

  Future _mapRunSoft(
    RunSoft event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    var result = Process.runSync(
        'reg', ['query', 'HKCU\Software\StorageUp', '/v', 'DirPath']);
    String dirPath = result.stdout.split(' ').last;
    dirPath = dirPath.substring(0, dirPath.length - 4);
    Process.runSync(
        'powershell.exe',
        [
          'Start-Process',
          '-WindowStyle',
          'hidden',
          '-FilePath',
          '$dirPath\start_keeper.vbs',
          dirPath,
          'Путь до папки из FilePicker',
          'Вес папки с ползунка'
        ],
        runInShell: true);
  }

  _mapSaveDirPath(
    SaveDirPath event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) {
    var countGb = event.countGb;
    var dirPath = event.dirPath;
    emit(state.copyWith(dirPath: dirPath, countGb: countGb));
  }
}
