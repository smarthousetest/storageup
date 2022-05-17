import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

@injectable
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc(@Named('files_controller') this._filesController)
      : super(FinanceState()) {
    on<FinanceEvent>((event, emit) async {
      if (event is FinancePageOpened) {
        await _mapMediaPageOpened(event, state, emit);
      } else if (event is ChangeSubscription) {
        await _changeSubcription(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();
  FilesController _filesController;
  UserController _userController = getIt<UserController>();

  Future _mapMediaPageOpened(
    FinancePageOpened event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    User? user = await _userController.getUser;
    var sub = await _subscriptionService.getCurrentSubscription();
    var allSub = await _subscriptionService.getAllTariffs();
    var rootFolder = await _filesController.getRootFolder;
    //print(sub);
    // print(allSub);
    if (sub == null && allSub == null) {
      emit(state.copyWith(
        user: user,
        sub: sub,
        allSub: allSub,
        rootFolders: rootFolder,
      ));
    }
    emit(state.copyWith(
        user: user, sub: sub, allSub: allSub, rootFolders: rootFolder));
  }

  Future<void> _changeSubcription(
    ChangeSubscription event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    var choosedSub = event.choosedSub;

    var status = await _subscriptionService.changeSubscription(choosedSub);
    if (status == ResponseStatus.ok) {
      var updatedSubscription =
          await _subscriptionService.getCurrentSubscription();
      emit(state.copyWith(
        sub: updatedSubscription,
      ));
    }
  }
}
