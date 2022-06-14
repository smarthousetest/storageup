import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upstorage_desktop/main.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/upload_state.dart';
import 'package:upstorage_desktop/utilites/autoupload/upload_media_repository.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/utilites/controllers/load/load_controller.dart';

@lazySingleton
class AutouploadController {
  UploadMediaRepo _repo;

  bool _isInProgress = false;
  bool _needToStop = false;
  Function()? _afterStopAction;
  List<int> _unUploadedMediaIds = [];

  @factoryMethod
  static Future<AutouploadController> init() async {
    var repo = await UploadMediaRepo().init();
    return AutouploadController._(repo);
  }

  AutouploadController._(this._repo);

  bool get isInProgress => _isInProgress;
  void setNeedStop(Function() afterStopAction) {
    if (!_needToStop) {
      _afterStopAction = afterStopAction;
      _needToStop = true;
    }
  }

  Stream<BoxEvent> listen(dynamic key) {
    if (key != null) {
      return _repo.listenByKey(key);
    } else {
      return _repo.listen();
    }
  }

  Future<List<int>?> _getUnuploadedFilesIndexes() async {
    List<int> indexToUpload = [];
    var savedIds = _repo.getAllDB();
    for (var uploadMedia in savedIds.entries) {
      if (uploadMedia.value.state != AutouploadState.endedWithoutException) {
        indexToUpload.add(uploadMedia.key);
      }
    }

    if (indexToUpload.isEmpty) return null;

    return indexToUpload;
  }

  Future<bool> isAllMediaLoaded() async {
    var ids = await _getUnuploadedFilesIndexes();

    return ids?.isEmpty == null ? true : false;
  }

  Future<void> syncMedia() async {
    var idsFromDevice =
        await MyApp.platformMedia.invokeListMethod<String>('getListOfPhotos');

    if (idsFromDevice == null || idsFromDevice.isEmpty) return;

    var db = _repo.getAllDB();

    idsFromDevice.forEach((id) {
      if (!db.values.any((element) => element.nativeStorageId == id)) {
        _repo.addMedia(id);
      }
    });

    db.values.forEach((element) async {
      if (!idsFromDevice.contains(element.nativeStorageId)) {
        db.forEach((key, value) async {
          if (value.nativeStorageId == element.nativeStorageId)
            await _repo.deleteKey(key);
        });
      }
    });
  }

  Future<String?> copyMediaToAppFolder(String id) async {
    String? filePath;

    filePath = await MyApp.platformMedia.invokeMethod(
      'copyMediaToAppFolder',
      {
        'id': id,
      },
    );

    return filePath;
  }

  Map getAllMediaList() {
    return _repo.getAllDB();
  }

  void clearBox() async {
    await _repo.clearDB();
  }

  void startAutoupload(String token) async {
    if (_isInProgress) return;

    _needToStop = false;
    _isInProgress = true;
    var req = await Permission.photos.request();
    print(req);
    if (req.isGranted) {
      await syncMedia();

      _unUploadedMediaIds = await _getUnuploadedFilesIndexes() ?? [];

      if (_unUploadedMediaIds.isEmpty) {
        _isInProgress = false;
        _afterStopAction?.call();
        return;
      }

      _uploadMedia(0, token);
    }
  }

  void _uploadMedia(int i, String token) async {
    if (_needToStop) {
      _isInProgress = false;
      _afterStopAction?.call();
      return;
    }

    var isAllMediaUploaded = await isAllMediaLoaded();

    if (isAllMediaUploaded) {
      _isInProgress = false;
      return;
    }

    try {
      var prefs = await SharedPreferences.getInstance();
      var isEnabled = prefs.getBool(kIsAutouploadEnabled);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      var native = CppNative(documentsFolder: appDocDir);
      if (i == _unUploadedMediaIds.length || isEnabled != true) return;

      var uploadMedia = _repo.getUploadMedia(_unUploadedMediaIds[i]);
      if (uploadMedia != null) {
        var filePath = await copyMediaToAppFolder(uploadMedia.nativeStorageId);
        if (filePath != null) {
          print(
              "-------------------------------------------- new file sending, path: $filePath");
          _repo.update(_unUploadedMediaIds[i],
              uploadMedia.copyWith(localPath: filePath));
          native.send(
            filePath: filePath,
            bearerToken: token,
            callback: (value) async {
              print(value);
              _processCallback(
                value: value,
                i: i,
                token: token,
                filePath: filePath,
              );
            },
          );
        }
      } else {
        _uploadMedia(i + 1, token);
      }
    } catch (e) {
      print(e);
      _uploadMedia(i + 1, token);
    }
  }

  Future<void> _processCallback({
    required dynamic value,
    required int i,
    required String token,
    required String filePath,
  }) async {
    var uploadMedia = _repo.getUploadMedia(_unUploadedMediaIds[i]);
    if (value is String) {
      await copyFileToDownloadDir(filePath: filePath, fileId: value);
      _repo.update(
        _unUploadedMediaIds[i],
        uploadMedia!.copyWith(
          serverId: value,
          state: AutouploadState.inProgress,
          uploadPercent: 0,
        ),
      );
    } else if (value is int) {
      if (value < 0) {
        _repo.update(
          _unUploadedMediaIds[i],
          uploadMedia!.copyWith(
            state: AutouploadState.endedWithException,
            uploadPercent: null,
          ),
        );
        await File(filePath).delete();
        _uploadMedia(i + 1, token);
      } else if (value == 100) {
        _repo.update(
          _unUploadedMediaIds[i],
          uploadMedia!.copyWith(
            state: AutouploadState.endedWithoutException,
            uploadPercent: 100,
          ),
        );
        // await File(filePath).delete();
        _uploadMedia(i + 1, token);
      } else {
        _repo.update(
          _unUploadedMediaIds[i],
          uploadMedia!.copyWith(
            state: AutouploadState.inProgress,
            uploadPercent: value,
          ),
        );
      }
    }
  }
}
