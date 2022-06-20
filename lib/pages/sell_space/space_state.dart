import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper> keeper;
  final ValueNotifier<User?>? valueNotifier;
  final String pathToKeeper;
  final int availableSpace;
  SpaceState({
    this.user,
    this.locationsInfo = const [],
    this.keeper = const [],
    this.valueNotifier,
    this.pathToKeeper = '',
    this.availableSpace = 0,
  });

  SpaceState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
    ValueNotifier<User?>? valueNotifier,
    String? pathToKeeper,
    int? availableSpace,
  }) {
    return SpaceState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      pathToKeeper: pathToKeeper ?? this.pathToKeeper,
      availableSpace: availableSpace ?? this.availableSpace,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keeper,
        valueNotifier,
        pathToKeeper,
        availableSpace,
      ];
}
