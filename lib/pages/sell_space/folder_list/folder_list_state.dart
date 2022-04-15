import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper>? keeper;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
    this.keeper,
  });

  FolderListState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
  }) {
    return FolderListState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
    );
  }

  @override
  List<Object?> get props => [user, locationsInfo, keeper];
}
