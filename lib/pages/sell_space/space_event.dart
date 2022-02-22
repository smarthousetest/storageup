import 'package:equatable/equatable.dart';

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
  final List<String>? dirPath;
  List<int> countGb;
  SaveDirPath({
    required this.dirPath,
    required this.countGb,
  });
}
