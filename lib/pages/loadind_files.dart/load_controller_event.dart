import 'package:equatable/equatable.dart';
import 'package:storageup/pages/loadind_files.dart/loading_container_state.dart';

abstract class LoadContainerEvent extends Equatable {
  const LoadContainerEvent();

  @override
  List<Object?> get props => [];
}

class MainSearchFieldChanged extends LoadContainerEvent {
  final String text;

  MainSearchFieldChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

class MainPageOpened extends LoadContainerEvent {
  MainPageOpened();
}

class MainPageChangeUploadInfo extends LoadContainerEvent {
  final LoadContainerUploadInfo uploadInfo;

  MainPageChangeUploadInfo({required this.uploadInfo});

  @override
  List<Object?> get props => [uploadInfo];
}

class MainPageChangeDownloadInfo extends LoadContainerEvent {
  final LoadContainerDownloadInfo downloadInfo;

  MainPageChangeDownloadInfo({required this.downloadInfo});

  @override
  List<Object?> get props => [downloadInfo];
}
