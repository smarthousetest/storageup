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

  late Observer _updateObserver = Observer((a) {
    try {
      var uploadingFilesList = a as List<UploadFileInfo>;
      if (uploadingFilesList.any((file) =>
          file.isInProgress &&
          file.uploadPercent == -1 &&
          file.id.isNotEmpty)) {
        var file = uploadingFilesList.firstWhere(
            (file) => file.isInProgress && file.uploadPercent == -1);

        _update(uploadingFileId: file.id);
      }
    } catch (e) {
      print('upload updater error: $e');
    }
  });

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
        previousFolders: previousFolders,
      ),
    );

    _loadController.getState.registerObserver(_updateObserver);

    _syncWithLoadController(objects);
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

        // var connect = await Connectivity().checkConnectivity();

        // if (connect == ConnectivityResult.none) {
        //   add(FilesNoInternet());
        // } else {
        //   add(FileUpdateFiles());
        // }
      }
    }
  }

  void _updateUploadPercent(
      {required String fileId, required int percent}) async {
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
      var appPath = (await getApplicationDocumentsDirectory()).path;
      var fullPathToFile = '$appPath/$path';
      var isExisting = await File(fullPathToFile).exists();
      if (isExisting) {
        var res = await OpenFile.open(fullPathToFile);
        print(res.message);
      }
    } else {
      _loadController.downloadFile(fileId: record.id);

      var controllerState = _loadController.getState;
      _setRecordDownloading(recordId: record.id);

      controllerState.registerObserver(
        DownloadObserver(record.id, (value) async {
          if (value is CustomError) {
            print('error while trying download file');
          } else {
            var state = _loadController.getState;
            var fileId = state.downloadingFiles
                .indexWhere((element) => element.id == record.id);
            if (fileId != -1) {
              var file = state.downloadingFiles[fileId];
              if (file.localPath.isNotEmpty) {
                var path = file.localPath
                    .split('/')
                    .skipWhile((value) => value != 'downloads')
                    .join('/');
                await box.put(file.id, path);

                _setRecordDownloading(
                  recordId: record.id,
                  isDownloading: false,
                );

                var res = await OpenFile.open(file.localPath);
                print(res.message);
              }
            }
          }
        }),
      );
    }
  }

  void _setRecordDownloading(
      {required String recordId, bool isDownloading = true}) {
    try {
      var currentRecordIndex =
          state.objects.indexWhere((element) => element.id == recordId);

      var objects = [...state.objects];
      var currentRecord = objects[currentRecordIndex] as Record;
      objects[currentRecordIndex] =
          currentRecord.copyWith(loadPercent: isDownloading ? 0 : null);
      emit(state.copyWith(objects: objects));
    } catch (e) {
      print(e);
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
