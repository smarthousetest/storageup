import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';

class MediaState extends Equatable {
  final List<Record> currentFolderRecords;
  final List<Record> sortedRecords;
  final List<Record> allRecords;
  final List<Folder> albums;
  final Folder currentFolder;
  final FilesRepresentation representation;
  final User? user;
  final bool progress;
  final String? searchText;
  final FormzStatus status;
  final ErrorType? errorType;
  final ResponseStatus? responseStatus;
  final ValueNotifier<User?>? valueNotifier;
  final ValueListenable<Box<BaseObject>>? folderValueListenable;
  final ValueListenable<Box<BaseObject>>? objectsValueListenable;
  final List<String>? foldersToListen;

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
    this.objectsValueListenable,
    this.folderValueListenable,
    this.errorType,
    this.foldersToListen,
    this.searchText,
    this.valueNotifier,
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
    List<String>? foldersToListen,
    String? searchText,
    bool? progress,
    ErrorType? errorType,
    ResponseStatus? responseStatus,
    ValueNotifier<User?>? valueNotifier,
    ValueListenable<Box<BaseObject>>? objectsValueListenable,
    ValueListenable<Box<BaseObject>>? folderValueListenable,
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
      searchText: searchText ?? this.searchText,
      errorType: errorType,
      responseStatus: responseStatus ?? this.responseStatus,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      objectsValueListenable:
          objectsValueListenable ?? this.objectsValueListenable,
      folderValueListenable:
          folderValueListenable ?? this.folderValueListenable,
      foldersToListen: foldersToListen,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        allRecords,
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
        valueNotifier,
        objectsValueListenable,
        searchText,
        foldersToListen,
        folderValueListenable,
      ];
}
