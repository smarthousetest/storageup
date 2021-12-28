import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/media/media_event.dart';
import 'package:upstorage_desktop/pages/media/media_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc() : super(MediaState()) {
    on<MediaEvent>((event, emit) async {
      if (event is MediaPageOpened) {
        await _mapMediaPageOpened(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();

  Future _mapMediaPageOpened(
    MediaPageOpened event,
    MediaState state,
    Emitter<MediaState> emit,
  ) async {
    User? user = await _userController.getUser;
    emit(state.copyWith(user: user));
  }
}
