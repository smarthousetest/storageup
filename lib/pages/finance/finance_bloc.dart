import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceState()) {
    on<FinanceEvent>((event, emit) async {
      if (event is FinancePageOpened) {
        await _mapMediaPageOpened(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();

  Future _mapMediaPageOpened(
    FinancePageOpened event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    User? user = await _userController.getUser;
    emit(state.copyWith(user: user));
  }
}
