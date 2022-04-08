import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/space_repository.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

import '../../../utilites/services/keeper_service.dart';

class FolderListBloc extends Bloc<FolderListEvent, FolderListState> {
  FolderListBloc() : super(FolderListState()) {
    on<FolderListEvent>((event, emit) async {
      if (event is FolderListPageOpened) {
        await _mapSpacePageOpened(event, state, emit);
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
    emit(state.copyWith(
        user: user, locationsInfo: locationsInfo, keeper: keeper));
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
    emit(state.copyWith(locationsInfo: updateLocations));
    // _update(emit, state);
  }
}
