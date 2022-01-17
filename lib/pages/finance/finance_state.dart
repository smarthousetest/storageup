import 'package:equatable/equatable.dart';
import 'package:upstorage_desktop/models/subscription.dart';
import 'package:upstorage_desktop/models/tariff.dart';
import 'package:upstorage_desktop/models/user.dart';

class FinanceState extends Equatable {
  final User? user;
  final Subscription? sub;
  final Tariff? numberSub;

  FinanceState({this.user, this.sub, this.numberSub});

  FinanceState copyWith({User? user, Subscription? sub, Tariff? numberSub}) {
    return FinanceState(
        user: user ?? this.user,
        sub: sub ?? this.sub,
        numberSub: numberSub ?? numberSub);
  }

  @override
  List<Object?> get props => [user, sub, numberSub];
}
