import 'package:cpp_native/cpp_native.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBQueue<T> {
  int id;
  List<T>? queue;
  OBQueue({
    this.id = 0,
    this.queue,
  });
}

abstract class FileInfo {
  int dbID;

  String localPath;
  String id;
  int loadPercent;
  bool isInProgress;
  bool endedWithException;
  ErrorReason? errorReason;
  bool needToShowPopup;
  bool isFinished;
  bool copiedToAppFolder;

  FileInfo({
    this.dbID = 0,
    required this.id,
    this.localPath = '',
    this.loadPercent = -1,
    this.isInProgress = false,
    this.endedWithException = false,
    this.errorReason,
    this.copiedToAppFolder = false,
    this.needToShowPopup = true,
    this.isFinished = false,
  });
}

@Entity()

///[localStorageId] should be provided with every instance from AutouploadController
class UploadFileInfo implements FileInfo {
  @Id()
  int dbID;
  String localPath;
  String id;
  String? localStorageId;
  int loadPercent;
  bool isInProgress;
  String? folderId;
  bool auto;
  bool endedWithException;
  bool copiedToAppFolder;
  ErrorReason? errorReason;
  bool needToShowPopup;
  bool isFinished;

  UploadFileInfo({
    this.dbID = 0,
    this.id = '',
    required this.localPath,
    this.loadPercent = -1,
    this.isInProgress = false,
    required this.folderId,
    this.auto = false,
    this.endedWithException = false,
    this.copiedToAppFolder = false,
    this.errorReason,
    this.needToShowPopup = true,
    this.isFinished = false,
    this.localStorageId,
  });

  UploadFileInfo copyWith({
    String? localPath,
    String? id,
    int? uploadPercent,
    bool? isInProgress,
    String? folderId,
    bool? endedWithException,
    bool? copiedToAppFolder,
    ErrorReason? errorReason,
    bool? needToShowPopup,
    bool? isFinished,
    String? localStorageId,
    bool? auto,
  }) {
    return UploadFileInfo(
      localPath: localPath ?? this.localPath,
      id: id ?? this.id,
      isInProgress: isInProgress ?? this.isInProgress,
      loadPercent: uploadPercent ?? this.loadPercent,
      folderId: folderId ?? this.folderId,
      endedWithException: endedWithException ?? this.endedWithException,
      copiedToAppFolder: copiedToAppFolder ?? this.copiedToAppFolder,
      errorReason: errorReason ?? this.errorReason,
      needToShowPopup: needToShowPopup ?? this.needToShowPopup,
      isFinished: isFinished ?? this.isFinished,
      localStorageId: localStorageId ?? this.localStorageId,
      auto: auto ?? this.auto,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is UploadFileInfo &&
        other.localPath == localPath &&
        other.id == id;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'id: $id, localStorageId: $localStorageId, filePath: $localPath, isInProgress: $isInProgress, uploadPercent: $loadPercent, endedWithException: $endedWithException, errorReason: $errorReason\n';
  }
}

@Entity()
class DownloadFileInfo implements FileInfo {
  @Id()
  int dbID;
  String localPath;
  String id;
  int loadPercent;
  bool isInProgress;
  bool endedWithException;
  bool needToShowPopup;
  ErrorReason? errorReason;
  bool copiedToAppFolder;
  bool isFinished;

  DownloadFileInfo({
    this.dbID = 0,
    required this.id,
    this.localPath = '',
    this.loadPercent = -1,
    this.isInProgress = false,
    this.endedWithException = false,
    this.errorReason,
    this.needToShowPopup = true,
    this.isFinished = false,
  }) : copiedToAppFolder = false;

  DownloadFileInfo copyWith(
      {String? localPath,
      String? id,
      int? downloadPercent,
      bool? isInProgress,
      bool? endedWithException,
      ErrorReason? errorReason,
      bool? needToShowPopup,
      bool? isFinished}) {
    return DownloadFileInfo(
      localPath: localPath ?? this.localPath,
      id: id ?? this.id,
      isInProgress: isInProgress ?? this.isInProgress,
      loadPercent: downloadPercent ?? this.loadPercent,
      endedWithException: endedWithException ?? this.endedWithException,
      errorReason: errorReason ?? this.errorReason,
      needToShowPopup: needToShowPopup ?? this.needToShowPopup,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class LoadNotification {
  final UploadFileInfo? uploadFileInfo;
  final DownloadFileInfo? downloadFileInfo;
  final bool isDownloadingInProgress;
  final bool isUploadingInProgress;
  final int countOfUploadingFiles;
  final int countOfUploadedFiles;
  final int countOfDownloadingFiles;
  final int countOfDownloadedFiles;

  LoadNotification({
    required this.uploadFileInfo,
    required this.downloadFileInfo,
    required this.countOfUploadingFiles,
    required this.countOfUploadedFiles,
    required this.countOfDownloadingFiles,
    required this.countOfDownloadedFiles,
    required this.isDownloadingInProgress,
    required this.isUploadingInProgress,
  });
}
