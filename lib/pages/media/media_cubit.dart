import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState());

  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  void init() async {
    var allMediaFolders = await _filesController.getMediaFolders(true);
    var currentFolder =
        allMediaFolders?.firstWhere((element) => element.id == '-1');
    emit(state.copyWith(
      albums: allMediaFolders,
      currentFolder: currentFolder,
      currentFolderRecords: currentFolder?.records,
    ));
  }
}
