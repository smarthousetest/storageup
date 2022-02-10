import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';

class SpaceState extends Equatable {
  final User? user;
  final String dirPath;
  SpaceState({this.user, this.dirPath = ''});

  SpaceState copyWith({
    User? user,
    String? dirPath,
  }) {
    return SpaceState(
      user: user ?? this.user,
      dirPath: dirPath ?? this.dirPath,
    );
  }

  @override
  List<Object?> get props => [user, dirPath];
}
