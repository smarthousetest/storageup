import 'package:cpp_native/models/folder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storageup/pages/files/move_files/move_state.dart';
import 'package:storageup/pages/home/home_bloc.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/event_bus.dart';

class MoveCubit extends Cubit<MoveState> {
  MoveCubit() : super(MoveState());

  late FilesController _filesController;

  void init() async {
    _filesController = await GetIt.I.getAsync<FilesController>();
    var rootFolder = await _filesController.getRootFolderForMove;
    List<Folder> allFolders = [];
    if (rootFolder != null) allFolders.add(rootFolder);

    emit(state.copyWith(
      folders: allFolders,
      currentFolder: rootFolder,
    ));
  }

  Future<void> createFolder(
    String name,
    Folder? moveToFolder,
    List<Folder>? moveFolder,
  ) async {
    if (moveToFolder == null) {
      var rootFolder = await _filesController.getRootFolderForMove;
      moveToFolder = rootFolder;
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
      var curFolder = await _filesController.getFolderByIdForMove(folder.id);
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
