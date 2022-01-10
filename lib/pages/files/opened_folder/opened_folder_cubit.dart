import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';

class OpenedFolderCubit extends Cubit<OpenedFolderState> {
  OpenedFolderCubit()
      : super(OpenedFolderState(
          objects: [],
          previousFolders: [],
        ));

  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  var _loadController = getIt<LoadController>();

  List<UploadObserver> _observers = [];

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

    emit(
      state.copyWith(
        currentFolder: currentFolder,
        objects: objects,
        previousFolders: previousFolders,
      ),
    );

    _syncWithLoadController(objects);
  }

  void _syncWithLoadController(List<BaseObject> filesInFolder) async {
    var loadState = _loadController.getState;

    filesInFolder.forEach((fileInFolder) {
      var index = loadState.uploadingFiles
          .indexWhere((loadingFile) => loadingFile.id == fileInFolder.id);
      if (index != -1) {
        _observers.add(
            UploadObserver(loadState.uploadingFiles[index].localPath, (p0) {
          _uploadListener(loadState.uploadingFiles[index].localPath);
        }));
      }
    });
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

  void _uploadListener(String pathToFile) async {
    var controllerState = _loadController.getState;
    try {
      var currentFile = controllerState.uploadingFiles.firstWhere(
          (element) => element.localPath == pathToFile && element.isInProgress);

      if (currentFile.uploadPercent == -1 && currentFile.id.isNotEmpty) {
        // add(FileUpdateFiles(id: currentFile.id));
        return;
      }

      if (!currentFile.isInProgress && currentFile.uploadPercent == -1) {
        return;
      }

      if (currentFile.uploadPercent >= 0 && currentFile.uploadPercent < 100) {
        print(
            'file\'s $pathToFile upload percent = ${currentFile.uploadPercent}');
        // add(FileChangeUploadPercent(
        //   id: currentFile.id,
        //   percent: currentFile.uploadPercent.toDouble(),
        // ));
      } else if (currentFile.uploadPercent != -1) {
        // add(FileUpdateFiles());
        // add(FileChangeUploadPercent(
        //   id: currentFile.id,
        //   percent: null,
        // ));
        var observer =
            _observers.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _observers.remove(observer);
      }
    } catch (e) {
      print(e);
      var ind = controllerState.uploadingFiles
          .indexWhere((e) => e.id == pathToFile && e.endedWithException);
      if (ind != -1) {
        var observer =
            _observers.firstWhere((element) => element.id == pathToFile);
        controllerState.unregisterObserver(observer);

        _observers.remove(observer);

        // var connect = await Connectivity().checkConnectivity();

        // if (connect == ConnectivityResult.none) {
        //   add(FilesNoInternet());
        // } else {
        //   add(FileUpdateFiles());
        // }
      }
    }
  }
}

class UploadObserver extends Observer {
  String id;
  UploadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}
