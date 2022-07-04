import 'package:cpp_native/models/folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:storageup/models/packet/packet.dart';
import 'package:storageup/models/subscription.dart';
import 'package:storageup/models/user.dart';

class InfoState extends Equatable {
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
  final User? user;
  final Folder? folder;
  final Subscription? sub;
  final Folder? rootFolders;
  final List<Folder>? allMediaFolders;

  final ValueNotifier<User?>? valueNotifier;
  final ValueNotifier<Packet?>? packetNotifier;

  InfoState({
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
    this.sub,
    this.user,
    this.rootFolders,
    this.folder,
    this.allMediaFolders,
    this.packetNotifier,
    this.valueNotifier,
  });

  InfoState copyWith({
    double? usingSpace,
    int? allSpace,
    double? loadPercentRentPlace,
    double? loadPercentPentPlaceFull,
    int? dailyProfit,
    int? yourBalance,
    bool? homeTab,
    bool? filesTab,
    bool? mediaTab,
    User? user,
    Subscription? sub,
    Folder? rootFolders,
    Folder? folder,
    List<Folder>? allMediaFolders,
    Packet? packetInfo,
    ValueNotifier<User?>? valueNotifier,
    ValueNotifier<Packet?>? packetNotifier,
  }) {
    return InfoState(
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
      user: user ?? this.user,
      folder: folder ?? this.folder,
      sub: sub ?? this.sub,
      rootFolders: rootFolders ?? this.rootFolders,
      allMediaFolders: allMediaFolders ?? this.allMediaFolders,
      packetNotifier: packetNotifier ?? this.packetNotifier,
      valueNotifier: valueNotifier ?? this.valueNotifier,
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
        user,
        folder,
        rootFolders,
        allMediaFolders,
        sub,
        packetNotifier,
        valueNotifier,
      ];
}
