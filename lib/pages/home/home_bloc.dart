import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'home_event.dart';
import 'home_state.dart';


@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
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

  // HomeState _mapLoginEmailChanged(
  //     HomeState state,
  //     AuthLoginEmailChanged event,
  //     ) {
  //   // Email email = Email.dirty(event.email);
  //
  //   return state.copyWith(
  //     // emailLogin: email,
  //     // status: Formz.validate([email]),
  //   );
  // }

  // AuthState _mapRegisterEmailChanged(
  //     AuthState state,
  //     AuthRegisterEmailChanged event,
  //     ) {
  //   Email email = Email.dirty(event.email);
  //
  //   return state.copyWith(
  //     emailRegister: email,
  //     status: Formz.validate([email]),
  //   );
  }

  // AuthState _mapLoginPasswordChanged(
  //     AuthState state,
  //     AuthLoginPasswordChanged event,
  //     ) {
  //   Password password = Password.dirty(event.password);
  //
  //   return state.copyWith(
  //     passwordLogin: password,
  //     status: Formz.validate([password]),
  //   );
  // }

  // AuthState _mapRegisterPasswordChanged(
  //     AuthState state,
  //     AuthRegisterPasswordChanged event,
  //     ) {
  //   Password password = Password.dirty(event.password);
  //
  //   return state.copyWith(
  //     passwordRegister: password,
  //     status: Formz.validate([password]),
  //   );
  // }

  // AuthState _mapNameChanged(
  //     AuthState state,
  //     AuthNameChanged event,
  //     ) {
  //   Name name = Name.dirty(event.name);
  //
  //   return state.copyWith(
  //     name: name,
  //     status: Formz.validate([name]),
  //   );
  // }

  // AuthState _mapRememberMeChanged(AuthState state) {
  //   return state.copyWith(rememberMe: !state.rememberMe);
  // }
  //
  // AuthState _mapAcceptTermsOfUseChanged(AuthState state) {
  //   return state.copyWith(acceptedTermsOfUse: !state.acceptedTermsOfUse);
  // }

  // Stream<AuthState> _mapLoginSubmitted(
  //     AuthLoginConfirmed event,
  //     AuthState state,
  //     ) async* {
  //   if (state.status.isValidated) {
  //     yield state.copyWith(status: FormzStatus.submissionInProgress);
  //     try {
  //       final result = await _authenticationRepository.logIn(
  //         email: state.emailLogin.value,
  //         password: state.passwordLogin.value,
  //       );
  //       if (result == AuthenticationStatus.authenticated) {
  //         yield state.copyWith(status: FormzStatus.submissionSuccess);
  //       } else if (result == AuthenticationStatus.wrongPassword) {
  //         yield state.copyWith(
  //           status: FormzStatus.submissionFailure,
  //           error: AuthError.wrongCredentials,
  //         );
  //       } else {
  //         yield state.copyWith(status: FormzStatus.submissionFailure);
  //       }
  //     } on Exception catch (_) {
  //       yield state.copyWith(status: FormzStatus.submissionFailure);
  //     }
  //   }
  // }
// }
