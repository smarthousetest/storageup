import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/packet_controllers.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

@injectable
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceState()) {
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
  var _packetController =
      getIt<PacketController>(instanceName: 'packet_controller');

  Future _mapFinancePageOpened(
    FinancePageOpened event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    User? user = await _userController.getUser;
    var sub = await _subscriptionService.getCurrentSubscription();
    var allSub = await _subscriptionService.getAllTariffs();
    var packetNotifier = _packetController.getValueNotifier();

    var valueNotifier = _userController.getValueNotifier();
    if (sub.right == ResponseStatus.declined) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        status: FormzStatus.submissionCanceled,
      ));
    } else if (sub.right == ResponseStatus.failed) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        status: FormzStatus.submissionFailure,
      ));
    }
    if (sub.left == null && allSub == null) {
      emit(state.copyWith(
        user: user,
        sub: sub.left,
        allSub: allSub,
        valueNotifier: valueNotifier,
        packetNotifier: packetNotifier,
        status: FormzStatus.pure,
      ));
    }
    emit(state.copyWith(
      user: user,
      sub: sub.left,
      allSub: allSub,
      // rootFolders: rootFolder,
      valueNotifier: valueNotifier,
      packetNotifier: packetNotifier,
      status: FormzStatus.pure,
    ));
  }

  Future<void> _changeSubcription(
    ChangeSubscription event,
    FinanceState state,
    Emitter<FinanceState> emit,
  ) async {
    var choosedSub = event.choosedSub;

    var status = await _subscriptionService.changeSubscription(choosedSub);
    if (status == ResponseStatus.ok) {
      var updatedSubscription = await _subscriptionService.getCurrentSubscription();
      emit(state.copyWith(
        sub: updatedSubscription.left,
      ));
    }
  }
}
