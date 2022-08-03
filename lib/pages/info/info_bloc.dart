import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  late FilesController _filesController;

  final SubscriptionService _subscriptionService = getIt<SubscriptionService>();
  var _subscriptionController =
      getIt<SubscriptionController>(instanceName: 'subscription_controller');

  Future _mapInfoPageOpened(
    InfoPageOpened event,
    InfoState state,
    Emitter<InfoState> emit,
  ) async {
    _filesController = await GetIt.I.getAsync<FilesController>();

    var folder = await _filesController.getFilesRootFolder();

    var allMediaFolders = await _filesController.getMediaFolders(true);
    var valueNotifier = _userController.getValueNotifier();
    var filesNotifier = _filesController.getFilesValueNotifier();
    var mediaNotifier = _filesController.getMediaValueNotifier();
    var subNotifier = _subscriptionController.getValueNotifier();
    // final rootFolder = await _filesController.getMediaRootFolder(
    //   withUpdate: true,
    // );
    // final valueListenable = _filesController
    //     .getObjectsValueListenableByFolderId(rootFolder!.folders!
    //         .firstWhere((element) => element.name == "Фото")
    //         .id);
    emit(state.copyWith(
      folder: folder,
      allMediaFolders: allMediaFolders,
      filesRootNotifier: filesNotifier,
      valueNotifier: valueNotifier,
      mediaRootNotifier: mediaNotifier,
      packetNotifier: subNotifier,
    ));
  }
}
