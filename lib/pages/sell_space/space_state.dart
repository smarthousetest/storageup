import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;
  final List<Keeper> keeper;

  SpaceState({
    this.user,
    this.locationsInfo = const [],
    this.keeper = const [],
  });

  SpaceState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
    List<Keeper>? keeper,
  }) {
    return SpaceState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
      keeper: keeper ?? this.keeper,
    );
  }

  @override
  List<Object?> get props => [user, locationsInfo, keeper];
}
