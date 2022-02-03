import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';

import '../../../constants.dart';

class OpenedFolderCubit extends Cubit<OpenedFolderState> {
  OpenedFolderCubit()
      : super(OpenedFolderState(
          objects: [],
          previousFolders: [],
        ));

  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  var _loadController = getIt<LoadController>();
  List<UploadObserver> _observers = [];
  List<DownloadObserver> _downloadObservers = [];
  late Observer _updateObserver = Observer((e) {
    try {
      if (e is List<UploadFileInfo>) {
        final uploadingFilesList = e;
        if (uploadingFilesList.any((file) =>
            file.isInProgress &&
            file.uploadPercent == -1 &&
            file.id.isNotEmpty)) {
          final file = uploadingFilesList.firstWhere(
              (file) => file.isInProgress && file.uploadPercent == -1);

          _update(uploadingFileId: file.id);
        }
      } else if (e is List<DownloadFileInfo>) {
        final downloadingFilesList = e;
        if (downloadingFilesList
            .any((file) => file.isInProgress && file.downloadPercent == -1)) {
          final file = downloadingFilesList.firstWhere(
              (file) => file.isInProgress && file.downloadPercent == -1);
          _setRecordDownloading(recordId: file.id);
        }
      }
    } catch (e) {
      log('OpenFolderCubit -> _updateObserver:', error: e);
    }
  });

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
        previousFolders: previousFolders,
      ),
    );

    _loadController.getState.registerObserver(_updateObserver);

    _syncWithLoadController();
  }

  void _syncWithLoadController() async {
    final loadState = _loadController.getState;
    final filesInFolder = state.objects;

    filesInFolder.forEach((fileInFolder) {
      var index = loadState.uploadingFiles
          .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
      if (index != -1 &&
          !_observers.any((element) =>
              element.id == loadState.uploadingFiles[index].localPath)) {
        var observer = UploadObserver(
          loadState.uploadingFiles[index].localPath,
          (p0) {
            _uploadListener(loadState.uploadingFiles[index].localPath, p0);
          },
        );

        _observers.add(observer);

        loadState.registerObserver(observer);
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

  Future<void> _update({String? uploadingFileId}) async {
    var objects = await _filesController
        .getContentFromFolderById(state.currentFolder!.id);

    if (uploadingFileId != null) {
      var uploadingFileIndex =
          objects.indexWhere((element) => element.id == uploadingFileId);
      objects[uploadingFileIndex] =
          (objects[uploadingFileIndex] as Record).copyWith(loadPercent: 0);
    }

    emit(state.copyWith(
      objects: objects,
    ));

    print('files was updated');

    _syncWithLoadController();
  }

  void _tryToFindObservableRecords() {
    var controllerState = _loadController.getState;

    if (controllerState.uploadingFiles.isNotEmpty) {
      try {
        var uploadingFile = controllerState.uploadingFiles
            .firstWhere((file) => file.isInProgress);

        if (state.objects.any((object) => object.id == uploadingFile.id)) {
          var observer = UploadObserver(
            uploadingFile.localPath,
            (value) => _uploadListener(uploadingFile.localPath, value),
          );

          _observers.add(observer);

          _loadController.getState.registerObserver(observer);
        }
      } catch (e) {
        print(
            'OpenedFolderCubit: can\'t find any uploading files in folder: ${state.currentFolder?.name}');
      }
    }
  }

  void _uploadListener(String pathToFile, dynamic value) async {
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

      if (value is CustomError) {
        var observer =
            _observers.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _observers.remove(observer);

        _update();
        return;
      }

      if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
        _update();
        print('currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty');
        return;
      }

      if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
        print('!currentFile.isInProgress && currentFile.uploadPercent == -1');
        return;
      }

      if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
        _updateUploadPercent(
          fileId: currentFile.id,
          percent: currentFile.uploadPercent,
        );
      } else if (currentFile.uploadPercent != -1) {
        _updateUploadPercent(
          fileId: currentFile.id,
          percent: currentFile.uploadPercent,
        );
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
      }
    }
  }

  void _updateUploadPercent({
    required String fileId,
    required int percent,
  }) async {
    var objects = List.from(state.objects);

    var indexOfUploadingFile =
        objects.indexWhere((element) => element.id == fileId);
    print('index if uploading filse is $indexOfUploadingFile');
    if (indexOfUploadingFile != -1) {
      var uploadingFile = objects[indexOfUploadingFile];

      if (uploadingFile is Record) {
        objects.insert(
          indexOfUploadingFile,
          uploadingFile.copyWith(
            loadPercent: percent == 100 ? null : percent.toDouble(),
          ),
        );
        objects.removeAt(indexOfUploadingFile + 1);
        // objects[indexOfUploadingFile] =
        //     uploadingFile.copyWith(loadPercent: percent.toDouble());
        print(
            'file\'s ${uploadingFile.name} upload percent = ${uploadingFile.loadPercent}');
        var newState = state.copyWith(objects: List.from(objects));

        emit(newState);
      }
    }
  }

  Future<void> fileTapped(Record record) async {
    var box = await Hive.openBox(kPathDBName);

    String path = box.get(record.id, defaultValue: '');

    if (path.isNotEmpty) {
      var appPath = (await getApplicationSupportDirectory()).path;
      var fullPathToFile = '$appPath/$path';
      var isExisting = await File(fullPathToFile).exists();
      if (isExisting) {
        var res = await OpenFile.open(fullPathToFile);
        print(res.message);
      }
    } else {
      _downloadFile(record.id);
    }
  }

  void _downloadFile(String recordId) async {
    _loadController.downloadFile(fileId: recordId);
    _registerDownloadObserver(recordId);
    _setRecordDownloading(recordId: recordId);
  }

  void _registerDownloadObserver(String recordId) async {
    var box = await Hive.openBox(kPathDBName);
    var controllerState = _loadController.getState;
    var downloadObserver = DownloadObserver(recordId, (value) async {
      if (value is List<DownloadFileInfo>) {
        var fileId = value.indexWhere((element) => element.id == recordId);

        if (fileId != -1) {
          var file = value[fileId];
          if (file.endedWithException) {
            _setRecordDownloading(
              recordId: recordId,
              isDownloading: false,
            );

            _unregisterDownloadObserver(recordId);
          } else if (file.localPath.isNotEmpty) {
            var path = file.localPath
                .split('/')
                .skipWhile((value) => value != 'downloads')
                .join('/');
            await box.put(file.id, path);

            _setRecordDownloading(
              recordId: recordId,
              isDownloading: false,
            );

            var res = await OpenFile.open(file.localPath);
            print(res.message);

            _unregisterDownloadObserver(recordId);
          }
        }
      }
      // }
    });

    controllerState.registerObserver(
      downloadObserver,
    );

    _downloadObservers.add(downloadObserver);
  }

  void _unregisterDownloadObserver(String recordId) async {
    try {
      final observer =
          _downloadObservers.firstWhere((observer) => observer.id == recordId);

      _loadController.getState.unregisterObserver(observer);

      _downloadObservers.remove(observer);
    } catch (e) {
      log('OpenFolderCubit -> _unregisterDownloadObserver:', error: e);
    }
  }

  void _setRecordDownloading({
    required String recordId,
    bool isDownloading = true,
  }) {
    try {
      var currentRecordIndex =
          state.objects.indexWhere((element) => element.id == recordId);

      var objects = [...state.objects];
      var currentRecord = objects[currentRecordIndex] as Record;
      objects[currentRecordIndex] =
          currentRecord.copyWith(loadPercent: isDownloading ? 0 : null);
      emit(state.copyWith(objects: objects));
    } catch (e) {
      log('OpenFolderCubit -> _setRecordDownloading:', error: e);
    }
  }
}

class UploadObserver extends Observer {
  String id;
  UploadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}

class DownloadObserver extends Observer {
  String id;
  DownloadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}
