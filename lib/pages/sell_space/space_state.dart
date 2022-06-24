import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/auth/models/name.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper> keeper;
  final ValueNotifier<User?>? valueNotifier;
  final String? localKeeperVersion;

  final String pathToKeeper;
  final int availableSpace;
  final Name name;

  SpaceState({
    this.user,
    this.locationsInfo = const [],
    this.keeper = const [],
    this.valueNotifier,
    this.localKeeperVersion = "",
    this.pathToKeeper = '',
    this.availableSpace = 0,
    this.name = const Name.pure(),
  });

  SpaceState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
    ValueNotifier<User?>? valueNotifier,
    String? localKeeperVersion,
    Name? name,
    String? pathToKeeper,
    int? availableSpace,
  }) {
    return SpaceState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
      valueNotifier: valueNotifier ?? this.valueNotifier,
      localKeeperVersion: localKeeperVersion ?? this.localKeeperVersion,
      pathToKeeper: pathToKeeper ?? this.pathToKeeper,
      name: name ?? this.name,
      availableSpace: availableSpace ?? this.availableSpace,
    );
  }

  @override
  List<Object?> get props => [
        user,
        locationsInfo,
        keeper,
        name,
        valueNotifier,
        localKeeperVersion,
        pathToKeeper,
        availableSpace,
      ];
}
