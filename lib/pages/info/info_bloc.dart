import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/info/info_event.dart';
import 'package:upstorage_desktop/pages/info/info_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/services/subscription_service.dart';

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
  Future _mapInfoPageOpened(
    InfoPageOpened event,
    InfoState state,
    Emitter<InfoState> emit,
  ) async {
    User? user = await _userController.getUser;
    await _filesController.updateFilesList();
    var folder = _filesController.getFilesRootFolder;
    var sub = await _subscriptionService.getCurrentSubscription();
    var allMediaFolders = await _filesController.getMediaFolders(true);
    var packetInfo = await _subscriptionService.getPacketInfo();
    var valueNotifier = _userController.getValueNotifier();
    emit(state.copyWith(
      user: user,
      folder: folder,
      allMediaFolders: allMediaFolders,
      sub: sub,
      packetInfo: packetInfo,
      valueNotifier: valueNotifier,
    ));
  }
}
