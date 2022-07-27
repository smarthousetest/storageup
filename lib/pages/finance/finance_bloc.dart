import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/finance/finance_event.dart';
import 'package:storageup/pages/finance/finance_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/subscription_controllers.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/services/subscription_service.dart';

@injectable
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc(@Named('files_controller') FilesController filesController)
      : super(FinanceState()) {
    on<FinanceEvent>((event, emit) async {
      if (event is FinancePageOpened) {
        await _mapFinancePageOpened(event, state, emit);
      } else if (event is ChangeSubscription) {
        await _changeSubcription(event, state, emit);
      }
    });
  }

  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();

  UserController _userController = getIt<UserController>();
  var _subscriptionController =
      getIt<SubscriptionController>(instanceName: 'subscription_controller');

  Future _mapFinancePageOpened(
    FinancePageOpened event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    User? user = await _userController.getUser;
    var sub = await _subscriptionService.getCurrentSubscription();
    var allSub = await _subscriptionService.getAllTariffs();
    var packetNotifier = _subscriptionController.getValueNotifier();

    var valueNotifier = _userController.getValueNotifier();
    if (sub.right == ResponseStatus.declined) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        statusHttpRequest: FormzStatus.submissionCanceled,
      ));
    } else if (sub.right == ResponseStatus.failed) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        statusHttpRequest: FormzStatus.submissionFailure,
      ));
    }
    if (sub.left == null && allSub == null) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        statusHttpRequest: FormzStatus.pure,
      ));
    }
    emit(state.copyWith(
      user: user,
      sub: sub.left,
      allSub: allSub,
      // rootFolders: rootFolder,
      valueNotifier: valueNotifier,
      packetNotifier: packetNotifier,
      statusHttpRequest: FormzStatus.pure,
    ));
  }

  Future<void> _changeSubcription(
    ChangeSubscription event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    var choosedSub = event.choosedSub;
    emit(state.copyWith(
      statusHttpRequest: FormzStatus.pure,
    ));
    var status = await _subscriptionService.changeSubscription(choosedSub);
    if (status == ResponseStatus.ok) {
      var updatedSubscription =
          await _subscriptionService.getCurrentSubscription();
      await _subscriptionController.updateSubscription();
      emit(state.copyWith(
        sub: updatedSubscription.left,
        statusHttpRequest: FormzStatus.pure,
      ));
    } else if (status == ResponseStatus.declined) {
      emit(state.copyWith(
        statusHttpRequest: FormzStatus.submissionCanceled,
      ));
    } else if (status == ResponseStatus.failed) {
      emit(state.copyWith(
        statusHttpRequest: FormzStatus.submissionFailure,
      ));
    }
  }
}
