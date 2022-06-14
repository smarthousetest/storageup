import 'dart:io';

import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/controllers/load/models.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/file_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/media_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/storage_files.dart';
import 'package:upstorage_desktop/utilites/services/files_service.dart';

class FilesController {
  MediaRepository _mediaRepo =
      getIt<MediaRepository>(instanceName: 'media_repo');
  FilesRepository _filesRepo =
      getIt<FilesRepository>(instanceName: 'files_repo');

  FilesService _service = getIt<FilesService>();
  S translate = getIt<S>();

  Future<List<BaseObject>?> getFiles() async {
    if (!_filesRepo.isInitilizated()) {
      await updateFilesList();
    }

    return _filesRepo.getFiles;
  }

  Folder? get getFilesRootFolder => _filesRepo.getRootFolder;

  Future<Folder?> get getRootFolder => _service.getRootFolder();

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

  Future<ResponseStatus> renameFolder(String newName, String folderId) {
    return _service.renameFolder(newName, folderId);
  }

  Future<ResponseStatus> renameRecord(String newName, String recordId) {
    return _service.renameRecord(newName, recordId);
  }

  Future<List<BaseObject>?> getDeletedFiles() async {
    return _filesRepo.getFiles;
  }

  Future<ResponseStatus> deleteFolder(String id) {
    return _service.deleteFolder(id);
  }

  Future<List<Record>?> getRecentFiles() {
    return _service.getRecentsRecords();
  }

  Future<Folder?> getFolderById(String id) async {
    return _service.getFolderById(id);
  }

  Future<List<BaseObject>> getContentFromFolderById(String folderId) async {
    var folder = await _service.getFolderById(folderId);
    List<BaseObject> content = [];

    content.addAll(folder?.records ?? []);
    content.addAll(folder?.folders ?? []);

    return content;
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
    var rootFolder = await _service.getRootFolder();

    var mediaFolderId = rootFolder?.folders
        ?.firstWhere((element) => element.name == 'Media'); //[0].id;
    var filesFolderId =
        rootFolder?.folders?.firstWhere((element) => element.name == 'Files');

    var mediaFolder = await _service.getFolderById(mediaFolderId!.id);
    var filesFolder = await _service.getFolderById(filesFolderId!.id);

    _filesRepo.setRootFolder = filesFolder;

    _mediaRepo.mediaRootFolderId = mediaFolderId.id;

    List<BaseObject> files = [];
    List<BaseObject> media = [];
    if (filesFolder != null) {
      files.addAll(filesFolder.folders ?? []);
      files.addAll(filesFolder.records ?? []);
    }
    if (mediaFolder != null) {
      media.addAll(mediaFolder.folders ?? []);
    }

    _filesRepo.setFiles(files);
    await _prepareMediaFolders(media);
  }

  Future<ResponseStatus> deleteObjects(List<BaseObject> objects) async {
    List<String>? foldersIds;
    List<String>? recordsIds;

    for (var i = 0; i < objects.length; i++) {
      if (objects[i] is Record) {
        if (recordsIds == null) recordsIds = [];

        recordsIds.add(objects[i].id);
      } else if (objects[i] is Folder) {
        if (foldersIds == null) foldersIds = [];

        foldersIds.add(objects[i].id);
      }
    }

    ResponseStatus? recordsResult;
    if (recordsIds != null) {
      recordsResult = await _service.deleteRecords(recordsIds);
    }

    ResponseStatus? foldersResult;
    if (foldersIds != null) {
      foldersResult = await _service.deleteFolders(foldersIds);
    }

    if (foldersResult == null && recordsResult != null) {
      return recordsResult;
    } else if (foldersResult != null && recordsResult == null) {
      return foldersResult;
    } else {
      if (recordsResult == ResponseStatus.ok &&
          foldersResult == ResponseStatus.ok) {
        return ResponseStatus.ok;
      } else if (recordsResult == ResponseStatus.noInternet &&
          foldersResult == ResponseStatus.noInternet) {
        return ResponseStatus.noInternet;
      } else {
        return ResponseStatus.failed;
      }
      // return recordsResult == ResponseStatus.ok &&
      //         foldersResult == ResponseStatus.ok
      //     ? ResponseStatus.ok
      //     : ResponseStatus.failed;
    }
  }

  String? getMediaRootFolderId() {
    return _mediaRepo.mediaRootFolderId;
  }

  Future<String?> createRecord(File file) {
    return _service.createRecord(file);
  }

  Future<ResponseStatus> createFolder(String name, String? parentFolderId) {
    return _service.createFolder(name, parentFolderId);
  }

  Future<ResponseStatus> moveToFolder(
      {required String folderId,
      List<String>? records,
      List<String>? folders}) {
    return _service.moveToFolder(
      folderId: folderId,
      folders: folders,
      records: records,
    );
  }

  Future<void> _prepareMediaFolders(List<BaseObject> folders) async {
    Folder all = Folder(
      size: 0,
      id: '-1',
      name: translate.all,
      records: [],
      assetImage: 'assets/media_page/all_media.svg',
      readOnly: true,
    );

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

    _mediaRepo.setMedia(folders);
  }
}
