import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/download_location.dart';
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

class GetPathToKeeper extends SpaceEvent {
  final String? pathForChange;
  const GetPathToKeeper({this.pathForChange});
}

class ChangeKeeper extends SpaceEvent {
  final int countGb;
  final DownloadLocation keeper;
  ChangeKeeper({
    required this.countGb,
    required this.keeper,
  });
}

class RunSoft extends SpaceEvent {
  final String keeperId;
  final SpaceState state;
  const RunSoft(this.state, this.keeperId);
}

class NameChanged extends SpaceEvent {
  final String name;
  final bool needValidation;

  NameChanged({
    required this.name,
    this.needValidation = false,
  });

  @override
  List<Object?> get props => [name];
}

class SaveDirPath extends SpaceEvent {
  final String pathDir;
  final int countGb;

  SaveDirPath({
    required this.pathDir,
    required this.countGb,
  });
}

class SendKeeperVersion extends SpaceEvent {
  SendKeeperVersion();
}
