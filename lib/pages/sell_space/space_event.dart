import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

abstract class SpaceEvent extends Equatable {
  const SpaceEvent();
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

class SpacePageOpened extends SpaceEvent {
  const SpacePageOpened();
}

class RunSoft extends SpaceEvent {
  const RunSoft();
}

class SaveDirPath extends SpaceEvent {
  String pathDir;
  int countGb;
  String name;
  SaveDirPath({
    required this.pathDir,
    required this.countGb,
    required this.name,
  });
}
