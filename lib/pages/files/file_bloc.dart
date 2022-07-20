import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/pages/files/file_event.dart';
import 'package:storageup/pages/files/file_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/user_repository.dart';

enum ContextActionEnum {
  share,
  move,
  duplicate,
  rename,
  info,
  delete,
  select,
  download,
  addToFavorites,
}

@Injectable()
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc(

      //@Named('files_location_database') this._box,
      )
      : super(FilesState()) {
    on<FilesEvent>((event, emit) async {
      if (event is FilesPageOpened) {
        await _mapFilesPageOpened(state, event, emit);
      } else if (event is FilesSortingClear) {
        _mapSortedClear(event, state, emit);
      }
    });
  }

  late FilesController _controller;
  final UserRepository _userRepository =
      getIt<UserRepository>(instanceName: 'user_repo');

  Future<void> _mapFilesPageOpened(
    FilesState state,
    FilesPageOpened event,
    Emitter<FilesState> emit,
  ) async {
    _controller = await GetIt.I.getAsync<FilesController>();
    var folderId = event.folderId;
    var filesToMove = event.filesToMove;
    if (folderId == null) {
      var files = await _controller.getFiles();
      var currentFolder = _controller.getFilesRootFolder;
      var user = _userRepository.getUser;
      var valueNotifier = _userRepository.getValueNotifier;
      print(files?.length);
      print(currentFolder?.name);
      emit(
        state.copyWith(
          currentFolder: currentFolder,
          filesToMove: filesToMove,
          user: user,
          valueNotifier: valueNotifier,
        ),
      );
    } else {
      var currentFolder = await _controller.getFolderById(folderId);
      var user = _userRepository.getUser;
      emit(
        state.copyWith(
          currentFolder: currentFolder,
          filesToMove: filesToMove,
          user: user,
        ),
      );
    }
  }

  FilesState _clearGroupedMap(
    FilesState state,
  ) {
    return state.copyWith(groupedFiles: Map());
  }

  void _mapSortedClear(
    FilesSortingClear event,
    FilesState state,
    Emitter<FilesState> emit,
  ) {
    final clearedState = _clearGroupedMap(state);

    emit(state.copyWith(
        sortedFiles: clearedState.sortedFiles,
        groupedFiles: clearedState.groupedFiles,
        status: FormzStatus.valid));
  }
}
