import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';

class LoadingContainerState extends Equatable {
  final List<BaseObject> filtredFiles;
  final List<BaseObject> filtredMedia;

  final List<BaseObject> recesntFiles;

  final ValueListenable<Box<BaseObject>>? objectsValueListenable;

  final LoadContainerDownloadInfo downloadInfo;
  final LoadContainerUploadInfo uploadInfo;
  final FormzStatus status;
  final Folder? folder;
  final Folder? rootFolders;

  final bool hasPremium;
  final bool isDownloading;
  final bool isUploading;
  final bool isSearching;

  LoadingContainerState({
    this.filtredFiles = const [],
    this.filtredMedia = const [],
    this.recesntFiles = const [],
    this.status = FormzStatus.pure,
    this.rootFolders,
    this.folder,
    this.hasPremium = false,
    this.isDownloading = false,
    this.isUploading = false,
    this.isSearching = false,
    this.objectsValueListenable,
    this.downloadInfo = const LoadContainerDownloadInfo(),
    this.uploadInfo = const LoadContainerUploadInfo(),
  });

  LoadingContainerState copyWith({
    List<BaseObject>? filtredFiles,
    List<BaseObject>? filtredMedia,
    List<BaseObject>? recesntFiles,
    FormzStatus? status,
    Folder? rootFolders,
    Folder? folder,
    bool? hasPremium,
    bool? isDownloading,
    bool? isUploading,
    bool? isSearching,
    ValueListenable<Box<BaseObject>>? objectsValueListenable,
    LoadContainerDownloadInfo? downloadInfo,
    LoadContainerUploadInfo? uploadInfo,
  }) {
    return LoadingContainerState(
      filtredFiles: filtredFiles ?? this.filtredFiles,
      filtredMedia: filtredMedia ?? this.filtredMedia,
      recesntFiles: recesntFiles ?? this.recesntFiles,
      status: status ?? this.status,
      folder: folder ?? this.folder,
      rootFolders: rootFolders ?? this.rootFolders,
      hasPremium: hasPremium ?? this.hasPremium,
      isDownloading: isDownloading ?? this.isDownloading,
      isUploading: isUploading ?? this.isUploading,
      isSearching: isSearching ?? this.isSearching,
      objectsValueListenable:
          objectsValueListenable ?? this.objectsValueListenable,
      uploadInfo: uploadInfo ?? this.uploadInfo,
      downloadInfo: downloadInfo ?? this.downloadInfo,
    );
  }

  @override
  List<Object?> get props => [
        filtredFiles,
        filtredMedia,
        recesntFiles,
        status,
        hasPremium,
        isDownloading,
        isUploading,
        isSearching,
        objectsValueListenable,
        uploadInfo,
        downloadInfo,
        folder,
        rootFolders
      ];
}

class LoadContainerDownloadInfo extends Equatable {
  final double downloadingFilePercent;
  final bool isDownloading;
  final int countOfDownloadingFiles;
  final int countOfDownloadedFiles;

  const LoadContainerDownloadInfo({
    this.downloadingFilePercent = 0,
    this.isDownloading = false,
    this.countOfDownloadingFiles = 0,
    this.countOfDownloadedFiles = 0,
  });

  LoadContainerDownloadInfo copyWith({
    double? downloadingFilePercent,
    bool? isDownloading,
    int? countOfDownloadingFiles,
    int? countOfDownloadedFiles,
  }) {
    return LoadContainerDownloadInfo(
      downloadingFilePercent:
          downloadingFilePercent ?? this.downloadingFilePercent,
      isDownloading: isDownloading ?? this.isDownloading,
      countOfDownloadingFiles:
          countOfDownloadingFiles ?? this.countOfDownloadingFiles,
      countOfDownloadedFiles:
          countOfDownloadedFiles ?? this.countOfDownloadedFiles,
    );
  }

  @override
  List<Object?> get props => [
        downloadingFilePercent,
        isDownloading,
        countOfDownloadingFiles,
        countOfDownloadedFiles,
      ];
}

class LoadContainerUploadInfo extends Equatable {
  final double uploadingFilePercent;
  final bool isUploading;
  final int countOfUploadingFiles;
  final int countOfUploadedFiles;

  const LoadContainerUploadInfo({
    this.uploadingFilePercent = 0,
    this.isUploading = false,
    this.countOfUploadingFiles = 0,
    this.countOfUploadedFiles = 0,
  });

  LoadContainerUploadInfo copyWith({
    double? uploadingFilePercent,
    bool? isUploading,
    int? countOfUpnloadingFiles,
    int? countOfUpnloadedFiles,
  }) {
    return LoadContainerUploadInfo(
      uploadingFilePercent: uploadingFilePercent ?? this.uploadingFilePercent,
      isUploading: isUploading ?? this.isUploading,
      countOfUploadingFiles:
          countOfUpnloadingFiles ?? this.countOfUploadingFiles,
      countOfUploadedFiles: countOfUpnloadedFiles ?? this.countOfUploadedFiles,
    );
  }

  @override
  List<Object?> get props => [
        uploadingFilePercent,
        isUploading,
        countOfUploadingFiles,
        countOfUploadedFiles,
      ];
}
