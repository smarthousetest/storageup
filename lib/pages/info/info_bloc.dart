import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/info/info_event.dart';
import 'package:storageup/pages/info/info_state.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/subscription_controllers.dart';
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
  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();
  var _subscriptionController =
      getIt<SubscriptionController>(instanceName: 'subscription_controller');

  Future _mapInfoPageOpened(
    InfoPageOpened event,
    InfoState state,
    Emitter<InfoState> emit,
  ) async {
    User? user = await _userController.getUser;
    await _filesController.updateFilesList();
    var folder = await _filesController.getRootFolder;
    var sub = await _subscriptionService.getCurrentSubscription();
    //await _packetController.updatePacket();
    var allMediaFolders = await _filesController.getMediaFolders(true);
    var valueNotifier = _userController.getValueNotifier();
    var filesNotifier = _filesController.getFilesValueNotifier();
    var mediaNotifier = _filesController.getMediaValueNotifier();
    var subscriptionNotifier = _subscriptionController.getValueNotifier();
    emit(state.copyWith(
      user: user,
      folder: folder,
      allMediaFolders: allMediaFolders,
      sub: sub.left,
      filesRootNotifier: filesNotifier,
      mediaRootNotifier: mediaNotifier,
      valueNotifier: valueNotifier,
      packetNotifier: subscriptionNotifier,
    ));
  }
}
