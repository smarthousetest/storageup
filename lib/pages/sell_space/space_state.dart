import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper> keeper;
  final ValueNotifier<User?>? valueNotifier;
  final String? localKeeperVersion;

  SpaceState({
    this.user,
    this.locationsInfo = const [],
    this.keeper = const [],
    this.valueNotifier,
    this.localKeeperVersion = "",
  });

  SpaceState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
    ValueNotifier<User?>? valueNotifier,
    String? localKeeperVersion,
  }) {
    return SpaceState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      localKeeperVersion: localKeeperVersion ?? this.localKeeperVersion,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keeper,
        valueNotifier,
        localKeeperVersion,
      ];
}
