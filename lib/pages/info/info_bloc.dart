import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/info/info_event.dart';
import 'package:storageup/pages/info/info_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/packet_controllers.dart';
import 'package:storageup/utilities/controllers/user_controller.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/services/subscription_service.dart';

@Injectable()
class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoState()) {
    on<InfoEvent>((event, emit) async {
      if (event is InfoPageOpened) {
        await _mapInfoPageOpened(event, state, emit);
      }
    });
  }
  // final AuthenticationRepository _authenticationRepository =
  // getIt<AuthenticationRepository>();

  UserController _userController = getIt<UserController>();
  late FilesController _filesController;
  var _packetController =
      getIt<PacketController>(instanceName: 'packet_controller');
  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();
  Future _mapInfoPageOpened(
    InfoPageOpened event,
    InfoState state,
    Emitter<InfoState> emit,
  ) async {
    _filesController = await GetIt.I.getAsync<FilesController>();

    var folder = await _filesController.getFilesRootFolder();
    var sub = await _subscriptionService.getCurrentSubscription();
    var allMediaFolders = await _filesController.getMediaFolders(true);
    //var packetInfo = await _subscriptionService.getPacketInfo();
    var valueNotifier = _userController.getValueNotifier();
    var packetNotifier = _packetController.getValueNotifier();
    emit(state.copyWith(
      folder: folder,
      allMediaFolders: allMediaFolders,
      sub: sub.left,
      packetNotifier: packetNotifier,
      valueNotifier: valueNotifier,
    ));
  }
}
