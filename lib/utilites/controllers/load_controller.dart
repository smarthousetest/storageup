import 'dart:developer';
import 'dart:io';
import 'package:cpp_native/cpp_native.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/file_bloc.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/constants.dart';
import '../injection.dart';

class LoadController {
  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  _LoadState _state = _LoadState();

  CppNative? _cpp;

  _LoadState get getState => _state;

  LoadController() {}

  bool isNotInitialized() {
    return _cpp == null;
  }

  Function(String)? _onAddAutoUploadingFile;

  set setAutoUploadNextFileListener(Function(String) callback) => _onAddAutoUploadingFile = callback;

  void clearAutoUploadNextFileCallback() => _onAddAutoUploadingFile = null;

  Future<void> init() async {
    print('Initializing load controller');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _cpp = await getInstanceCppNative(
      documentsFolder: appDocDir,
      baseUrl: kServerUrl.split('/').last,
    );
  }

  Future<void> uploadFile({
    String? filePath,
    String? folderId,
    bool force = false,
  }) async {
    if (isNotInitialized()) {
      await init();
    }
    var uploadingFiles = _state.uploadingFiles;
    UploadFileInfo obj;
    if (filePath == null) {
      obj = uploadingFiles.firstWhere(
        (element) => element.isInProgress == false && element.uploadPercent != 100 && !element.auto && !element.endedWithException,
      );
    } else {
      obj = UploadFileInfo(localPath: filePath, folderId: folderId);
    }

    print('start processing file: $filePath');
    print(!force && _state.uploadingFiles.isNotEmpty && _state.uploadingFiles.any((element) => element.isInProgress));
    print(!_state.uploadingFiles.contains(obj));

    if (!force && _state.uploadingFiles.isNotEmpty && _state.uploadingFiles.any((element) => element.isInProgress)) {
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

    print('start sending file $filePath');
    var token = await _tokenRepository.getApiToken();
    var file = File(obj.localPath);
    print('file existing is ${file.existsSync()}');
    if (token != null && token.isNotEmpty) {
      final createRecordResult = await Request.instance.createRecord(
        file: File(obj.localPath),
        bearerToken: token,
        documentsFolderPath: (await getApplicationDocumentsDirectory()).path,
        backendUrl: kServerUrl.split('/').last,
        folderId: obj.folderId,
      );

      if (createRecordResult.isLeft()) {
        _processUploadCallback(Either.left(createRecordResult.left));
      } else {
        final record = Record.fromJson(createRecordResult.right!);

        _cpp
            ?.send(
              recordId: record.id,
              filePath: obj.localPath,
              bearerToken: token,
              folderId: obj.folderId,
            )
            .listen(_processUploadCallback);
      }
    }
  }

  void _processUploadCallback(
    Either<CustomError, SendProgress> event,
  ) async {
    print('--------------------------------------- $event');
    try {
      var uploadingFiles = List<UploadFileInfo>.from(_state.uploadingFiles);

      if (event.right != null) {
        var element = uploadingFiles
            .firstWhere((element) => (element.localPath == event.right!.filePath && (element.isInProgress || element.uploadPercent != 100)) || element.id == event.right!.recordId);
        final uploadingPercent = event.right!.percent;
        if (uploadingPercent != 100) {
          element.uploadPercent = uploadingPercent;
          element.id = event.right!.recordId;
          _state.changeUploadingFiles(uploadingFiles);
        } else {
          element.uploadPercent = 100;

          _state.changeUploadingFiles(uploadingFiles);

          element.isInProgress = false;
          _state.changeUploadingFiles(uploadingFiles);

          _processNextFileUpload();
        }
      } else {
        var element = uploadingFiles
            .firstWhere((element) => (element.localPath == event.left!.id && (element.isInProgress || element.uploadPercent != 100)) || element.id == event.right!.recordId);
        var nf = element.copyWith(
          isInProgress: false,
          uploadPercent: -1,
          endedWithException: true,
          errorReason: event.left!.errorReason,
        );

        var ind = uploadingFiles.indexOf(element);
        uploadingFiles[ind] = nf;

        _state.changeUploadingFiles(uploadingFiles);
        _processNextFileUpload();
      }
      print('_processUploadCallback ! count of uploading files : ${_state.uploadingFiles.length}');
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
          (element) => !element.isInProgress && element.uploadPercent != 100 && !element.auto && !element.endedWithException,
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
    }
  }

  void downloadFile({required String? fileId, bool force = false}) async {
    if (isNotInitialized()) {
      await init();
    }
    var downloadingFiles = _state.downloadingFiles;

    DownloadFileInfo fileInfo;
    if (fileId != null) {
      if (downloadingFiles.any((element) => element.id == fileId))
        fileInfo = downloadingFiles.firstWhere((element) => element.id == fileId);
      else
        fileInfo = DownloadFileInfo(id: fileId);
    } else {
      fileInfo = downloadingFiles.firstWhere((element) => !element.isInProgress && element.downloadPercent != 100);
    }

    // if (downloadingFiles.any((element) => element.id != fileId)) {
    //   fileInfo = DownloadFileInfo(id: fileId);
    // } else {
    //   fileInfo = downloadingFiles.firstWhere((element) => element.id == fileId);
    // }
    if (!force && downloadingFiles.isNotEmpty && downloadingFiles.any((element) => element.isInProgress == true)) {
      downloadingFiles = [fileInfo, ...downloadingFiles];
      _state.changeDowloadingFiles(downloadingFiles);
      print('file with id $fileId added to a list and will be downloaded later');
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

      _cpp
          ?.downloadFile(
            recordID: fileInfo.id,
            bearerToken: token,
          )
          .listen(_processDownloadCallback);
    }
  }

  void _processDownloadCallback(
    Either<CustomError, SendProgress> event,
  ) async {
    try {
      if (event.right != null && event.right!.file != null) {
        throwIfNot(event.right!.file!.existsSync(), Exception('Downloaded file doesn\'t exists'));
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == event.right!.recordId);
        if (fileIndex != -1) {
          log('LoadController -> processDownloadCallback: \n file recieved: ${event.right!.file!.path}');
          var record = filesList[fileIndex].copyWith(
            localPath: event.right!.file!.path,
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
      } else if (event.right != null) {
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == event.right!.recordId);
        if (fileIndex != -1) {
          log('LoadController -> processDownloadCallback: \n file: ${event.right!.file?.path}, download percent ${event.right!.percent}');
          var record = filesList[fileIndex].copyWith(
            localPath: event.right!.filePath,
            isInProgress: true,
            downloadPercent: event.right!.percent,
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
      } else {
        var filesList = _state.downloadingFiles;
        var fileIndex = filesList.indexWhere((element) => element.id == event.left!.id);
        if (fileIndex != -1) {
          var record = filesList[fileIndex].copyWith(
            localPath: null,
            isInProgress: false,
            downloadPercent: -1,
            endedWithException: true,
            errorReason: event.left!.errorReason,
          );

          filesList[fileIndex] = record;
          // filesList.firstWhere((element) => element.id == fileId)
          //   ..localPath = file.path
          //   ..isInProgress = false
          //   ..downloadPercent = 100;

          _state.changeDowloadingFiles(filesList);
          _processNextFileDownload();
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
            (element) => !element.isInProgress && element.downloadPercent != 100 && !element.endedWithException,
          )) {
        print('start downloading next file');

        var file = _state.downloadingFiles.firstWhere((element) => !element.isInProgress && element.downloadPercent != 100);

        downloadFile(fileId: file.id, force: true);
      } else if (downloadingFiles.every((element) => element.downloadPercent == 100 && !element.isInProgress)) {
        _state.changeDowloadingFiles([]);
      }
    } catch (e, st) {
      print('$e $st');
    }
  }

  void increasePriorityOfRecord(String recordId) {
    try {
      var currentRecord = _state.downloadingFiles.firstWhere((element) => element.id == recordId);
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

    if (downloadingFiles.isNotEmpty && downloadingFiles.any((element) => element.isInProgress)) {
      await _cpp?.abortDownload();
      _state.changeDowloadingFiles([]);
    }
  }

  bool isCurrentFileDownloading(String id) {
    var downloadingFiles = _state.downloadingFiles;

    var currentFileIndex = downloadingFiles.indexWhere((element) => element.isInProgress && element.id == id);

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
        var uploadedObject = _uploadingFiles.firstWhere((element) => element.localPath == observer.id);
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
    return other is UploadFileInfo && other.localPath == localPath && other.isInProgress == isInProgress && other.uploadPercent == uploadPercent;
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
