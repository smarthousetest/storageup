import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/main_download_info.dart';
import 'package:storageup/models/main_upload_info.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomePageOpened extends HomeEvent {}

class FileTapped extends HomeEvent {
  final Record record;
  FileTapped({required this.record});
}

class HomeUserActionChosen extends HomeEvent {
  final UserAction action;
  final List<String?>? values;
  final String? folderId;

  HomeUserActionChosen({
    required this.action,
    this.values,
    this.folderId,
  });
}

class MainPageChangeUploadInfo extends HomeEvent {
  final MainUploadInfo uploadInfo;

  MainPageChangeUploadInfo({required this.uploadInfo});

  @override
  List<Object?> get props => [uploadInfo];
}

class MainPageChangeDownloadInfo extends HomeEvent {
  final MainDownloadInfo downloadInfo;

  MainPageChangeDownloadInfo({required this.downloadInfo});

  @override
  List<Object?> get props => [downloadInfo];
}

class UpdateRemoteVersion extends HomeEvent {
  final String localVersion;
  final String remoteVersion;

  const UpdateRemoteVersion({
    required this.localVersion,
    required this.remoteVersion,
  });
}
