import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/folder.dart';

class MoveState extends Equatable {
  final List<Folder> folders;
  final Folder currentFolder;
  final List<Folder>? foldersInFolder;

  MoveState({
    this.folders = const [],
    this.foldersInFolder = const [],
    Folder? currentFolder,
  }) : this.currentFolder = currentFolder ?? Folder.empty();

  MoveState copyWith({
    List<Folder>? folders,
    List<Folder>? foldersInFolder,
    Folder? currentFolder,
  }) {
    return MoveState(
      folders: folders ?? this.folders,
      foldersInFolder: foldersInFolder ?? this.foldersInFolder,
      currentFolder: currentFolder ?? this.currentFolder,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        folders,
        foldersInFolder,
      ];
}
