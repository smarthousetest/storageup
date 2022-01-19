part of 'space_bloc.dart';

abstract class SpaceEvent extends Equatable {
  SpaceEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SpaceSearchFieldChanged extends SpaceEvent {
  String itemName;
  SpaceSearchFieldChanged(this.itemName);

  @override
  // TODO: implement props
  List<Object?> get props => [itemName];
}
