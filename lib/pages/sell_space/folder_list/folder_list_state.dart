import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';

class FolderListState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper>? keeper;
  final List<Keeper> localKeeper;
  final List<Keeper> serverKeeper;
  final List<String> localPath;
  final bool sleepStatus;

  FolderListState({
    this.user,
    this.locationsInfo = const [],
    this.keeper,
    this.localKeeper = const [],
    this.serverKeeper = const [],
    this.localPath = const [],
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
      keeper: keeper ?? this.keeper,
      localKeeper: localKeeper ?? this.localKeeper,
      serverKeeper: serverKeeper ?? this.serverKeeper,
      localPath: localPath ?? this.localPath,
      sleepStatus: sleepStatus ?? this.sleepStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keeper,
        localKeeper,
        serverKeeper,
        localPath,
        sleepStatus,
      ];
}
