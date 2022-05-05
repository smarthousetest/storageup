import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/space_repository.dart';
import 'package:upstorage_desktop/utilites/services/keeper_service.dart';
import '../../constants.dart';
import '../../utilites/repositories/token_repository.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceState()) {
    on<SpaceEvent>((event, emit) async {
      if (event is SpacePageOpened) {
        await _mapSpacePageOpened(event, state, emit);
      }
      if (event is RunSoft) {
        await _mapRunSoft(state, event);
      }
      if (event is SaveDirPath) {
        await _mapSaveDirPath(event, state, emit);
      }
    });
  }

  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _subscriptionService = getIt<KeeperService>();

  Future _mapSpacePageOpened(
    SpacePageOpened event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    final locationsInfo = _repository.getlocationsInfo;
    var keeper = await _subscriptionService.getAllKeepers();
    emit(state.copyWith(user: user, locationsInfo: locationsInfo, keeper: keeper));
  }

  Future _mapRunSoft(
    SpaceState state,
    RunSoft event,
  ) async {
    var os = (Platform.isWindows) ? Windows() : Linux();
    var keeperLocations = File('${os.appDirPath}keeper_locations');
    if (keeperLocations.existsSync()) {
      keeperLocations.deleteSync();
    }
    keeperLocations.createSync();
    var keeperLocationsSink = keeperLocations.openWrite(mode: FileMode.append);
    state.locationsInfo.forEach((element) {
      keeperLocationsSink.add('${element.dirPath}|${element.countGb * GB}\n'.codeUnits);
    });
    await keeperLocationsSink.close();
    _writeKeeperId('${state.locationsInfo.last.dirPath}${Platform.pathSeparator}keeper_id.txt', event.keeperId);
    var bearerToken = await TokenRepository().getApiToken();
    if (bearerToken != null) {
      os.startProcess('keeper', [
        Uri.encodeFull(state.locationsInfo.last.dirPath),
        '${state.locationsInfo.last.countGb * GB}',
        bearerToken,
        Uri.encodeFull(state.locationsInfo.last.name),
      ]);
    }
  }

  void _writeKeeperId(String path, String keeper_id){
    File(path).createSync(recursive: true);
    File(path).writeAsStringSync(keeper_id);
  }

  _mapSaveDirPath(
    SaveDirPath event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    var countOfGb = event.countGb;
    var path = event.pathDir;
    var name = event.name;
    var id = await _subscriptionService.addNewKeeper(name, countOfGb);
    if (id != null) {
      _repository.createLocation(countOfGb: countOfGb, path: path, name: name, idForCompare: id);
      var locationsInfo = _repository.getlocationsInfo;
      final tmpState = state.copyWith(locationsInfo: locationsInfo);
      emit(tmpState);
      add(RunSoft(tmpState, id));
    }


    // _mapRunSoft(tmpState, id);
  }
}
