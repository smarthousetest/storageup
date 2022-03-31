import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/record.dart';

abstract class MediaOpenEvent extends Equatable {
  const MediaOpenEvent();

  @override
  List<Object?> get props => [];
}

class MediaOpenPageOpened extends MediaOpenEvent {
  final BaseObject? choosedFolder;
  final BaseObject choosedMedia;

  const MediaOpenPageOpened({
    required this.choosedFolder,
    required this.choosedMedia,
  });

  @override
  List<Object?> get props => [
        choosedFolder,
        choosedMedia,
      ];
}

class MediaOpenChangeFavoriteState extends MediaOpenEvent {
  final BaseObject media;

  const MediaOpenChangeFavoriteState({
    required this.media,
  });

  @override
  List<Object?> get props => [media];
}

class MediaOpenError extends MediaOpenEvent {
  final ErrorType? errorType;

  MediaOpenError(this.errorType);

  @override
  List<Object?> get props => [errorType];
}

class MediaOpenShare extends MediaOpenEvent {
  final int mediaId;

  const MediaOpenShare({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenDownload extends MediaOpenEvent {
  final String mediaId;

  const MediaOpenDownload({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenDelete extends MediaOpenEvent {
  final String mediaId;

  const MediaOpenDelete({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenChangeChoosedMedia extends MediaOpenEvent {
  final int index;

  const MediaOpenChangeChoosedMedia({required this.index});

  @override
  List<Object?> get props => [index];
}

class MediaOpenChangeDownloadStatus extends MediaOpenEvent {
  final Record media;

  const MediaOpenChangeDownloadStatus({required this.media});

  @override
  List<Object?> get props => [media];
}
