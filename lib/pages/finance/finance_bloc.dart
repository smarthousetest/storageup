import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

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

  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();

  UserController _userController = getIt<UserController>();

  Future _mapMediaPageOpened(
    FinancePageOpened event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    User? user = await _userController.getUser;
    var sub = await _subscriptionService.getCurrentSubscription();
    var numberSub = await _subscriptionService.getNumberTariffAll();
    //print(sub);
    print(numberSub);
    emit(state.copyWith(user: user, sub: sub, numberSub: numberSub));
  }
}
