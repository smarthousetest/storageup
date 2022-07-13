import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cpp_native/local_update/local_update_server.dart';
import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:os_specification/os_specification.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/keeper/keeper.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:storageup/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/space_repository.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';
import 'package:storageup/utilities/services/keeper_service.dart';
import 'package:web_socket_channel/io.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc() : super(FolderListState()) {
    on<FolderListEvent>((event, emit) async {
      if (event is FolderListPageOpened) {
        await _startUpdatingKeeperInfo(event, state, emit, 5);
      } else if (event is GetKeeperInfo) {
        await _getKeeperInfo(event, state, emit);
      } else if (event is DeleteLocation) {
        await _deleteLocation(event, state, emit);
      } else if (event is SleepStatus) {
        await _emitSleepStatusKeeper(emit, state, event);
      } else if (event is KeeperReboot) {
        await _rebootKeeper(event, state, emit);
      }
    });
    on<UpdateLocationsList>(
        (event, emit) => emit(state.copyWith(locationsInfo: event.locations)));
  }

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _keeperService = getIt<KeeperService>();
  static Timer? timerUpdateKeeperInfo;

  Future _startUpdatingKeeperInfo(
    FolderListPageOpened event,
    FolderListState state,
    Emitter<FolderListState> emit,
    int updateKeeperInfoDelay,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    emit(state.copyWith(user: user));
    add(GetKeeperInfo());
    try {
      // if (timerUpdateKeeperInfo == null || !timerUpdateKeeperInfo!.isActive) {
      timerUpdateKeeperInfo?.cancel();
      timerUpdateKeeperInfo = Timer.periodic(
        Duration(seconds: updateKeeperInfoDelay),
        (Timer t) async {
          add(GetKeeperInfo());
          print("Update keeper info");
        },
      );
      print("Timer of updating keeper info started");
      // }

    } catch (e) {
      print('error timer in get keeper');
    }
    _repository.getDownloadLocationsValueListenable.addListener(_listener);
  }

  Future<void> _getKeeperInfo(
    GetKeeperInfo event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    List<Keeper> localKeepers = [];
    List<Keeper> serverKeepers = [];
    List<String> localPaths = [];
    var keepers = await _keeperService.getAllKeepers();
    final locationsInfo = await _repository.locationsInfo;
    if (keepers.right != null) {
      for (var keeper in keepers.right ?? []) {
        if (locationsInfo
            .any((_locationInfo) => _locationInfo.keeperId == keeper.id)) {
          if (state.localKeepers.isNotEmpty) {
            localKeepers.add(keeper.copyWith(
                isRebooting: (state.localKeepers
                        .firstWhere((keeper2) => keeper.name == keeper2.name))
                    .isRebooting));
          } else {
            localKeepers.add(keeper);
          }
          for (var locationInfo in locationsInfo) {
            localPaths.add(locationInfo.dirPath);
          }
        } else {
          serverKeepers.add(keeper);
        }
        emit(
          state.copyWith(
            locationsInfo: locationsInfo,
            localKeeper: localKeepers.reversed.toList(),
            serverKeeper: serverKeepers,
            localPath: localPaths.reversed.toList(),
            needToValidatePopup: false,
            statusHttpRequest: FormzStatus.pure,
          ),
        );
      }
    } else if (keepers.left == ResponseStatus.declined) {
      emit(
        state.copyWith(
          statusHttpRequest: FormzStatus.submissionCanceled,
          needToValidatePopup: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          statusHttpRequest: FormzStatus.submissionFailure,
          needToValidatePopup: true,
        ),
      );
    }
    // print('5 seconds update keeper');
  }

  void _listener() {
    final info = _repository.locationsInfo;
    if (!isClosed) {
      add(UpdateLocationsList(locations: info));
    }
  }

  @override
  Future<void> close() {
    timerUpdateKeeperInfo?.cancel();
    print('Timer is cancelled');
    return super.close();
  }

  _emitSleepStatusKeeper(
    Emitter<FolderListState> emit,
    FolderListState state,
    SleepStatus event,
  ) async {
    var keeperId = event.keeper.id;
    if (event.keeper.online == 1) {
      if (keeperId != null) {
        var result = await _keeperService.changeSleepStatus(keeperId);
        if (result.left == ResponseStatus.declined) {
          emit(
            state.copyWith(
              statusHttpRequest: FormzStatus.submissionCanceled,
              needToValidatePopup: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              statusHttpRequest: FormzStatus.submissionFailure,
              needToValidatePopup: true,
            ),
          );
        }
      }
      List<Keeper> localKeepers = [];
      List<Keeper> serverKeepers = [];
      List<String> localPaths = [];
      var keepers = await _keeperService.getAllKeepers();
      final locationsInfo = _repository.locationsInfo;

      if (keepers.right != null) {
        for (var keeper in keepers.right!) {
          if (locationsInfo.any((info) => info.keeperId == keeper.id)) {
            localKeepers.add(keeper);
            for (var locationInfo in locationsInfo) {
              localPaths.add(locationInfo.dirPath);
            }
          } else {
            serverKeepers.add(keeper);
          }
        }
        emit(
          state.copyWith(
            localKeeper: localKeepers.reversed.toList(),
            serverKeeper: serverKeepers,
            localPath: localPaths.reversed.toList(),
            statusHttpRequest: FormzStatus.pure,
            needToValidatePopup: false,
          ),
        );
      } else if (keepers.left == ResponseStatus.declined) {
        emit(
          state.copyWith(
            statusHttpRequest: FormzStatus.submissionCanceled,
            needToValidatePopup: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            statusHttpRequest: FormzStatus.submissionFailure,
            needToValidatePopup: true,
          ),
        );
      }
      // print('5 seconds update keeper');

    }
  }

  _deleteLocation(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    emit(state.copyWith(
        statusHttpRequest: FormzStatus.pure, needToValidatePopup: false));
    var idLocation = event.location.id;
    await _repository.deleteLocation(id: idLocation);
    var updateLocations = _repository.locationsInfo;
    var tmpState = state.copyWith(locationsInfo: updateLocations);
    await _deleteKeeper(event, tmpState, emit);
    var keeper = await _keeperService.getAllKeepers();
    List<Keeper> localKeeper = [];
    List<Keeper> serverKeeper = [];
    if (keeper.right != null) {
      for (var element in keeper.right!) {
        if (updateLocations.any((info) => info.keeperId == element.id)) {
          localKeeper.add(element);
        } else {
          serverKeeper.add(element);
        }
      }
      emit(
        state.copyWith(
          locationsInfo: updateLocations,
          localKeeper: localKeeper.reversed.toList(),
          serverKeeper: serverKeeper,
          statusHttpRequest: FormzStatus.pure,
          needToValidatePopup: false,
        ),
      );
    }
  }

  Future _deleteKeeper(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    emit(
      state.copyWith(statusHttpRequest: FormzStatus.pure),
    );
    String? bearerToken = await TokenRepository().getApiToken();
    Dio dio = getIt<Dio>(instanceName: 'record_dio');
    var box = await Hive.openBox('keeper_data');
    String keeperDir =
        Uri.decodeFull(await box.get(event.location.id.toString()));
    await box.delete(event.location.id.toString());
    String keeperId = '';
    var keeperIdFile = File(
        '$keeperDir${Platform.pathSeparator}.keeper${Platform.pathSeparator}keeper_id.txt');
    if (keeperIdFile.existsSync()) {
      keeperId = keeperIdFile.readAsStringSync().trim();
    }
    if (bearerToken != null) {
      await _getKeeperSession(keeperId, dio, bearerToken);
      try {
        await dio.delete(
          '/keeper',
          queryParameters: {'ids[]': keeperId},
          options: Options(
            headers: {
              'Authorization': 'Bearer $bearerToken',
            },
          ),
        );
      } on DioError catch (e) {
        print(e);
        if (e.response?.statusCode == 401 ||
            e.response?.statusCode == 429 ||
            e.response?.statusCode == 404 ||
            e.response?.statusCode == 500 ||
            e.response?.statusCode == 502 ||
            e.response?.statusCode == 504) {
          emit(
            state.copyWith(
                statusHttpRequest: FormzStatus.pure,
                needToValidatePopup: false),
          );
          emit(
            state.copyWith(
                statusHttpRequest: FormzStatus.submissionCanceled,
                needToValidatePopup: true),
          );
        } else {
          emit(
            state.copyWith(
                statusHttpRequest: FormzStatus.pure,
                needToValidatePopup: false),
          );
          emit(
            state.copyWith(
                statusHttpRequest: FormzStatus.submissionFailure,
                needToValidatePopup: true),
          );
        }
      }
    } else {
      emit(
        state.copyWith(
            statusHttpRequest: FormzStatus.pure, needToValidatePopup: false),
      );
      emit(
        state.copyWith(
            statusHttpRequest: FormzStatus.submissionFailure,
            needToValidatePopup: true),
      );
    }

    if (Directory('${keeperDir}${Platform.pathSeparator}.keeper')
        .existsSync()) {
      Directory('${keeperDir}${Platform.pathSeparator}.keeper')
          .deleteSync(recursive: true);
    }
    emit(state.copyWith(locationsInfo: _repository.locationsInfo));
  }

  Future _disconnectKeeper(String proxyUrl, String session) async {
    var channel = IOWebSocketChannel.connect(proxyUrl);
    channel.sink.add(
      json.encode({
        'messageType': 'update_disconnect',
        'session': session,
      }),
    );
    // await channel.sink.done;
  }

  Future _getKeeperSession(String keeperId, Dio dio, String bearerToken) async {
    for (int i = 0; i < 5; i++) {
      Response? response;
      try {
        response = await dio.get(
          '/keeper/${keeperId}',
          options: Options(
            receiveTimeout: 1000,
            sendTimeout: 1000,
            headers: {
              'Authorization': 'Bearer ${bearerToken}',
              'accept': 'application/json',
            },
          ),
        );
        if (response.data['online'] != 0) {
          await _disconnectKeeper(
              'ws://${response.data['proxyIP']}:${response.data['proxyPORT']}',
              response.data['session']);
        }
      } catch (e) {
        print(e);
      }
      break;
    }
  }

  Future<void> _rebootKeeper(KeeperReboot event, FolderListState state,
      Emitter<FolderListState> emit) async {
    String keeperId = event.location.keeperId;
    print("Start rebooting keeper");
    _emitNewLocalKeepersState(emit, event.location.name, true);
    await _pollingKeepersToShutdown(keeperId: keeperId);
    await _startKeeperWithDelay(
      secondsDelay: 5,
      keeperDirPath: event.location.dirPath,
    );
    _emitNewLocalKeepersState(emit, event.location.name, false);
    for (int i = 0; i < 4; i++) {
      add(GetKeeperInfo());
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _emitNewLocalKeepersState(
      Emitter<FolderListState> emit, String name, bool isRebooting) {
    var newLocalKeepers = <Keeper>[];
    for (int i = 0; i < state.localKeepers.length; i++) {
      if (state.localKeepers[i].name == name) {
        newLocalKeepers
            .add(state.localKeepers[i].copyWith(isRebooting: isRebooting));
      } else {
        newLocalKeepers.add(state.localKeepers[i]);
      }
    }
    emit(state.copyWith(localKeeper: newLocalKeepers));
  }

  Future _pollingKeepersToShutdown({required String keeperId}) async {
    int keepersCount = state.locationsInfo.length;
    print("Start polling keepers");
    for (int port = START_PORT; port < END_PORT || keepersCount == 0; port++) {
      try {
        await Dio().get("http://localhost:$port/reboot/$keeperId",
            options: Options(
              receiveTimeout: 300,
              sendTimeout: 300,
            ));
        print("Signal, to off keeper, is sent");
        break;
      } on DioError catch (e) {
        switch (e.response?.statusCode) {
          case 404:
            print("Not correct keeper to reboot");
            keepersCount--;
            break;
          default:
            print("Port is not busy by keeper");
        }
      }
    }
  }

  Future _startKeeperWithDelay({
    required int secondsDelay,
    required String keeperDirPath,
  }) async {
    await Future.delayed(Duration(seconds: secondsDelay));

    var os = OsSpecifications.getOs();
    var domainNameFile = File("${os.appDirPath}domainName");
    String? domainName;
    if (domainNameFile.existsSync()) {
      domainName = File("${os.appDirPath}domainName").readAsStringSync().trim();
      String? bearerToken = await TokenRepository().getApiToken();
      print(bearerToken);
      if (bearerToken != null) {
        os.startProcess('keeper', [
          domainName,
          "${keeperDirPath}${Platform.pathSeparator}.keeper",
          bearerToken,
        ]);
      } else {
        print("Bearer token is null");
      }
    } else {
      print("Domain name file is not exist");
    }
  }
}
