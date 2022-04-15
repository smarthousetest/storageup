import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';
import 'package:upstorage_desktop/utilites/repositories/latest_file_repository.dart';
import 'package:upstorage_desktop/utilites/services/files_service.dart';
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
          await _createAlbum(event, emit);
          break;
        case UserAction.uploadMedia:
          await _uploadMedia(event, emit);
          break;
        default:
          break;
      }
    });

    on<HomePageOpened>((event, emit) async {
      getApplicationSupportDirectory().then((value) {
        Hive.init(value.path);
        print('Hive initialized');
      });
      var upToDateVersion = await _filesService.getVersionApp();
      _repository = await GetIt.instance.getAsync<LatestFileRepository>();
      var latestFile = await _repository.getLatestFile;
      var listenable = _getObjectsBoxListenable(null);
      String version = await _read();
      emit(state.copyWith(
        upToDateVersion: upToDateVersion,
        version: version,
        latestFile: latestFile,
        objectsValueListenable: listenable,
        //checkLatestFile: checkLatestFile,
      ));
    });
    on<FileTapped>((event, emit) async {
      await fileTapped(event);
    });
  }
  final FilesService _filesService = getIt<FilesService>();
  var _loadController = getIt<LoadController>();
  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  late final LatestFileRepository _repository;
  List<DownloadObserver> _downloadObservers = [];
  Box<LatestFile>? boxLatestFile;

  ValueListenable<Box<LatestFile>>? _getObjectsBoxListenable(
    List<String>? objectsId,
  ) {
    var listenable = boxLatestFile?.listenable(keys: objectsId);

    return listenable;
  }

  Future<String> _read() async {
    String version;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/ui_version.txt');
      version = await file.readAsString();
      return version;
    } catch (e) {
      print("Couldn't read file");
      return "Couldn't read file";
    }
  }

  Future<void> _uploadFiles(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    if (event.values != null) {
      for (int i = 0; i < event.values!.length; i++) {
        await _loadController.uploadFile(
            filePath: event.values![i], folderId: event.folderId);
      }
    }
  }

  Future<void> _createFolder(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    String? folderId;
    if (event.folderId == null) {
      try {
        await _filesController.updateFilesList();
      } catch (_) {}
      folderId = _filesController.getFilesRootFolder?.id;
    } else {
      folderId = event.folderId;
    }
    if (event.values?.first != null && folderId != null) {
      final result =
          await _filesController.createFolder(event.values!.first!, folderId);
      if (event.choosedPage == ChoosedPage.file) {
        eventBusUpdateFolder.fire(UpdateFolderEvent);
      }

      if (result != ResponseStatus.ok) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } else if (folderId == null) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  Future<void> _createAlbum(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    String? mediaRootFolderId;
    if (event.folderId == null) {
      try {
        await _filesController.updateFilesList();
      } catch (_) {}
      mediaRootFolderId = _filesController.getMediaRootFolderId();
    } else {
      mediaRootFolderId = event.folderId;
    }
    print(mediaRootFolderId);
    //var mediaRootFolderId = await _filesController.getMediaRootFolderId();
    if (event.values?.first != null && mediaRootFolderId != null) {
      final result = await _filesController.createFolder(
          event.values!.first!, mediaRootFolderId);
      if (event.choosedPage == ChoosedPage.media) {
        eventBusUpdateAlbum.fire(UpdateAlbumEvent);
      }
      if (result != ResponseStatus.ok) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } else if (mediaRootFolderId == null) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  Future<void> _uploadMedia(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    if (event.values != null && event.values!.isNotEmpty) {
      for (int i = 0; i < event.values!.length; i++) {
        await _loadController.uploadFile(
            filePath: event.values![i], folderId: event.folderId);
      }
    }
    //eventBusUpdateFolder.fire(HomeBloc());
  }

  Future<void> fileTapped(FileTapped event) async {
    //_repository.addFile(latestFile: record);
    var box = await Hive.openBox(kPathDBName);
    String path = box.get(event.record.id, defaultValue: '');

    if (path.isNotEmpty) {
      var appPath = (await getApplicationSupportDirectory()).path;
      if (path.contains("()")) {
        path.replaceAll(('('), '"("');
        path.replaceAll((')'), '")"');
      }

      var fullPathToFile = "$appPath/$path";
      var isExisting = await File(fullPathToFile).exists();
      //var isExistingSync = File(fullPathToFile).watch();
      print(fullPathToFile);
      if (isExisting) {
        var res = await OpenFile.open(fullPathToFile);
        print(res.message);
      } else {
        _downloadFile(event.record.id);
      }
    } else {
      _downloadFile(event.record.id);
    }
  }

  void _downloadFile(String recordId) async {
    _loadController.downloadFile(fileId: recordId);
    _registerDownloadObserver(recordId);
    _setRecordDownloading(recordId: recordId);
  }

  void _registerDownloadObserver(String recordId) async {
    var box = await Hive.openBox(kPathDBName);
    var controllerState = _loadController.getState;
    var downloadObserver = DownloadObserver(recordId, (value) async {
      if (value is List<DownloadFileInfo>) {
        var fileId = value.indexWhere((element) => element.id == recordId);

        if (fileId != -1) {
          var file = value[fileId];
          if (file.endedWithException) {
            _setRecordDownloading(
              recordId: recordId,
              isDownloading: false,
            );

            _unregisterDownloadObserver(recordId);
          } else if (file.localPath.isNotEmpty) {
            var path = file.localPath
                .split('/')
                .skipWhile((value) => value != 'downloads')
                .join('/');
            await box.put(file.id, path);

            _setRecordDownloading(
              recordId: recordId,
              isDownloading: false,
            );

            var res = await OpenFile.open(file.localPath);
            print(res.message);

            _unregisterDownloadObserver(recordId);
          }
        }
      }
      // }
    });

    controllerState.registerObserver(
      downloadObserver,
    );

    _downloadObservers.add(downloadObserver);
  }

  void _unregisterDownloadObserver(String recordId) async {
    try {
      final observer =
          _downloadObservers.firstWhere((observer) => observer.id == recordId);

      _loadController.getState.unregisterObserver(observer);

      _downloadObservers.remove(observer);
    } catch (e) {
      log('OpenFolderCubit -> _unregisterDownloadObserver:', error: e);
    }
  }

  void _setRecordDownloading({
    required String recordId,
    bool isDownloading = true,
  }) {
    try {
      var currentRecordIndex = state.latestFile
          .indexWhere((element) => element.latestFile.id == recordId);
      var record = state.latestFile.map((e) => e.latestFile).toList();
      var objects = [...record];
      var currentRecord = objects[currentRecordIndex];
      objects[currentRecordIndex] =
          currentRecord.copyWith(loadPercent: isDownloading ? 0 : null);
      //List<LatestFile> latestFile = [];

      //emit(state.copyWith(latestFile: objects));
    } catch (e) {
      log('OpenFolderCubit -> _setRecordDownloading:', error: e);
    }
  }
}

class UpdateFolderEvent {}

class UpdateAlbumEvent {}

class DownloadObserver extends Observer {
  String id;
  DownloadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}
