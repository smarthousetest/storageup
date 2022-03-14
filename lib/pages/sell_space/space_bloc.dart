import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/space_repository.dart';

import '../../os/linux.dart';
import '../../os/windows.dart';

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
      if (event is DeleteLocation) {
        await _mapDeleteLocation(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;

  Future _mapSpacePageOpened(
    SpacePageOpened event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    final locationsInfo = _repository.getlocationsInfo;
    emit(state.copyWith(user: user, locationsInfo: locationsInfo));
  }

  Future _mapRunSoft(
    RunSoft event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    var os = (Platform.isWindows) ? Windows() : Linux();
    os.killProcess('keeper.exe');
    var appDirPath = os.getAppLocation();
    if (appDirPath.isNotEmpty){
      os.startProcessDetach('keeper', true, [state.locationsInfo.last.dirPath, (state.locationsInfo.last.countGb * 1024 * 1024 * 1024).toString()]);
    }
  }

  _mapSaveDirPath(
    SaveDirPath event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) {
    var countOfGb = event.countGb;
    var path = event.pathDir;

    _repository.createLocation(countOfGb: countOfGb, path: path);
    var locationsInfo = _repository.getlocationsInfo;
    emit(state.copyWith(locationsInfo: locationsInfo));
  }

  _mapDeleteLocation(
    DeleteLocation event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) {
    var idLocation = event.location.id;
    _repository.deleteLocation(id: idLocation);
  }
}
