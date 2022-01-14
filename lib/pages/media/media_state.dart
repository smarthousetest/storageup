import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';

class MediaState extends Equatable {
  final List<Record> currentFolderRecords;
  final List<Folder> albums;
  final Folder currentFolder;
  final FilesRepresentation representation;

  MediaState({
    this.currentFolderRecords = const [],
    this.albums = const [],
    Folder? currentFolder,
    this.representation = FilesRepresentation.grid,
  }) : this.currentFolder = currentFolder ?? Folder.empty();

  MediaState copyWith(
      {List<Folder>? albums,
      Folder? currentFolder,
      List<Record>? currentFolderRecords,
      FilesRepresentation? representation}) {
    return MediaState(
      albums: albums ?? this.albums,
      currentFolder: currentFolder ?? this.currentFolder,
      currentFolderRecords: currentFolderRecords ?? this.currentFolderRecords,
      representation: representation ?? this.representation,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        albums,
        currentFolderRecords,
        representation,
      ];
}
