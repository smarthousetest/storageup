import 'package:equatable/equatable.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();
  @override
  List<Object?> get props => [];
}

class FinancePageOpened extends FinanceEvent {
  const FinancePageOpened();
}
