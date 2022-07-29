import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cpp_native/controllers/load/load_controller.dart';
import 'package:cpp_native/controllers/load/models.dart';
import 'package:cpp_native/controllers/load/observable_utils.dart';
import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/pages/sell_space/space_bloc.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/packet_controllers.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/latest_file_repository.dart';

import '../../../constants.dart';
import '../../../utilities/repositories/user_repository.dart';

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

class OpenedFolderCubit extends Cubit<OpenedFolderState> {
  OpenedFolderCubit()
      : super(OpenedFolderState(
          objects: [],
          previousFolders: [],
        ));

  late FilesController _filesController;
  var _loadController = LoadController.instance;
  StreamSubscription? updatePageSubscription;
  late final LatestFileRepository _recentsFilesRepository;
  String idTappedFile = '';
  final UserRepository _userRepository =
      getIt<UserRepository>(instanceName: 'user_repo');
  var _packetController =
      getIt<PacketController>(instanceName: 'packet_controller');

  //    void _processLoadChanges(LoadNotification notification) async {
  //   MainUploadInfo? upload;
  //   MainDownloadInfo? download;

  //   final isUploadingInProgress = notification.countOfUploadingFiles != 0 &&
  //       notification.isUploadingInProgress;

  //   if (isUploadingInProgress) {
  //     final loadPercent = notification.uploadFileInfo?.loadPercent.toDouble();

  //     upload = MainUploadInfo(
  //       countOfUploadedFiles: notification.countOfUploadedFiles,
  //       countOfUploadingFiles: notification.countOfUploadingFiles,
  //       isUploading: true,
  //       uploadingFilePercent:
  //           loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
  //     );

  //     add(MainPageChangeUploadInfo(uploadInfo: upload));
  //   } else {
  //     add(MainPageChangeUploadInfo(
  //         uploadInfo: MainUploadInfo(isUploading: false)));
  //   }

  //   final isDownloadingInProgress = notification.countOfDownloadingFiles != 0 &&
  //       notification.isDownloadingInProgress;

  //   if (isDownloadingInProgress) {
  //     final loadPercent = notification.downloadFileInfo?.loadPercent.toDouble();

  //     download = MainDownloadInfo(
  //       countOfDownloadedFiles: notification.countOfDownloadedFiles,
  //       countOfDownloadingFiles: notification.countOfDownloadingFiles,
  //       isDownloading: true,
  //       downloadingFilePercent:
  //           loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
  //     );

  //     add(MainPageChangeDownloadInfo(downloadInfo: download));
  //   } else {
  //     add(MainPageChangeDownloadInfo(
  //         downloadInfo: MainDownloadInfo(isDownloading: false)));
  //   }
  // }

  late Observer _updateObserver = Observer((e) async {
    try {
      if (e is LoadNotification) {
        final uploadingFile = e.uploadFileInfo;
        print("e =  ${e.downloadFileInfo}");
        // if (uploadingFilesList.any((file) =>
        //     file.isInProgress && file.loadPercent == 0 && file.id.isNotEmpty)) {
        //   final file = uploadingFilesList
        //       .firstWhere((file) => file.isInProgress && file.loadPercent == 0);

        if (uploadingFile != null &&
            uploadingFile.folderId == state.currentFolder?.id) {
          _updateUploadPercent(
            fileId: uploadingFile.id,
            percent: uploadingFile.loadPercent,
          );
          update();
        } else if (e.downloadFileInfo != null &&
            e.isDownloadingInProgress &&
            e.downloadFileInfo?.loadPercent == -1) {
          _setRecordDownloading(recordId: e.downloadFileInfo!.id);
        } else if (e.downloadFileInfo != null &&
            e.downloadFileInfo!.loadPercent == 100) {
          var downloadObject = e.downloadFileInfo;

          if (downloadObject!.localPath.isNotEmpty) {
            var box = await Hive.openBox(kPathDBName);
            var path = downloadObject.localPath;
            await box.put(downloadObject.id, path);

            _setRecordDownloading(
              recordId: downloadObject.id,
              isDownloading: false,
            );
            var appPath = await getDownloadAppFolder();
            var fullPathToFile = '$appPath$path';
            // fullPathToFile = Uri.decodeFull(fullPathToFile);
            await OpenFile.open(fullPathToFile);
          }
        } else if (e.downloadFileInfo?.endedWithException == true &&
            e.downloadFileInfo?.errorReason ==
                ErrorReason.noInternetConnection &&
            e.downloadFileInfo?.loadPercent == -1 &&
            e.isDownloadingInProgress == false &&
            e.downloadFileInfo?.id == idTappedFile) {
          emit(state.copyWith(status: FormzStatus.submissionCanceled));
          emit(state.copyWith(status: FormzStatus.pure));
        } else if (e.downloadFileInfo?.endedWithException == true &&
            e.downloadFileInfo?.loadPercent == -1 &&
            e.isDownloadingInProgress == false &&
            e.downloadFileInfo?.id == idTappedFile) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
          emit(state.copyWith(status: FormzStatus.pure));
        }

        // }
      }
    } catch (e) {
      log('OpenFolderCubit -> _updateObserver:', error: e);
    }
  });

  @override
  Future<void> close() async {
    _loadController.getState.unregisterObserver(_updateObserver);

    updatePageSubscription?.cancel();
    return super.close();
  }

  void init(Folder? folder, List<Folder> previousFolders) async {
    _filesController = await GetIt.I.getAsync<FilesController>();
    Folder? currentFolder;
    OpenedFolderState newState;
    if (folder == null) {
      currentFolder =
          await _filesController.getFilesRootFolder(withUpdate: true);
      final objectsVL = _filesController
          .getObjectsValueListenableByFolderId(currentFolder!.id);

      newState = state.copyWith(
        currentFolder: currentFolder,
        objectsValueListenable: objectsVL,
      );
    } else {
      currentFolder = await _filesController.getFolderById(folder.id);
      final objectsVL = _filesController
          .getObjectsValueListenableByFolderId(currentFolder!.id);
      newState = state.copyWith(
        currentFolder: currentFolder,
        objectsValueListenable: objectsVL,
      );
    }
    // var objects =
    //     await _filesController.getContentFromFolderById(currentFolder!.id);

    updatePageSubscription = eventBusUpdateFolder.on().listen((event) {
      update();
    });

    bool progress = true;
    _recentsFilesRepository =
        await GetIt.instance.getAsync<LatestFileRepository>();
    var valueNotifier = _userRepository.getValueNotifier;
    emit(newState);
    emit(
      state.copyWith(
        previousFolders: previousFolders,
        progress: progress,
        valueNotifier: valueNotifier,
      ),
    );

    _loadController.getState.registerObserver(_updateObserver);

    _syncWithLoadController();
  }

  List<BaseObject> mapSortedFieldChanged(String sortText) {
    emit(state.copyWith(status: FormzStatus.pure));
    final allFiles = state.objects;

    List<BaseObject> sortedFiles = [];
    var textLoverCase = sortText.toLowerCase();

    allFiles.forEach((element) {
      var containsDate = DateFormat.yMd(Intl.getCurrentLocale())
          .format(element.createdAt!)
          .toString()
          .toLowerCase()
          .contains(textLoverCase);
      if ((element.createdAt != null && containsDate) ||
          (element.name != null &&
              element.name!.toLowerCase().contains(textLoverCase)) ||
          (element.extension != null &&
              element.extension!.toLowerCase().contains(textLoverCase))) {
        sortedFiles.add(element);
      }
    });
    return sortedFiles;
    //emit(state.copyWith(sortedFiles: sortedFiles));
  }

  void onRecordActionChoosed(FileAction action, BaseObject object) {
    emit(state.copyWith(status: FormzStatus.pure));
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

  void _onActionDeleteChoosed(BaseObject object) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    var result = await _filesController.delete([object]);

    var recentsFile = await _filesController.getRecentFiles();
    if (recentsFile != null) {
      await _recentsFilesRepository.addFiles(latestFile: recentsFile);
    }

    // if (result == ResponseStatus.ok) {
    //   await _packetController.updatePacket();
    //   update();
    // } else if (result == ResponseStatus.noInternet) {
    //   emit(state.copyWith(status: FormzStatus.submissionCanceled));
    // } else {
    //   emit(state.copyWith(status: FormzStatus.submissionFailure));
    // }
  }

  Future<void> onActionMoveFiles(
    List<BaseObject> objects,
    Folder currentFolder,
  ) async {
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

    try {
      await _filesController.moveToFolder(
        folderId: currentFolder.id,
        folders: folders,
        records: records,
      );
      await update();
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
        ),
      );
    }
  }

  Future<void> uploadFilesAction(String? folderId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      List<String?> filePaths = result.paths;

      for (int i = 0; i < filePaths.length; i++) {
        if (filePaths[i] != null &&
            PathCheck().isPathCorrect(filePaths[i].toString())) {
          if (folderId == null) folderId = state.currentFolder?.id;
          await _loadController.uploadFile(
              filePath: filePaths[i], folderId: folderId);
        } else {
          emit(state.copyWith(status: FormzStatus.invalid));
          emit(state.copyWith(status: FormzStatus.pure));
        }
      }
    } else {
      return null;
    }
  }

  Future<ErrorType?> onActionRenameChoosedFile(
      BaseObject object, String newName) async {
    var result = await _filesController.rename(name: newName, object: object);
    print(result);
    if (result == ResponseStatus.ok) {
      update();
    } else if (result == ResponseStatus.notExecuted) {
      return ErrorType.alreadyExist;
    } else if (result == ResponseStatus.failed) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionCanceled));
    }
    return null;
  }

  Future<ErrorType?> onActionRenameChosenFolder(
      BaseObject object, String newName) async {
    var result = await _filesController.rename(name: newName, object: object);
    print(result);
    if (result == ResponseStatus.ok) {
      update();
    } else if (result == ResponseStatus.notExecuted) {
      return ErrorType.alreadyExist;
    } else if (result == ResponseStatus.failed) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionCanceled));
    }
    return null;
  }

  void _syncWithLoadController() async {
    // final loadState = _loadController.getState;
    // final filesInFolder = state.objects;

    // filesInFolder.forEach((fileInFolder) {
    //   var index = loadState.uploadingFiles
    //       .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
    //   if (index != -1 &&
    //       !_observers.any((element) =>
    //           element.id == loadState.uploadingFiles[index].localPath)) {
    //     var observer = UploadObserver(
    //       loadState.uploadingFiles[index].localPath,
    //       (p0) {
    //         _uploadListener(loadState.uploadingFiles[index].localPath, p0);
    //       },
    //     );

    //     _observers.add(observer);

    //     loadState.registerObserver(observer);
    //   }
    // });
  }

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(
      representation: representation,
      status: FormzStatus.pure,
    ));
  }

  void setFavorite(BaseObject object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      update();
    }
  }

  Future<void> createFolder(
    String? name,
    String? folderId,
  ) async {
    if (folderId == null) {
      try {
        await _filesController.updateFilesList();
      } catch (_) {}
      var rootFilesFolder = await _filesController.getFilesRootFolder();
      folderId = rootFilesFolder!.id;
    } else {
      folderId = folderId;
    }

    if (name != null) {
      final result = await _filesController.createFolder(name, folderId);
      update();

      if (result == ResponseStatus.failed) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      } else if (result == ResponseStatus.noInternet) {
        emit(state.copyWith(status: FormzStatus.submissionCanceled));
      }
    }
  }

  Future<void> setNewCriterionAndDirection(
      SortingCriterion criterion,
      SortingDirection direction,
      String? sortText,
      FilesRepresentation representation) async {
    emit(state.copyWith(
      criterion: criterion,
      direction: direction,
      representation: representation,
      search: sortText,
      status: FormzStatus.pure,
    ));
  }

  Future<void> update({String? uploadingFileId}) async {
    await _filesController.updateFilesList();

    final valueListenable = _filesController
        .getObjectsValueListenableByFolderId(state.currentFolder!.id);

    await _packetController.updatePacket();
    emit(state.copyWith(
      objectsValueListenable: valueListenable,
      status: FormzStatus.pure,
    ));

    print('files was updated');

    _syncWithLoadController();
  }

  void _tryToFindObservableRecords() {
    // var controllerState = _loadController.getState;

    // if (controllerState.uploadingFiles.isNotEmpty) {
    //   try {
    //     var uploadingFile = controllerState.uploadingFiles
    //         .firstWhere((file) => file.isInProgress);

    //     if (state.objects.any((object) => object.id == uploadingFile.id)) {
    //       var observer = UploadObserver(
    //         uploadingFile.localPath,
    //         (value) => _uploadListener(uploadingFile.localPath, value),
    //       );

    //       _observers.add(observer);

    //       _loadController.getState.registerObserver(observer);
    //     }
    //   } catch (e) {
    //     print(
    //         'OpenedFolderCubit: can\'t find any uploading files in folder: ${state.currentFolder?.name}');
    //   }
    // }
  }

  // void _uploadListener(String pathToFile, dynamic value) async {
  //   var controllerState = _loadController.getState;

  //   final uploadingFile = controllerState.currentUploadingFile;
  //   // final downloadingFile = controllerState.currentDownloadingFile;

  //   if (uploadingFile != null &&
  //       uploadingFile.folderId == state.currentFolder) {
  //     _updateUploadPercent(
  //       fileId: uploadingFile.id,
  //       percent: uploadingFile.loadPercent,
  //     );
  //   }
  // }

  // if (pathToFile.isEmpty) {
  //   var currentFileIndex = controllerState.uploadingFiles
  //       .indexWhere((file) => file.isInProgress);

  //   if (currentFileIndex != -1) {
  //     var currentFilePath =
  //         controllerState.uploadingFiles[currentFileIndex].localPath;

  //     var indexOfObserver =
  //         _observers.indexWhere((observer) => observer.id == currentFilePath);

  //     if (indexOfObserver == -1) {
  //       await _update();
  //       _tryToFindObservableRecords();
  //     }
  //   }
  //   return;
  // }

  // try {
  //   // var currentFile = controllerState.uploadingFiles.firstWhere(
  //   //     (element) => element.localPath == pathToFile && element.isInProgress);

  //   // if (value is CustomError) {
  //   //   var observer =
  //   //       _observers.firstWhere((element) => element.id == pathToFile);
  //   //   controllerState.unregisterObserver(observer);

  //   //   _observers.remove(observer);

  //   //   _update();
  //   //   return;
  //   // }

  //   if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
  //     _update();
  //     print('currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty');
  //     return;
  //   }

  //   if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
  //     print('!currentFile.isInProgress && currentFile.uploadPercent == -1');
  //     return;
  //   }

  //   if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
  //     _updateUploadPercent(
  //       fileId: currentFile.id,
  //       percent: currentFile.uploadPercent,
  //     );
  //   } else if (currentFile.uploadPercent != -1) {
  //     _updateUploadPercent(
  //       fileId: currentFile.id,
  //       percent: currentFile.uploadPercent,
  //     );
  //     var observer =
  //         _observers.firstWhere((element) => element.id == pathToFile);
  //     controllerState.unregisterObserver(observer);

  //     _observers.remove(observer);
  //   }
  // } catch (e) {
  //   print(e);
  //   var ind = controllerState.uploadingFiles
  //       .indexWhere((e) => e.id == pathToFile && e.endedWithException);
  //   if (ind != -1) {
  //     var observer =
  //         _observers.firstWhere((element) => element.id == pathToFile);
  //     controllerState.unregisterObserver(observer);

  //     _observers.remove(observer);
  //   }
  // }

  void _updateUploadPercent({
    required String fileId,
    required int percent,
  }) async {
    var objects = List.from(state.objects);

    var indexOfUploadingFile =
        objects.indexWhere((element) => element.id == fileId);
    print('index if uploading filse is $indexOfUploadingFile');

    if (indexOfUploadingFile == -1) {
      // objects = await _filesController
      //     .getContentFromFolderById(state.currentFolder!.id);
      indexOfUploadingFile =
          objects.indexWhere((element) => element.id == fileId);
    }

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
        var newState = state.copyWith(
          objects: List.from(objects),
        );

        emit(newState);
      }
    }
  }

  Future<void> fileSave(Record record) async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      _downloadFile(record.id, result);
    }
  }

  Future<void> fileTapped(Record record) async {
    final result = await _filesController.setRecentFile(record, DateTime.now());
    if (result == ResponseStatus.ok) {
      var recentsFile = await _filesController.getRecentFiles();
      if (recentsFile != null) {
        // recentsFile.forEach((element) {
        await _recentsFilesRepository.addFiles(latestFile: recentsFile);
        // });
      }
      //_repository.addFile(latestFile: record);

      var box = await Hive.openBox(kPathDBName);
      String path = box.get(record.id, defaultValue: '');
      // idTappedFile = record.id;
      if (path.isNotEmpty) {
        var appPath = await getDownloadAppFolder();
        if (path.contains("()")) {
          path.replaceAll(('('), '"("');
          path.replaceAll((')'), '")"');
        }

        var fullPathToFile = "$appPath/$path";
        var isExisting = await File(fullPathToFile).exists();
        //var isExistingSync = File(fullPathToFile).watch();
        print(fullPathToFile);
        if (isExisting) {
          var res = await OpenFile.open(fullPathToFile);
          print(res.message);
        } else {
          _downloadFile(record.id, null);
        }
      } else {
        _downloadFile(record.id, null);
      }
    } else if (result == ResponseStatus.failed) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionCanceled));
    }
  }

  void _downloadFile(String recordId, String? path) async {
    _loadController.downloadFile(fileId: recordId, path: path); //?

    _setRecordDownloading(recordId: recordId);
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
      emit(state.copyWith(
        objects: objects,
        status: FormzStatus.pure,
      ));
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
