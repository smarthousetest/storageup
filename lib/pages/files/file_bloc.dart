import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {

  FileBloc() : super(FileInitial());

  @override
  Stream<FileState> mapEventToState(
    FileEvent event,
  ) async* {
    if (event is FileSearchFieldChanged ){
      yield _mapSearchFieldChanged(state, event);
    }
  }

  FileState _mapSearchFieldChanged(FileState state, FileSearchFieldChanged event) {


    return state;
  }
}
