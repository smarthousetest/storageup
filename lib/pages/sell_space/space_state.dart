import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';

class SpaceState extends Equatable {
  final User? user;

  SpaceState({
    this.user,
  });

  SpaceState copyWith({
    User? user,
  }) {
    return SpaceState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
