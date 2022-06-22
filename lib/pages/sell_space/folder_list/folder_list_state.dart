import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper>? keepers;
  final List<Keeper> localKeepers;
  final List<Keeper> serverKeepers;
  final List<String> localPaths;
  final bool sleepStatus;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
    this.keepers,
    this.localKeepers = const [],
    this.serverKeepers = const [],
    this.localPaths = const [],
    this.sleepStatus = true,
  });

  FolderListState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
    List<Keeper>? localKeeper,
    List<Keeper>? serverKeeper,
    List<String>? localPath,
    bool? sleepStatus,
  }) {
    return FolderListState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keepers: keeper ?? this.keepers,
      localKeepers: localKeeper ?? this.localKeepers,
      serverKeepers: serverKeeper ?? this.serverKeepers,
      localPaths: localPath ?? this.localPaths,
      sleepStatus: sleepStatus ?? this.sleepStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keepers,
        localKeepers,
        serverKeepers,
        localPaths,
        sleepStatus,
      ];
}
