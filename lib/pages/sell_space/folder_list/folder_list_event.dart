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

class SleepStatus extends FolderListEvent {
  Keeper keeper;
  SleepStatus({required this.keeper});
}

class DeleteLocation extends FolderListEvent {
  DownloadLocation location;
  DeleteLocation({required this.location});
}

class UpdateLocationsList extends FolderListEvent {
  List<DownloadLocation> locations;

  UpdateLocationsList({required this.locations});

  @override
  List<Object?> get props => [locations];
}
