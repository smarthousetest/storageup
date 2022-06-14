import 'dart:collection';
import 'dart:developer';

import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:upstorage_desktop/utilites/controllers/load/load_state_local_storage.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';

import '../files_controller.dart';
import 'models.dart';

class LoadState extends Observable {
  FilesController _controller;
  LoadStateStorage _storage;

  LoadState(this._controller, this._storage) : super([]) {
    _init();
  }

  void _init() {
    final uploadingFile = _storage.getUploadingFile();
    final downloadingFile = _storage.getDownloadingFile();

    final uploadingFiles = _storage.getFilesToUpload();
    final downloadingFiles = _storage.getFilesToDownload();

    addUploadingFilesToStart(uploadingFiles);
    addDownloadingFilesToStart(downloadingFiles);

    if (downloadingFile != null) {
      addDownloadingFileToStart(downloadingFile);
      isDownloadingInProgress = true;
    }

    if (uploadingFile != null) {
      addUploadingFileToStart(uploadingFile);
      currentUploadingFile = uploadingFile;
      isUploadingInProgress = true;
    }
  }

  @override
  String tag = 'LoadState';

  @override
  void unregisterObserver(Observer observer) {
    if (observer is UploadObserver) {
      try {
        var uploadedObject = _uploadingFiles
            .firstWhere((element) => element.localPath == observer.id);

        if (uploadedObject.loadPercent == 100 && !uploadedObject.isInProgress) {
          log('deleting object with path: ${uploadedObject.localPath} ${uploadedObject.loadPercent} ${uploadedObject.id}');
          _uploadingFiles.remove(uploadedObject);
        }
      } catch (e) {
        print('_LoadState  unregisterObserver: $e');
      }
    }
    super.unregisterObserver(observer);
  }

  UploadFileInfo? _currentUploadingFile;
  UploadFileInfo? get currentUploadingFile => _currentUploadingFile;

  bool isUploadingInProgress = false;

  int get countOfUploadingFiles {
    var totalCount = _uploadedFiles.length +
        _uploadingFiles.length +
        _autouploadingFiles.length;

    if (isUploadingInProgress && _currentUploadingFile != null) totalCount++;

    return totalCount;
  }

  Queue<UploadFileInfo> _uploadingFiles = Queue<UploadFileInfo>();
  Queue<UploadFileInfo> _autouploadingFiles = Queue<UploadFileInfo>();
  List<UploadFileInfo> _uploadedFiles = [];

  DownloadFileInfo? _currentDownloadingFile;
  DownloadFileInfo? get currentDownloadingFile => _currentDownloadingFile;

  bool isDownloadingInProgress = false;

  int get countOfDownloadingFiles {
    var totalCount = _downloadedFiles.length + _downloadingFiles.length;

    if (isDownloadingInProgress && _currentDownloadingFile != null)
      totalCount++;

    return totalCount;
  }

  Queue<DownloadFileInfo> _downloadingFiles = Queue<DownloadFileInfo>();
  List<DownloadFileInfo> _downloadedFiles = [];

  LoadNotification createNotification() {
    return LoadNotification(
      uploadFileInfo: _currentUploadingFile,
      downloadFileInfo: _currentDownloadingFile,
      countOfUploadingFiles: countOfUploadingFiles,
      countOfUploadedFiles: _uploadedFiles.length,
      countOfDownloadingFiles: 0,
      countOfDownloadedFiles: 0,
      isDownloadingInProgress: isDownloadingInProgress,
      isUploadingInProgress: isUploadingInProgress,
    );
  }

  set currentUploadingFile(UploadFileInfo? uploadingFile) {
    if (uploadingFile != null) {
      // _controller.updateObject(uploadingFile);

      if (!uploadingFile.auto) _storage.changeUpload([uploadingFile]);
    }

    _currentUploadingFile = uploadingFile;

    notifyObservers(createNotification());
  }

  set currentDownloadingFile(DownloadFileInfo? downloadingFile) {
    if (downloadingFile != null && _currentDownloadingFile != downloadingFile) {
      // _controller.updateObject(downloadingFile);
      _storage.changeDownload([downloadingFile]);
    }

    _currentDownloadingFile = downloadingFile;

    notifyObservers(createNotification());
  }

  void clearAll() {
    _autouploadingFiles.clear();
    _currentDownloadingFile = null;
    _currentUploadingFile = null;
    _downloadedFiles.clear();
    _downloadingFiles.clear();
    _uploadedFiles.clear();
    _uploadingFiles.clear();
    isDownloadingInProgress = false;
    isUploadingInProgress = false;
    _storage.cleanAll();
  }
}

extension Upload on LoadState {
  void addUploadingFilesToEnd(List<UploadFileInfo> uploadingFiles) {
    _uploadingFiles.addAll(uploadingFiles);

    notifyObservers(createNotification());
    _storage.changeUpload(_uploadingFiles.toList());
  }

  ///Invoke [Queue.addFirst] to each element in [uploadingFiles]
  void addUploadingFilesToStart(List<UploadFileInfo> uploadingFiles) {
    uploadingFiles.forEach((element) {
      _uploadingFiles.addFirst(element);
    });

    notifyObservers(createNotification());
    _storage.changeUpload(_uploadingFiles.toList());
  }

  void addUploadingFileToEnd(UploadFileInfo uploadingFile) {
    _uploadingFiles.addLast(uploadingFile);

    // countOfUploadingFiles++;

    notifyObservers(createNotification());
    _storage.changeUpload(_uploadingFiles.toList());
  }

  void addUploadingFileToStart(UploadFileInfo uploadingFile) {
    _uploadingFiles.addFirst(uploadingFile);

    // countOfUploadingFiles++;
    notifyObservers(createNotification());
    _storage.changeUpload(_uploadingFiles.toList());
  }

  void resetUploadingFile() {
    if (_currentUploadingFile == null) return;

    _currentUploadingFile!
      ..loadPercent = 0
      ..isInProgress = false
      ..id = '';

    notifyObservers(createNotification());
    _storage.changeUpload([_currentUploadingFile!]);
  }

  ///Can throw when files to upload is empty
  void changeNextUploadingFile() {
    if (_currentUploadingFile != null) {
      // _controller.updateObject(_currentUploadingFile!);
      _uploadedFiles.add(_currentUploadingFile!);
      _storage.removeUploadingFile(_currentUploadingFile!);
    }

    UploadFileInfo? fileToUpload;

    if (_uploadingFiles.isNotEmpty) {
      fileToUpload = _uploadingFiles.removeFirst();
    } else if (_autouploadingFiles.isNotEmpty) {
      fileToUpload = _autouploadingFiles.removeFirst();
    }

    if (fileToUpload != null) {
      currentUploadingFile = fileToUpload
        ..isInProgress = true
        ..loadPercent = -1;

      isUploadingInProgress = true;
    } else {
      _uploadedFiles.clear();
      _currentUploadingFile = null;
      isUploadingInProgress = false;
      _storage.clearUploadingFiles();
      log('End of uploading');
    }

    notifyObservers(createNotification());
  }

  // void removeFilesFromUploadingQueue(bool Function(UploadFileInfo) test) {
  //   _uploadingFiles.removeWhere(test);

  //   notifyObservers(createNotification());
  // }

  void changeUploadingFileWithPath(String path) {
    try {
      final fileInfo =
          _uploadingFiles.firstWhere((element) => element.localPath == path);

      _uploadingFiles.remove(fileInfo);

      currentUploadingFile = fileInfo
        ..isInProgress = true
        ..loadPercent = -1;
    } on StateError catch (_) {
      // if (_currentUploadingFile == null) changeNextUploadingFile();
      log("$tag changeUploadingFileWithPath -> can't find file");
    }
  }

  bool containUploadingObjectWithPath(String path) {
    try {
      _uploadingFiles.firstWhere((element) => element.localPath == path);
      return true;
    } on StateError catch (_) {
      return false;
    }
  }

  UploadFileInfo? getUploadFileInfoByPath(String path) {
    try {
      return _uploadingFiles.firstWhere((element) => element.localPath == path);
    } on StateError catch (_) {
      return null;
    }
  }
}

extension Autouploading on LoadState {
  void addFilesToAutoupload(List<UploadFileInfo> uploadingFiles) {
    _autouploadingFiles.addAll(uploadingFiles);
    _storage.changeUpload(_autouploadingFiles.toList());
  }

  void removeAllFilesFromAutoupload() {
    _autouploadingFiles.clear();

    if (_currentUploadingFile?.auto ?? false) {
      currentUploadingFile = null;
    }

    _uploadedFiles.removeWhere((element) => element.auto);
    // _storage.removeAutouploadingFiles();

    notifyObservers(createNotification());
  }
}

extension Download on LoadState {
  void addDownloadingFilesToEnd(List<DownloadFileInfo> downloadingFiles) {
    _downloadingFiles.addAll(downloadingFiles);

    notifyObservers(createNotification());

    _storage.changeDownload(_downloadingFiles.toList());
  }

  ///Invoke [Queue.addFirst] to each element in [downloadingFiles]
  void addDownloadingFilesToStart(List<DownloadFileInfo> downloadingFiles) {
    downloadingFiles.forEach((element) {
      _downloadingFiles.addFirst(element);
    });

    notifyObservers(createNotification());

    _storage.changeDownload(_downloadingFiles.toList());
  }

  void addDownloadingFileToEnd(DownloadFileInfo downloadingFile) {
    _downloadingFiles.addLast(downloadingFile);

    // countOfDownloadingFiles++;
    notifyObservers(createNotification());

    _storage.changeDownload(_downloadingFiles.toList());
  }

  void addDownloadingFileToStart(DownloadFileInfo downloadingFile) {
    _downloadingFiles.addFirst(downloadingFile);

    // countOfDownloadingFiles++;
    notifyObservers(createNotification());

    _storage.changeDownload(_downloadingFiles.toList());
  }

  void resetDownloadingFile() {
    if (_currentDownloadingFile == null) return;

    _currentDownloadingFile!
      ..loadPercent = 0
      ..isInProgress = false
      ..id = '';

    notifyObservers(createNotification());

    _storage.changeDownload([_currentDownloadingFile!]);
  }

  ///Can throw when files to download is empty
  void changeNextFileDownloading() {
    if (_currentDownloadingFile != null) {
      // _controller.updateObject(_currentDownloadingFile!);
      _downloadedFiles.add(_currentDownloadingFile!);
      _storage.removeDownloadingFile(_currentDownloadingFile!);
    }

    if (_downloadingFiles.isNotEmpty) {
      var fileToDownload = _downloadingFiles.removeFirst();
      _currentDownloadingFile = fileToDownload.copyWith(
        isInProgress: true,
        downloadPercent: -1,
      );
    } else {
      _currentDownloadingFile = null;
      _downloadingFiles.clear();
      _downloadedFiles.clear();
      _storage.clearDownloading();
      isDownloadingInProgress = false;
    }

    if (_currentDownloadingFile != null) {
      isDownloadingInProgress = true;
    }
  }

  bool containDownloadingObjectWithId(String id) {
    try {
      if (_currentDownloadingFile?.id == id) return true;

      _downloadingFiles.firstWhere((element) => element.id == id);

      return true;
    } on StateError catch (_) {
      return false;
    }
  }

  void changeDownloadingFileWithId(String id) {
    try {
      final fileInfo =
          _downloadingFiles.firstWhere((element) => element.id == id);

      _uploadingFiles.remove(fileInfo);

      currentDownloadingFile =
          fileInfo.copyWith(isInProgress: true, downloadPercent: 0);
    } on StateError catch (_) {
      // if (_currentUploadingFile == null) changeNextUploadingFile();
      log("$tag changeUDownloadingFileWithId -> can't find file");
    }
  }

  bool increasePriorityOfDownloadFileById(String id) {
    try {
      final fileInfo =
          _downloadingFiles.firstWhere((element) => element.id == id);

      _downloadingFiles.remove(fileInfo);

      _downloadingFiles.addFirst(fileInfo);
      _storage.changeDownload(_downloadingFiles.toList());
      return true;
    } on StateError catch (_) {
      return false;
    }
  }

  void clearDownloadingQueue() {
    _downloadingFiles.clear();
    _downloadedFiles.clear();
    _storage.cleanAll();
  }
}
