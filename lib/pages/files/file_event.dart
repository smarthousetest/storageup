part of 'file_bloc.dart';

abstract class FileEvent extends Equatable{
  FileEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FileSearchFieldChanged extends FileEvent{
  String item_name;
  FileSearchFieldChanged(this.item_name);

  @override
  // TODO: implement props
  List<Object?> get props => [item_name];
}
