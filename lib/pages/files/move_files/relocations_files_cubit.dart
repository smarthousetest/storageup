import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/move_files/relocations_files_state.dart';
import 'package:upstorage_desktop/pages/home/home_bloc.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class MoveCubit extends Cubit<MoveState> {
  MoveCubit() : super(MoveState());

  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  void init() async {
    var allFolders =
        _filesController.getFilesRootFolder?.folders?.reversed.toList();
    // var currentFolder = allFolders?.firstWhere((element) => element.id == '-1');

    emit(state.copyWith(
      folders: allFolders,
      // currentFolder: currentFolder,
    ));

    // List<Record> allMedia = [];
    // for (int i = 1; i < allFolders!.length; i++) {
    //   allMedia.addAll(allFolders[i].records!);
    // }
  }

  Future<void> createFolder(String name, Folder? moveToFolder) async {
    if (moveToFolder == null) {
      moveToFolder = _filesController.getFilesRootFolder;
    }
    await _filesController.createFolder(name, moveToFolder!.id);

    await _filesController.updateFilesList();
    var allFolders =
        _filesController.getFilesRootFolder?.folders?.reversed.toList();

    emit(state.copyWith(
      folders: allFolders,
    ));

    eventBusUpdateFolder.fire(UpdateFolderEvent);
  }

  getFolderById(Folder folder) async {
    var curFolder = await _filesController.getFolderById(folder.id);
    emit(state.copyWith(
      foldersInFolder: curFolder?.folders,
    ));
  }
}
