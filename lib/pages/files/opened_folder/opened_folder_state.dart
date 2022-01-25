import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/folder.dart';

class OpenedFolderState extends Equatable {
  final Folder? currentFolder;
  final List<BaseObject> objects;
  final List<BaseObject> sortedFiles;
  final List<Folder> previousFolders;
  final FilesRepresentation representation;
  final FormzStatus status;
  final Map<String, List<BaseObject>> groupedFiles;

  OpenedFolderState(
      {this.currentFolder,
      required this.objects,
      this.sortedFiles = const [],
      this.status = FormzStatus.pure,
      required this.previousFolders,
      this.groupedFiles = const {},
      this.representation = FilesRepresentation.grid});

  OpenedFolderState copyWith({
    Folder? currentFolder,
    List<BaseObject>? objects,
    List<BaseObject>? sortedFiles,
    Map<String, List<BaseObject>>? groupedFiles,
    FormzStatus? status,
    List<Folder>? previousFolders,
    FilesRepresentation? representation,
  }) {
    return OpenedFolderState(
      currentFolder: currentFolder ?? this.currentFolder,
      groupedFiles: groupedFiles ?? this.groupedFiles,
      status: status ?? this.status,
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
        status
      ];
}

enum FilesRepresentation { grid, table }
