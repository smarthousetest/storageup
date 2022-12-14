import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cpp_native/cpp_native.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:os_specification/os_specification.dart';
import 'package:storageup/models/download_location.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/auth/models/name.dart';
import 'package:storageup/pages/sell_space/space_event.dart';
import 'package:storageup/pages/sell_space/space_state.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/space_repository.dart';
import 'package:storageup/utilities/services/keeper_service.dart';

import '../../constants.dart';
import '../../utilities/keeper_data.dart';
import '../../utilities/repositories/token_repository.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceState()) {
    on<SpaceEvent>((event, emit) async {
      if (event is SpacePageOpened) {
        await _mapSpacePageOpened(event, state, emit);
      } else if (event is SaveDirPath) {
        await _mapSaveDirPath(event, state, emit);
      } else if (event is SendKeeperVersion) {
        _sendLocalKeeperVersion(state, emit);
      } else if (event is UpdateKeepersList) {
        await _mapUpdateKeepersList(event, state, emit);
      } else if (event is GetUserDisks) {
        await _mapGetUserDisks(event, state, emit);
      } else if (event is GetPathToKeeper) {
        await _getPathToKeeper(event, state, emit);
      } else if (event is NameChanged) {
        _mapNameChanged(state, event, emit);
      } else if (event is GetDiskToKeeper) {
        await _mapGetDiskToKeeper(event, state, emit);
      } else if (event is GetAlreadyUsedDisk) {
        await _mapGetAlreadyUsedDisk(event, state, emit);
      } else if (event is ChangeKeeper) {
        _changeKeeper(state, event, emit);
      }
    });
  }

  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _keeperService = getIt<KeeperService>();

  Future _mapSpacePageOpened(
    SpacePageOpened event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    final locationsInfo = _repository.locationsInfo;
    var keeper = await _keeperService.getAllKeepers();
    var valueNotifier = await _userController.getValueNotifier();
    final diskList = await getDisksList();
    List<String> checkedDisk = [];
    for (String availableDisk in diskList)
      if (locationsInfo.any(
          (_locationInfo) => _locationInfo.dirPath == availableDisk.trim())) {
      } else {
        checkedDisk.add(availableDisk.trim());
        print(checkedDisk);
      }
    if (keeper.left == null) {
      emit(state.copyWith(
        locationsInfo: locationsInfo,
        keeper: keeper.right,
        valueNotifier: valueNotifier,
        diskList: diskList,
      ));
    }
  }

  // DiskSpaceController()
  Future<void> _getPathToKeeper(
    GetPathToKeeper event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    if (event.pathForChange != null) {
      var path = DiskSpaceController(pathToDir: event.pathForChange!);
      var availableBytes = await path.getAvailableDiskSpace();
      print(availableBytes);
      emit(state.copyWith(
        availableSpace: availableBytes,
      ));
    } else {
      String? result = await FilePicker.platform.getDirectoryPath();

      if (result != null) {
        var path = DiskSpaceController(pathToDir: result);
        var availableBytes = await path.getAvailableDiskSpace();
        print(availableBytes);
        emit(state.copyWith(
          pathToKeeper: PathCheck.doPathCorrect(result),
          availableSpace: availableBytes,
        ));
      }
    }
  }

  Future<void> _changeKeeper(
    SpaceState state,
    ChangeKeeper event,
    Emitter<SpaceState> emit,
  ) async {
    var countOfGb = event.countGb;

    var id = await _keeperService.changeKeeper(
        state.name.value, countOfGb, event.keeper.keeperId);
    DownloadLocation keeper = DownloadLocation(
        countGb: countOfGb,
        name: state.name.value,
        keeperId: event.keeper.keeperId,
        dirPath: event.keeper.dirPath,
        id: event.keeper.id);
    if (id != null) {
      _repository.changeLocation(location: keeper);
      // var locationsInfo = _repository.locationsInfo;
      // final tmpState = state.copyWith(locationsInfo: locationsInfo);
      // emit(tmpState);
      // var box = await Hive.openBox('keeper_data');
      // await box.put(keeperDataId.toString(), Uri.encodeFull(path));
      // _mapRunSoft(tmpState, id);
    }
  }

  Future<void> _mapNameChanged(
    SpaceState state,
    NameChanged event,
    Emitter<SpaceState> emit,
  ) async {
    Name name = Name.dirty(event.name, event.needValidation);
    print(name.value);
    emit(state.copyWith(
      name: name,
    ));
  }

  Future<void> _mapGetDiskToKeeper(
      GetDiskToKeeper event, SpaceState state, Emitter<SpaceState> emit) async {
    String? selectedDisk = event.selectedDisk;
    if (selectedDisk != null) {
      var path = DiskSpaceController(pathToDir: selectedDisk);
      var availableBytes = await path.getAvailableDiskSpace();
      print(availableBytes);
      emit(state.copyWith(
        pathToKeeper: PathCheck.doPathCorrect(selectedDisk),
        availableSpace: availableBytes,
      ));
    }
  }

  Future _mapRunSoft(
    SpaceState state,
    String keeperId,
  ) async {
    var os = OsSpecifications.getOs();
    _writeKeeperId(
      '${state.pathToKeeper}',
      keeperId,
    );
    var bearerToken = await TokenRepository().getApiToken();
    if (bearerToken != null) {
      _writeKeeperName(state);
      _writeKeeperMemorySize(state);
      os.startProcess(Processes.keeper, true, [
        domainName,
        Uri.encodeFull(
            "${state.locationsInfo.last.dirPath}${Platform.pathSeparator}.keeper"),
        bearerToken,
      ]);
    }
    // for(int i = 0; i < 5; i++){
    //   add(GetKeeperInfo());
    //   print("Try to keeper update");
    //   await Future.delayed(Duration(seconds: 3));
    // }
  }

  void _writeKeeperName(SpaceState state) {
    var keeperNameFile = File(
      '${state.pathToKeeper}${Platform.pathSeparator}.keeper${Platform.pathSeparator}keeperName',
    );
    if (!keeperNameFile.existsSync()) {
      keeperNameFile.createSync(recursive: true);
    }
    keeperNameFile.writeAsStringSync(state.locationsInfo.last.name);
  }

  void _writeKeeperMemorySize(SpaceState state) {
    var keeperMemorySizeFile = File(
      '${state.pathToKeeper}${Platform.pathSeparator}.keeper${Platform.pathSeparator}memorySize',
    );
    if (!keeperMemorySizeFile.existsSync()) {
      keeperMemorySizeFile.createSync(recursive: true);
    }
    keeperMemorySizeFile
        .writeAsStringSync('${state.locationsInfo.last.countGb * GB}');
  }

  void _writeKeeperId(String keeperDisk, String keeperId) {
    var partsList = [keeperDisk, ".keeper", "keeper_id.txt"];
    var keeperIdFile = File(partsList.join(Platform.pathSeparator));
    if (!keeperIdFile.existsSync()) {
      keeperIdFile.createSync(recursive: true);
    }
    keeperIdFile.writeAsStringSync(keeperId);
  }

  _mapSaveDirPath(
    SaveDirPath event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    emit(state.copyWith(statusHttpRequest: FormzStatus.pure));
    var countOfGb = event.countGb;
    var path = state.pathToKeeper;
    var id = await _keeperService.addNewKeeper(state.name.value, countOfGb);
    if (id.right != null) {
      int keeperDataId = _repository.createLocation(
          countOfGb: countOfGb,
          path: path,
          name: state.name.value,
          idForCompare: id.right!);
      var locationsInfo = _repository.locationsInfo;
      final tmpState =
          state.copyWith(locationsInfo: locationsInfo, name: Name.dirty());
      emit(tmpState);
      var box = await Hive.openBox('keeper_data');
      await box.put(keeperDataId.toString(), Uri.encodeFull(path));
      _mapRunSoft(tmpState, id.right!);
    } else if (id.left == ResponseStatus.declined) {
      emit(state.copyWith(statusHttpRequest: FormzStatus.submissionCanceled));
    } else if (id.left == ResponseStatus.failed) {
      emit(state.copyWith(statusHttpRequest: FormzStatus.submissionFailure));
    }
  }

  void _sendLocalKeeperVersion(SpaceState state, Emitter<SpaceState> emit) {
    print("_sendLocalKeeperVersion");
    var keeperVersion = _getKeeperVersion();
    if (state.localKeeperVersion != keeperVersion) {
      _putLocalKeeperVersion(state, keeperVersion);
      emit(state.copyWith(localKeeperVersion: _getKeeperVersion()));
    }
  }

  void _putLocalKeeperVersion(SpaceState state, String keeperVersion) async {
    Dio dio = getIt<Dio>(instanceName: 'record_dio');
    String? bearerToken = await getIt<TokenRepository>().getApiToken();
    for (var location in state.locationsInfo) {
      try {
        dio.put(
          "/keeper/${location.keeperId}",
          data: KeeperData(
            null,
            null,
            null,
            null,
            keeperVersion,
          ).toJson(),
          options: Options(
            headers: {
              "Authorisation": "Bearer $bearerToken",
            },
          ),
        );
        print("Keeper info is sent");
      } catch (e) {
        print("_putLocalKeeperVersion");
        print(e);
      }
    }
  }

  String _getKeeperVersion() {
    var os = OsSpecifications.getOs();
    var keeperVersionFile = File("${os.appDirPath}keeper_version.txt");
    var keeperVersion = "0.0.0.0";
    if (!keeperVersionFile.existsSync()) {
      keeperVersionFile.createSync();
      keeperVersionFile.writeAsStringSync(keeperVersion);
    } else if (keeperVersion.isEmpty) {
      keeperVersionFile.writeAsStringSync(keeperVersion);
    } else {
      keeperVersion = keeperVersionFile.readAsStringSync().trim();
    }
    return keeperVersion;
  }

  Future _mapUpdateKeepersList(
    UpdateKeepersList event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    var keeper = await _keeperService.getAllKeepers();
    if (keeper.right != null) {
      emit(state.copyWith(
        keeper: keeper.right,
        statusHttpRequest: FormzStatus.valid,
      ));
    } else if (keeper.left == ResponseStatus.declined) {
      emit(state.copyWith(statusHttpRequest: FormzStatus.submissionCanceled));
    } else if (keeper.left == ResponseStatus.failed) {
      print("folder");
      emit(state.copyWith(
        statusHttpRequest: FormzStatus.submissionFailure,
      ));
    }
  }

  Future _mapGetUserDisks(
    GetUserDisks event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    final diskList = await getDisksList();
    emit(state.copyWith(
      diskList: diskList,
    ));
  }

  Future _mapGetAlreadyUsedDisk(
    GetAlreadyUsedDisk event,
    SpaceState state,
    Emitter<SpaceState> emit,
  ) async {
    final locationsInfo = await _repository.locationsInfo;
    final diskList = await getDisksList();
    List<String> checkedDisk = [];
    for (String availableDisk in diskList)
      if (locationsInfo.any(
          (_locationInfo) => _locationInfo.dirPath == availableDisk.trim())) {
      } else {
        checkedDisk.add(availableDisk.trim());
      }
    emit(state.copyWith(
        diskList: checkedDisk, statusHttpRequest: FormzStatus.valid));
  }
}

class PathCheck {
  static List<String> _restrictedWords = [
    'OneDrive',
    'Program Files',
    'Program Files (x86)',
  ];

  bool isPathCorrect(String path) {
    var partsOfPath = path.split(Platform.pathSeparator);
    for (var part in partsOfPath) {
      for (var restrictedWord in _restrictedWords) {
        if (part == restrictedWord) {
          return false;
        }
      }
    }
    return true;
  }

  ///Function check is a path contain "OneDrive" part
  ///If contain, return path before "OneDrive" part
  static String doPathCorrect(String path) {
    var partPath = path.split(Platform.pathSeparator);
    for (int i = 0; i < partPath.length; i++) {
      for (var restrictedWord in _restrictedWords) {
        if (partPath[i] == restrictedWord) {
          var result = partPath.sublist(0, i);
          result.add(path.split(Platform.pathSeparator).last);
          return result.join(Platform.pathSeparator);
        }
      }
    }
    return path;
  }

  @override
  String toString() {
    return _restrictedWords.toString();
  }
}
