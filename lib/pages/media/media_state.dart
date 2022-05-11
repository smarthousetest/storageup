import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';


class MediaState extends Equatable {
  final List<Record> currentFolderRecords;
  final List<Record> sortedRecords;
  final List<Record> allRecords;
  final List<Folder> albums;
  final Folder currentFolder;
  final FilesRepresentation representation;
  final User? user;
  final bool progress;
  final FormzStatus status;
  final ErrorType? errorType;
  final ResponseStatus? responseStatus;

  MediaState({
    this.currentFolderRecords = const [],
    this.albums = const [],
    this.sortedRecords = const [],
    this.allRecords = const [],
    Folder? currentFolder,
    this.status = FormzStatus.pure,
    this.progress = false,
    this.responseStatus,
    this.representation = FilesRepresentation.grid,
    this.user,
    this.errorType,
  }) : this.currentFolder = currentFolder ?? Folder.empty();

  MediaState copyWith({
    List<Folder>? albums,
    Folder? currentFolder,
    FormzStatus? status,
    List<Record>? sortedRecords,
    List<Record>? allRecords,
    List<Record>? currentFolderRecords,
    FilesRepresentation? representation,
    User? user,
    bool? progress,
    ErrorType? errorType,
    ResponseStatus? responseStatus,
  }) {
    return MediaState(
      albums: albums ?? this.albums,
      currentFolder: currentFolder ?? this.currentFolder,
      currentFolderRecords: currentFolderRecords ?? this.currentFolderRecords,
      sortedRecords: sortedRecords ?? this.sortedRecords,
      allRecords: allRecords ?? this.allRecords,
      representation: representation ?? this.representation,
      user: user ?? this.user,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorType: errorType,
      responseStatus: responseStatus ?? this.responseStatus,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        albums,
        currentFolderRecords,
        representation,
        user,
        sortedRecords,
        allRecords,
        progress,
        errorType,
        status,
        responseStatus,
      ];
}
