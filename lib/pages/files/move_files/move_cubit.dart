import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/move_files/move_state.dart';
import 'package:upstorage_desktop/pages/home/home_bloc.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class MoveCubit extends Cubit<MoveState> {
  MoveCubit() : super(MoveState());

  FilesController _filesController =
      getIt<FilesController>(instanceName: 'files_controller');

  void init() async {
    var rootFolder = _filesController.getFilesRootFolder;
    List<Folder> allFolders = [];
    if (rootFolder != null) allFolders.add(rootFolder);

    emit(state.copyWith(
      folders: allFolders,
    ));
  }

  Future<void> createFolder(
    String name,
    Folder? moveToFolder,
    List<Folder>? moveFolder,
  ) async {
    if (moveToFolder == null) {
      moveToFolder = _filesController.getFilesRootFolder;
    }

    await _filesController.createFolder(name, moveToFolder!.id);

    await _filesController.updateFilesList();
    // var rootFolder = _filesController.getFilesRootFolder;
    var childFolders = Map<String, List<Folder>?>.from(state.childFolders);
    var curFolder = await _filesController.getFolderById(moveToFolder.id);

    if (moveFolder != null) {
      var toRemove = [];

      curFolder?.folders?.forEach((a) {
        if (moveFolder.any((b) => a == b)) {
          toRemove.add(a);
        }
      });
      curFolder?.folders?.removeWhere((e) => toRemove.contains(e));
    }

    childFolders[moveToFolder.id] = curFolder?.folders;

    // List<Folder> allFolders = [];
    // if (rootFolder != null) allFolders.add(rootFolder);

    emit(state.copyWith(
        // folders: allFolders,
        childFolders: childFolders));

    eventBusUpdateFolder.fire(UpdateFolderEvent);
  }

  List<Folder> mapSortedFieldChanged(String sortText) {
    final allFolders = state.folders;

    List<Folder> sortedFolders = [];
    var textLoverCase = sortText.toLowerCase();

    allFolders.forEach((element) {
      if ((element.createdAt != null) ||
          (element.name != null &&
              element.name!.toLowerCase().contains(textLoverCase))) {
        sortedFolders.add(element);
      }
    });

    //emit(state.copyWith(folders: sortedFolders));

    return sortedFolders;
  }

  Future<void> getFolderById(
    Folder folder,
    List<Folder>? moveFolder,
  ) async {
    var childFolders = Map<String, List<Folder>?>.from(state.childFolders);
    if (childFolders.containsKey(folder.id)) {
      childFolders.remove(folder.id);
      emit(state.copyWith(
        childFolders: childFolders,
      ));
    } else {
      var curFolder = await _filesController.getFolderById(folder.id);
      if (moveFolder != null) {
        var toRemove = [];

        curFolder?.folders?.forEach((a) {
          if (moveFolder.any((b) => a == b)) {
            toRemove.add(a);
          }
        });
        curFolder?.folders?.removeWhere((e) => toRemove.contains(e));
      }

      childFolders[folder.id] = curFolder?.folders;

      emit(state.copyWith(
        childFolders: childFolders,
      ));
    }
  }
}
