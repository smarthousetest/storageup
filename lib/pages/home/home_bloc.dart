import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cpp_native/controllers/load/load_controller.dart';
import 'package:cpp_native/controllers/load/models.dart';
import 'package:cpp_native/controllers/load/observable_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:open_file/open_file.dart';
import 'package:os_specification/os_specification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/main_download_info.dart';
import 'package:storageup/models/main_upload_info.dart';
import 'package:storageup/pages/sell_space/space_bloc.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/latest_file_repository.dart';
import 'package:storageup/utilities/services/files_service.dart';
import 'home_event.dart';
import 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeUserActionChosen>((event, emit) async {
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

    Timer.periodic(
      Duration(minutes: 5),
      (_) async {
        String? localAppVersion = _getLocalAppVersion();
        var remoteAppVersion = await _filesService.getRemoteAppVersion();
        add(UpdateRemoteVersion(
          localVersion: localAppVersion,
          remoteVersion: remoteAppVersion,
        ));
      },
    );

    on<HomePageOpened>((event, emit) async {
      initLoadControllerObserver();
      _filesController = await GetIt.I.getAsync<FilesController>();
      // _filesController.clearLocalDatabase();
      var os = OsSpecifications.getOs();
      await Hive.initFlutter(os.supportDir);
      print('Hive initialized');
      var remoteAppVersion = await _filesService.getRemoteAppVersion();
      _repository = await GetIt.instance.getAsync<LatestFileRepository>();

      var recentFiles = await _filesService.getRecentsRecords();
      if (recentFiles != null) {
        await _repository.addFiles(latestFile: recentFiles);
      }
      var latestFile = await _repository.getLatestFile;
      var listenable = _repository.getLatestFilesValueListenable();

      String? localAppVersion = _getLocalAppVersion();
      emit(state.copyWith(
        upToDateVersion: remoteAppVersion,
        version: localAppVersion,
        latestFile: latestFile,
        objectsValueListenable: listenable,
      ));
    });
    on<FileTapped>((event, emit) async {
      await fileTapped(event);
    });

    on<HomeEvent>((event, emit) async {
      if (event is UpdateRemoteVersion) {
        emit(
          state.copyWith(
            upToDateVersion: event.remoteVersion,
            version: event.localVersion,
          ),
        );
      }
    });

    on<MainPageChangeUploadInfo>(
        (event, emit) => emit(state.copyWith(uploadInfo: event.uploadInfo)));
    on<MainPageChangeDownloadInfo>((event, emit) =>
        emit(state.copyWith(downloadInfo: event.downloadInfo)));
  }

  final FilesService _filesService = getIt<FilesService>();
  var _loadController = LoadController.instance;
  late FilesController _filesController;
  late final LatestFileRepository _repository;

  late Observer loadControllerObserver;

  void initLoadControllerObserver() async {
    loadControllerObserver = Observer((value) {
      if (value is LoadNotification) {
        _processLoadChanges(value);
      }
    });

    _loadController.getState.registerObserver(loadControllerObserver);
  }

  void _processLoadChanges(LoadNotification notification) async {
    MainUploadInfo? upload;
    MainDownloadInfo? download;

    final isUploadingInProgress = notification.countOfUploadingFiles != 0 &&
        notification.isUploadingInProgress;

    if (isUploadingInProgress) {
      final loadPercent = notification.uploadFileInfo?.loadPercent.toDouble();

      upload = MainUploadInfo(
        countOfUploadedFiles: notification.countOfUploadedFiles,
        countOfUploadingFiles: notification.countOfUploadingFiles,
        isUploading: true,
        uploadingFilePercent:
            loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
      );

      add(MainPageChangeUploadInfo(uploadInfo: upload));
    } else {
      add(MainPageChangeUploadInfo(
          uploadInfo: MainUploadInfo(isUploading: false)));
    }

    final isDownloadingInProgress = notification.countOfDownloadingFiles != 0 &&
        notification.isDownloadingInProgress;

    if (isDownloadingInProgress) {
      final loadPercent = notification.downloadFileInfo?.loadPercent.toDouble();

      download = MainDownloadInfo(
        countOfDownloadedFiles: notification.countOfDownloadedFiles,
        countOfDownloadingFiles: notification.countOfDownloadingFiles,
        isDownloading: true,
        downloadingFilePercent:
            loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
      );

      add(MainPageChangeDownloadInfo(downloadInfo: download));
    } else {
      add(MainPageChangeDownloadInfo(
          downloadInfo: MainDownloadInfo(isDownloading: false)));
    }
  }

  String _getLocalAppVersion() {
    var os = OsSpecifications.getOs();
    var uiVersionFile = File('${os.appDirPath}ui_version.txt');
    if (uiVersionFile.existsSync()) {
      return (uiVersionFile.readAsStringSync()).trim();
    } else {
      return "";
    }
  }

  Future<void> _uploadFiles(
    HomeUserActionChosen event,
    Emitter<HomeState> emit,
  ) async {
    if (event.values != null) {
      for (int i = 0; i < event.values!.length; i++) {
        if (event.values![i] != null &&
            PathCheck().isPathCorrect(event.values![i].toString())) {
          await _loadController.uploadFile(
              filePath: event.values![i], folderId: event.folderId);
        } else {
          emit(state.copyWith(status: FormzStatus.invalid));
          emit(state.copyWith(status: FormzStatus.pure));
        }
      }
    }
  }

  Future<void> _createFolder(
    HomeUserActionChosen event,
    Emitter<HomeState> emit,
  ) async {
    String? folderId;
    if (event.folderId == null) {
      try {
        await _filesController.updateFilesList();
      } catch (_) {}
      var rootFilesFolder = await _filesController.getFilesRootFolder();
      folderId = rootFilesFolder!.id;
    } else {
      folderId = event.folderId;
    }
    if (event.values?.first != null && folderId != null) {
      final result =
          await _filesController.createFolder(event.values!.first!, folderId);

      eventBusUpdateFolder.fire(UpdateFolderEvent);

      if (result == ResponseStatus.failed) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        emit(state.copyWith(status: FormzStatus.pure));
      } else if (result == ResponseStatus.noInternet) {
        emit(state.copyWith(status: FormzStatus.submissionCanceled));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } else if (folderId == null) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  Future<void> _createAlbum(
    HomeUserActionChosen event,
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

      eventBusUpdateAlbum.fire(UpdateAlbumEvent);

      if (result == ResponseStatus.failed) {
        emit(state.copyWith(status: FormzStatus.submissionCanceled));
        emit(state.copyWith(status: FormzStatus.pure));
      } else if (result == ResponseStatus.noInternet) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } else if (mediaRootFolderId == null) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  Future<void> _uploadMedia(
    HomeUserActionChosen event,
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
    _setRecordDownloading(recordId: recordId);
  }

  void _setRecordDownloading({
    required String recordId,
    bool isDownloading = true,
  }) {
    try {
      var currentRecordIndex =
          state.latestFile.indexWhere((element) => element.id == recordId);
      var record = state.latestFile.map((e) => e).toList();
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
