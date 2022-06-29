import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/base_object.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/record.dart';

class MediaOpenState extends Equatable {
  final BaseObject openedFolder;
  final BaseObject choosedMedia;
  final List<BaseObject> mediaFromFolder;
  final bool isInitialized;
  final ErrorType? errorType;

  final FormzStatus status;

  MediaOpenState({
    this.mediaFromFolder = const [],
    this.status = FormzStatus.pure,
    BaseObject? openedFolder,
    BaseObject? choosedMedia,
    this.isInitialized = false,
    this.errorType,
  })  : openedFolder = openedFolder ?? Record.empty(),
        choosedMedia = choosedMedia ?? Record.empty();

  MediaOpenState copyWith({
    BaseObject? openedFolder,
    BaseObject? choosedMedia,
    List<BaseObject>? mediaFromFolder,
    FormzStatus? status,
    bool? isInitialized,
    ErrorType? errorType,
  }) {
    return MediaOpenState(
      choosedMedia: choosedMedia ?? this.choosedMedia,
      mediaFromFolder: mediaFromFolder ?? this.mediaFromFolder,
      openedFolder: openedFolder ?? this.openedFolder,
      status: status ?? this.status,
      isInitialized: isInitialized ?? this.isInitialized,
      errorType: errorType ?? this.errorType,
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
      ];
}
