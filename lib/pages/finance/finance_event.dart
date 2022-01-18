import 'package:equatable/equatable.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();
  @override
  List<Object?> get props => [];
}

class FinancePageOpened extends FinanceEvent {
  const FinancePageOpened();
}

class ChangeSubscription extends FinanceEvent {
  final String choosedSub;

  ChangeSubscription({
    required this.choosedSub,
  });

  @override
  List<Object?> get props => [choosedSub];
}
