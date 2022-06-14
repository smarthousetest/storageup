import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/record.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomePageOpened extends HomeEvent {}

class FileTapped extends HomeEvent {
  final Record record;
  FileTapped({required this.record});
}

class HomeUserActionChoosed extends HomeEvent {
  final UserAction action;
  final List<String?>? values;
  final String? folderId;

  HomeUserActionChoosed({
    required this.action,
    this.values,
    this.folderId,
  });
}
