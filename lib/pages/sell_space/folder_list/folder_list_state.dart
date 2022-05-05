import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper>? keeper;
  final List<Keeper> localKeeper;
  final List<Keeper> serverKeeper;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
    this.keeper,
    this.localKeeper = const [],
    this.serverKeeper = const [],
  });

  FolderListState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
    List<Keeper>? localKeeper,
    List<Keeper>? serverKeeper,
  }) {
    return FolderListState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
      localKeeper: localKeeper ?? this.localKeeper,
      serverKeeper: serverKeeper ?? this.serverKeeper,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keeper,
        localKeeper,
        serverKeeper,
      ];
}
