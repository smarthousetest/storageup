import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
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
    emit(state.copyWith(
        user: user, locationsInfo: locationsInfo, keeper: keeper));
  }

  Future _mapRunSoft(
    SpaceState state,
    String keeperId,
  ) async {
    // var hashedPassword =
    //       new DBCrypt().hashpw(plainPwd, new DBCrypt().gensalt());
    var os = OsSpecifications.getOs();
    // os.setKeeperHash(state.user!.email!, hashedPassword);

    _writeKeeperId(
        '${state.locationsInfo.last.dirPath}${Platform.pathSeparator}keeper_id.txt',
        keeperId);
    var bearerToken = await TokenRepository().getApiToken();
    if (bearerToken != null) {
      _writeKeeperName(state);
      _writeKeeperMemorySize(state);

      os.startProcess('keeper', [
        domainName,
        Uri.encodeFull(state.locationsInfo.last.dirPath),
        bearerToken,
      ]);
    }
  }

  void _writeKeeperName(SpaceState state) {
    var keeperNameFile = File(
        '${state.locationsInfo.last.dirPath}${Platform.pathSeparator}keeperName');
    if (!keeperNameFile.existsSync()) {
      keeperNameFile.createSync(recursive: true);
    }
    keeperNameFile.writeAsStringSync(state.locationsInfo.last.name);
  }

  void _writeKeeperMemorySize(SpaceState state) {
    var keeperMemorySizeFile = File(
        '${state.locationsInfo.last.dirPath}${Platform.pathSeparator}memorySize');
    if (!keeperMemorySizeFile.existsSync()) {
      keeperMemorySizeFile.createSync(recursive: true);
    }
    keeperMemorySizeFile
        .writeAsStringSync('${state.locationsInfo.last.countGb * GB}');
  }

  void _writeKeeperId(String keeperIdFilePath, String keeper_id) {
    var keeperIdFile = File(keeperIdFilePath);
    if (!keeperIdFile.existsSync()) {
      keeperIdFile.createSync(recursive: true);
    }
    keeperIdFile.writeAsStringSync(keeper_id);
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
      int keeperDataId = _repository.createLocation(
          countOfGb: countOfGb, path: path, name: name, idForCompare: id);
      var locationsInfo = _repository.getlocationsInfo;
      final tmpState = state.copyWith(locationsInfo: locationsInfo);
      emit(tmpState);
      var box = await Hive.openBox('keeper_data');
      await box.put(keeperDataId.toString(), Uri.encodeFull(path));
      _mapRunSoft(tmpState, id);
    }
  }
}
