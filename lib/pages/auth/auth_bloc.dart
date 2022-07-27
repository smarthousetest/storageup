import 'dart:convert';
import 'dart:typed_data';

import 'package:cpp_native/cpp_native.dart';
import 'package:cpp_native/file_proc/encryption.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/models/email.dart';
import 'package:storageup/pages/auth/models/name.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/auth_repository.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'models/password.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on((event, emit) async {
      if (event is AuthLoginEmailChanged) {
        _mapLoginEmailChanged(state, event, emit);
      } else if (event is AuthLoginPasswordChanged) {
        _mapLoginPasswordChanged(state, event, emit);
      } else if (event is AuthRegisterEmailChanged) {
        _mapRegisterEmailChanged(state, event, emit);
      } else if (event is AuthRegisterPasswordChanged) {
        _mapRegisterPasswordChanged(state, event, emit);
      } else if (event is AuthNameChanged) {
        _mapNameChanged(state, event, emit);
      } else if (event is AuthAcceptTermsOfUseChanged) {
        _mapAcceptTermsOfUseChanged(state, emit);
      } else if (event is AuthRememberMeChanged) {
        _mapRememberMeChanged(state, emit);
      } else if (event is AuthLoginConfirmed) {
        await _mapLoginSubmitted(event, state, emit);
      } else if (event is AuthRegisterConfirmed) {
        await _mapRegisterSubmitted(event, state, emit);
      } else if (event is AuthClear) {
        _mapClear(state, emit);
      } else if (event is AuthSendEmailVerify) {
        _mapEmailVerify(state, emit);
      } else if (event is AuthPageOpened) {
        await _mapOpened(state, emit);
      }
    });
  }

  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  void _mapLoginEmailChanged(
    AuthState state,
    AuthLoginEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    Email email = Email.dirty(event.email, event.needValidation);

    emit(state.copyWith(
      emailLogin: email,
      status: Formz.validate([email]),
    ));
  }

  void _mapRegisterEmailChanged(
    AuthState state,
    AuthRegisterEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    Email email = Email.dirty(event.email, event.needValidation);

    emit(state.copyWith(
      emailRegister: email,
      status: Formz.validate([email]),
    ));
  }

  void _mapLoginPasswordChanged(
    AuthState state,
    AuthLoginPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    Password password = Password.dirty(event.password, event.needValidation);

    emit(state.copyWith(
      passwordLogin: password,
      status: Formz.validate([password]),
    ));
  }

  void _mapRegisterPasswordChanged(
    AuthState state,
    AuthRegisterPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    Password password = Password.dirty(event.password, event.needValidation);

    emit(state.copyWith(
      passwordRegister: password,
      status: Formz.validate([password]),
    ));
  }

  void _mapNameChanged(
    AuthState state,
    AuthNameChanged event,
    Emitter<AuthState> emit,
  ) {
    Name name = Name.dirty(event.name, event.needValidation);

    emit(state.copyWith(
      name: name,
      status: Formz.validate([name]),
    ));
  }

  void _mapRememberMeChanged(
    AuthState state,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void _mapAcceptTermsOfUseChanged(
    AuthState state,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(acceptedTermsOfUse: !state.acceptedTermsOfUse));
  }

  void _mapClear(
    AuthState state,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      emailRegister: Email.pure(),
      passwordRegister: Password.pure(),
      name: Name.pure(),
      status: FormzStatus.pure,
      action: null,
      error: null,
    ));
  }

  void _mapEmailVerify(
    AuthState state,
    Emitter<AuthState> emit,
  ) {
    _authenticationRepository.sendEmailConfirm();
    emit(state);
  }

  Future<void> _mapLoginSubmitted(
    AuthLoginConfirmed event,
    AuthState state,
    Emitter<AuthState> emit,
  ) async {
    print(state.status.isValidated);
    if (state.status.isValidated) {
      var plainPwd = state.passwordLogin.value;
      var hashedPassword = aesCbcEncrypt(
        // Encrypting password
        passphraseToKey(state.emailLogin.value, bitLength: 128),
        Uint8List.fromList(IV.codeUnits),
        pad(
          utf8.encode(plainPwd) as Uint8List,
          128,
        ),
      );
      var os = OsSpecifications.getOs();
      os.setKeeperHash(state.emailLogin.value, hashedPassword);

      emit(state.copyWith(
          status: FormzStatus.submissionInProgress,
          action: RequestedAction.login));
      print('authorization in progress');
      try {
        final result = await _authenticationRepository.logIn(
          email: state.emailLogin.value,
          password: state.passwordLogin.value,
          isNeedSave: state.rememberMe,
        );
        if (result == AuthenticationStatus.authenticated) {
          // await _filesController.clearLocalDatabase();
          // await _filesController.initDatabase();
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              action: RequestedAction.login));
        } else if (result == AuthenticationStatus.wrongPassword) {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.wrongCredentials,
            action: RequestedAction.login,
          ));
        } else if (result == AuthenticationStatus.notVerifiedEmail) {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.noVerifiedEmail,
            action: RequestedAction.login,
          ));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            action: RequestedAction.login,
          ));
        }
      } on Exception catch (_) {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          action: RequestedAction.login,
        ));
      }
    }
  }

  Future<void> _mapRegisterSubmitted(
    AuthRegisterConfirmed event,
    AuthState state,
    Emitter<AuthState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress,
          action: RequestedAction.registration));

      print('registration in progress');
      try {
        final result = await _authenticationRepository.register(
          email: state.emailRegister.value,
          password: state.passwordRegister.value,
        );
        if (result == AuthenticationStatus.authenticated) {
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else if (result == AuthenticationStatus.emailAllreadyRegistered) {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.emailAlreadyRegistered,
            action: RequestedAction.registration,
          ));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            action: RequestedAction.registration,
          ));
        }
      } on Exception catch (_) {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          action: RequestedAction.registration,
        ));
      }
    }
  }

  Future<void> _mapOpened(AuthState state, Emitter<AuthState> emit) async {
    var token = await _tokenRepository.getApiToken();

    if (token != null && token.isNotEmpty) {
      var result = await _authenticationRepository.updateUserInfo();
      if (result == AuthenticationStatus.authenticated) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            action: RequestedAction.login));
      }
    }
  }
}
