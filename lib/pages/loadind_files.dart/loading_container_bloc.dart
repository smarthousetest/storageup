import 'package:cpp_native/controllers/load/load_controller.dart';
import 'package:cpp_native/controllers/load/models.dart';
import 'package:cpp_native/controllers/load/observable_utils.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/pages/loadind_files.dart/load_controller_event.dart';
import 'package:storageup/pages/loadind_files.dart/loading_container_state.dart';

@Injectable()
class LoadingContainerBloc
    extends Bloc<LoadContainerEvent, LoadingContainerState> {
  LoadingContainerBloc() : super(LoadingContainerState()) {
    on<MainPageOpened>((event, emit) async {
      List<BaseObject>? files = []; // await _filesController.getFiles();

      _loadController = LoadController.instance;
      // final valueListenable = _filesController.getObjectsValueListenable(null);

      // print(
      //     'load controller is not  inited: ${getIt<LoadController>().isNotInited()}');
      //  var folder = await _filesController.getFilesRootFolder();
      //  print(folder?.size);
      emit(state.copyWith(
        // folder: folder,
        // rootFolders: folder,
        isDownloading: true,
        isUploading: true,
        hasPremium: false,
        // objectsValueListenable: valueListenable,
        recesntFiles: files,
      ));

      initLoadControllerObserver();
    });

    on<MainPageChangeUploadInfo>(
        (event, emit) => emit(state.copyWith(uploadInfo: event.uploadInfo)));
    on<MainPageChangeDownloadInfo>((event, emit) =>
        emit(state.copyWith(downloadInfo: event.downloadInfo)));
  }

  late LoadController _loadController;
  late Observer loadControllerObserver;

  void initLoadControllerObserver() async {
    loadControllerObserver = Observer((value) {
      // if (value is List<DownloadFileInfo>) {
      //   _processDownloadChanges(value);
      // } else if (value is List<UploadFileInfo>) {
      //   _processUploadChanges(value);
      // }

      if (value is LoadNotification) {
        _processLoadChanges(value);
      }
    });
    // if (_loadController.isNotInited()) {
    //   await _loadController.init();
    // }

    _loadController.getState.registerObserver(loadControllerObserver);
  }

  void _processDownloadChanges(List<DownloadFileInfo> downloadFilesInfo) {
    final countOfDownloadedFiles =
        downloadFilesInfo.where((element) => element.isFinished).length;

    final countOfDownloadingFile = downloadFilesInfo.length;

    final isDownloading = countOfDownloadingFile != countOfDownloadedFiles;

    double loadProgressOfFile = 0;
    if (downloadFilesInfo.any((element) => element.isInProgress)) {
      final indexOfDownloadingFile =
          downloadFilesInfo.indexWhere((element) => element.isInProgress);
      final tmpLoadPercent =
          downloadFilesInfo[indexOfDownloadingFile].loadPercent;
      loadProgressOfFile = tmpLoadPercent == -1 ? 0 : tmpLoadPercent.toDouble();
    }

    final mainDownloadInfo = LoadContainerDownloadInfo(
      countOfDownloadedFiles: countOfDownloadedFiles,
      countOfDownloadingFiles: countOfDownloadingFile,
      downloadingFilePercent: loadProgressOfFile,
      isDownloading: isDownloading,
    );

    add(MainPageChangeDownloadInfo(downloadInfo: mainDownloadInfo));
  }

  void _processUploadChanges(List<UploadFileInfo> uploadFilesInfo) {
    final countOfUploadedFiles =
        uploadFilesInfo.where((element) => element.isFinished).length;

    final countOfUploadingFiles = uploadFilesInfo.length;

    final isUploading = countOfUploadingFiles != countOfUploadedFiles;

    double loadProgressOfFile = 0;

    if (uploadFilesInfo.any((element) => element.isInProgress)) {
      final indexOfUploadingFile =
          uploadFilesInfo.indexWhere((element) => element.isInProgress);
      final tmpLoadPercent = uploadFilesInfo[indexOfUploadingFile].loadPercent;
      loadProgressOfFile = tmpLoadPercent == -1 ? 0 : tmpLoadPercent.toDouble();
    }

    final mainUploadInfo = LoadContainerUploadInfo(
      countOfUploadedFiles: countOfUploadedFiles,
      countOfUploadingFiles: countOfUploadingFiles,
      isUploading: isUploading,
      uploadingFilePercent: loadProgressOfFile,
    );

    add(MainPageChangeUploadInfo(uploadInfo: mainUploadInfo));
  }

  void _processLoadChanges(LoadNotification notification) async {
    LoadContainerUploadInfo? upload;
    LoadContainerDownloadInfo? download;

    final isUploadingInProgress = notification.countOfUploadingFiles != 0 &&
        notification.isUploadingInProgress;

    if (isUploadingInProgress) {
      final loadPercent = notification.uploadFileInfo?.loadPercent.toDouble();

      upload = LoadContainerUploadInfo(
        countOfUploadedFiles: notification.countOfUploadedFiles,
        countOfUploadingFiles: notification.countOfUploadingFiles,
        isUploading: true,
        uploadingFilePercent:
            loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
      );

      add(MainPageChangeUploadInfo(uploadInfo: upload));
    } else {
      add(MainPageChangeUploadInfo(
          uploadInfo: LoadContainerUploadInfo(isUploading: false)));
    }

    final isDownloadingInProgress = notification.countOfDownloadingFiles != 0 &&
        notification.isDownloadingInProgress;

    if (isDownloadingInProgress) {
      final loadPercent = notification.downloadFileInfo?.loadPercent.toDouble();

      download = LoadContainerDownloadInfo(
        countOfDownloadedFiles: notification.countOfDownloadedFiles,
        countOfDownloadingFiles: notification.countOfDownloadingFiles,
        isDownloading: true,
        downloadingFilePercent:
            loadPercent == null || loadPercent == -1 ? 0 : loadPercent,
      );

      add(MainPageChangeDownloadInfo(downloadInfo: download));
    } else {
      add(MainPageChangeDownloadInfo(
          downloadInfo: LoadContainerDownloadInfo(isDownloading: false)));
    }
  }
  // Future<MainViewState> _mapSearchingFieldChanged(
  //   MainViewState state,
  //   MainSearchFieldChanged event,
  // ) async {
  //   // List<BaseObject>? files = await _filesController.getFiles();
  //   List<BaseObject>? media = await _filesController.getMediaFolders(false);
  //   // .getDeletedMedia(); // TODO change this after implementing files logic

  //   bool isSearchingFieldNotEmpty = event.text.length > 0;

  //   List<BaseObject> filtredFiles = [];
  //   List<BaseObject> filtredMedia = [];

  //   // files?.forEach((element) {
  //   //   if (element.name != null &&
  //   //       element.name!.toLowerCase().contains(event.text.toLowerCase()))
  //   //     filtredFiles.add(element);
  //   // });
  //   media?.forEach((element) {
  //     if (element.name!.toLowerCase().contains(event.text.toLowerCase()))
  //       filtredMedia.add(element);
  //   });

  //   return state.copyWith(
  //     isSearching: isSearchingFieldNotEmpty,
  //     filtredFiles: filtredFiles,
  //     filtredMedia: filtredMedia,
  //   );
  // }

}
