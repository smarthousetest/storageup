import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/folder.dart';
import 'package:storageup/models/record.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/load_controller.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/observable_utils.dart';

import '../../constants.dart';
import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState());

  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  var _loadController = getIt<LoadController>();
  List<UploadObserver> _observers = [];
  List<DownloadObserver> _downloadObservers = [];
  UserController _userController = getIt<UserController>();
  StreamSubscription? updatePageSubscription;
  String idTappedFile = '';

  late var _updateObserver = Observer((e) {
    try {
      if (e is List<UploadFileInfo>) {
        final uploadingFilesList = e;
        if (uploadingFilesList.any((file) =>
            file.isInProgress &&
            file.uploadPercent == 0 &&
            file.id.isNotEmpty)) {
          final file = uploadingFilesList.firstWhere(
              (file) => file.isInProgress && file.uploadPercent == 0);

          _update(uploadingFileId: file.id);
        }
      } else if (e is List<DownloadFileInfo>) {
        final downloadingFilesList = e;
        if (downloadingFilesList
            .any((file) => file.isInProgress && file.downloadPercent == -1)) {
          final file = downloadingFilesList.firstWhere(
            (file) => file.isInProgress && file.downloadPercent == -1,
          );

          _setRecordDownloading(recordId: file.id);
        }

        if (downloadingFilesList.any((file) =>
            file.endedWithException == true &&
            file.errorReason == ErrorReason.noInternetConnection &&
            file.downloadPercent == -1 &&
            file.isInProgress == false &&
            file.id == idTappedFile)) {
          emit(state.copyWith(status: FormzStatus.submissionCanceled));
          emit(state.copyWith(status: FormzStatus.pure));
        } else if (downloadingFilesList.any((file) =>
            file.endedWithException == true &&
            file.downloadPercent == -1 &&
            file.isInProgress == false &&
            file.id == idTappedFile)) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
          emit(state.copyWith(status: FormzStatus.pure));
        }
      }
    } catch (e) {
      log('MediaCubit -> _updateObserver:', error: e);
    }
  });

  void init() async {
    var allMediaFolders = await _filesController.getMediaFolders(true);
    var currentFolder =
        allMediaFolders?.firstWhere((element) => element.id == '-1');
    User? user = await _userController.getUser;
    bool progress = true;
    var valueNotifier = _userController.getValueNotifier();
    emit(state.copyWith(
      albums: allMediaFolders,
      currentFolder: currentFolder,
      currentFolderRecords: currentFolder?.records?.reversed.toList(),
      allRecords: currentFolder?.records,
      user: user,
      progress: progress,
      status: FormzStatus.pure,
      valueNotifier: valueNotifier,
    ));
    _loadController.getState.registerObserver(_updateObserver);
    List<Record> allMedia = [];
    for (int i = 1; i < allMediaFolders!.length; i++) {
      allMedia.addAll(allMediaFolders[i].records!);
      print("all media $allMedia");
    }
    _syncWithLoadController(allMedia);
    print("all media2 $allMedia");
    updatePageSubscription = eventBusUpdateAlbum.on().listen((event) {
      _update();
    });
  }

  @override
  Future<void> close() async {
    _observers.forEach((element) {
      _loadController.getState.unregisterObserver(element);
    });

    _loadController.getState.unregisterObserver(_updateObserver);
    updatePageSubscription?.cancel();
    return super.close();
  }

  void mapSortedFieldChanged(String sortText) {
    final tmpState = _resetSortedList(state: state);
    final allFiles = tmpState.allRecords;

    List<Record> sortedMedia = [];
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
        sortedMedia.add(element);
      }
    });

    emit(state.copyWith(
        currentFolderRecords: sortedMedia, status: FormzStatus.pure));
  }

  MediaState _resetSortedList({
    required MediaState state,
  }) {
    return state.copyWith(sortedRecords: state.allRecords);
  }

  void _syncWithLoadController(List<Record> filesInFolder) async {
    var loadState = _loadController.getState;
    print("upload synh");
    filesInFolder.forEach((fileInFolder) {
      var index = loadState.uploadingFiles
          .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
      if (index != -1 &&
          !_observers.any((element) =>
              element.id == loadState.uploadingFiles[index].localPath)) {
        print("upload file ${loadState.uploadingFiles[index].localPath}");
        var observer = UploadObserver(
          loadState.uploadingFiles[index].localPath,
          (p0) {
            _uploadListener(loadState.uploadingFiles[index].localPath);
          },
        );

        _observers.add(observer);
        print("observesr $_observers");
        loadState.registerObserver(observer);
      }
    });
  }

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(
      representation: representation,
      status: FormzStatus.pure,
    ));
  }

  void setFavorite(Record object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      _update();
    }
  }

  Future<void> _update({String? uploadingFileId}) async {
    await _filesController.updateFilesList();

    var albums = await _filesController.getMediaFolders(true);
    var updatedChoosedFolder =
        albums?.firstWhere((element) => element.id == state.currentFolder.id);
    var newState = state.copyWith(
      albums: albums,
      currentFolder: updatedChoosedFolder,
      currentFolderRecords: updatedChoosedFolder?.records?.reversed.toList(),
    );

    emit(newState);

    var isAnyMediaUploding = albums?.any((album) =>
        album.records?.any((record) => record.id == uploadingFileId) == true);

    if (uploadingFileId != null && isAnyMediaUploding == true) {
      log('MediaCubit -> _update: Downloading file finded');
      List<Folder> newAlbumList = [];
      for (int i = 0; i < albums!.length; i++) {
        var album = albums[i];
        var indexOfUploadingMedia =
            album.records?.indexWhere((record) => record.id == uploadingFileId);

        final uploadingObjectIndexFromLoadState = _loadController
            .getState.uploadingFiles
            .indexWhere((element) => element.id == uploadingFileId);

        var isAllreadyLoaded = false;

        if (uploadingObjectIndexFromLoadState != -1) {
          final objectFromLoadState = _loadController
              .getState.uploadingFiles[uploadingObjectIndexFromLoadState];

          isAllreadyLoaded = objectFromLoadState.uploadPercent == 100 ||
              objectFromLoadState.uploadPercent == -1;
        }

        if (indexOfUploadingMedia != null &&
            indexOfUploadingMedia != -1 &&
            !isAllreadyLoaded) {
          var newRecordsList = album.records!;
          newRecordsList[indexOfUploadingMedia] =
              newRecordsList[indexOfUploadingMedia].copyWith(loadPercent: 0);
          var newAlbum = album.copyWith(records: newRecordsList);
          newAlbumList.add(newAlbum);
        } else {
          newAlbumList.add(album);
        }
      }
      var currentFolder = newAlbumList
          .firstWhere((element) => element.id == state.currentFolder.id);
      emit(
        state.copyWith(
          albums: newAlbumList,
          currentFolder: currentFolder,
          currentFolderRecords: currentFolder.records?.reversed.toList(),
          status: FormzStatus.pure,
        ),
      );
    }

    List<Record> allRecords = [];
    for (var i = 1; i < albums!.length; i++) {
      allRecords.addAll(albums[i].records!);
    }
    _syncWithLoadController(allRecords);
  }

  void _tryToFindObservableRecords() {
    var controllerState = _loadController.getState;

    if (controllerState.uploadingFiles.isNotEmpty) {
      try {
        var uploadingFile = controllerState.uploadingFiles
            .firstWhere((file) => file.isInProgress);

        if (state.albums.any(
          (album) =>
              album.records!.any((object) => object.id == uploadingFile.id),
        )) {
          var observer = UploadObserver(uploadingFile.localPath,
              (_) => _uploadListener(uploadingFile.localPath));

          _observers.add(observer);

          _loadController.getState.registerObserver(observer);
        }
      } catch (e) {
        print(
            'OpenedFolderCubit: can\'t find any uploading files in folder: ${state.currentFolder.name}');
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
        await _updateUploadPercent(
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

  Future<void> _updateUploadPercent({
    required String fileId,
    required int percent,
  }) async {
    if (percent == 100 || percent == 99)
      print('------------------- fuck yeah $percent percents');
    var albums = List<Folder>.from(state.albums);
    for (var album in albums) {
      print('foler index = ${albums.indexOf(album)}, percent is $percent');
      var objects = List<Record>.from(album.records!);

      var indexOfUploadingFile =
          objects.indexWhere((element) => element.id == fileId);
      print('index of uploading file is $indexOfUploadingFile');
      if (indexOfUploadingFile != -1) {
        var uploadingFile = objects[indexOfUploadingFile];

        objects.insert(
          indexOfUploadingFile,
          uploadingFile.copyWith(
            loadPercent: percent >= 99 ? null : percent.toDouble(),
          ),
        );
        objects.removeAt(indexOfUploadingFile + 1);
        // objects[indexOfUploadingFile] =
        //     uploadingFile.copyWith(loadPercent: percent.toDouble());
        print(
            'file\'s ${uploadingFile.name} upload percent = ${uploadingFile.loadPercent}');

        var indexOfAlbum = albums.indexOf(album);
        // albums[indexOfAlbum] = ;
        albums.insert(
          indexOfAlbum,
          album.copyWith(records: objects),
        );
        albums.removeAt(indexOfAlbum + 1);

        var isCurrentFolder = state.currentFolder.id == album.id;

        var newState = state.copyWith(
          albums: albums,
          currentFolder: isCurrentFolder ? album : null,
          currentFolderRecords:
              isCurrentFolder ? album.records?.reversed.toList() : null,
        );
        emit(newState);
      }
    }
  }

  Future<void> fileTapped(Record record) async {
    var box = await Hive.openBox(kPathDBName);

    String path = box.get(record.id, defaultValue: '');
    idTappedFile = record.id;
    if (path.isNotEmpty) {
      var appPath = (await getApplicationSupportDirectory()).path;
      var fullPathToFile = '$appPath/$path';
      var isExisting = await File(fullPathToFile).exists();
      if (isExisting) {
        var res = await OpenFile.open(fullPathToFile);
        print(res.message);
      } else {
        _downloadFile(record.id);
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
          } else {
            var state = _loadController.getState;
            var fileId = state.downloadingFiles
                .indexWhere((element) => element.id == recordId);
            if (fileId != -1) {
              var file = state.downloadingFiles[fileId];
              if (file.localPath.isNotEmpty) {
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
        }
      }
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
      log('MediaCubit -> _unregisterDownloadObserver: error $e');
    }
  }

  void onActionDeleteChosen(Record record) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    var result = await _filesController.deleteObjects([record]);
    print(result);
    if (result == ResponseStatus.ok) {
      _update();
    } else if (result == ResponseStatus.noInternet) {
      emit(state.copyWith(status: FormzStatus.submissionCanceled));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<ErrorType?> onActionRenameChosen(Record object, String newName) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    var result = await _filesController.renameRecord(newName, object.id);
    print(result);
    if (result == ResponseStatus.ok) {
      _update();
    } else if (result == ResponseStatus.notExecuted) {
      print('declined');
      return ErrorType.alreadyExist;
    } else if (result == ResponseStatus.failed) {
      print('declined');
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionCanceled));
    }
    return null;
  }

  void _setRecordDownloading({
    required String recordId,
    bool isDownloading = true,
  }) async {
    var albums = List<Folder>.from(state.albums);
    for (var album in albums) {
      try {
        var currentRecordIndex =
            album.records!.indexWhere((element) => element.id == recordId);

        var objects = [...album.records!];
        var currentRecord = objects[currentRecordIndex];
        objects.insert(
          currentRecordIndex,
          currentRecord.copyWith(loadPercent: isDownloading ? 0 : null),
        );
        objects.removeAt(currentRecordIndex + 1);
        var indexOfAlbum = albums.indexOf(album);
        albums.insert(
          indexOfAlbum,
          album.copyWith(records: objects),
        );
        albums.removeAt(indexOfAlbum + 1);
      } catch (e) {
        // print(e);
      }
    }
    final currentFolder =
        albums.firstWhere((album) => album.id == state.currentFolder.id);
    emit(state.copyWith(
      albums: albums,
      currentFolder: currentFolder,
      currentFolderRecords: currentFolder.records?.reversed.toList(),
      status: FormzStatus.pure,
    ));
  }

  void changeFolder(Folder newFolder) async {
    emit(
      state.copyWith(
        currentFolder: newFolder,
        currentFolderRecords: newFolder.records?.reversed.toList(),
        status: FormzStatus.pure,
      ),
    );
  }
}
