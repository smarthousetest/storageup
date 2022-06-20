import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';

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
  final String keeperId;
  final SpaceState state;
  const RunSoft(this.state, this.keeperId);
}

class SaveDirPath extends SpaceEvent {
  final String pathDir;
  final int countGb;
  final String name;
  SaveDirPath({
    required this.pathDir,
    required this.countGb,
    required this.name,
  });
}

class SendKeeperVersion extends SpaceEvent {
  SendKeeperVersion();
}
