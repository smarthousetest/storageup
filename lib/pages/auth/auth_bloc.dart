import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/pages/auth/models/email.dart';
import 'package:upstorage_desktop/pages/auth/models/name.dart';
import 'package:upstorage_desktop/utilites/enums.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'models/password.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState());
  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLoginEmailChanged) {
      yield _mapLoginEmailChanged(state, event);
    } else if (event is AuthLoginPasswordChanged) {
      yield _mapLoginPasswordChanged(state, event);
    } else if (event is AuthRegisterEmailChanged) {
      yield _mapRegisterEmailChanged(state, event);
    } else if (event is AuthRegisterPasswordChanged) {
      yield _mapRegisterPasswordChanged(state, event);
    } else if (event is AuthNameChanged) {
      yield _mapNameChanged(state, event);
    } else if (event is AuthAcceptTermsOfUseChanged) {
      yield _mapAcceptTermsOfUseChanged(state);
    } else if (event is AuthRememberMeChanged) {
      yield _mapRememberMeChanged(state);
    } else if (event is AuthLoginConfirmed) {
      yield* _mapLoginSubmitted(event, state);
    } else if (event is AuthRegisterConfirmed) {
      yield* _mapRegisterSubmitted(event, state);
    } else if (event is AuthClear) {
      yield _mapClear(state);
    } else if (event is AuthSendEmailVerify) {
      yield _mapEmailVerify(state);
    }
  }

  AuthState _mapLoginEmailChanged(
    AuthState state,
    AuthLoginEmailChanged event,
  ) {
    Email email = Email.dirty(event.email, event.needValidation);

    return state.copyWith(
      emailLogin: email,
      status: Formz.validate([email]),
    );
  }

  AuthState _mapRegisterEmailChanged(
    AuthState state,
    AuthRegisterEmailChanged event,
  ) {
    Email email = Email.dirty(event.email, event.needValidation);

    return state.copyWith(
      emailRegister: email,
      status: Formz.validate([email]),
    );
  }

  AuthState _mapLoginPasswordChanged(
    AuthState state,
    AuthLoginPasswordChanged event,
  ) {
    Password password = Password.dirty(event.password, event.needValidation);

    return state.copyWith(
      passwordLogin: password,
      status: Formz.validate([password]),
    );
  }

  AuthState _mapRegisterPasswordChanged(
    AuthState state,
    AuthRegisterPasswordChanged event,
  ) {
    Password password = Password.dirty(event.password, event.needValidation);

    return state.copyWith(
      passwordRegister: password,
      status: Formz.validate([password]),
    );
  }

  AuthState _mapNameChanged(
    AuthState state,
    AuthNameChanged event,
  ) {
    Name name = Name.dirty(event.name, event.needValidation);

    return state.copyWith(
      name: name,
      status: Formz.validate([name]),
    );
  }

  AuthState _mapRememberMeChanged(AuthState state) {
    return state.copyWith(rememberMe: !state.rememberMe);
  }

  AuthState _mapAcceptTermsOfUseChanged(AuthState state) {
    return state.copyWith(acceptedTermsOfUse: !state.acceptedTermsOfUse);
  }

  AuthState _mapClear(AuthState state) {
    return state.copyWith(
      emailRegister: Email.pure(),
      passwordRegister: Password.pure(),
      name: Name.pure(),
      status: FormzStatus.pure,
      action: null,
      error: null,
    );
  }

  AuthState _mapEmailVerify(AuthState state) {
    _authenticationRepository.sendEmailConfirm();
    return state;
  }

  Stream<AuthState> _mapLoginSubmitted(
    AuthLoginConfirmed event,
    AuthState state,
  ) async* {
    print(state.status.isValidated);
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final result = await _authenticationRepository.logIn(
          email: state.emailLogin.value,
          password: state.passwordLogin.value,
        );
        if (result == AuthenticationStatus.authenticated) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else if (result == AuthenticationStatus.wrongPassword) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.wrongCredentials,
            action: RequestedAction.login,
          );
        } else {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            action: RequestedAction.login,
          );
        }
      } on Exception catch (_) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          action: RequestedAction.login,
        );
      }
    }
  }

  Stream<AuthState> _mapRegisterSubmitted(
    AuthRegisterConfirmed event,
    AuthState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      print('registration in progress');
      try {
        final result = await _authenticationRepository.register(
          email: state.emailRegister.value,
          password: state.passwordRegister.value,
        );
        if (result == AuthenticationStatus.authenticated) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else if (result == AuthenticationStatus.emailAllreadyRegistered) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.emailAlreadyRegistered,
            action: RequestedAction.registration,
          );
        } else {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
            action: RequestedAction.registration,
          );
        }
      } on Exception catch (_) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          action: RequestedAction.registration,
        );
      }
    }
  }
}
