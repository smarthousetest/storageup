import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'like_event.dart';

part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeInitial());

  @override
  Stream<LikeState> mapEventToState(
    LikeEvent event,
  ) async* {
    if (event is LikeSearchFieldChanged) {
      yield _mapSearchFieldChanged(state, event);
    }
  }

  LikeState _mapSearchFieldChanged(
    LikeState state,
    LikeSearchFieldChanged event,
  ) {
    return state;
  }
}
