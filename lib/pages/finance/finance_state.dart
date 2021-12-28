import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/user.dart';

class FinanceState extends Equatable {
  final User? user;

  FinanceState({
    this.user,
  });

  FinanceState copyWith({
    User? user,
  }) {
    return FinanceState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}
