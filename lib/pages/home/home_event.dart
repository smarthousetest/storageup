import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
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
  final String? folderId;
  final ChoosedPage? choosedPage;

  HomeUserActionChoosed({
    required this.action,
    this.values,
    this.folderId,
    this.choosedPage,
  });
}
