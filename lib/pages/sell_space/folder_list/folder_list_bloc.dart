import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/space_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/utilites/services/keeper_service.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc() : super(FolderListState()) {
    on<FolderListEvent>((event, emit) async {
      if (event is FolderListPageOpened) {
        await _mapSpacePageOpened(event, state, emit);
      } else if (event is DeleteLocation) {
        await _mapDeleteLocation(event, state, emit);
      } else if (event is SleepStatus) {
        await _sleepStatusKeeper(emit, state, event);
      }
    });
    on<UpdateLocationsList>((event, emit) => emit(state.copyWith(locationsInfo: event.locations)));
  }

  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _keeperService = getIt<KeeperService>();

  Future _mapSpacePageOpened(
    FolderListPageOpened event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    var keeper = await _keeperService.getAllKeepers();
    final locationsInfo = _repository.getlocationsInfo;

    List<Keeper> localKeeper = [];
    List<Keeper> serverKeeper = [];
    List<String> localPath = [];

    keeper?.forEach((element) {
      if (locationsInfo.any((info) => info.idForCompare == element.id)) {
        localKeeper.add(element);
        //// need add dirPath in keeper
        locationsInfo.forEach((element) {
          localPath.add(element.dirPath);
        });
      } else {
        serverKeeper.add(element);
      }
    });

    emit(state.copyWith(
      user: user,
      locationsInfo: locationsInfo,
      keeper: keeper,
      localKeeper: localKeeper.reversed.toList(),
      serverKeeper: serverKeeper,
      localPath: localPath.reversed.toList(),
    ));

    _repository.getDownloadLocationsValueListenable.addListener(_listener);
  }

  void _listener() {
    final info = _repository.getlocationsInfo;

    if (!isClosed) add(UpdateLocationsList(locations: info));
  }

  _update(
    Emitter<FolderListState> emit,
    FolderListState state,
  ) async {
    //_repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    final locationsInfo = _repository.getlocationsInfo;

    emit(state.copyWith(
      locationsInfo: locationsInfo,
    ));
    print('folders was updated');
  }

  _sleepStatusKeeper(
    Emitter<FolderListState> emit,
    FolderListState state,
    SleepStatus event,
  ) async {
    var keeperId = event.keeper.id;
    if (event.keeper.online == 1) {
      if (keeperId != null) {
        await _keeperService.changeSleepStatus(keeperId);
      }
      var keeper = await _keeperService.getAllKeepers();
      final locationsInfo = _repository.getlocationsInfo;

      List<Keeper> localKepper = [];
      List<Keeper> serverKeeper = [];
      List<String> localPath = [];

      keeper?.forEach((element) {
        if (locationsInfo.any((info) => info.idForCompare == element.id)) {
          localKepper.add(element);
          //// need add dirPath in keeper

          locationsInfo.forEach((element) {
            localPath.add(element.dirPath);
          });
        } else {
          serverKeeper.add(element);
        }
      });
      emit(state.copyWith(
        localKeeper: localKepper.reversed.toList(),
        serverKeeper: serverKeeper,
        localPath: localPath.reversed.toList(),
      ));
    }
  }

  _mapDeleteLocation(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    var idLocation = event.location.id;
    await _repository.deleteLocation(id: idLocation);
    var updateLocations = _repository.getlocationsInfo;
    var keeper = await _keeperService.getAllKeepers();
    List<Keeper> localKeeper = [];
    List<Keeper> serverKeeper = [];

    if(keeper != null){
      for (var element in keeper) {
        if (updateLocations.any((info) => info.idForCompare == element.id)) {
          localKeeper.add(element);
        } else {
          serverKeeper.add(element);
        }
      }
    }
    print('Прошёл до конца');
    var tmpState = state.copyWith(locationsInfo: updateLocations);

    await _deleteKeeper(event, tmpState, emit);
    emit(state.copyWith(
        locationsInfo: updateLocations, localKeeper: localKeeper.reversed.toList(), serverKeeper: serverKeeper));

    // _update(emit, state);
  }

  Future _deleteKeeper(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    String? bearerToken = await TokenRepository().getApiToken();
    var os = (Platform.isWindows) ? Windows() : Linux();
    Dio dio = getIt<Dio>(instanceName: 'record_dio');
    var keeperLocationsFile = File('${os.appDirPath}keeper_locations');
    List<String> keeperLocations = [];
    if (keeperLocationsFile.existsSync()) {
      keeperLocations = keeperLocationsFile.readAsLinesSync();
    }
    if (keeperLocations.isEmpty) {
      return;
    }
    String keeperId = '';
    if (File('${keeperLocations[event.location.id - 1]}${Platform.pathSeparator}keeper_id.txt').existsSync()) {
      keeperId = File('${keeperLocations[event.location.id - 1]}${Platform.pathSeparator}keeper_id.txt')
          .readAsStringSync()
          .trim();
    }
    if (bearerToken != null) {
      await _getKeeperSession(keeperId, dio, bearerToken);
      try {
        await dio.delete('/keeper',
            queryParameters: {'ids[]': keeperId}, options: Options(headers: {'Authorization': 'Bearer $bearerToken'}));
      } catch (e) {
        print('Keeper does not exist');
      }
    }
    if (Directory(keeperLocations[event.location.id - 1]).existsSync()) {
      Directory(keeperLocations[event.location.id - 1]).deleteSync(recursive: true);
    }
    if (keeperLocationsFile.existsSync()) {
      keeperLocationsFile..deleteSync()..createSync();
    }
    var keeperLocationsSink = keeperLocationsFile.openWrite(mode: FileMode.append);
    for (var element in state.locationsInfo) {
      keeperLocationsSink.add('${element.dirPath}\n'.codeUnits);
    }
    await keeperLocationsSink.close();
    //TODO Не изменяется список локальных киперов
    emit(state.copyWith(locationsInfo: _repository.getlocationsInfo));
  }

  Future _disconnectKeeper(String proxyUrl, String session) async {
    var channel = IOWebSocketChannel.connect(proxyUrl);
    channel.sink.add(json.encode({
      'messageType': 'update_disconnect',
      'session': session,
    }));
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
              'ws://${response.data['proxyIP']}:${response.data['proxyPORT']}', response.data['session']);
        }
      } catch (e) {
        print(e);
      }
      break;
    }
  }
}
