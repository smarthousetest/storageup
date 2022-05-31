import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upstorage_desktop/pages/files/file_bloc.dart';
import 'package:upstorage_desktop/utilites/autoupload/autoupload_controller.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/upload_media.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/upload_state.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

import 'package:upstorage_desktop/constants.dart';
import '../injection.dart';

class LoadController {
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  AutouploadController? _autouploadController;

  _LoadState _state = _LoadState();

  late CppNative _cpp;

  _LoadState get getState => _state;

  LoadController() {
    // init();
  }

  bool isNotInited() {
    return _autouploadController == null;
  }

  Function(String)? _onAddAutouploadingFile;

  set setAutouploadNextFileListener(Function(String) callback) =>
      _onAddAutouploadingFile = callback;
  void clearAutouploadNextFileCallback() => _onAddAutouploadingFile = null;

  Future<void> init() async {
    print('initializing load controller');
    _autouploadController =
        await GetIt.instance.getAsync<AutouploadController>();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _cpp = await getInstanceCppNative(
        documentsFolder: appDocDir, baseUrl: kServerUrl.split('/').last);
    _autouploadController?.listen(null).listen((event) async {
      try {
        var uploadMedia = event.value as UploadMedia;
        if (uploadMedia.serverId == null) return;

        var mediaFromState = _state.uploadingFiles;

        print('upload media local path is ${uploadMedia.localPath}');

        if (mediaFromState
            .any((element) => element.id == uploadMedia.serverId)) {
          var listenableMedia = mediaFromState
              .firstWhere((element) => element.id == uploadMedia.serverId);

          listenableMedia
            ..localPath = uploadMedia.localPath ?? ''
            ..isInProgress = uploadMedia.state == AutouploadState.inProgress
            ..uploadPercent = uploadMedia.uploadPercent ?? -1;

          _state.changeUploadingFiles(mediaFromState);
        } else {
          var newListenableMedia = UploadFileInfo(
            localPath: uploadMedia.localPath ?? '',
            folderId: '',
            id: uploadMedia.serverId ?? '',
            auto: true,
            isInProgress: uploadMedia.state == AutouploadState.inProgress,
            uploadPercent: uploadMedia.uploadPercent ?? -1,
          );

          mediaFromState.add(newListenableMedia);
          _onAddAutouploadingFile?.call(uploadMedia.serverId ?? '');
          print('invoke autouploading file callback');
          _state.changeUploadingFiles(mediaFromState);
        }
      } catch (e, st) {
        print('$e, $st');
      }
    });
  }

  Future<void> uploadFile({
    String? filePath,
    String? folderId,
    bool force = false,
  }) async {
    if (isNotInited()) {
      await init();
    }
    var uploadingFiles = _state.uploadingFiles;
    UploadFileInfo obj;
    if (filePath == null) {
      obj = uploadingFiles.firstWhere(
        (element) =>
            element.isInProgress == false &&
            element.uploadPercent != 100 &&
            !element.auto &&
            !element.endedWithException,
      );
    } else {
      obj = UploadFileInfo(localPath: filePath, folderId: folderId);
    }

    print('start processing file: $filePath');
    print(!force &&
        _state.uploadingFiles.isNotEmpty &&
        _state.uploadingFiles.any((element) => element.isInProgress));
    print(!_state.uploadingFiles.contains(obj));

    if (!force &&
        _state.uploadingFiles.isNotEmpty &&
        _state.uploadingFiles.any((element) => element.isInProgress)) {
      print('file $filePath will be added to list and loaded');
      uploadingFiles.add(obj);
      _state.changeUploadingFiles(uploadingFiles);
      print('count of uploading files: ${_state.uploadingFiles.length}');
      return;
    } else if (!_state.uploadingFiles.contains(obj)) {
      obj.isInProgress = true;
      uploadingFiles.add(obj);
      _state.changeUploadingFiles(uploadingFiles);
    } else {
      final uploadingFileIndex = _state.uploadingFiles.indexOf(obj);
      if (uploadingFileIndex != -1) {
        obj.isInProgress = true;
        uploadingFiles[uploadingFileIndex] = obj;
        _state.changeUploadingFiles(uploadingFiles);
      }
    }
    if (_autouploadController == null) {
      _autouploadController =
          await GetIt.instance.getAsync<AutouploadController>();
    }

    if (_autouploadController?.isInProgress == true) {
      _autouploadController?.setNeedStop(() {
        uploadFile(force: true);
      });
      print('file will be sended after autoupload continued');
      return;
    }
    print('start sending file $filePath');
    var token = await _tokenRepository.getApiToken();
    var file = File(obj.localPath);
    print('file existing is ${file.existsSync()}');
    if (token != null && token.isNotEmpty) {
      _cpp.send(
        filePath: obj.localPath,
        callback: (value) {
          _processUploadCallback(value, obj.localPath, null);
        },
        bearerToken: token,
        folderId: obj.folderId,
      );
    }
  }

  void _processUploadCallback(
    dynamic value,
    String filePath,
    String? fileId,
  ) async {
    print('--------------------------------------- $value');
    try {
      if (fileId == null) fileId = '-1';
      var uploadingFiles = List<UploadFileInfo>.from(_state.uploadingFiles);

      var element = uploadingFiles.firstWhere((element) =>
          (element.localPath == filePath &&
              (element.isInProgress || element.uploadPercent != 100)) ||
          element.id == fileId);
      if (value is SendProgress) {
        final uploadingPercent = value.percent;
        if (uploadingPercent != 100) {
          element.uploadPercent = uploadingPercent;
          element.id = value.recordId;
          _state.changeUploadingFiles(uploadingFiles);
        } else {
          element.uploadPercent = 100;

          _state.changeUploadingFiles(uploadingFiles);

          element.isInProgress = false;
          _state.changeUploadingFiles(uploadingFiles);

          _processNextFileUpload();
        }
      } else if (value is CustomError) {
        var nf = element.copyWith(
          isInProgress: false,
          uploadPercent: -1,
          endedWithException: true,
          errorReason: value.errorReason,
        );

        var ind = uploadingFiles.indexOf(element);
        uploadingFiles[ind] = nf;

        _state.changeUploadingFiles(uploadingFiles);
        _processNextFileUpload();
      }
      print(
          '_processUploadCallback ! count of uploading files : ${_state.uploadingFiles.length}');
    } catch (e, sw) {
      print('_processUploadCallback error: $e \nstack trace: $sw');
      _processNextFileUpload();
      //попробовать вернуть что-то здесь
    }
  }

  _processNextFileUpload() async {
    var uploadingFiles = _state.uploadingFiles;
    print('------------------------------- _processNextFileUpload');

    if (uploadingFiles.isNotEmpty &&
        uploadingFiles.any(
          (element) =>
              !element.isInProgress &&
              element.uploadPercent != 100 &&
              !element.auto &&
              !element.endedWithException,
        )) {
      print('start uploading next file');
      try {
        // var file = uploadingFiles.firstWhere(
        //   (element) =>
        //       !element.isInProgress &&
        //       element.uploadPercent != 100 &&
        //       !element.auto,
        // );
        uploadFile(
          // filePath: file.localPath,
          force: true,
        );
      } catch (e, st) {
        print('$e \n$st');
      }
    } else {
      var prefs = await SharedPreferences.getInstance();

      var needToContinueAutoupload =
          prefs.getBool(kIsAutouploadEnabled) ?? false;

      if (needToContinueAutoupload) {
        var token = await _tokenRepository.getApiToken();

        if (token != null && token.isNotEmpty) {
          _autouploadController?.startAutoupload(token);
        }
      }
    }
  }

  void downloadFile({required String? fileId, bool force = false}) async {
    if (isNotInited()) {
      await init();
    }
    var downloadingFiles = _state.downloadingFiles;

    DownloadFileInfo fileInfo;
    if (fileId != null) {
      if (downloadingFiles.any((element) => element.id == fileId))
        fileInfo =
            downloadingFiles.firstWhere((element) => element.id == fileId);
      else
        fileInfo = DownloadFileInfo(id: fileId);
    } else {
      fileInfo = downloadingFiles.firstWhere(
          (element) => !element.isInProgress && element.downloadPercent != 100);
    }

    // if (downloadingFiles.any((element) => element.id != fileId)) {
    //   fileInfo = DownloadFileInfo(id: fileId);
    // } else {
    //   fileInfo = downloadingFiles.firstWhere((element) => element.id == fileId);
    // }
    if (!force &&
        downloadingFiles.isNotEmpty &&
        downloadingFiles.any((element) => element.isInProgress == true)) {
      downloadingFiles = [fileInfo, ...downloadingFiles];
      _state.changeDowloadingFiles(downloadingFiles);
      print(
          'file with id $fileId added to a list and will be downloaded later');
      return;
    } else if (!downloadingFiles.contains(fileInfo)) {
      fileInfo.isInProgress = true;
      downloadingFiles.add(fileInfo);
      _state.changeDowloadingFiles(downloadingFiles);
    }

    var token = await _tokenRepository.getApiToken();

    if (token != null && token.isNotEmpty) {
      try {
        downloadingFiles.firstWhere((element) => element.id == fileInfo.id)
          ..isInProgress = true
          ..downloadPercent = 0;
        _state.changeDowloadingFiles(downloadingFiles);
      } catch (e) {
        print(e);
        fileInfo.isInProgress = true;
        fileInfo.downloadPercent = 0;
        downloadingFiles.add(fileInfo);
      }

      _state.changeDowloadingFiles(downloadingFiles);

      _cpp.downloadFile(
          recordID: fileInfo.id,
          bearerToken: token,
          callback: (value) {
            _processDownloadCallback(value: value, fileId: fileInfo.id);
          });
    }
  }

  void _processDownloadCallback({
    required dynamic value,
    required String fileId,
  }) async {
    try {
      if (value is File) {
        throwIfNot(
            value.existsSync(), Exception('Downloaded file doesn\'t exists'));
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == fileId);
        if (fileIndex != -1) {
          log('LoadController -> processDownloadCallback: \n file recieved: ${value.path}');
          var record = filesList[fileIndex].copyWith(
            localPath: value.path,
            isInProgress: false,
            downloadPercent: 100,
            endedWithException: false,
            errorReason: null,
          );

          filesList[fileIndex] = record;
          // filesList.firstWhere((element) => element.id == fileId)
          //   ..localPath = file.path
          //   ..isInProgress = false
          //   ..downloadPercent = 100;

          _state.changeDowloadingFiles(filesList);
        }
      } else if (value is SendProgress) {
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == fileId);
        if (fileIndex != -1) {
          log('LoadController -> processDownloadCallback: \n file: ${value.filePath}, download percent ${value.percent}');
          var record = filesList[fileIndex].copyWith(
            localPath: value.filePath,
            isInProgress: true,
            downloadPercent: value.percent,
            endedWithException: false,
            errorReason: null,
          );

          filesList[fileIndex] = record;
          // filesList.firstWhere((element) => element.id == fileId)
          //   ..localPath = file.path
          //   ..isInProgress = false
          //   ..downloadPercent = 100;

          _state.changeDowloadingFiles(filesList);
          _processNextFileDownload();
        }
      } else if (value is CustomError) {
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == fileId);
        if (fileIndex != -1) {
          var record = filesList[fileIndex].copyWith(
              localPath: null,
              isInProgress: false,
              downloadPercent: -1,
              endedWithException: true,
              errorReason: value.errorReason);

          filesList[fileIndex] = record;
          // filesList.firstWhere((element) => element.id == fileId)
          //   ..localPath = file.path
          //   ..isInProgress = false
          //   ..downloadPercent = 100;

          _state.changeDowloadingFiles(filesList);
          _processNextFileDownload();
        }
      } else {
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == fileId);
        if (fileIndex != -1) {
          var record = filesList[fileIndex].copyWith(
            isInProgress: false,
            downloadPercent: -1,
            endedWithException: false,
            errorReason: null,
          );

          filesList[fileIndex] = record;
          // filesList.firstWhere((element) => element.id == fileId)
          //   ..downloadPercent = -1
          //   ..isInProgress = false;
          _state.changeDowloadingFiles(filesList);
        }
      }
    } catch (e) {
      print(e);
      _processNextFileDownload();
    }
  }

  void _processNextFileDownload() {
    try {
      var downloadingFiles = _state.downloadingFiles;
      if (downloadingFiles.isNotEmpty &&
          downloadingFiles.any(
            (element) =>
                !element.isInProgress &&
                element.downloadPercent != 100 &&
                !element.endedWithException,
          )) {
        print('start downloading next file');

        var file = _state.downloadingFiles.firstWhere((element) =>
            !element.isInProgress && element.downloadPercent != 100);

        downloadFile(fileId: file.id, force: true);
      } else if (downloadingFiles.every((element) =>
          element.downloadPercent == 100 && !element.isInProgress)) {
        _state.changeDowloadingFiles([]);
      }
    } catch (e, st) {
      print('$e $st');
    }
  }

  void increasePriorityOfRecord(String recordId) {
    try {
      var currentRecord = _state.downloadingFiles
          .firstWhere((element) => element.id == recordId);
      var downloadingRecords = _state.downloadingFiles;
      downloadingRecords.forEach((element) {
        print('old: ${element.id}');
      });
      downloadingRecords.remove(currentRecord);
      var newDownloadingRecords = [currentRecord, ...downloadingRecords];
      newDownloadingRecords.forEach((element) {
        print('new: ${element.id}');
      });
      _state.changeDowloadingFiles(newDownloadingRecords);
    } catch (e, st) {
      print('$e, $st');
    }
  }

  Future<void> discardDownloading() async {
    var downloadingFiles = _state.downloadingFiles;

    if (downloadingFiles.isNotEmpty &&
        downloadingFiles.any((element) => element.isInProgress)) {
      await _cpp.abortDownload();
      _state.changeDowloadingFiles([]);
    }
  }

  bool isCurrentFileDownloading(String id) {
    var downloadingFiles = _state.downloadingFiles;

    var currentFileIndex = downloadingFiles
        .indexWhere((element) => element.isInProgress && element.id == id);

    return currentFileIndex != -1;
  }

  // bool _checkIsUploadingInProgress() {
  //   return _state.uploadingFiles.value.isNotEmpty;
  // }

  // bool _checkIsDownloadingInProgress() {
  //   return _state.downloadingFiles.value.isNotEmpty;
  // }
}

Future<void> copyFileToDownloadDir({
  required String filePath,
  required String fileId,
}) async {
  try {
    var file = File(filePath);
    var appDownloadFolderPath = await getDownloadAppFolder();
    await Directory(appDownloadFolderPath).create(recursive: true);
    var copiedFile = await file.copy(appDownloadFolderPath + file.name);

    var isFileCopied = await copiedFile.exists();
    print('copied file existing is $isFileCopied');

    if (isFileCopied) {
      var box = await Hive.openBox(kPathDBName);
      await box.put(fileId, 'downloads/${file.name}');
      print('uploading file succesfully copied to app folder');
    }
  } catch (e) {
    print('cannot copy file with exception: $e');
    // copyFileToDownloadDir(filePath: filePath, fileId: fileId);
  }
}

class _LoadState extends Observable {
  List<UploadFileInfo> _uploadingFiles = [];
  List<UploadFileInfo> get uploadingFiles => _uploadingFiles.toList();

  List<DownloadFileInfo> _downloadingFiles = [];
  List<DownloadFileInfo> get downloadingFiles => _downloadingFiles.toList();

  void changeUploadingFiles(List<UploadFileInfo> uploadingFiles) {
    _uploadingFiles = uploadingFiles;
    notifyObservers(_uploadingFiles);
  }

  void changeDowloadingFiles(List<DownloadFileInfo> downloadingFiles) {
    print('old downloading files count: ${_downloadingFiles.length}');
    _downloadingFiles = downloadingFiles;
    print('new downloading files count: ${_downloadingFiles.length}');
    notifyObservers(_downloadingFiles);
  }

  @override
  void unregisterObserver(Observer observer) {
    if (observer is UploadObserver) {
      try {
        var uploadedObject = _uploadingFiles
            .firstWhere((element) => element.localPath == observer.id);
        _uploadingFiles.remove(uploadedObject);
      } catch (e) {
        print('unregisterObserver: $e');
      }
    }
    super.unregisterObserver(observer);
  }
}

class UploadFileInfo {
  String localPath;
  String id;
  int uploadPercent;
  bool isInProgress;
  String? folderId;
  bool auto;
  bool endedWithException;
  ErrorReason? errorReason;

  UploadFileInfo({
    this.id = '',
    required this.localPath,
    this.uploadPercent = -1,
    this.isInProgress = false,
    required this.folderId,
    this.auto = false,
    this.endedWithException = false,
    this.errorReason,
  });

  UploadFileInfo copyWith({
    String? localPath,
    String? id,
    int? uploadPercent,
    bool? isInProgress,
    String? folderId,
    bool? endedWithException,
    ErrorReason? errorReason,
  }) {
    return UploadFileInfo(
      localPath: localPath ?? this.localPath,
      id: id ?? this.id,
      isInProgress: isInProgress ?? this.isInProgress,
      uploadPercent: uploadPercent ?? this.uploadPercent,
      folderId: folderId ?? this.folderId,
      endedWithException: endedWithException ?? this.endedWithException,
      errorReason: errorReason ?? this.errorReason,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is UploadFileInfo &&
        other.localPath == localPath &&
        other.isInProgress == isInProgress &&
        other.uploadPercent == uploadPercent;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'id: $id, filePath: $localPath, isInProgress: $isInProgress, uploadPercent: $uploadPercent\n';
  }
}

class DownloadFileInfo {
  String localPath;
  String id;
  int downloadPercent;
  bool isInProgress;
  bool endedWithException;
  ErrorReason? errorReason;

  DownloadFileInfo({
    required this.id,
    this.localPath = '',
    this.downloadPercent = -1,
    this.isInProgress = false,
    this.endedWithException = false,
    this.errorReason,
  });

  DownloadFileInfo copyWith({
    String? localPath,
    String? id,
    int? downloadPercent,
    bool? isInProgress,
    bool? endedWithException,
    ErrorReason? errorReason,
  }) {
    return DownloadFileInfo(
      localPath: localPath ?? this.localPath,
      id: id ?? this.id,
      isInProgress: isInProgress ?? this.isInProgress,
      downloadPercent: downloadPercent ?? this.downloadPercent,
      endedWithException: endedWithException ?? this.endedWithException,
      errorReason: errorReason ?? this.errorReason,
    );
  }
}
