import 'package:equatable/equatable.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();
  @override
  List<Object?> get props => [];
}

class MediaPageOpened extends MediaEvent {
  const MediaPageOpened();
}
