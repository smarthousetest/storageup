import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'space_event.dart';
part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceInitial());

  @override
  Stream<SpaceState> mapEventToState(
    SpaceEvent event,
  ) async* {
    if (event is SpaceSearchFieldChanged) {
      yield _mapSearchFieldChanged(state, event);
    }
  }

  SpaceState _mapSearchFieldChanged(
      SpaceState state, SpaceSearchFieldChanged event) {
    return state;
  }
}
