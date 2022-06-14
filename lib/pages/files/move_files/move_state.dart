import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/folder.dart';

class MoveState extends Equatable {
  final List<Folder> folders;
  final Folder currentFolder;
  final Map<String, List<Folder>?> childFolders;

  MoveState({
    this.folders = const [],
    Map<String, List<Folder>?>? childFolders,
    Folder? currentFolder,
  })  : this.currentFolder = currentFolder ?? Folder.empty(),
        this.childFolders = childFolders ?? Map();

  MoveState copyWith({
    List<Folder>? folders,
    Map<String, List<Folder>?>? childFolders,
    Folder? currentFolder,
  }) {
    return MoveState(
      folders: folders ?? this.folders,
      childFolders: childFolders ?? this.childFolders,
      currentFolder: currentFolder ?? this.currentFolder,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        folders,
        childFolders,
      ];
}
