import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/controllers/load/load_controller.dart';
import 'package:cpp_native/controllers/load/models.dart';
import 'package:cpp_native/controllers/load/observable_utils.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/pages/sell_space/space_bloc.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';

import '../../constants.dart';
import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit({required this.stateContainer}) : super(MediaState()) {
    localeChangedStreamSubscription =
        stateContainer.localeChangedController.stream.listen((newLocale) {
      onLocaleChanged(newLocale);
    });
  }

  StreamSubscription<Locale>? localeChangedStreamSubscription;
  final StateContainerState stateContainer;
  late FilesController _filesController;
  var _loadController = LoadController.instance;
  UserController _userController = getIt<UserController>();
  StreamSubscription? updatePageSubscription;
  String idTappedFile = '';

  void onLocaleChanged(Locale locale) {
    S translate = getIt<S>();
    var albums = state.albums.map((e) => e.copyWith()).toList();

    String photos =
        Intl.withLocale(locale.languageCode, () => translate.photos);
    String video = Intl.withLocale(locale.languageCode, () => translate.video);
    String all = Intl.withLocale(locale.languageCode, () => translate.all);

    for (var album in albums) {
      if (album.name == '??????' || album.name == 'All') {
        album.name = all;
      } else if (album.name == '????????' || album.name == 'Photos') {
        album.name = photos;
      } else if (album.name == '??????????' || album.name == 'Video') {
        album.name = video;
      }
    }

    emit(state.copyWith(albums: albums));
  }

  late var _updateObserver = Observer((e) async {
    if (e is LoadNotification) {
      final uploadingMedia = e.uploadFileInfo;
      final downloadingMedia = e.downloadFileInfo;
      List<String> albums = state.foldersToListen!;
      // String all =
      //     state.foldersToListen!.firstWhere((element) => element == '-1');
      if (albums.any((element) => element == uploadingMedia?.folderId)) {
        _update(uploadingFile: uploadingMedia?.copyWith());
      }
      // for (var album in albums) {
      //   if (album.id == uploadingMedia?.folderId) {
      //     if (!(album.records
      //             ?.any((element) => element.id == uploadingMedia?.id) ??
      //         false)) {
      //       _update(uploadingFile: uploadingMedia?.copyWith());
      //     }

      //     final currentAlbum = _changeRecordInAlbum(uploadingMedia!, album);

      //     all = _changeRecordInAlbum(uploadingMedia, all);

      //     final indexOfAlbum = albums.indexOf(album);

      //     albums[indexOfAlbum] = currentAlbum;
      //   }
      // }
      // final currentAlbum =
      //     albums.firstWhere((element) => element.id == state.currentFolder.id);

      // emit(state.copyWith(
      //   albums: albums,
      //   allRecords:
      //       albums.fold<List<Record>>(<Record>[], (previousValue, element) {
      //     previousValue.addAll(element.records ?? []);
      //     return previousValue;
      //   }),
      //   currentFolder: currentAlbum,
      //   currentFolderRecords: currentAlbum.records,
      // ));

      if (downloadingMedia != null &&
          state.allRecords
              .any((element) => element.id == downloadingMedia.id)) {
        _setRecordDownloading(
          recordId: downloadingMedia.id,
          isDownloading: downloadingMedia.loadPercent != 100,
        );

        if (downloadingMedia.endedWithException) {
          _update();
          return;
        }

        if (downloadingMedia.loadPercent == 100) {
          if (downloadingMedia.localPath.isNotEmpty) {
            var box = await Hive.openBox(kPathDBName);
            var path = downloadingMedia.localPath;
            await box.put(downloadingMedia.id, path);

            _setRecordDownloading(
              recordId: downloadingMedia.id,
              isDownloading: false,
            );
            var appPath = await getDownloadAppFolder();
            var fullPathToFile = '$appPath$path';
            // fullPathToFile = Uri.decodeFull(fullPathToFile);
            // await OpenFile.open(fullPathToFile);
          }
        }
      }
      // try {
      //   if (e is List<UploadFileInfo>) {
      //     final uploadingFilesList = e;
      //     if (uploadingFilesList.any((file) =>
      //         file.isInProgress && file.loadPercent == 0 && file.id.isNotEmpty)) {
      //       final file = uploadingFilesList
      //           .firstWhere((file) => file.isInProgress && file.loadPercent == 0);

      //       _update(uploadingFileId: file.id);
      //     }
      //   } else if (e is List<DownloadFileInfo>) {
      //     final downloadingFilesList = e;
      //     if (downloadingFilesList
      //         .any((file) => file.isInProgress && file.loadPercent == -1)) {
      //       final file = downloadingFilesList.firstWhere(
      //         (file) => file.isInProgress && file.loadPercent == -1,
      //       );

      //       _setRecordDownloading(recordId: file.id);
      //     }

      //     if (downloadingFilesList.any((file) =>
      //         file.endedWithException == true &&
      //         file.errorReason == ErrorReason.noInternetConnection &&
      //         file.loadPercent == -1 &&
      //         file.isInProgress == false &&
      //         file.id == idTappedFile)) {
      //       emit(state.copyWith(status: FormzStatus.submissionCanceled));
      //       emit(state.copyWith(status: FormzStatus.pure));
      //     } else if (downloadingFilesList.any((file) =>
      //         file.endedWithException == true &&
      //         file.loadPercent == -1 &&
      //         file.isInProgress == false &&
      //         file.id == idTappedFile)) {
      //       emit(state.copyWith(status: FormzStatus.submissionFailure));
      //       emit(state.copyWith(status: FormzStatus.pure));
      //     }
      //   }
      // } catch (e) {
      //   log('MediaCubit -> _updateObserver:', error: e);
      // }
    }
  });

  Folder _changeRecordInAlbum(FileInfo info, Folder folder) {
    final indexOfUploadingMedia =
        folder.records?.indexWhere((element) => element.id == info.id);

    if (indexOfUploadingMedia == -1 || indexOfUploadingMedia == null)
      return folder;

    var uploadingMedia = folder.records?.elementAt(indexOfUploadingMedia);

    if (uploadingMedia == null) return folder;

    uploadingMedia = uploadingMedia.copyWith(
      isInProgress: info.isInProgress,
      loadPercent: info.loadPercent.toDouble(),
    );

    final recordsFromFolder = List<Record>.from(folder.records!);

    recordsFromFolder[indexOfUploadingMedia] = uploadingMedia;

    folder.copyWith(records: recordsFromFolder);

    return folder;
  }

  void init() async {
    _filesController = await GetIt.I.getAsync<FilesController>();
    final rootFolder = await _filesController.getMediaRootFolder(
      withUpdate: true,
    );

    var mediaFolder =
        await _filesController.getObjectByIdFromLocalStorage('-1');

    bool progress = true;
    var valueNotifier = _userController.getValueNotifier();
    final valueListenable =
        _filesController.getObjectsValueListenableByFolderId(rootFolder!.id);

    final foldersId =
        _filesController.getContentFromFolderById(mediaFolder!.parentFolder!);
    final valueListenableObject =
        _filesController.getObjectsValueListenableByFolderId('-1');

    emit(state.copyWith(
      rootMediaFolder: rootFolder,
      currentFolder: mediaFolder as Folder,
      folderValueListenable: valueListenable,
      objectsValueListenable: valueListenableObject,
      foldersToListen: foldersId,
      progress: progress,
      status: FormzStatus.pure,
      valueNotifier: valueNotifier,
    ));

    _filesController.getRelationsValueListenable(rootFolder.id).addListener(() {
      _update();
    });

    _loadController.getState.registerObserver(_updateObserver);
    List<Record> allMedia = [];
    // for (int i = 1; i < rootFolder.folders!.length; i++) {
    //   allMedia.addAll(rootFolder.folders![i].records!);
    //   print("all media $allMedia");
    // }
    _syncWithLoadController(allMedia);
    print("all media2 $allMedia");
    updatePageSubscription = eventBusUpdateAlbum.on().listen((event) {
      update();
    });
  }

  Future<void> update() async {
    // var allMediaFolders = await _filesController.getMediaFolders(true);
    // var currentFolder = allMediaFolders
    //     ?.firstWhere((element) => element.id == state.currentFolder.id);
    // User? user = await _userController.getUser;
    // bool progress = true;
    var valueNotifier = _userController.getValueNotifier();
    final foldersId =
        _filesController.getContentFromFolderById(state.currentFolder.id);
    final valueListenable = _filesController
        .getObjectsValueListenableByFolderId(state.currentFolder.id);
    emit(state.copyWith(
      // albums: allMediaFolders,
      // currentFolder: currentFolder,
      // currentFolderRecords: currentFolder?.records?.reversed.toList(),
      // allRecords: currentFolder?.records,
      // user: user,
      // progress: progress,
      //foldersToListen: foldersId,
      objectsValueListenable: valueListenable,
      status: FormzStatus.pure,
      valueNotifier: valueNotifier,
    ));
  }

  @override
  Future<void> close() async {
    _loadController.getState.unregisterObserver(_updateObserver);
    updatePageSubscription?.cancel();
    return super.close();
  }

  void mapSortedFieldChanged(String sortText) {
    var newState = state.copyWith(searchText: sortText);
    emit(newState);
  }

  MediaState _resetSortedList({
    required MediaState state,
  }) {
    return state.copyWith(sortedRecords: state.allRecords);
  }

  void _syncWithLoadController(List<Record> filesInFolder) async {
    // _observers.add(observer);
    // filesInFolder.forEach((fileInFolder) {
    //   var index = loadState.registerObserver(observer)
    //       .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
    //   if (index != -1 &&
    //       !_observers.any((element) =>
    //           element.id == loadState.uploadingFiles[index].localPath)) {
    //     var observer = UploadObserver(
    //       loadState.uploadingFiles[index].localPath,
    //       (p0) {
    //         _uploadListener(loadState.uploadingFiles[index].localPath);
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

  void setFavorite(Record object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      _update();
    }
  }

  Future<void> _update({UploadFileInfo? uploadingFile}) async {
    // await _filesController.updateFilesList();
    final valueListenable = _filesController
        .getObjectsValueListenableByFolderId(state.currentFolder.id);
    var albums = await _filesController.getMediaFolders(true);
    // var updatedChoosedFolder =
    //     albums?.firstWhere((element) => element.id == state.currentFolder.id);
    var newState = state.copyWith(
      objectsValueListenable: valueListenable,
      // albums: albums,
      // currentFolder: updatedChoosedFolder,
      // currentFolderRecords: updatedChoosedFolder?.records?.reversed.toList(),
    );

    emit(newState);

    var isAnyMediaUploding = albums?.any((album) =>
        album.records?.any((record) => record.id == uploadingFile?.id) == true);

    if (uploadingFile != null && isAnyMediaUploding == true) {
      log('MediaCubit -> _update: Downloading file finded');
      List<Folder> newAlbumList = [];
      for (int i = 0; i < albums!.length; i++) {
        var album = albums[i];
        var indexOfUploadingMedia = album.records
            ?.indexWhere((record) => record.id == uploadingFile.id);

        // final uploadingObjectIndexFromLoadState = _loadController
        //     .getState.uploadingFiles
        //     .indexWhere((element) => element.id == uploadingFileId);

        // final uploadingFileFromState = _loadController.getState.currentUploadingFile;

        var isAllreadyLoaded =
            uploadingFile.loadPercent == 100 || uploadingFile.loadPercent == -1;

        // if (uploadingObjectIndexFromLoadState != -1) {
        //   final objectFromLoadState = _loadController
        //       .getState.uploadingFiles[uploadingObjectIndexFromLoadState];

        //   isAllreadyLoaded = objectFromLoadState.uploadPercent == 100 ||
        //       objectFromLoadState.uploadPercent == -1;
        // }

        if (indexOfUploadingMedia != null &&
            indexOfUploadingMedia != -1 &&
            !isAllreadyLoaded) {
          var newRecordsList = album.records!;
          if ((newRecordsList[indexOfUploadingMedia].loadPercent ?? 0) <
              uploadingFile.loadPercent) {
            newRecordsList[indexOfUploadingMedia] =
                newRecordsList[indexOfUploadingMedia].copyWith(
                    loadPercent: uploadingFile.loadPercent.toDouble());
          }
          var newAlbum = album.copyWith(records: newRecordsList);
          print(
              '------------------------------------------------------ ${uploadingFile.loadPercent}');
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

    // if (controllerState.uploadingFiles.isNotEmpty) {
    //   try {
    //     var uploadingFile = controllerState.uploadingFiles
    //         .firstWhere((file) => file.isInProgress);

    //     if (state.albums.any(
    //       (album) =>
    //           album.records!.any((object) => object.id == uploadingFile.id),
    //     )) {
    //       var observer = UploadObserver(uploadingFile.localPath,
    //           (_) => _uploadListener(uploadingFile.localPath));

    //       _observers.add(observer);

    //       _loadController.getState.registerObserver(observer);
    //     }
    //   } catch (e) {
    //     print(
    //         'OpenedFolderCubit: can\'t find any uploading files in folder: ${state.currentFolder.name}');
    //   }
    // }
  }

  void _uploadListener(String pathToFile) async {
    var controllerState = _loadController.getState;

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
    //   var currentFile = controllerState.uploadingFiles.firstWhere(
    //       (element) => element.localPath == pathToFile && element.isInProgress);

    //   if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
    //     // add(FileUpdateFiles(id: currentFile.id));
    //     _update();
    //     print('currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty');
    //     return;
    //   }

    //   if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
    //     print('!currentFile.isInProgress && currentFile.uploadPercent == -1');
    //     return;
    //   }

    //   if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
    //     // print(
    //     //     'file\'s $pathToFile upload percent = ${currentFile.uploadPercent}');
    //     // add(FileChangeUploadPercent(
    //     //   id: currentFile.id,
    //     //   percent: currentFile.uploadPercent.toDouble(),
    //     // ));

    //     _updateUploadPercent(
    //       fileId: currentFile.id,
    //       percent: currentFile.uploadPercent,
    //     );
    //   } else if (currentFile.uploadPercent != -1) {
    //     // add(FileUpdateFiles());
    //     // add(FileChangeUploadPercent(
    //     //   id: currentFile.id,
    //     //   percent: null,
    //     // ));
    //     await _updateUploadPercent(
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

    //     // var connect = await Connectivity().checkConnectivity();

    //     // if (connect == ConnectivityResult.none) {
    //     //   add(FilesNoInternet());
    //     // } else {
    //     //   add(FileUpdateFiles());
    //     // }
    //   }
    // }
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

  Future<void> createAlbum(
    String? name,
  ) async {
    var albumId = _filesController.getMediaRootFolderId();

    if (name != null && albumId != null) {
      final result = await _filesController.createFolder(name, albumId);
      update();
      if (result == ResponseStatus.failed) {
        emit(state.copyWith(status: FormzStatus.submissionCanceled));
        emit(state.copyWith(status: FormzStatus.pure));
      } else if (result == ResponseStatus.noInternet) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } else if (albumId == null) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  Future<void> uploadMediaAction(String? folderId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );
    if (result != null) {
      List<String?> filePaths = result.paths;

      for (int i = 0; i < filePaths.length; i++) {
        if (filePaths[i] != null &&
            PathCheck().isPathCorrect(filePaths[i].toString())) {
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

  Future<void> fileTapped(Record record) async {
    var box = await Hive.openBox(kPathDBName);

    String path = box.get(record.id, defaultValue: '');
    idTappedFile = record.id;
    if (path.isNotEmpty) {
      var appPath = await getDownloadAppFolder();
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

  void _downloadFile(String recordId, [String? path]) async {
    _loadController.downloadFile(fileId: recordId, path: path);
    _setRecordDownloading(recordId: recordId);
  }

  Future<void> onActionDeleteChosen(BaseObject record) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    var result = await _filesController.delete([record]);
    update();
    // print(result);
    // if (result == ResponseStatus.ok) {
    //   _update();
    // } else if (result == ResponseStatus.noInternet) {
    //   emit(state.copyWith(status: FormzStatus.submissionCanceled));
    // } else {
    //   emit(state.copyWith(status: FormzStatus.submissionFailure));
    // }
  }

  Future<ErrorType?> onActionRenameChosen(
      BaseObject object, String newName) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    var result = await _filesController.rename(name: newName, object: object);
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
    MediaState ns;

    if (newFolder.id == '-1') {
      await _filesController.getMediaRootFolder(withUpdate: true);
      final foldersId =
          _filesController.getContentFromFolderById(newFolder.parentFolder!);
      final valueListenable =
          _filesController.getObjectsValueListenableByFolderId('-1');

      ns = state.copyWith(
          currentFolder: newFolder,
          foldersToListen: foldersId,
          objectsValueListenable: valueListenable);
      emit(ns);

      _filesController.getRelationsBoxEventStream('-1')?.listen((event) {
        update();
      });
    } else {
      final valueListenable =
          _filesController.getObjectsValueListenableByFolderId(newFolder.id);
      final foldersId = _filesController.getContentFromFolderById(newFolder.id);
      final folder =
          _filesController.getObjectByIdFromLocalStorage(newFolder.id);

      emit(state.copyWith(
        foldersToListen: [newFolder.id],
        currentFolder: folder as Folder,
        objectsValueListenable: valueListenable,
      ));
      // emit(ns);
      print(state.currentFolder);

      _filesController.getRelationsValueListenable(folder.id).addListener(() {
        update();
      });

      _filesController.updateFolder(folder.id);
    }

    // emit(
    //   state.copyWith(
    //     currentFolder: newFolder,
    //     objectsValueListenable: ,
    //     currentFolderRecords: newFolder.records?.reversed.toList(),
    //     status: FormzStatus.pure,
    //   ),
    // );
  }

  Future<void> saveFile(Record record) async {
    var box = await Hive.openBox(kPathDBName);

    var path = box.get(record.id);

    if (path == null) {
      String? downloadPath = await FilePicker.platform.getDirectoryPath();
      if (downloadPath != null) {
        _downloadFile(record.id, '$downloadPath/');
      }
    } else {
      String downloadFolderPath = await getDownloadAppFolder();
      String fullPath = '${downloadFolderPath}${path}';

      if (await File(fullPath).exists()) {
        String? downloadPath =
            await FilePicker.platform.saveFile(fileName: record.name);

        if (downloadPath != null) {
          File(fullPath).copy(downloadPath);
        }
      } else {
        String? downloadPath = await FilePicker.platform.getDirectoryPath();
        if (downloadPath != null) {
          _downloadFile(record.id, '$downloadPath/');
        }
      }
    }
  }
}
