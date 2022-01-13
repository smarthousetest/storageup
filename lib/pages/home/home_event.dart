import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/enums.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomePageOpened extends HomeEvent {}

class HomeUserActionChoosed extends HomeEvent {
  final UserAction action;
  final List<String?>? values;

  HomeUserActionChoosed({
    required this.action,
    this.values,
  });
}
