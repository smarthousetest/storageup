import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class OpenedFolderCubit extends Cubit<OpenedFolderState> {
  OpenedFolderCubit()
      : super(OpenedFolderState(
          objects: [],
          previousFolders: [],
        ));

  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  void init(Folder? folder, List<Folder> previousFolders) async {
    Folder? currentFolder;
    if (folder == null) {
      await _filesController.updateFilesList();
      currentFolder = _filesController.getFilesRootFolder;
    } else {
      currentFolder = await _filesController.getFolderById(folder.id);
    }
    var objects =
        await _filesController.getContentFromFolderById(currentFolder!.id);

    emit(state.copyWith(
      currentFolder: currentFolder,
      objects: objects,
      previousFolders: previousFolders,
    ));
  }

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(representation: representation));
  }

  void setFavorite(BaseObject object) async {
    var favorite = !object.favorite;
    var res = await _filesController.setFavorite(object, favorite);
    if (res == ResponseStatus.ok) {
      _update();
    }
  }

  void _update() async {
    var objects = await _filesController
        .getContentFromFolderById(state.currentFolder!.id);

    emit(state.copyWith(
      objects: objects,
    ));
  }
}
