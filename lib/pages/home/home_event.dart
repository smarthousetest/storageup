import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:storageup/models/enums.dart';

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

class UpdateRemoteVersion extends HomeEvent {
  final String localVersion;
  final String remoteVersion;

  const UpdateRemoteVersion({
    required this.localVersion,
    required this.remoteVersion,
  });
}
