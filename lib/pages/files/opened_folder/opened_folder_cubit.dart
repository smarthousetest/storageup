import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';

//enum SortingDirection { neutral, up, down }

class OpenedFolderCubit extends Cubit<OpenedFolderState> {
  OpenedFolderCubit()
      : super(OpenedFolderState(
          objects: [],
          previousFolders: [],
        ));

  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  var _loadController = getIt<LoadController>();
  late Observer _updateObserver = Observer((a) {
    if (_canUpdate) _update();
  });

  var _canUpdate = true;

  List<UploadObserver> _observers = [];
  @override
  Future<void> close() async {
    _observers.forEach((element) {
      _loadController.getState.unregisterObserver(element);
    });

    _loadController.getState.unregisterObserver(_updateObserver);

    return super.close();
  }

  void init(Folder? folder, List<Folder> previousFolders) async {
    Folder? currentFolder;
    if (folder == null) {
      await _filesController.updateFilesList();
      currentFolder = _filesController.getFilesRootFolder;
    } else {
      currentFolder = await _filesController.getFolderById(folder.id);
    }
    var objects =
        await _filesController.getContentFromFolderById(currentFolder!.id);

    emit(
      state.copyWith(
        currentFolder: currentFolder,
        objects: objects,
        sortedFiles: objects,
        previousFolders: previousFolders,
      ),
    );

    _loadController.getState.registerObserver(_updateObserver);

    _syncWithLoadController(objects);
  }

  void onRecordActionChoosed(FileAction action, BaseObject object) {
    switch (action) {
      case FileAction.delete:
        _onActionDeleteChoosed(object);
        break;
      case FileAction.properties:
        //PropertiesView(object: object);
        break;
      default:
        print('default');
    }
  }

  Future<void> mapFileSortingByCreterion() async {
    OpenedFolderState newState = _clearGroupedMap(state);
    var criterion = newState.criterion;
    var direction = newState.direction;
    switch (criterion) {
      case SortingCriterion.byType:
        await _sortByType(newState, direction, criterion);
        break;
      case SortingCriterion.byDateCreated:
        await _sortByDate(newState, direction, criterion);
        break;
      case SortingCriterion.byName:
        await _sortByName(newState, direction, criterion);
        break;
      case SortingCriterion.bySize:
        await _sortBySize(newState, direction, criterion);
        break;
    }
  }

  OpenedFolderState _clearGroupedMap(
    OpenedFolderState state,
  ) {
    return state.copyWith(groupedFiles: Map());
  }

  void _mapSortedClear(
    OpenedFolderState state,
  ) {
    final clearedState = _clearGroupedMap(state);
    emit(state.copyWith(
        sortedFiles: clearedState.sortedFiles,
        groupedFiles: clearedState.groupedFiles,
        status: FormzStatus.valid));
  }

  Future<List<BaseObject>> _getClearListOfFiles(
    OpenedFolderState state,
  ) async {
    List<BaseObject>? items = await _filesController.getFiles();
    List<BaseObject> sortedFiles = [];
    sortedFiles.addAll(items ?? []);

    return sortedFiles;
  }

  Future<void> _sortByType(OpenedFolderState state, SortingDirection direction,
      SortingCriterion criterion) async {
    List<BaseObject> items = await _getClearListOfFiles(state);

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

    if (direction == SortingDirection.down) {
      emit(state.copyWith(groupedFiles: groupedFiles));
    } else {
      emit(state.copyWith(
        groupedFiles: groupedFiles
            .map((key, value) => MapEntry(key, value.reversed.toList())),
      ));
    }
  }

  Future<void> _sortBySize(OpenedFolderState state, SortingDirection direction,
      SortingCriterion criterion) async {
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
    if (direction == SortingDirection.down) {
      emit(state.copyWith(sortedFiles: sortedFiles.reversed.toList()));
    } else {
      emit(state.copyWith(sortedFiles: sortedFiles));
    }
  }

  Future<void> _sortByName(OpenedFolderState state, SortingDirection direction,
      SortingCriterion criterion) async {
    List<BaseObject> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) {
      if (a.name != null && b.name != null) {
        return a.name!.compareTo(b.name!);
      } else if (a.name == null && b.name == null) {
        return a.id.compareTo(b.id);
      } else
        return a.name == null ? 0 : 1;
    });
    if (direction == SortingDirection.up) {
      emit(state.copyWith(sortedFiles: sortedFiles.reversed.toList()));
    } else {
      emit(state.copyWith(sortedFiles: sortedFiles));
    }
  }

  Future<void> _sortByDate(OpenedFolderState state, SortingDirection direction,
      SortingCriterion criterion) async {
    List<BaseObject> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return _compareDates(a.createdAt!, b.createdAt!);
      } else if (a.createdAt == null && b.createdAt == null) {
        return a.id.compareTo(b.id);
      } else
        return a.createdAt == null ? 0 : 1;
    });
    if (direction == SortingDirection.down) {
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

  void _onActionDeleteChoosed(BaseObject object) async {
    //emit(state.copyWith(status: FormzStatus.submissionInProgress));

    var result = await _filesController.deleteObjects([object]);
    print(result);
    if (result == ResponseStatus.ok) {
      _update();
    }
  }

  void _syncWithLoadController(List<BaseObject> filesInFolder) async {
    var loadState = _loadController.getState;

    filesInFolder.forEach((fileInFolder) {
      var index = loadState.uploadingFiles
          .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
      if (index != -1 &&
          !_observers.any((element) =>
              element.id == loadState.uploadingFiles[index].localPath)) {
        var observer = UploadObserver(
          loadState.uploadingFiles[index].localPath,
          (p0) {
            _uploadListener(loadState.uploadingFiles[index].localPath);
          },
        );

        _observers.add(observer);

        loadState.registerObserver(observer);
        _checkIfNeedToUpdating();
      }
    });
  }

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(representation: representation));
  }

  void setFavorite(BaseObject object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      _update();
    }
  }

  Future<void> setNewCriterionAndDirection(
      SortingCriterion criterion, SortingDirection direction) async {
    emit(state.copyWith(criterion: criterion, direction: direction));
  }

  Future<void> _update() async {
    var objects = await _filesController
        .getContentFromFolderById(state.currentFolder!.id);

    emit(state.copyWith(
      sortedFiles: objects,
    ));

    mapFileSortingByCreterion();

    print('files was updated');

    _syncWithLoadController(objects);
  }

  void _tryToFindObservableRecords() {
    var controllerState = _loadController.getState;

    if (controllerState.uploadingFiles.isNotEmpty) {
      try {
        var uploadingFile = controllerState.uploadingFiles
            .firstWhere((file) => file.isInProgress);

        if (state.objects.any((object) => object.id == uploadingFile.id)) {
          var observer = UploadObserver(uploadingFile.localPath,
              (_) => _uploadListener(uploadingFile.localPath));

          _observers.add(observer);

          _loadController.getState.registerObserver(observer);
        }
      } catch (e) {
        print(
            'OpenedFolderCubit: can\'t find any uploading files in folder: ${state.currentFolder?.name}');
      }
    }
  }

  void _uploadListener(String pathToFile) async {
    var controllerState = _loadController.getState;

    if (pathToFile.isEmpty) {
      var currentFileIndex = controllerState.uploadingFiles
          .indexWhere((file) => file.isInProgress);

      if (currentFileIndex != -1) {
        var currentFilePath =
            controllerState.uploadingFiles[currentFileIndex].localPath;

        var indexOfObserver =
            _observers.indexWhere((observer) => observer.id == currentFilePath);

        if (indexOfObserver == -1) {
          await _update();
          _tryToFindObservableRecords();
        }
      }
      return;
    }

    try {
      var currentFile = controllerState.uploadingFiles.firstWhere(
          (element) => element.localPath == pathToFile && element.isInProgress);

      if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
        // add(FileUpdateFiles(id: currentFile.id));
        _update();
        print('currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty');
        return;
      }

      if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
        print('!currentFile.isInProgress && currentFile.uploadPercent == -1');
        return;
      }

      if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
        // print(
        //     'file\'s $pathToFile upload percent = ${currentFile.uploadPercent}');
        // add(FileChangeUploadPercent(
        //   id: currentFile.id,
        //   percent: currentFile.uploadPercent.toDouble(),
        // ));

        _updateUploadPercent(
          fileId: currentFile.id,
          percent: currentFile.uploadPercent,
        );
      } else if (currentFile.uploadPercent != -1) {
        // add(FileUpdateFiles());
        // add(FileChangeUploadPercent(
        //   id: currentFile.id,
        //   percent: null,
        // ));
        var observer =
            _observers.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _observers.remove(observer);
      }
    } catch (e) {
      print(e);
      var ind = controllerState.uploadingFiles
          .indexWhere((e) => e.id == pathToFile && e.endedWithException);
      if (ind != -1) {
        var observer =
            _observers.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _observers.remove(observer);
        _checkIfNeedToUpdating();
        // var connect = await Connectivity().checkConnectivity();

        // if (connect == ConnectivityResult.none) {
        //   add(FilesNoInternet());
        // } else {
        //   add(FileUpdateFiles());
        // }
      }
    }
  }

  void _checkIfNeedToUpdating() {
    _canUpdate = _observers.isEmpty;
  }

  void _updateUploadPercent({required String fileId, required int percent}) {
    var objects = state.objects;

    var indexOfUploadingFile =
        objects.indexWhere((element) => element.id == fileId);
    print('index if uploading filse is $indexOfUploadingFile');
    if (indexOfUploadingFile != -1) {
      var uploadingFile = objects[indexOfUploadingFile];

      if (uploadingFile is Record) {
        objects[indexOfUploadingFile] =
            uploadingFile.copyWith(loadPercent: percent.toDouble());
        print(
            'file\'s ${uploadingFile.name} upload percent = ${uploadingFile.loadPercent}');
        var newState = state.copyWith(objects: List.from(objects));
        emit(newState);
      }
    }
  }
}

class UploadObserver extends Observer {
  String id;
  UploadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}
