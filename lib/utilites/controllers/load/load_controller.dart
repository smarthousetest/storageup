import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/cpp_native.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load/load_state_local_storage.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import '../../extensions.dart';
import 'load_state.dart';
import 'models.dart';

@lazySingleton
class LoadController {
  static const _tag = 'LoadController';
  final TokenRepository _tokenRepository;
  // AutouploadController? _autouploadController;
  LoadController(@injectable this._tokenRepository) {
    init();
  }

  late LoadState _state;
  late FilesController _filesController;
  var canLoad = false;
  final tag = 'LoadController';
  CppNative? _cpp;

  LoadState get getState => _state;

  void addFileToStateWitoutUploading(String path) {
    var newfile = UploadFileInfo(
      localPath: path,
      folderId: null,
      auto: false,
    );

    _state.addUploadingFileToStart(newfile);
  }

  bool isNotInited() {
    return _cpp == null;
  }

  Future<void> init() async {
    print('initializing load controller');
    // _autouploadController =
    //     await GetIt.instance.getAsync<AutouploadController>();
    _filesController =
        await GetIt.I.get<FilesController>(instanceName: 'files_controller');
    final stateStorage = await GetIt.I.getAsync<LoadStateStorage>();
    _state = LoadState(_filesController, stateStorage);
    final documentsFolder = await getApplicationDocumentsDirectory();
    _cpp = await getInstanceCppNative(
      documentsFolder: documentsFolder,
      baseUrl: kServerUrl.split('/').last,
    );

    if (_state.countOfUploadingFiles != 0) {
      _state.changeNextUploadingFile();

      uploadFile();
    }

    if (_state.countOfDownloadingFiles != 0) {
      _state.changeNextFileDownloading();

      downloadFile(fileId: null);
    }
  }

  void userAuthenticated() {
    canLoad = true;

    if (_state.countOfUploadingFiles != 0) {
      _state.changeNextUploadingFile();

      uploadFile();
    }

    if (_state.countOfDownloadingFiles != 0) {
      _state.changeNextFileDownloading();

      downloadFile(fileId: null);
    }
  }

  // Future<void> removeUploadMediaWhere(
  //   bool Function(UploadFileInfo) test,
  // ) async {
  //   _state.removeFilesFromUploadingQueue(test);
  // }

  void restartLoad() async {
    uploadFile();
  }

  Future<void> uploadFile({
    String? filePath,
    String? folderId,
    String? localId,
    bool force = false,
  }) async {
    if (isNotInited()) {
      await init();
    }
    UploadFileInfo obj;

    if (filePath == null) {
      if (_state.countOfUploadingFiles == 0) return;

      if (_state.countOfUploadingFiles != 0 &&
          _state.currentUploadingFile == null) {
        _state.changeNextUploadingFile();
      }

      if (_state.currentUploadingFile == null)
        throw Exception("$tag: upload() ->\nCan't find file to upload");

      obj = _state.currentUploadingFile!;

      if (obj.auto) {
        // final filePath = await _autouploadController
        //     ?.copyMediaToAppFolder(obj.localStorageId!);

        obj = obj.copyWith(localPath: filePath);

        _state.currentUploadingFile = obj;
      }
    } else {
      if (_state.containUploadingObjectWithPath(filePath)) {
        if (_state.isUploadingInProgress) {
          return;
        } else {
          _state.changeUploadingFileWithPath(filePath);
          if (_state.currentUploadingFile?.localPath == filePath) {
            obj = _state.currentUploadingFile!;
          } else {
            log("$tag uploadFile -> can't change the uploading file in load state");
            return;
          }
        }
      } else {
        obj = UploadFileInfo(
          localPath: filePath,
          folderId: folderId,
          localStorageId: localId,
        );

        if (_state.isUploadingInProgress) {
          _state.addUploadingFileToEnd(obj);

          return;
        } else {
          _state
            ..addUploadingFileToStart(obj)
            ..changeNextUploadingFile();

          obj = _state.currentUploadingFile!;
        }
      }
    }

    print('start processing file: ${obj.localPath}');

    print('start sending file ${obj.localPath}');
    var token = await _tokenRepository.getApiToken();

    String? thumbnailPath;
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
    // }
  }

  Future<void> _processUploadCallback(
    Either<CustomError, SendProgress> event,
  ) async {
    print('--------------------------------------- $event');
    try {
      // if (fileId == null) fileId = '-1';
      var element = _state.currentUploadingFile!;
      if (event.right != null) {
        if (!element.copiedToAppFolder) {
          element.id = event.right!.recordId;
          element.isInProgress = true;
          await copyFileToDownloadDir(
            filePath: event.right!.filePath!,
            fileId: event.right!.recordId,
          );
          element.copiedToAppFolder = true;
        }
        final uploadingPercent = event.right!.percent;
        if (uploadingPercent != 100) {
          if (element.loadPercent < uploadingPercent) {
            element.loadPercent = uploadingPercent;
            _state.currentUploadingFile = element;
          }
        } else {
          element.loadPercent = 100;

          element.isInProgress = false;
          element.isFinished = true;
          _state.currentUploadingFile = element;

          _processNextFileUpload();
        }
      } else {
        var nf = element.copyWith(
          isInProgress: false,
          uploadPercent: -1,
          endedWithException: true,
          errorReason: event.left!.errorReason,
          isFinished: true,
        );
        AppMetrica.reportError(
          message: 'error in _processUploadCallback',
          errorDescription: AppMetricaErrorDescription.fromCurrentStackTrace(
              message: event.left!.errorSource,
              type: event.left!.errorReason.toString()),
        );
        _state.currentUploadingFile = nf;
        _processNextFileUpload();
      }
      print(
          '_processUploadCallback ! count of uploading files : ${_state.countOfUploadingFiles}');
    } catch (e, sw) {
      print('_processUploadCallback error: $e \nstack trace: $sw');
      _processNextFileUpload();
    }
  }

  _processNextFileUpload() async {
    print('------------------------------- _processNextFileUpload');
    _state.changeNextUploadingFile();
    if (_state.isUploadingInProgress) {
      uploadFile(force: true);
    }
  }

  Future<void> downloadFile(
      {required String? fileId, bool force = false}) async {
    if (isNotInited()) {
      await init();
    }

    DownloadFileInfo fileInfo;
    if (fileId != null) {
      if (_state.containDownloadingObjectWithId(fileId)) {
        if (!_state.isDownloadingInProgress &&
            _state.currentDownloadingFile?.id != fileId) {
          _state.increasePriorityOfDownloadFileById(fileId);

          return;
        } else {
          return;
        }
      } else {
        _state.addDownloadingFileToStart(DownloadFileInfo(id: fileId));
        if (!_state.isDownloadingInProgress) {
          _state.changeNextFileDownloading();

          throwIf(
            _state.currentDownloadingFile == null,
            Exception(
                '$tag -> downloadFile:\nSomething goes wrong with changing next downloading file'),
          );
          fileInfo = _state.currentDownloadingFile!;
        } else {
          return;
        }
      }
    } else {
      if (_state.isDownloadingInProgress) {
        fileInfo = _state.currentDownloadingFile!;
      } else {
        return;
      }
    }
    var token = await _tokenRepository.getApiToken();

    if (token != null && token.isNotEmpty) {
      _cpp?.downloadFile(
        recordID: fileInfo.id,
        bearerToken: token,
      );
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
        if (_state.currentDownloadingFile?.id == fileId) {
          final filePath = value.path.split('/').last;

          var record = _state.currentDownloadingFile!.copyWith(
            localPath: filePath,
            isInProgress: false,
            downloadPercent: 100,
            isFinished: true,
          );

          _state.currentDownloadingFile = record;
        }
      } else if (value is SendProgress) {
        if (_state.currentDownloadingFile?.id == fileId) {
          log('LoadController -> processDownloadCallback: \n file: ${value.filePath}, download percent ${value.percent}');
          var record = _state.currentDownloadingFile!.copyWith(
            localPath: value.filePath,
            isInProgress: true,
            downloadPercent: value.percent,
          );

          _state.currentDownloadingFile = record;
        } else {
          throw Exception(
              'LoadController -> processDownloadCallback: downloading file does not the same as in state');
        }
      } else if (value is CustomError) {
        log('LoadController -> processDownloadCallback:',
            error: 'CustomError recieved: $value');

        if (_state.currentDownloadingFile?.id == fileId) {
          var record = _state.currentDownloadingFile!.copyWith(
            localPath: null,
            isInProgress: false,
            downloadPercent: -1,
            endedWithException: true,
            errorReason: value.errorReason,
            isFinished: true,
          );

          _state.currentDownloadingFile = record;
        }
      }
      if (_state.currentDownloadingFile?.isFinished ?? false) {
        _processNextFileDownload();
      }
    } catch (e) {
      print(e);
      _processNextFileDownload();
    }
  }

  void _processNextFileDownload() {
    try {
      _state.changeNextFileDownloading();
      if (_state.isDownloadingInProgress) {
        downloadFile(fileId: null);
      }
    } catch (e, st) {
      print('$e $st');
    }
  }

  void increasePriorityOfRecord(String recordId) {
    try {
      _state.increasePriorityOfDownloadFileById(recordId);
    } catch (e, st) {
      print('$e, $st');
    }
  }

  Future<void> discardDownloading() async {
    _state.clearDownloadingQueue();
    _state.currentDownloadingFile = null;

    await _cpp?.abortDownload();
  }

  bool isCurrentFileDownloading(String id) {
    return _state.currentDownloadingFile?.id == id;
  }

  Future<void> abortAndClearAll() async {
    try {
      _cpp?.abortSend(null);
    } catch (e) {
      log('error emmited in function: abortAndClearAll on abortSend', error: e);
    }

    try {
      await _cpp?.abortDownload();
    } catch (e) {
      log('error emmited in function: abortAndClearAll on abortDownload',
          error: e);
    }

    _state.clearAll();
  }

  Future<bool> abortSend() async {
    try {
      await _cpp?.abortSend(null);

      return true;
    } catch (e) {
      return false;
    }
  }
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
  }
}
