import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
  });

  FolderListState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
  }) {
    return FolderListState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
    );
  }

  @override
  List<Object?> get props => [user, locationsInfo];
}
