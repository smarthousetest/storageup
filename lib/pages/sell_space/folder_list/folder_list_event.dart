import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

abstract class FolderListEvent extends Equatable {
  const FolderListEvent();

  @override
  List<Object?> get props => [];
}

// class SpaceSearchFieldChanged extends SpaceEvent {
//   String itemName;
//   SpaceSearchFieldChanged(this.itemName);

//   @override
//   // TODO: implement props
//   List<Object?> get props => [itemName];
// }

class FolderListPageOpened extends FolderListEvent {
  const FolderListPageOpened();
}

class GetKeeperInfo extends FolderListEvent {
  const GetKeeperInfo();
}

class SleepStatus extends FolderListEvent {
  final Keeper keeper;

  SleepStatus({required this.keeper});
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
