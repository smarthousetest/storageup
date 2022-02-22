import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';

class SpaceState extends Equatable {
  final User? user;
  final List<String> dirPath;
  List<int> countGb;
  SpaceState({
    this.user,
    this.dirPath = const [],
    this.countGb = const [],
  });

  SpaceState copyWith({
    User? user,
    List<String>? dirPath,
    List<int>? countGb,
  }) {
    return SpaceState(
      user: user ?? this.user,
      dirPath: dirPath ?? this.dirPath,
      countGb: countGb ?? this.countGb,
    );
  }

  @override
  List<Object?> get props => [user, dirPath, countGb];
}
