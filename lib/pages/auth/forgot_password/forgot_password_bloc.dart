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
  ForgotPasswordBloc() : super(ForgotPasswordState());
  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordEmailChanged) {
      yield _mapEmailChanged(event, state);
    } else if (event is ForgotPasswordConfirmed) {
      yield* _mapSubmitted(event, state);
    }
  }

  ForgotPasswordState _mapEmailChanged(
    ForgotPasswordEmailChanged event,
    ForgotPasswordState state,
  ) {
    var email = Email.dirty(event.email, event.needValidation);
    return state.copyWith(
      email: email,
      status: Formz.validate([email]),
    );
  }

  Stream<ForgotPasswordState> _mapSubmitted(
    ForgotPasswordConfirmed event,
    ForgotPasswordState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    print('send email to restore password');
    try {
      final result = await _authenticationRepository.restorePassword(
          email: state.email.value);
      if (result == AuthenticationStatus.authenticated) {
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } else {
        yield state.copyWith(
            status: FormzStatus.submissionFailure,
            error: AuthError.wrongCredentials);
      }
    } on Exception catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
