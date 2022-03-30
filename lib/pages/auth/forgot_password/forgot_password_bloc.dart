import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/pages/auth/models/email.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/auth_repository.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

@Injectable()
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState()) {
    on<ForgotPasswordEvent>((event, emit) async {
      if (event is ForgotPasswordEmailChanged) {
        _mapEmailChanged(event, state, emit);
      } else if (event is ForgotPasswordConfirmed) {
        await _mapSubmitted(event, state, emit);
      }
    });
  }

  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  void _mapEmailChanged(
    ForgotPasswordEmailChanged event,
    ForgotPasswordState state,
    Emitter<ForgotPasswordState> emit,
  ) {
    var email = Email.dirty(event.email, event.needValidation);
    //var formzEmail = Formz.validate([email]);
    emit(state.copyWith(email: email, status: Formz.validate([email])));
  }

  Future<void> _mapSubmitted(
    ForgotPasswordConfirmed event,
    ForgotPasswordState state,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    print('send email to restore password');
    try {
      final result = await _authenticationRepository.restorePassword(
          email: state.email.value);
      if (result == AuthenticationStatus.authenticated) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else if (result == AuthenticationStatus.unauthenticated) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.wrongCredentials));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.noInternet));
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
