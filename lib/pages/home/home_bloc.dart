import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'home_event.dart';
import 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeUserActionChoosed>((event, emit) async {
      switch (event.action) {
        case UserAction.uploadFiles:
          _uploadFiles(event, emit);
          break;
        case UserAction.createFolder:
          await _createFolder(event, emit);
          break;
        case UserAction.createAlbum:
          await _cerateAlbum(event, emit);
          break;
        default:
          break;
      }
    });

    on<HomePageOpened>((event, emit) async {
      getApplicationDocumentsDirectory().then((value) {
        Hive.init(value.path);
        print('Hive initialized');
      });
    });
  }

  var _loadController = getIt<LoadController>();
  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  Future<void> _uploadFiles(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    if (event.values != null) {
      for (int i = 0; i < event.values!.length; i++) {
        await _loadController.uploadFile(filePath: event.values![i]);
      }
    }
  }

  Future<void> _createFolder(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    var filesRootFolder = _filesController.getFilesRootFolder;
    if (event.values?.first != null && filesRootFolder != null) {
      _filesController.createFolder(event.values!.first!, filesRootFolder.id);
    }
  }

  Future<void> _cerateAlbum(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    var mediaRootFolderId = _filesController.getMediaRootFolderId();
    if (event.values?.first != null && mediaRootFolderId != null) {
      _filesController.createFolder(event.values!.first!, mediaRootFolderId);
    }
  }
}
