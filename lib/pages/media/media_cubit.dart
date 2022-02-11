import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/user_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState());

  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  UserController _userController = getIt<UserController>();

  void init() async {
    var allMediaFolders = await _filesController.getMediaFolders(true);
    var currentFolder =
        allMediaFolders?.firstWhere((element) => element.id == '-1');
    User? user = await _userController.getUser;
    emit(state.copyWith(
        albums: allMediaFolders,
        currentFolder: currentFolder,
        currentFolderRecords: currentFolder?.records,
        user: user));
  }

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(representation: representation));
  }

  void setFavorite(Record object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      _update();
    }
  }

  Future<void> _update() async {
    await _filesController.updateFilesList();

    var albums = await _filesController.getMediaFolders(true);
    var updatedChoosedFolder =
        albums?.firstWhere((element) => element.id == state.currentFolder.id);

    emit(state.copyWith(
      albums: albums,
      currentFolder: updatedChoosedFolder,
      currentFolderRecords: updatedChoosedFolder?.records,
    ));
  }

  void changeFolder(Folder newFolder) async {
    emit(
      state.copyWith(
        currentFolder: newFolder,
        currentFolderRecords: newFolder.records,
      ),
    );
  }
}
