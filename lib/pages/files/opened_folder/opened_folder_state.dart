import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/folder.dart';

class OpenedFolderState extends Equatable {
  final Folder? currentFolder;
  final List<BaseObject> objects;
  final List<Folder> previousFolders;
  final FilesRepresentation representation;

  OpenedFolderState(
      {this.currentFolder,
      required this.objects,
      required this.previousFolders,
      this.representation = FilesRepresentation.grid});

  OpenedFolderState copyWith({
    Folder? currentFolder,
    List<BaseObject>? objects,
    List<Folder>? previousFolders,
    FilesRepresentation? representation,
  }) {
    return OpenedFolderState(
      currentFolder: currentFolder ?? this.currentFolder,
      objects: objects ?? this.objects,
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
      ];
}

enum FilesRepresentation { grid, table }
