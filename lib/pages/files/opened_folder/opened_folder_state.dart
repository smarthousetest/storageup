import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:storageup/models/base_object.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/folder.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';

class OpenedFolderState extends Equatable {
  final Folder? currentFolder;
  final List<BaseObject> objects;
  final List<BaseObject> sortedFiles;
  final List<Folder> previousFolders;
  final FilesRepresentation representation;
  final FormzStatus status;
  final Map<String, List<BaseObject>> groupedFiles;
  final SortingCriterion criterion;
  final SortingDirection direction;
  final String search;
  final bool progress;
  final ResponseStatus? responseStatus;
  final User? user;
  final ValueNotifier<User?>? valueNotifier;

  OpenedFolderState({
    this.currentFolder,
    required this.objects,
    this.sortedFiles = const [],
    this.status = FormzStatus.pure,
    this.criterion = SortingCriterion.byDateCreated,
    this.direction = SortingDirection.down,
    required this.previousFolders,
    this.responseStatus,
    this.search = '',
    this.groupedFiles = const {},
    this.progress = false,
    this.representation = FilesRepresentation.grid,
    this.user,
    this.valueNotifier,
  });

  OpenedFolderState copyWith({
    Folder? currentFolder,
    List<BaseObject>? objects,
    List<BaseObject>? sortedFiles,
    Map<String, List<BaseObject>>? groupedFiles,
    FormzStatus? status,
    String? search,
    SortingDirection? direction,
    SortingCriterion? criterion,
    List<Folder>? previousFolders,
    FilesRepresentation? representation,
    ResponseStatus? responseStatus,
    bool? progress,
    User? user,
    ValueNotifier<User?>? valueNotifier,
  }) {
    return OpenedFolderState(
      currentFolder: currentFolder ?? this.currentFolder,
      groupedFiles: groupedFiles ?? this.groupedFiles,
      status: status ?? this.status,
      criterion: criterion ?? this.criterion,
      direction: direction ?? this.direction,
      objects: objects ?? this.objects,
      search: search ?? this.search,
      sortedFiles: sortedFiles ?? this.sortedFiles,
      previousFolders: previousFolders ?? this.previousFolders,
      representation: representation ?? this.representation,
      progress: progress ?? this.progress,
      responseStatus: responseStatus ?? this.responseStatus,
      user: user ?? this.user,
      valueNotifier: valueNotifier ?? this.valueNotifier,
    );
  }

  @override
  List<Object?> get props => [
        currentFolder,
        objects,
        previousFolders,
        representation,
        groupedFiles,
        sortedFiles,
        criterion,
        direction,
        status,
        search,
        progress,
        responseStatus,
        user,
        valueNotifier,
      ];
}

enum FilesRepresentation { grid, table }
