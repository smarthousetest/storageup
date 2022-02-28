import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<DownloadLocation> locationsInfo;

  SpaceState({
    this.user,
    this.locationsInfo = const [],
  });

  SpaceState copyWith({
    User? user,
    List<DownloadLocation>? locationsInfo,
  }) {
    return SpaceState(
      user: user ?? this.user,
      locationsInfo: locationsInfo ?? this.locationsInfo,
    );
  }

  @override
  List<Object?> get props => [user, locationsInfo];
}
