import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceState());

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
