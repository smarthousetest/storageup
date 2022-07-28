import 'package:equatable/equatable.dart';
import 'package:storageup/models/download_location.dart';
import 'package:storageup/models/keeper/keeper.dart';

abstract class FolderListEvent extends Equatable {
  const FolderListEvent();

  @override
  List<Object?> get props => [];
}

class FolderListPageOpened extends FolderListEvent {
  const FolderListPageOpened();
}

class GetKeeperInfo extends FolderListEvent {
  const GetKeeperInfo();
}

class SleepStatus extends FolderListEvent {
  final Keeper keeper;
  final bool sleepStatus;

  SleepStatus({required this.keeper, required this.sleepStatus});
}

class DeleteLocation extends FolderListEvent {
  final DownloadLocation location;

  DeleteLocation({required this.location});
}

class UpdateLocationsList extends FolderListEvent {
  final List<DownloadLocation> locations;

  UpdateLocationsList({required this.locations});

  @override
  List<Object?> get props => [locations];
}

class KeeperReboot extends FolderListEvent {
  final DownloadLocation location;

  KeeperReboot({required this.location});
}
