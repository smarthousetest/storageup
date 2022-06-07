import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cpp_native/local_update/local_update_server.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/space_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/utilites/services/keeper_service.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc() : super(FolderListState()) {
    on<FolderListEvent>((event, emit) async {
      if (event is FolderListPageOpened) {
        await _mapSpacePageOpened(event, state, emit);
      } else if (event is GetKeeperInfo) {
        await _mapGetKeeperInfo(event, state, emit);
      } else if (event is DeleteLocation) {
        await _mapDeleteLocation(event, state, emit);
      } else if (event is SleepStatus) {
        await _sleepStatusKeeper(emit, state, event);
      } else if (event is KeeperReboot) {
        await _rebootKeeper(event, state, emit);
      }
    });
    on<UpdateLocationsList>(
        (event, emit) => emit(state.copyWith(locationsInfo: event.locations)));
  }

  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late final DownloadLocationsRepository _repository;
  final KeeperService _keeperService = getIt<KeeperService>();
  Timer? timer;

  Future _mapSpacePageOpened(
    FolderListPageOpened event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    User? user = await _userController.getUser;
    _repository = await GetIt.instance.getAsync<DownloadLocationsRepository>();

    emit(state.copyWith(
      user: user,
    ));
    try {
      timer = Timer.periodic(const Duration(minutes: 5), (Timer t) async {
        add(GetKeeperInfo());
      });
    } catch (e) {
      print('error timer in get keeper');
    }
    _repository.getDownloadLocationsValueListenable.addListener(_listener);
  }

  Future<void> _mapGetKeeperInfo(
    GetKeeperInfo event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    var keeper = await _keeperService.getAllKeepers();
    final locationsInfo = await _repository.getlocationsInfo;

    List<Keeper> localKeeper = [];
    List<Keeper> serverKeeper = [];
    List<String> localPath = [];

    keeper?.forEach((element) {
      if (locationsInfo.any((info) => info.idForCompare == element.id)) {
        localKeeper.add(element);

        /// need add dirPath in keeper
        locationsInfo.forEach((element) {
          localPath.add(element.dirPath);
        });
      } else {
        serverKeeper.add(element);
      }
    });

    print('5 seconds update keeper');
    emit(state.copyWith(
      locationsInfo: locationsInfo,
      localKeeper: localKeeper.reversed.toList(),
      serverKeeper: serverKeeper,
      localPath: localPath.reversed.toList(),
    ));
  }

  void _listener() {
    final info = _repository.getlocationsInfo;

    if (!isClosed) add(UpdateLocationsList(locations: info));
  }

  @override
  Future<void> close() {
    timer?.cancel();
    print('timer is cancelled');
    return super.close();
  }

  _update(
    Emitter<FolderListState> emit,
    FolderListState state,
  ) async {
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

      List<Keeper> localKeeper = [];
      List<Keeper> serverKeeper = [];
      List<String> localPath = [];

      keeper?.forEach((element) {
        if (locationsInfo.any((info) => info.idForCompare == element.id)) {
          localKeeper.add(element);

          /// need add dirPath in keeper
          locationsInfo.forEach((element) {
            localPath.add(element.dirPath);
          });
        } else {
          serverKeeper.add(element);
        }
      });
      emit(
        state.copyWith(
          localKeeper: localKeeper.reversed.toList(),
          serverKeeper: serverKeeper,
          localPath: localPath.reversed.toList(),
        ),
      );
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
    var tmpState = state.copyWith(locationsInfo: updateLocations);
    await _deleteKeeper(event, tmpState, emit);
    var keeper = await _keeperService.getAllKeepers();
    List<Keeper> localKeeper = [];
    List<Keeper> serverKeeper = [];
    if (keeper != null) {
      for (var element in keeper) {
        if (updateLocations.any((info) => info.idForCompare == element.id)) {
          localKeeper.add(element);
        } else {
          serverKeeper.add(element);
        }
      }
    }
    emit(
      state.copyWith(
        locationsInfo: updateLocations,
        localKeeper: localKeeper.reversed.toList(),
        serverKeeper: serverKeeper,
      ),
    );

    // _update(emit, state);
  }

  Future _deleteKeeper(
    DeleteLocation event,
    FolderListState state,
    Emitter<FolderListState> emit,
  ) async {
    String? bearerToken = await TokenRepository().getApiToken();
    Dio dio = getIt<Dio>(instanceName: 'record_dio');
    var box = await Hive.openBox('keeper_data');
    String keeperDir =
        Uri.decodeFull(await box.get(event.location.id.toString()));
    await box.delete(event.location.id.toString());
    String keeperId = '';
    var keeperIdFile = File('$keeperDir${Platform.pathSeparator}keeper_id.txt');
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
      } catch (e) {
        print('Keeper does not exist');
      }
    }

    if (Directory(keeperDir).existsSync()) {
      Directory(keeperDir).deleteSync(recursive: true);
    }
    emit(state.copyWith(locationsInfo: _repository.getlocationsInfo));
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

  _rebootKeeper(KeeperReboot event, FolderListState state, Emitter emit) async {
    String keeperId = event.location.idForCompare;
    int keepersCount = state.locationsInfo.length;
    for (int port = START_PORT; port < END_PORT || keepersCount == 0; port++) {
      try {
        Dio().get("http://localhost:$port/reboot/$keeperId");
        break;
      } on DioError catch (e) {
        switch (e.response?.statusCode) {
          case 404:
            keepersCount--;
            break;
        }
      }
    }
    await Timer(
      Duration(seconds: 5),
      () async {
        var os = OsSpecifications.getOs();
        var domainNameFile = File("${os.appDirPath}domainName");
        String? domainName;
        if (domainNameFile.existsSync()) {
          domainName =
              File("${os.appDirPath}domainName").readAsStringSync().trim();
          String? bearerToken = await TokenRepository().getApiToken();
          print(bearerToken);
          if (bearerToken != null) {
            os.startProcess('keeper', [
              domainName,
              event.location.dirPath,
              bearerToken,
            ]);
          } else {
            print("Bearer token is null");
          }
        } else {
          print("Domain name file is not exist");
        }
      },
    );
  }
}
