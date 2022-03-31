import 'package:equatable/equatable.dart';
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

class DeleteLocation extends FolderListEvent {
  DownloadLocation location;
  DeleteLocation({required this.location});
}
