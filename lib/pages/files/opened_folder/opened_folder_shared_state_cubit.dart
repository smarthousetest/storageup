import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';

class FilesSharedState extends Equatable {
  const FilesSharedState({required this.representation});

  final FilesRepresentation representation;

  FilesSharedState copyWith({FilesRepresentation? representation}) {
    return FilesSharedState(
        representation: representation ?? this.representation);
  }

  @override
  List<Object?> get props => [representation];
}

class FilesSharedStateCubit extends Cubit<FilesSharedState> {
  FilesSharedStateCubit(super.initialState);

  void changeRepresentation(FilesRepresentation representation) {
    emit(state.copyWith(representation: representation));
  }
}
