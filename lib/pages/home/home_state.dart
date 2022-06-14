import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';

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
  final List<LatestFile> latestFile;
  final List<LatestFile> checkLatestFile;
  final ValueListenable<Box<LatestFile>>? objectsValueListenable;

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
    List<LatestFile>? latestFile,
    List<LatestFile>? checkLatestFile,
    ValueListenable<Box<LatestFile>>? objectsValueListenable,
  }) {
    return HomeState(
      usingSpace: usingSpace ?? this.usingSpace,
      allSpace: allSpace ?? this.allSpace,
      loadPercentRentPlace: loadPercentRentPlace ?? this.loadPercentRentPlace,
      loadPercentPentPlaceFull: loadPercentPentPlaceFull ?? this.loadPercentPentPlaceFull,
      dailyProfit: dailyProfit ?? this.dailyProfit,
      yourBalance: yourBalance ?? this.yourBalance,
      homeTab: homeTab ?? this.homeTab,
      filesTab: filesTab ?? this.filesTab,
      mediaTab: mediaTab ?? this.mediaTab,
      status: status ?? FormzStatus.pure,
      upToDateVersion: upToDateVersion ?? this.upToDateVersion,
      version: version ?? this.version,
      objectsValueListenable: objectsValueListenable ?? this.objectsValueListenable,
      latestFile: latestFile ?? this.latestFile,
      checkLatestFile: checkLatestFile ?? this.checkLatestFile,
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
      ];
}
