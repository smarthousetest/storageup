import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
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
      }
      else if (event is DeleteLocation) {
        await _mapDeleteLocation(event, state, emit);
      }

    });
    on<UpdateLocationsList>((event, emit) => emit(state.copyWith(locationsInfo: event.locations)));
  }

  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _subscriptionService = getIt<KeeperService>();

  Future _mapSpacePageOpened(
    FolderListPageOpened event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    var keeper = await _subscriptionService.getAllKeepers();
    final locationsInfo = _repository.getlocationsInfo;
    emit(state.copyWith(user: user, locationsInfo: locationsInfo, keeper: keeper));

    _repository.getDownloadLocationsValueListenable.addListener(_listener);
  }

  void _listener() {
    final info = _repository.getlocationsInfo;

    if(!isClosed)
    add(UpdateLocationsList(locations: info));
  }

  Future<void> _update(
    Emitter<FolderListState> emit,
    FolderListState state,
  ) async {
    //_repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();
    final locationsInfo = _repository.getlocationsInfo;

    emit(state.copyWith(locationsInfo: locationsInfo));
    print('folders was updated');
  }

  _mapDeleteLocation(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    var idLocation = event.location.id;
    await _repository.deleteLocation(id: idLocation);
    var updateLocations = _repository.getlocationsInfo;
    var tmpState = state.copyWith(locationsInfo: updateLocations);
    emit(state.copyWith(locationsInfo: updateLocations));
    await _deleteKeeper(event, tmpState, emit);
    _update(emit, state);
  }

  Future _deleteKeeper(DeleteLocation event, FolderListState state,Emitter<FolderListState> emit,) async {
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
    if (File('${keeperLocations[event.location.id - 1].split('|').first}${Platform.pathSeparator}keeper_id.txt').existsSync()) {
      keeperId = File('${keeperLocations[event.location.id - 1].split('|').first}${Platform.pathSeparator}keeper_id.txt').readAsStringSync().trim();
    }
    if(bearerToken != null){
      await _getKeeperSession(keeperId, dio, bearerToken);
      try {
        await dio.delete('/keeper', queryParameters: {'ids[]': keeperId}, options: Options(headers: {'Authorization': 'Bearer $bearerToken'}));
      } catch (e) {
        print('Keeper does not exist');
      }
    }
    if(Directory(keeperLocations[event.location.id - 1].split('|').first).existsSync()) {
      Directory(keeperLocations[event.location.id - 1].split('|').first).deleteSync(recursive: true);
    }
    if (keeperLocationsFile.existsSync()) {
      keeperLocationsFile.deleteSync();
      keeperLocationsFile.createSync();
    }
    var keeperLocationsSink = keeperLocationsFile.openWrite(mode: FileMode.append);
    for(var element in state.locationsInfo) {
      keeperLocationsSink.add('${element.dirPath}|${element.countGb * (1024 * 1024 * 1024)}\n'.codeUnits);
    };
    await keeperLocationsSink.close();


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
              'ws://${response.data['proxyIP']}:${response.data['proxyPORT']}',
              response.data['session']);
        }
      } catch (e) {
        print(e);
      }
      break;
    }
  }
}
