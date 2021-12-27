import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/pages/info/info_event.dart';
import 'package:upstorage_desktop/pages/info/info_state.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

@Injectable()
class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoState());
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  @override
  Stream<InfoState> mapEventToState(InfoEvent event) async* {
    // if (event is AuthLoginEmailChanged) {
    //   yield _mapLoginEmailChanged(state, event);
    // } else if (event is AuthLoginPasswordChanged) {
    //   yield _mapLoginPasswordChanged(state, event);
    // } else if (event is AuthRegisterEmailChanged) {
    //   yield _mapRegisterEmailChanged(state, event);
    // } else if (event is AuthRegisterPasswordChanged) {
    //   yield _mapRegisterPasswordChanged(state, event);
    // } else if (event is AuthNameChanged) {
    //   yield _mapNameChanged(state, event);
    // } else if (event is AuthAcceptTermsOfUseChanged) {
    //   yield _mapAcceptTermsOfUseChanged(state);
    // } else if (event is AuthRememberMeChanged) {
    //   yield _mapRememberMeChanged(state);
    // } else if (event is AuthLoginConfirmed) {
    //   yield* _mapLoginSubmitted(event, state);
    // }
  }
}
