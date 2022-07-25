import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:storageup/models/enums.dart';

class MediaOpenState extends Equatable {
  final ValueListenable<Box<BaseObject>>? objectsValueListenable;
  final List<String>? foldersToListen;
  final BaseObject openedFolder;
  final BaseObject choosedMedia;
  final List<BaseObject> mediaFromFolder;
  final bool isInitialized;
  final bool isVideoReady;
  final ErrorType? errorType;
  final ErrorReason? errorReason;

  final FormzStatus status;

  MediaOpenState({
    this.mediaFromFolder = const [],
    this.status = FormzStatus.pure,
    BaseObject? openedFolder,
    BaseObject? choosedMedia,
    this.isInitialized = false,
    this.errorType,
    this.errorReason,
    this.objectsValueListenable,
    this.foldersToListen,
    this.isVideoReady = false,
  })  : openedFolder = openedFolder ?? Record.empty(),
        choosedMedia = choosedMedia ?? Record.empty();

  bool get isVideoChosen =>
      (choosedMedia as Record).mimeType?.contains('video') ?? false;

  MediaOpenState copyWith({
    BaseObject? openedFolder,
    BaseObject? choosedMedia,
    List<BaseObject>? mediaFromFolder,
    FormzStatus? status,
    bool? isInitialized,
    ErrorType? errorType,
    ErrorReason? errorReason,
    ValueListenable<Box<BaseObject>>? objectsValueListenable,
    List<String>? foldersToListen,
    bool? isVideoReady,
  }) {
    return MediaOpenState(
      choosedMedia: choosedMedia ?? this.choosedMedia,
      mediaFromFolder: mediaFromFolder ?? this.mediaFromFolder,
      openedFolder: openedFolder ?? this.openedFolder,
      status: status ?? this.status,
      isInitialized: isInitialized ?? this.isInitialized,
      errorType: errorType,
      errorReason: errorReason,
      objectsValueListenable:
          objectsValueListenable ?? this.objectsValueListenable,
      foldersToListen: foldersToListen ?? this.foldersToListen,
      isVideoReady: isVideoReady ?? this.isVideoReady,
    );
  }

  @override
  List<Object?> get props => [
        openedFolder,
        choosedMedia,
        mediaFromFolder,
        status,
        isInitialized,
        errorType,
        errorReason,
        objectsValueListenable,
        foldersToListen,
        isVideoReady
      ];
}
