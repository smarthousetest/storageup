import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storageup/models/latest_file.dart';
import 'package:storageup/models/main_download_info.dart';
import 'package:storageup/models/main_upload_info.dart';

class HomeState extends Equatable {
  final double usingSpace;
  final int allSpace;
  final double loadPercentRentPlace;
  final double loadPercentPentPlaceFull;
  final int dailyProfit;
  final int yourBalance;
  final bool homeTab;
  final bool filesTab;
  final bool mediaTab;
  final bool starTab;
  final bool rentPlaceTab;
  final bool settingsTab;
  final bool trashTab;
  final bool financeTab;
  final FormzStatus status;
  final String? upToDateVersion;
  final String? version;

  final MainDownloadInfo downloadInfo;
  final MainUploadInfo uploadInfo;
  final List<Record> latestFile;
  final List<Record> checkLatestFile;
  final ValueListenable<Box<Record>>? objectsValueListenable;

  HomeState({
    this.usingSpace = 0,
    this.allSpace = 0,
    this.loadPercentRentPlace = 0,
    this.loadPercentPentPlaceFull = 0,
    this.dailyProfit = 0,
    this.yourBalance = 0,
    this.homeTab = false,
    this.filesTab = false,
    this.mediaTab = false,
    this.starTab = false,
    this.rentPlaceTab = false,
    this.settingsTab = false,
    this.trashTab = false,
    this.financeTab = false,
    this.status = FormzStatus.pure,
    this.upToDateVersion,
    this.version,
    this.objectsValueListenable,
    this.latestFile = const [],
    this.checkLatestFile = const [],
    this.downloadInfo = const MainDownloadInfo(),
    this.uploadInfo = const MainUploadInfo(),
  });

  HomeState copyWith({
    double? usingSpace,
    int? allSpace,
    double? loadPercentRentPlace,
    double? loadPercentPentPlaceFull,
    int? dailyProfit,
    int? yourBalance,
    bool? homeTab,
    bool? filesTab,
    bool? mediaTab,
    FormzStatus? status,
    String? upToDateVersion,
    String? version,
    List<Record>? latestFile,
    List<Record>? checkLatestFile,
    ValueListenable<Box<Record>>? objectsValueListenable,
    MainDownloadInfo? downloadInfo,
    MainUploadInfo? uploadInfo,
  }) {
    return HomeState(
      usingSpace: usingSpace ?? this.usingSpace,
      allSpace: allSpace ?? this.allSpace,
      loadPercentRentPlace: loadPercentRentPlace ?? this.loadPercentRentPlace,
      loadPercentPentPlaceFull:
          loadPercentPentPlaceFull ?? this.loadPercentPentPlaceFull,
      dailyProfit: dailyProfit ?? this.dailyProfit,
      yourBalance: yourBalance ?? this.yourBalance,
      homeTab: homeTab ?? this.homeTab,
      filesTab: filesTab ?? this.filesTab,
      mediaTab: mediaTab ?? this.mediaTab,
      status: status ?? FormzStatus.pure,
      upToDateVersion: upToDateVersion ?? this.upToDateVersion,
      version: version ?? this.version,
      objectsValueListenable:
          objectsValueListenable ?? this.objectsValueListenable,
      latestFile: latestFile ?? this.latestFile,
      checkLatestFile: checkLatestFile ?? this.checkLatestFile,
      downloadInfo: downloadInfo ?? this.downloadInfo,
      uploadInfo: uploadInfo ?? this.uploadInfo,
    );
  }

  @override
  List<Object?> get props => [
        usingSpace,
        allSpace,
        loadPercentRentPlace,
        loadPercentPentPlaceFull,
        dailyProfit,
        yourBalance,
        homeTab,
        filesTab,
        mediaTab,
        status,
        upToDateVersion,
        version,
        latestFile,
        checkLatestFile,
        objectsValueListenable,
        downloadInfo,
        uploadInfo
      ];
}
