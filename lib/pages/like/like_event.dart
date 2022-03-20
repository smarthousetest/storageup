part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  LikeEvent();
  @override
  List<Object?> get props => [];
}

class LikeSearchFieldChanged extends LikeEvent {
  String itemName;
  LikeSearchFieldChanged(this.itemName);

  @override
  List<Object?> get props => [itemName];
}
