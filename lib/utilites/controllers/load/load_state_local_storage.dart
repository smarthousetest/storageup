import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:upstorage_desktop/objectbox.g.dart';
import 'package:upstorage_desktop/utilites/controllers/load/models.dart';

@lazySingleton
class LoadStateStorage {
  Box<UploadFileInfo> _uploadBox;
  Box<DownloadFileInfo> _downloadBox;

  LoadStateStorage._(this._uploadBox, this._downloadBox);

  @factoryMethod
  static Future<LoadStateStorage> create() async {
    final store = await openStore();

    final uploadBox = store.box<UploadFileInfo>();
    final downloadBox = store.box<DownloadFileInfo>();

    return LoadStateStorage._(uploadBox, downloadBox);
  }

  void changeUpload(List<UploadFileInfo> uploadFilesInfo) async {
    _uploadBox.putMany(uploadFilesInfo);
    // print('files from objectsBox:' + _uploadBox.getAll().toString());
  }

  List<UploadFileInfo> getFilesToUpload() {
    final query = _uploadBox
        .query(UploadFileInfo_.isInProgress.equals(false) &
            UploadFileInfo_.auto.equals(false))
        .build();
    final res = query.find();
    query.close();
    return res;
  }

  // List<UploadFileInfo> getFilesToAutoupload() {
  //   return _uploadBox.query(UploadFileInfo_.auto.equals(true)).build().find();
  // }

  // void removeAutouploadingFiles() {
  //   final allAutouploadeingFilesIds = _uploadBox
  //       .query(UploadFileInfo_.auto.equals(true))
  //       .build()
  //       .find()
  //       .map((e) => e.dbID)
  //       .toList(growable: false);

  //   _uploadBox.removeMany(allAutouploadeingFilesIds);
  // }

  UploadFileInfo? getUploadingFile() {
    final query =
        _uploadBox.query(UploadFileInfo_.isInProgress.equals(true)).build();
    final res = query.findFirst();
    query.close();
    return res;
  }

  void removeUploadingFile(UploadFileInfo fileInfo) {
    try {
      _uploadBox.remove(fileInfo.dbID);
    } catch (e) {
      log(e.toString());
    }
  }

  void clearUploadingFiles() {
    _uploadBox.removeAll();
  }

  void changeDownload(List<DownloadFileInfo> downloadFileInfo) async {
    _downloadBox.putMany(downloadFileInfo);
  }

  List<DownloadFileInfo> getFilesToDownload() {
    final query = _downloadBox
        .query(DownloadFileInfo_.isInProgress.equals(false))
        .build();
    final res = query.find();
    query.close();
    return res;
  }

  DownloadFileInfo? getDownloadingFile() {
    final query =
        _downloadBox.query(DownloadFileInfo_.isInProgress.equals(true)).build();
    final res = query.findFirst();
    query.close();
    return res;
  }

  void removeDownloadingFile(DownloadFileInfo fileInfo) {
    _downloadBox.remove(fileInfo.dbID);
  }

  void clearDownloading() {
    _downloadBox.removeAll();
  }

  void cleanAll() {
    _downloadBox.removeAll();
    _uploadBox.removeAll();
  }
}
