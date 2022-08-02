import 'dart:developer';

import 'package:cpp_native/controllers/load/models.dart';
import 'package:cpp_native/controllers/load/observable_utils.dart';
import 'package:cpp_native/interfaces/load_interfaces.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/utilities/errors.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/file_repository.dart';
import 'package:storageup/utilities/repositories/media_repository.dart';
import 'package:storageup/utilities/repositories/storage_files.dart';
import 'package:storageup/utilities/services/files_service.dart';

class FilesController extends FilesObservable<Error>
    implements IFilesController {
  MediaRepository _mediaRepo =
      getIt<MediaRepository>(instanceName: 'media_repo');
  FilesRepository _filesRepo =
      getIt<FilesRepository>(instanceName: 'files_repo');

  FilesService _service = getIt<FilesService>();
  S translate = getIt<S>();

  @disposeMethod
  void dispose() {
    // BehaviorSubject();
    // _errorsStream.close();
  }

  FilesController(LocalStorage localStorage) : _localStorage = localStorage;

  LocalStorage _localStorage;

  Future<List<BaseObject>?> getFiles() async {
    if (!_filesRepo.isInitilizated()) {
      await updateFilesList();
    }

    return _filesRepo.getFiles;
  }

  Folder? get getRootFolderForMove => _filesRepo.getRootFolder;

  Future<Folder?> get getRootFolder => _service.getRootFolder();

  Future<Folder?> getFolderByIdForMove(String id) async {
    return _service.getFolderById(id);
  }

  Future<List<Folder>?> getMediaFolders(bool withUpdate) async {
    if (withUpdate) {
      await updateFilesList();
    }

    var mediaFolders = _mediaRepo.getMedia();
    List<Folder> mo = [];

    mediaFolders?.forEach((element) {
      if (element is Folder) {
        mo.add(element);
      }
    });

    return mo;
  }

  void clearAll() {
    _filesRepo.setFiles(null);
    _mediaRepo.setMedia(null);
  }

  Future<ResponseStatus> setFavorite(BaseObject object, bool isFavorite) {
    if (object is Folder)
      return _service.setFolderFavorite(object.id, isFavorite);
    else
      return _service.setRecordFavorite(object.id, isFavorite);
  }

  Future<ResponseStatus> setRecentFile(BaseObject object, DateTime time) {
    return _service.setRecentFile(object.id, time);
  }

  Future<Folder?> getAlbum(String id) async {
    var folders = _mediaRepo.getMedia();
    Folder? choosedFolder =
        folders?.firstWhere((element) => element.id == id) as Folder;

    return choosedFolder;
  }

  Future<List<BaseObject>?> getDeletedFiles() async {
    return _filesRepo.getFiles;
  }

  Future<List<Record>?> getRecentFiles() {
    return _service.getRecentsRecords();
  }

  List<String>? getContentFromFolderById(String folderId) {
    return _localStorage.getObjectsIdsFromFolder(folderId);
  }

  Future<ResponseStatus> moveContentToFolder(
    String folderId,
    List<String> files,
  ) {
    return _service.moveContentToFolder(folderId, files);
  }

  Future<ResponseStatus> deleteFiles(List<BaseObject> files) async {
    List<String> ids = [];

    files.forEach((element) {
      ids.add(element.id);
    });

    var response = await _service.deleteRecords(ids);

    if (response == ResponseStatus.ok) {
      await updateFilesList();
    }

    return response ?? ResponseStatus.failed;
  }

  Future<void> updateFilesList() async {
    var mediaFolder = await _service.getRootMediaFolder();
    var filesFolder = await _service.getRootFilesFolder();

    // var mediaFolder = await _service.getFolderById(mediaFolderId!.id);
    // var filesFolder = await _service.getFolderById(filesFolderId!.id);

    _filesRepo.setRootFolder = filesFolder;
    _mediaRepo.setMediaRootFolder = mediaFolder;

    _mediaRepo.mediaRootFolderId = mediaFolder?.id;

    List<BaseObject> files = [];
    List<BaseObject> media = [];
    if (filesFolder != null) {
      files.addAll(filesFolder.folders ?? []);
      files.addAll(filesFolder.records ?? []);
    }
    if (mediaFolder != null) {
      media.addAll(mediaFolder.folders ?? []);
      await _prepareMediaFolders(mediaFolder);
    }

    _filesRepo.setFiles(files);
  }

  String? getMediaRootFolderId() {
    return _mediaRepo.mediaRootFolderId;
  }

  // Future<String?> createRecord(File file) {
  //   return _service.createRecord(file);
  // }

  Future<ResponseStatus> createFolder(
      String name, String? parentFolderId) async {
    final createdFolder = await _service.createFolder(name, parentFolderId);

    if (createdFolder.right != null) {
      _localStorage.addFolder(folder: createdFolder.right!);
      return ResponseStatus.ok;
    } else {
      return ResponseStatus.failed;
    }
  }

  @override
  Future<void> updateObject(FileInfo object) async {
    if (object.endedWithException && object.needToShowPopup) {
      _handleError(object);
    }
    if (object.id.isNotEmpty) {
      final localObject = _localStorage.getObjectsBox.get(object.id);

      if (localObject != null) {
        if (localObject is Record) {
          _updateRecord(localObject, object);
        }
      } else if (object.isInProgress) {
        final recordOrError = await _service.getRecordById(object.id);

        if (!recordOrError.isLeft() && recordOrError.right != null) {
          _localStorage.setObject(recordOrError.right!);

          _updateRecord(recordOrError.right!, object);
        }
      }
    }
    //  else if (object is UploadFileInfo &&
    //     object.id.isEmpty &&
    //     object.folderId != null &&
    //     object.folderId!.isNotEmpty &&
    //     (!object.isFinished || !object.endedWithException) &&
    //     object.isInProgress &&
    //     object.loadPercent == -1) {
    //   // _localStorage.setShimmerToFolder(object.folderId!);
    // }
  }

  @override
  void setObject(BaseObject object) {
    _localStorage.setObject(object);
  }
}

extension ValueListenableExtension on FilesController {
  ValueNotifier<Folder?> getFilesValueNotifier() => _filesRepo.getValueNotifier;

  ValueNotifier<Folder?> getMediaValueNotifier() => _mediaRepo.getValueNotifier;

  ValueListenable<Box<BaseObject>> getObjectsValueListenable(
    List<String>? objectsToListen,
  ) {
    return _localStorage.getObjectsBoxListenable(objectsToListen);
  }

  ValueListenable<Box<List<String>>> getRelationsValueListenable(
    String folderId,
  ) {
    return _localStorage.getRelationsBoxListenable(folderId);
  }

  ValueListenable<Box<BaseObject>> getObjectsValueListenableByFolderId(
    String folderId,
  ) {
    List<String>? objectsIdsToListen = [shimmerKey];
    final objectsIdsFromFolder =
        _localStorage.getObjectsIdsFromFolder(folderId);
    objectsIdsToListen
        .addAll(objectsIdsFromFolder == null ? [] : objectsIdsFromFolder);

    return _localStorage.getObjectsBoxListenable(objectsIdsToListen);
  }

  Stream<BoxEvent>? getObjectsBoxEventStream(String? key) {
    return _localStorage.getObjectsBoxEventStream(key);
  }

  Stream<BoxEvent>? getRelationsBoxEventStream(String? key) {
    if (key == '-1') return _getMediaAllFolder();

    return _localStorage.getRelationsBoxEventSteam(key);
  }

  Stream<BoxEvent>? _getMediaAllFolder() {
    final mediaRootFolderId =
        _localStorage.getObjectsIdsFromFolder(mediaRootFolderKey);
    if (mediaRootFolderId != null) {
      final mediaFoldersIds =
          _localStorage.getObjectsIdsFromFolder(mediaRootFolderId[0]);

      if (mediaFoldersIds != null) {
        List<Stream<BoxEvent>> streams = [];

        for (var mediaFolderId in mediaFoldersIds) {
          streams.add(_localStorage.getRelationsBoxEventSteam(mediaFolderId));
        }

        return MergeStream(streams);
      }

      return null;
    }

    return null;
  }
}

extension RootFolders on FilesController {
  Future<Folder?> getFilesRootFolder({bool withUpdate = true}) async {
    final filesRootFolderId = _localStorage.getRootFolderId(filesRootFolderKey);

    if (filesRootFolderId != null) {
      final folder = _localStorage.getObject(filesRootFolderId);

      if (folder != null) {
        if (withUpdate) updateFolder(filesRootFolderId);

        return folder as Folder;
      } else {
        return _requestFilesRootFolder();
      }
    } else {
      return _requestFilesRootFolder();
    }
  }

  Future<Folder?> _requestFilesRootFolder() async {
    final rootFolder = await _service.getRootFolder();

    if (rootFolder != null) {
      var filesFolder =
          rootFolder.folders?.firstWhere((element) => element.name == 'Files');

      var updatedFilesFolder = await _service.getFolderById(filesFolder!.id);
      if (updatedFilesFolder != null) {
        _localStorage.addFolder(
          folder: updatedFilesFolder,
          rootKey: filesRootFolderKey,
        );

        return updatedFilesFolder;
      }
    }

    return null;
  }

  Future<Folder?> getMediaRootFolder({bool withUpdate = true}) async {
    final mediaRootFolderId = _localStorage.getRootFolderId(mediaRootFolderKey);

    if (withUpdate) _requestMediaRootFolder();

    if (mediaRootFolderId != null) {
      final folder = _localStorage.getObject(mediaRootFolderId);

      if (folder != null && folder is Folder) {
        return folder;
      } else {
        return _requestMediaRootFolder();
      }
    } else {
      return _requestMediaRootFolder();
    }
  }

  Future<Folder?> _requestMediaRootFolder() async {
    final rootFolder = await _service.getRootFolder();

    if (rootFolder != null) {
      var mediaFolder =
          rootFolder.folders?.firstWhere((element) => element.name == 'Media');

      var updatedFilesFolder = await _service.getFolderById(mediaFolder!.id);
      if (updatedFilesFolder != null) {
        final folders = await _prepareMediaFolders(updatedFilesFolder);

        _localStorage.addFolder(
          folder: updatedFilesFolder.copyWith(folders: folders),
          rootKey: mediaRootFolderKey,
        );

        return updatedFilesFolder;
      }
    }

    return null;
  }

  Future<List<Folder>> _prepareMediaFolders(Folder folder) async {
    Folder all = Folder(
      size: 0,
      id: '-1',
      parentFolder: folder.id,
      name: translate.all,
      records: [],
      assetImage: 'assets/media_page/all_media.svg',
      readOnly: true,
    );
    var folders = folder.folders ?? [];
    for (int i = 0; i < folders.length; i++) {
      var folder = await getFolderById(folders[i].id); // element as Folder?;
      if (folder?.name == 'Photo') {
        folder?.name = translate.photos;
        folder?.assetImage = 'assets/media_page/photo.svg';
      } else if (folder?.name == 'Video') {
        folder?.name = translate.video;
        folder?.assetImage = 'assets/media_page/video.svg';
      }
      folders[i] = folder!;
      all.records?.addAll(folder.records ?? []);
    }
    folders.insert(0, all);

    return folders;
  }
}

extension CRUD on FilesController {
  Future<Folder?> getFolderById(String id, {bool withUpdate = true}) async {
    final folder = _localStorage.getObject(id);

    if (folder == null) {
      final result = await updateFolder(id);

      if (result) {
        return _localStorage.getObject(id) as Folder;
      }

      return null;
    } else {
      if (withUpdate) updateFolder(id);

      return folder as Folder;
    }
  }

  List<String>? getReferencesById(String id) {
    return _localStorage.getReferencesById(id);
  }

  BaseObject? getObjectByIdFromLocalStorage(String id) {
    return _localStorage.getObject(id);
  }

  List<BaseObject> getObjectsWhere(bool Function(BaseObject) test) {
    return _localStorage.getObjectsWhere(test);
  }

  // Future<void> moveContentToFolder(
  //   String folderId,
  //   List<String> files,
  // ) async {
  //   final result = await _service.moveContentToFolder(folderId, files);

  //   if (result == ResponseStatus.ok) {
  //     _localStorage.moveContentToFolder(folderId, files);
  //   } else
  //     throw ServerError();
  // }

  Future<bool> updateFolder(String fodlerId) async {
    final folder = await _service.getFolderById(fodlerId);
    if (folder != null) {
      if (folder.readOnly ?? false) {
        if (folder.name == 'Photo') {
          folder.name = translate.photos;
          folder.assetImage = 'assets/media_page/photo.svg';
        } else if (folder.name == 'Video') {
          folder.name = translate.video;
          folder.assetImage = 'assets/media_page/video.svg';
        }
      }

      _localStorage.addFolder(folder: folder);

      return true;
    } else {
      return false;
    }
  }

  Future<void> delete(List<BaseObject> objects) async {
    for (var object in objects) {
      if (object is Folder) {
        await _deleteFolder(object);
      } else if (object is Record) {
        await _deleteRecord(object);
      }
    }
  }

  void setRecord(Record record) {
    _localStorage.setObject(record);
  }

  Future<void> _deleteRecord(Record record) async {
    final result = await _service.deleteRecords([record.id]);

    if (result == ResponseStatus.ok) {
      _localStorage.deleteRecord(record);
    } else
      throw ServerError();
  }

  Future<void> _deleteFolder(Folder folder) async {
    final result = await _service.deleteFolder(folder.id);

    if (result == ResponseStatus.ok) {
      _localStorage.deleteFolder(folder);
    } else
      throw ServerError();
  }

  Future<ResponseStatus> rename({
    required String name,
    required BaseObject object,
  }) async {
    if (object is Folder) {
      final result = await _renameFolder(name: name, object: object);
      return result;
    } else if (object is Record) {
      final result = await _renameRecord(name: name, object: object);
      return result;
    } else {
      return ResponseStatus.declined;
    }
  }

  Future<ResponseStatus> _renameRecord({
    required String name,
    required BaseObject object,
  }) async {
    final result = await _service.renameRecord(name, object.id);

    if (result.right != null) {
      _localStorage.setObject(result.right!);
      return ResponseStatus.ok;
    } else if (result.left == 403) {
      return ResponseStatus.notExecuted;
    } else if (result.left == 401 ||
        result.left == 429 ||
        result.left == 500 ||
        result.left == 502 ||
        result.left == 504) {
      return ResponseStatus.failed;
    } else {
      return ResponseStatus.declined;
    }
  }

  Future<ResponseStatus> _renameFolder({
    required String name,
    required BaseObject object,
  }) async {
    final result = await _service.renameFolder(name, object.id);

    if (result.right != null) {
      _localStorage.addFolder(folder: result.right!);
      return ResponseStatus.ok;
    } else if (result.left == 403) {
      return ResponseStatus.notExecuted;
    } else if (result.left == 401 ||
        result.left == 429 ||
        result.left == 500 ||
        result.left == 502 ||
        result.left == 504) {
      return ResponseStatus.failed;
    } else {
      return ResponseStatus.declined;
    }
  }

  void setSelected(String id) {
    final object = _localStorage.getObject(id);
    log('${object?.id} ${object?.isChoosed} ${object?.parentFolder}');
    if (object != null) {
      if (object is Record) {
        _localStorage.setObject(object.copyWith(isChoosed: !object.isChoosed));
      } else if (object is Folder) {
        _localStorage.setObject(object.copyWith(isChoosed: !object.isChoosed));
      }

      print(_localStorage.getObject(id)?.isChoosed);
    }
  }

  Future<void> discardSelecting() async {
    log('discard selecting is in progress');
    final objects = _localStorage.getObjectsWhere((object) => object.isChoosed);

    objects.forEach((object) async {
      setSelected(object.id);
    });
  }

  Future<void> deleteChoosed() async {
    final objects = _localStorage.getObjectsWhere((object) => object.isChoosed);

    await delete(objects);
  }

  Future<void> moveToFolder({
    required String folderId,
    List<String>? records,
    List<String>? folders,
  }) async {
    final result = await _service.moveToFolder(
      folderId: folderId,
      folders: folders,
      records: records,
    );

    if (result == ResponseStatus.ok) {
      List<String> objectsIds = [];

      if (records != null) objectsIds.addAll(records);
      if (folders != null) objectsIds.addAll(folders);

      _localStorage.moveContentToFolder(folderId, objectsIds);
    } else
      throw ServerError();
  }

  Future<void> setFavorite(BaseObject object, bool isFavorite) async {
    if (object is Folder)
      return _setFolderFavorite(object, isFavorite);
    else
      return _setRecordFavorite(object as Record, isFavorite);
  }

  Future<void> _setRecordFavorite(Record record, bool isFavorite) async {
    final response = await _service.setRecordFavorite(record.id, isFavorite);

    if (response == ResponseStatus.ok) {
      final updatedRecord = record.copyWith(favorite: isFavorite);

      _localStorage.setObject(updatedRecord);
    } else {
      throw ServerError();
    }
  }

  Future<void> _setFolderFavorite(Folder folder, bool isFavorite) async {
    final response = await _service.setFolderFavorite(folder.id, isFavorite);

    if (response == ResponseStatus.ok) {
      final updatedRecord = folder.copyWith(favorite: isFavorite);

      _localStorage.setObject(updatedRecord);
    } else {
      throw ServerError();
    }
  }
}

extension LoadFunctions on FilesController {
  void _updateRecord(Record record, FileInfo info) async {
    final loadPercent = info.loadPercent != 100 && info.loadPercent != -1
        ? info.loadPercent.toDouble()
        : null;

    final path = info.loadPercent == 100
        ? info.localPath.split('/').last
        : info.localPath;

    final updatedRecord = record.copyWith(
      copiedToAppFolder: info.copiedToAppFolder,
      endedWithException: info.endedWithException,
      path: path,
      loadPercent: info.endedWithException ? null : loadPercent,
    );

    _localStorage.setObject(updatedRecord);

    // if (info is UploadFileInfo &&
    //     info.folderId != null &&
    //     info.folderId!.isNotEmpty) {
    //   _localStorage.removeShimmerFromFolderIfNecessary(info.folderId!);
    // }
  }

  void _handleError(FileInfo info) {
    notifyObservers(LoadError(reason: info.errorReason));

    if (info.id.isNotEmpty && info is UploadFileInfo) {
      _localStorage.deleteObjectById(info.id);
    }
    // else if ((info is UploadFileInfo) &&
    //     info.folderId != null &&
    //     info.folderId!.isNotEmpty) {
    //   _localStorage.removeShimmerFromFolderIfNecessary(info.folderId!);
    // }
  }

  Future<void> clearLocalDatabase() async {
    await _localStorage.clearAll();
  }

  Future<void> initDatabase() async {
    await _localStorage.init();
  }
}
