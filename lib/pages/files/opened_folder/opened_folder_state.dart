import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';

class OpenedFolderState extends Equatable {
  final Folder? currentFolder;
  final List<BaseObject> objects;
  final List<BaseObject> sortedFiles;
  final List<Folder> previousFolders;
  final FilesRepresentation representation;
  final FormzStatus status;
  final Map<String, List<BaseObject>> groupedFiles;
  final SortingCriterion criterion;
  final SortingDirection direction;

  OpenedFolderState(
      {this.currentFolder,
      required this.objects,
      this.sortedFiles = const [],
      this.status = FormzStatus.pure,
      this.criterion = SortingCriterion.byDateCreated,
      this.direction = SortingDirection.down,
      required this.previousFolders,
      this.groupedFiles = const {},
      this.representation = FilesRepresentation.grid});

  OpenedFolderState copyWith({
    Folder? currentFolder,
    List<BaseObject>? objects,
    List<BaseObject>? sortedFiles,
    Map<String, List<BaseObject>>? groupedFiles,
    FormzStatus? status,
    SortingDirection? direction,
    SortingCriterion? criterion,
    List<Folder>? previousFolders,
    FilesRepresentation? representation,
  }) {
    return OpenedFolderState(
      currentFolder: currentFolder ?? this.currentFolder,
      groupedFiles: groupedFiles ?? this.groupedFiles,
      status: status ?? this.status,
      criterion: criterion ?? this.criterion,
      direction: direction ?? this.direction,
      objects: objects ?? this.objects,
      sortedFiles: sortedFiles ?? this.sortedFiles,
      previousFolders: previousFolders ?? this.previousFolders,
      representation: representation ?? this.representation,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        objects,
        previousFolders,
        representation,
        groupedFiles,
        sortedFiles,
        criterion,
        direction,
        status
      ];
}

enum FilesRepresentation { grid, table }
