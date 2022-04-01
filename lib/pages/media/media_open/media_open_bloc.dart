import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/observable_utils.dart';

import 'media_open_event.dart';
import 'media_open_state.dart';

@injectable
class MediaOpenBloc extends Bloc<MediaOpenEvent, MediaOpenState> {
  MediaOpenBloc(@Named('files_controller') this._controller)
      : super(MediaOpenState()) {
    on((event, emit) async {
      if (event is MediaOpenPageOpened) {
        await _mapMediaOpenPageOpened(state, event, emit);
      } else if (event is MediaOpenChangeFavoriteState) {
        await _mapMediaOpenChangeFavoriteState(state, event, emit);
      } else if (event is MediaOpenShare) {
        await _mapMediaOpenShare(state, event, emit);
      } else if (event is MediaOpenDownload) {
        await _mapMediaOpenDownload(state, event, emit);
      } else if (event is MediaOpenDelete) {
        await _mapMediaOpenDelete(state, event, emit);
      } else if (event is MediaOpenChangeChoosedMedia) {
        await _mapMediaOpenChangeChoosedMedia(state, event, emit);
      } else if (event is MediaOpenChangeDownloadStatus) {
        await _mapChangeDownloadStatus(state, event, emit);
      } else if (event is MediaOpenError) {
        _onError(event, state, emit);
      }
    });
  }

  FilesController _controller;
  final LoadController _loadController = getIt<LoadController>();
  List<DownloadObserver> _listeners = [];

  Future<void> _mapMediaOpenPageOpened(
    MediaOpenState state,
    MediaOpenPageOpened event,
    Emitter<MediaOpenState> emit,
  ) async {
    var connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.none) {
      add(MediaOpenError(ErrorType.noInternet));
    }

    List<BaseObject> mediaFromFolder = [];
    if (event.choosedFolder?.id == '-1') {
      var allMediaFolders = await _controller.getMediaFolders(true);

      for (var folder in allMediaFolders!) {
        if (folder.id != '-1') {
          var records = await _controller.getContentFromFolderById(folder.id);

          mediaFromFolder.addAll(records);
        }
      }
    } else {
      mediaFromFolder = await _controller.getContentFromFolderById(
          event.choosedFolder?.id ?? state.choosedMedia.id);
    }
    var box = await Hive.openBox(kPathDBName);
    var appPath = (await getApplicationDocumentsDirectory()).path;

    mediaFromFolder.forEach((record) {
      var path = box.get(record.id);
      if (path != null) {
        if (File('$appPath/$path').existsSync())
          (record as Record).path = '$appPath/$path';
        else {
          print('Deleting file with id: ${record.id}');
          box.delete(record.id);
          (record as Record).path = null;
        }
      }
    });

    var filePath = box.get(event.choosedMedia.id);

    if (filePath != null) {
      var path = '$appPath/$filePath';
      var choosedMedia = event.choosedMedia as Record;

      choosedMedia.path = path;

      (mediaFromFolder.firstWhere((element) => element.id == choosedMedia.id)
              as Record)
          .path = path;

      emit(
        state.copyWith(
          choosedMedia: choosedMedia,
          openedFolder: event.choosedFolder,
          mediaFromFolder: mediaFromFolder,
          isInitialized: true,
        ),
      );
    } else {
      var id = event.choosedMedia.id;
      var isAllreadyLoading = _loadController.isCurrentFileDownloading(id);
      if (!isAllreadyLoading) {
        await _loadController.discardDownloading();
        _loadController.downloadFile(fileId: id);
      }

      var observer = DownloadObserver(id, (_) {
        _downloadListener(id);
      });

      _listeners.add(observer);
      _loadController.getState.registerObserver(observer);

      emit(
        state.copyWith(
          choosedMedia: event.choosedMedia,
          openedFolder: event.choosedFolder,
          mediaFromFolder: mediaFromFolder,
          isInitialized: true,
        ),
      );
    }
  }

  void _downloadListener(String id) async {
    var controllerState = _loadController.getState;
    try {
      var currentFile = controllerState.downloadingFiles
          .firstWhere((element) => element.id == id);

      if (currentFile.downloadPercent == -1 && currentFile.endedWithException) {
        var observer = _listeners.firstWhere((element) => element.id == id);

        controllerState.unregisterObserver(observer);
        _listeners.remove(observer);

        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none)
          add(MediaOpenError(ErrorType.noInternet));
        else
          add(MediaOpenError(ErrorType.technicalError));
        return;
      }

      if (currentFile.downloadPercent > 0 &&
          currentFile.downloadPercent < 100) {
        Record media = state.mediaFromFolder
            .firstWhere((element) => element.id == id) as Record;
        media.loadPercent = currentFile.downloadPercent.toDouble();
        add(MediaOpenChangeDownloadStatus(media: media));
      } else if (currentFile.downloadPercent == 100) {
        Record media = state.mediaFromFolder
            .firstWhere((element) => element.id == id) as Record;
        var path = currentFile.localPath;
        var np = path
            .split('/')
            .skipWhile((value) => value != 'downloads')
            .join('/');
        var box = await Hive.openBox(kPathDBName);
        box.put(media.id, np);
        add(MediaOpenChangeDownloadStatus(media: media));
        var observer =
            _listeners.firstWhere((element) => element.id == media.id);

        controllerState.unregisterObserver(observer);
        _listeners.remove(observer);
      }
    } catch (e) {
      print(e);

      var ind = controllerState.downloadingFiles
          .indexWhere((element) => element.id == id);

      if (ind != -1) {
        var observer = _listeners.firstWhere((element) => element.id == id);

        controllerState.unregisterObserver(observer);
        _listeners.remove(observer);

        var connect = await Connectivity().checkConnectivity();
        if (connect == ConnectivityResult.none)
          add(MediaOpenError(ErrorType.noInternet));
        else
          add(MediaOpenError(ErrorType.technicalError));
      }
    }
  }

  Future<void> _mapMediaOpenChangeFavoriteState(
    MediaOpenState state,
    MediaOpenChangeFavoriteState event,
    Emitter<MediaOpenState> emit,
  ) async {
    var isFavorite = event.media.favorite;
    print(!isFavorite);
    var res = await _controller.setFavorite(event.media, !isFavorite);
    print(res);
    var mediaList =
        await _controller.getContentFromFolderById(state.openedFolder.id);
    // MediaInfo choosedMedia =
    //     await _controller.addToFavorites(event.mediaId, state.openedFolder.id);
    // List<MediaInfo> mediaFromFolder =
    //     await _controller.getMediaListFromFolder(state.openedFolder.id);
    emit(
      state.copyWith(
        mediaFromFolder: mediaList,
        choosedMedia:
            mediaList.firstWhere((element) => element.id == event.media.id),
        status: FormzStatus.submissionSuccess,
      ),
    );
  }

  Future _mapMediaOpenShare(
    MediaOpenState state,
    MediaOpenShare event,
    Emitter<MediaOpenState> emit,
  ) async {
    emit(state);
  }

  Future<void> _mapMediaOpenDownload(
    MediaOpenState state,
    MediaOpenDownload event,
    Emitter<MediaOpenState> emit,
  ) async {
    print(
        'need to download file with name ${state.mediaFromFolder.firstWhere((element) => element.id == event.mediaId).name}');
    var id = event.mediaId;
    var cs = _loadController.getState;

    if (cs.downloadingFiles.any((element) => element.id == id)) {
      print(
          'file with name ${state.mediaFromFolder.firstWhere((element) => element.id == event.mediaId).name} allready downloading, wait!');
      return;
    }

    _loadController.downloadFile(fileId: event.mediaId);

    var observer = DownloadObserver(id, (_) {
      _downloadListener(id);
    });

    _listeners.add(observer);
    _loadController.getState.registerObserver(observer);
    emit(state);
  }

  Future<void> _mapMediaOpenDelete(
    MediaOpenState state,
    MediaOpenDelete event,
    Emitter<MediaOpenState> emit,
  ) async {
    await _controller.deleteFiles([
      state.mediaFromFolder.firstWhere((element) => element.id == event.mediaId)
    ]);

    List<BaseObject> mediaFromFolder = [];
    if (state.openedFolder.id == '-1') {
      var allMediaFolders = await _controller.getMediaFolders(true);

      for (var folder in allMediaFolders!) {
        if (folder.id != '-1') {
          var records = await _controller.getContentFromFolderById(folder.id);

          mediaFromFolder.addAll(records);
        }
      }
    } else {
      mediaFromFolder =
          await _controller.getContentFromFolderById(state.openedFolder.id);
    }

    emit(
      state.copyWith(mediaFromFolder: mediaFromFolder),
    );
  }

  Future<void> _mapMediaOpenChangeChoosedMedia(
    MediaOpenState state,
    MediaOpenChangeChoosedMedia event,
    Emitter<MediaOpenState> emit,
  ) async {
    print('new choosed image index is ${event.index}');
    var choosedMedia = state.mediaFromFolder[event.index] as Record;

    emit(
      state.copyWith(choosedMedia: choosedMedia),
    );

    if (choosedMedia.path == null || choosedMedia.path!.isEmpty) {
      var loadState = _loadController.getState;
      if (loadState.downloadingFiles
          .any((element) => element.id == choosedMedia.id)) {
        _loadController.increasePriorityOfRecord(choosedMedia.id);
      } else {
        add(MediaOpenDownload(mediaId: choosedMedia.id));
      }
    }
    if (choosedMedia.path != null) {
      var loadState = _loadController.getState;
      var file = File(choosedMedia.path!);
      if (!file.existsSync()) {
        if (loadState.downloadingFiles
            .any((element) => element.id == choosedMedia.id)) {
          _loadController.increasePriorityOfRecord(choosedMedia.id);
        } else {
          add(MediaOpenDownload(mediaId: choosedMedia.id));
        }
      }
    }
  }

  Future<void> _mapChangeDownloadStatus(
    MediaOpenState state,
    MediaOpenChangeDownloadStatus event,
    Emitter<MediaOpenState> emit,
  ) async {
    var allMedia = state.mediaFromFolder;
    var choosedFile = state.choosedMedia;

    var updatedFile = event.media;
    // var path = updatedFile.path
    var appPath = (await getApplicationDocumentsDirectory()).path;
    var box = await Hive.openBox(kPathDBName);
    // var path = '$appPath/$inAppPath'

    allMedia.forEach((element) {
      if (element.id == updatedFile.id) {
        var inAppPath = box.get(element.id);
        if (inAppPath != null) {
          var path = '$appPath/$inAppPath';
          (element as Record).path = path;
        }
      }
    });

    if (choosedFile.id == updatedFile.id) {
      var inAppPath = box.get(choosedFile.id);
      var path = '$appPath/$inAppPath';
      (choosedFile as Record).path = path;
    }
    var ns = state.copyWith(
      choosedMedia: choosedFile,
      mediaFromFolder: [...allMedia],
    );
    emit(ns);
    emit(ns.copyWith(isInitialized: false));
    emit(ns.copyWith(isInitialized: true));
  }

  void _onError(
    MediaOpenError event,
    MediaOpenState state,
    Emitter<MediaOpenState> emit,
  ) {
    emit(state.copyWith(
      errorType: event.errorType,
      status: FormzStatus.submissionFailure,
    ));
  }
}

class DownloadObserver extends Observer {
  String id;
  DownloadObserver(this.id, Function(dynamic) onChange) : super(onChange);
}