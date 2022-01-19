import 'package:connectivity/connectivity.dart';
import 'package:cpp_native/cpp_native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/file_state.dart';
import 'package:upstorage_desktop/pages/files/file_event.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/user_repository.dart';

enum SortingDirection { neutral, up, down }
enum ContextActionEnum {
  share,
  move,
  duplicate,
  rename,
  info,
  delete,
  select,
  download,
  addToFavorites
}

@Injectable()
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc(
    @Named('files_controller') this._controller,
    //@Named('files_location_database') this._box,
  ) : super(FilesState()) {
    on<FilesEvent>((event, emit) async {
      if (event is FilesSortingFieldChanged) {
        _mapSortedFieldChanged(event, state, emit);
      } else if (event is FilesPageOpened) {
        await _mapFilesPageOpened(state, event, emit);
      } else if (event is FilesSortingClear) {
        _mapSortedClear(event, state, emit);
      } else if (event is FileSortingByCriterion) {
        await _mapFileSortingByCreterion(event, state, emit);
      } else if (event is FileContextActionChoosed) {
        await _mapContextActionChoosed(event, state, emit);
      } else if (event is FileAddFile) {
        await _mapAddFile(event, state, emit);
      } else if (event is FileUpdateFiles) {
        await _mapUpdateFilesList(state, event, emit);
      } else if (event is FileAddFolder) {
        await _mapAddFolder(state, event, emit);
      } else if (event is FileChangeUploadPercent) {
        await _mapChangePercent(state, event, emit);
      } else if (event is FilesDiscardSelecting) {
        _mapDiscardSelecting(state, emit);
      } else if (event is FilesMoveHere) {
        await _mapMoveHere(state, emit);
      } else if (event is FilesDeleteChoosed) {
        await _mapDeleteChoosed(state, emit);
      } else if (event is FilesNoInternet) {
        _mapNoInternet(state, emit);
      } else if (event is FileRename) {
        await _mapRename(event, state, emit);
      }
    });
  }

  FilesController _controller;
  //Box  get _box async  => await Hive.openBox('file_path_db');
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final LoadController _loadController = getIt<LoadController>();
  final UserRepository _userRepository =
      getIt<UserRepository>(instanceName: 'user_repo');
  List<UploadObserver> _listeners = [];

  Future<void> _mapFilesPageOpened(
    FilesState state,
    FilesPageOpened event,
    Emitter<FilesState> emit,
  ) async {
    var folderId = event.folderId;
    var filesToMove = event.filesToMove;
    if (folderId == null) {
      var files = await _controller.getFiles();
      var currentFolder = _controller.getFilesRootFolder;
      var user = _userRepository.getUser;
      print(files?.length);
      print(currentFolder?.name);
      emit(
        state.copyWith(
          allFiles: files,
          sortedFiles: files,
          currentFolder: currentFolder,
          filesToMove: filesToMove,
          user: user,
        ),
      );
    } else {
      var files = await _controller.getContentFromFolderById(folderId);
      var currentFolder = await _controller.getFolderById(folderId);
      var user = _userRepository.getUser;
      emit(
        state.copyWith(
          allFiles: files,
          sortedFiles: files,
          currentFolder: currentFolder,
          filesToMove: filesToMove,
          user: user,
        ),
      );
    }
    print('Load controller init is: ${_loadController.isNotInited()}');
  }

  Future<void> _mapUpdateFilesList(
    FilesState state,
    FileUpdateFiles event,
    Emitter<FilesState> emit,
  ) async {
    List<BaseObject>? files;
    if (state.currentFolder?.readOnly == true) {
      await _controller.updateFilesList();
      files = await _controller.getFiles();
    } else {
      await _controller.updateFilesList();
      files =
          await _controller.getContentFromFolderById(state.currentFolder!.id);
    }

    if (event.id != null) {
      try {
        // (files?.firstWhere((element) => element.id == event.id) as Record)
        //     .loadPercent = 0;
      } catch (e) {
        print(
            'on updating files can\'t find file with the same id as sended in event');
      }
    }
    // var st = _loadController.getState.uploadingFiles;
    // if (st.any((element) => element.isInProgress)) {
    //   st.forEach((uploadingFile) {
    //     if (uploadingFile.isInProgress) {
    //       try {
    //         (files?.firstWhere((element) => element.id == uploadingFile.id)
    //                 as Record)
    //             .loadPercent = uploadingFile.uploadPercent.toDouble();
    //       } catch (e) {
    //         print('$e handled');
    //       }
    //     } else {
    //       try {
    //         (files?.firstWhere((element) => element.id == uploadingFile.id)
    //                 as Record)
    //             .loadPercent = 0;
    //       } catch (e) {
    //         print('$e handled');
    //       }
    //     }
    //   });
    // }
    emit(state.copyWith(
      allFiles: files,
      sortedFiles: files,
    ));
  }

  void _mapSortedFieldChanged(
    FilesSortingFieldChanged event,
    FilesState state,
    Emitter<FilesState> emit,
  ) {
    final tmpState = _resetSortedList(state: state);
    final allFiles = tmpState.sortedFiles;
    final sortText = event.sortingText;

    List<BaseObject> sortedFiles = [];
    allFiles.forEach((element) {
      if ((element.createdAt != null &&
              DateFormat.yMd(Intl.getCurrentLocale())
                  .format(element.createdAt!)
                  .toString()
                  .toLowerCase()
                  .contains(sortText.toLowerCase())) ||
          (element.name != null &&
              element.name!.toLowerCase().contains(sortText.toLowerCase())) ||
          (element.extension != null &&
              element.extension!
                  .toLowerCase()
                  .contains(sortText.toLowerCase()))) {
        sortedFiles.add(element);
      }
    });

    emit(state.copyWith(
      sortedFiles: sortedFiles,
    ));
  }

  Future<void> _mapFileSortingByCreterion(
    FileSortingByCriterion event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    SortingCriterion criterion = event.criterion;
    FilesState newState = _clearGroupedMap(state);

    switch (criterion) {
      case SortingCriterion.byName:
        await _sortByName(event, newState, emit);
        break;
      case SortingCriterion.byDate:
        await _sortByDate(event, newState, emit);
        break;
      case SortingCriterion.bySize:
        await _sortBySize(event, newState, emit);
        break;
      case SortingCriterion.byType:
        await _sortByType(event, newState, emit);
        break;
    }
  }

  Future<List<BaseObject>> _getClearListOfFiles(
    FilesState state,
  ) async {
    List<BaseObject>? items = await _controller.getFiles();
    List<BaseObject> sortedFiles = [];
    sortedFiles.addAll(items ?? []);

    return sortedFiles;
  }

  Future<void> _sortByType(
    FileSortingByCriterion event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    List<BaseObject> items = state.allFiles;

    Map<String, List<BaseObject>> groupedFiles = {};

    items.forEach((element) {
      String key;
      if (element.extension == null) {
        key = 'folder';
      } else {
        key = element.extension!.toLowerCase();
      }
      if (groupedFiles.containsKey(key)) {
        groupedFiles[key]?.add(element);
      } else {
        groupedFiles[key] = [element];
      }
    });
    if (event.direction == SortingDirection.down) {
      emit(state.copyWith(groupedFiles: groupedFiles));
    } else {
      emit(state.copyWith(
        groupedFiles: groupedFiles
            .map((key, value) => MapEntry(key, value.reversed.toList())),
      ));
    }
  }

  FilesState _clearGroupedMap(
    FilesState state,
  ) {
    return state.copyWith(groupedFiles: Map());
  }

  Future<void> _sortBySize(
    FileSortingByCriterion event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    List<BaseObject> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) {
      // if (a.size != null && b.size != null) {
      return a.size.compareTo(b.size);
      // }
      // else if (a.size == null && b.size == null) {
      //   return a.id.compareTo(b.id);
      // } else
      //   return a.size == null ? 0 : 1;
    });
    if (event.direction == SortingDirection.up) {
      emit(state.copyWith(sortedFiles: sortedFiles.reversed.toList()));
    } else {
      emit(state.copyWith(sortedFiles: sortedFiles));
    }
  }

  Future<void> _sortByName(
    FileSortingByCriterion event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    List<BaseObject> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) {
      if (a.name != null && b.name != null) {
        return a.name!.compareTo(b.name!);
      } else if (a.name == null && b.name == null) {
        return a.id.compareTo(b.id);
      } else
        return a.name == null ? 0 : 1;
    });
    if (event.direction == SortingDirection.up) {
      emit(state.copyWith(sortedFiles: sortedFiles.reversed.toList()));
    } else {
      emit(state.copyWith(sortedFiles: sortedFiles));
    }
  }

  Future<void> _sortByDate(
    FileSortingByCriterion event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    List<BaseObject> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return _compareDates(a.createdAt!, b.createdAt!);
      } else if (a.createdAt == null && b.createdAt == null) {
        return a.id.compareTo(b.id);
      } else
        return a.createdAt == null ? 0 : 1;
    });
    if (event.direction == SortingDirection.up) {
      emit(state.copyWith(sortedFiles: sortedFiles.reversed.toList()));
    } else {
      emit(state.copyWith(sortedFiles: sortedFiles));
    }
  }

  int _compareDates(DateTime a, DateTime b) {
    // var dateA = DateTime.parse(a);
    // var dateB = DateTime.parse(b);

    return a.compareTo(b);
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

  Future<void> _mapContextActionChoosed(
    FileContextActionChoosed event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    // emit(state.copyWith(status: FormzStatus.submissionInProgress));
    print('${event.action} ${event.file}');
    if (event.action == ContextActionEnum.delete) {
      await _mapDeleteFile(event, state, emit);
    } else if (event.action == ContextActionEnum.share) {
      // await _mapDownloadFile(event, state, emit); //TODO remove this
    } else if (event.action == ContextActionEnum.select) {
      await _mapSelectFile(event, state, emit);
    } else {
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    }
  }

  Future<void> _mapSelectFile(
    FileContextActionChoosed event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    var choosedFile = event.file;
    var filesFromFolder = state.allFiles.toList();

    FilesState ns;
    try {
      var indexOfChoosedFile =
          filesFromFolder.indexWhere((element) => element.id == choosedFile.id);
      if (indexOfChoosedFile != -1) {
        var isRecord = filesFromFolder[indexOfChoosedFile] is Record;
        if (isRecord) {
          var record = filesFromFolder[indexOfChoosedFile] as Record;
          var modifiedRecord = record.copyWith(isChoosed: !record.isChoosed);
          filesFromFolder[indexOfChoosedFile] = modifiedRecord;
        } else {
          var folder = filesFromFolder[indexOfChoosedFile] as Folder;
          var modifiedFolder = folder.copyWith(isChoosed: !folder.isChoosed);
          filesFromFolder[indexOfChoosedFile] = modifiedFolder;
        }
      }

      var countOfSelected =
          filesFromFolder.where((element) => element.isChoosed).length;

      ns = state.copyWith(
        isSelectable: true,
        allFiles: filesFromFolder,
        sortedFiles: filesFromFolder,
        selectedCount: countOfSelected,
      );

      emit(ns);
    } catch (e, st) {
      print('FIlesBloc: $e, $st');
    }
  }

  Future<void> _mapDeleteFile(
    FileContextActionChoosed event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    ResponseStatus result;
    if (event.file is Record) {
      result = await _controller.deleteFiles([event.file]);
    } else {
      result = await _controller.deleteFolder(event.file.id);
    }

    if (result == ResponseStatus.ok) {
      // var files = await _controller.getFiles();
      add(FileUpdateFiles());
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
      ));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  FilesState _resetSortedList({
    required FilesState state,
  }) {
    return state.copyWith(sortedFiles: state.allFiles);
  }

  var re = RegExp(
    r'^'
    r'(?<day>[0-9]{1,2})'
    r'.'
    r'(?<month>[0-9]{1,2})'
    r'.'
    r'(?<year>[0-9]{4,})'
    r'$',
  );

  Future<void> _mapAddFile(
    FileAddFile event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, allowCompression: false, allowMultiple: true);

    if (result != null && result.paths.isNotEmpty) {
      result.paths.forEach((element) async {
        if (element != null) {
          var observer = UploadObserver(element, (_) {
            _uploadListener(element);
          });
          _listeners.add(observer);
          _loadController.getState.registerObserver(observer);

          await _loadController.uploadFile(
            filePath: element,
            folderId: state.currentFolder?.id,
          );
        }
      });
    }
  }

  void _uploadListener(String pathToFile) async {
    var controllerState = _loadController.getState;
    try {
      var currentFile = controllerState.uploadingFiles.firstWhere(
          (element) => element.localPath == pathToFile && element.isInProgress);

      if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
        add(FileUpdateFiles(id: currentFile.id));
        return;
      }

      if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
        return;
      }

      if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
        print(
            'file\'s $pathToFile upload percent = ${currentFile.uploadPercent}');
        add(FileChangeUploadPercent(
          id: currentFile.id,
          percent: currentFile.uploadPercent.toDouble(),
        ));
      } else if (currentFile.uploadPercent != -1) {
        // add(FileUpdateFiles());
        add(FileChangeUploadPercent(
          id: currentFile.id,
          percent: null,
        ));
        var observer =
            _listeners.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _listeners.remove(observer);
      }
    } catch (e) {
      print(e);
      var ind = controllerState.uploadingFiles
          .indexWhere((e) => e.id == pathToFile && e.endedWithException);
      if (ind != -1) {
        var observer =
            _listeners.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _listeners.remove(observer);

        var connect = await Connectivity().checkConnectivity();

        if (connect == ConnectivityResult.none) {
          add(FilesNoInternet());
        } else {
          add(FileUpdateFiles());
        }
      }
    }
  }

  Future<void> _mapDownloadFile(
    FileContextActionChoosed event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    var token = await _tokenRepository.getApiToken();
    var recordId = event.file.id;

    if (token != null) {
      CppNative cpp = CppNative();
      await cpp.downloadFile(
          recordID: recordId,
          bearerToken: token,
          callback: (file) async {
            print(file.path);
            var box = await Hive.openBox(kPathDBName);
            box.put(recordId, file.path);
          });
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> _mapAddFolder(
    FilesState state,
    FileAddFolder event,
    Emitter<FilesState> emit,
  ) async {
    var folderId = event.parentFolderId;
    var name = event.name;

    await _controller.createFolder(name, folderId);
    if (state.currentFolder!.readOnly!) {
      await _mapUpdateFilesList(state, FileUpdateFiles(), emit);
    } else {
      var files = await _controller.getContentFromFolderById(folderId!);
      emit(state.copyWith(
        allFiles: files,
        sortedFiles: files,
      ));
    }
  }

  Future<void> _mapChangePercent(
    FilesState state,
    FileChangeUploadPercent event,
    Emitter<FilesState> emit,
  ) async {
    // (state.allFiles.firstWhere((element) => element.id == event.id) as Record)
    //     .uploadPercent = null;
    var files =
        await _controller.getContentFromFolderById(state.currentFolder!.id);

    files.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    try {
      // (files.firstWhere((element) =>
      //         element.id == event.id &&
      //         (element as Record).path?.isNotEmpty != true) as Record)
      //     .loadPercent = event.percent;
      var ind = files.indexWhere((element) =>
              element is Record &&
              element.id ==
                  event.id /*&&
          element.path?.isNotEmpty != true*/
          );
      var record = (files[ind] as Record).copyWith(loadPercent: event.percent);
      files[ind] = record;
    } catch (_) {
      print(
          'can\'t find file with same id as downloading file at _mapChangePercent with id: ${event.id}');
    }
    emit(state.copyWith(
      allFiles: files,
      sortedFiles: files,
    ));
    print('------------------------- state emmited');
  }

  void _mapDiscardSelecting(FilesState state, Emitter<FilesState> emit) {
    var allFiles = state.allFiles.toList();

    allFiles.forEach((element) {
      if (element.isChoosed) element.isChoosed = false;
    });

    emit(state.copyWith(
      allFiles: allFiles,
      sortedFiles: allFiles,
      isSelectable: false,
      selectedCount: 0,
    ));
  }

  Future<void> _mapMoveHere(
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    var objects = state.filesToMove;
    List<String>? records;
    List<String>? folders;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    objects.forEach((element) {
      if (element is Record) {
        if (records == null) records = [];

        records?.add(element.id);
      } else if (element is Folder) {
        if (folders == null) folders = [];

        folders?.add(element.id);
      }
    });

    var result = await _controller.moveToFolder(
      folderId: state.currentFolder!.id,
      folders: folders,
      records: records,
    );

    if (result == ResponseStatus.ok) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          filesAction: FilesAction.moving,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          filesAction: FilesAction.moving,
        ),
      );
    }
    print(result);
  }

  Future<void> _mapDeleteChoosed(
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    var choosedObjects =
        state.allFiles.where((element) => element.isChoosed).toList();

    var result = await _controller.deleteObjects(choosedObjects);

    if (result == ResponseStatus.ok) {
      add(FilesDiscardSelecting());
      add(FileUpdateFiles());
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
        ),
      );
    }
  }

  void _mapNoInternet(FilesState state, Emitter<FilesState> emit) {
    emit(state.copyWith(
      status: FormzStatus.submissionFailure,
      errorType: ErrorType.noInternet,
    ));
  }

  Future<void> _mapRename(
    FileRename event,
    FilesState state,
    Emitter<FilesState> emit,
  ) async {
    var obj = event.object;
    if (obj.name == event.newName) {
      print('old and new name are the same');
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    ResponseStatus status;
    if (obj is Record) {
      status = await _controller.renameRecord(event.newName, obj.id);
    } else {
      status = await _controller.renameFolder(event.newName, obj.id);
    }

    if (status == ResponseStatus.ok) {
      add(FileUpdateFiles());
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } else {
      var connect = await Connectivity().checkConnectivity();

      if (connect == ConnectivityResult.none) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            errorType: ErrorType.noInternet));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}

class UploadObserver extends Observer {
  String id;
  UploadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}
