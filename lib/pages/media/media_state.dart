import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';

class MediaState extends Equatable {
  final List<Record> currentFolderRecords;
  final List<Folder> albums;
  final Folder currentFolder;

  MediaState({
    this.currentFolderRecords = const [],
    this.albums = const [],
    Folder? currentFolder,
  }) : this.currentFolder = currentFolder ?? Folder.empty();

  MediaState copyWith({
    List<Folder>? albums,
    Folder? currentFolder,
    List<Record>? currentFolderRecords,
  }) {
    return MediaState(
      albums: albums ?? this.albums,
      currentFolder: currentFolder ?? this.currentFolder,
      currentFolderRecords: currentFolderRecords ?? this.currentFolderRecords,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        albums,
        currentFolderRecords,
      ];
}
