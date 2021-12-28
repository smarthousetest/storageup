import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';

class MediaState extends Equatable {
  final User? user;

  MediaState({
    this.user,
  });

  MediaState copyWith({
    User? user,
  }) {
    return MediaState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
