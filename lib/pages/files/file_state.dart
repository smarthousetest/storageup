import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:formz/formz.dart';

enum FilesAction { moving }

class FilesState extends Equatable {
  final List<BaseObject> allFiles;

  final List<BaseObject> sortedFiles;

  final Folder? currentFolder;

  final bool isSelectable;

  final Map<String, List<BaseObject>> groupedFiles;

  final FormzStatus status;

  final int selectedCount;

  final List<BaseObject> filesToMove;

  final FilesAction? filesAction;

  final ErrorType? errorType;

  FilesState({
    this.allFiles = const [],
    this.sortedFiles = const [],
    this.status = FormzStatus.pure,
    this.groupedFiles = const {},
    this.currentFolder,
    this.isSelectable = false,
    this.selectedCount = 0,
    this.filesToMove = const [],
    this.filesAction,
    this.errorType,
  });

  FilesState.init({
    this.allFiles = const [],
    //this.sortedFiles = const [],
    this.status = FormzStatus.pure,
    this.groupedFiles = const {},
    this.currentFolder,
    this.isSelectable = false,
    this.selectedCount = 0,
    this.filesToMove = const [],
    this.filesAction,
    this.errorType,
  }) : sortedFiles = allFiles;

  FilesState copyWith({
    List<BaseObject>? allFiles,
    List<BaseObject>? sortedFiles,
    FormzStatus? status,
    Map<String, List<BaseObject>>? groupedFiles,
    Folder? currentFolder,
    bool? isSelectable,
    int? selectedCount,
    List<BaseObject>? filesToMove,
    FilesAction? filesAction,
    ErrorType? errorType,
  }) {
    return FilesState(
      allFiles: allFiles ?? this.allFiles,
      sortedFiles: sortedFiles ?? this.sortedFiles,
      status: status ?? this.status,
      groupedFiles: groupedFiles ?? this.groupedFiles,
      currentFolder: currentFolder ?? this.currentFolder,
      isSelectable: isSelectable ?? this.isSelectable,
      selectedCount: selectedCount ?? this.selectedCount,
      filesToMove: filesToMove ?? this.filesToMove,
      filesAction: filesAction ?? this.filesAction,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [
        allFiles,
        sortedFiles,
        status,
        groupedFiles,
        currentFolder,
        isSelectable,
        selectedCount,
        filesToMove,
        filesAction,
        errorType,
      ];
}
