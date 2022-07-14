import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:storageup/pages/files/file_bloc.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';

abstract class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object?> get props => [];
}

class FilesSortingFieldChanged extends FilesEvent {
  final String sortingText;

  const FilesSortingFieldChanged({required this.sortingText});

  @override
  List<Object?> get props => [sortingText];
}

class FilesPageOpened extends FilesEvent {
  final BaseObject? choosedFolder;
  final String? folderId;
  final List<BaseObject>? filesToMove;

  const FilesPageOpened({this.folderId, this.filesToMove, this.choosedFolder});
}

class FilesSortingClear extends FilesEvent {
  const FilesSortingClear();
}

class FileSortingByCriterion extends FilesEvent {
  final SortingCriterion criterion;
  final SortingDirection direction;

  const FileSortingByCriterion({
    required this.criterion,
    required this.direction,
  });

  @override
  List<Object?> get props => [criterion];
}

class FileTapped extends FilesEvent {
  final Record record;

  FileTapped({required this.record});
}

class FileContextActionChoosed extends FilesEvent {
  final BaseObject file;
  final ContextActionEnum action;

  FileContextActionChoosed({
    required this.file,
    required this.action,
  });

  @override
  List<Object?> get props => [file, action];
}

class FileRename extends FilesEvent {
  final String newName;
  final BaseObject object;

  FileRename({required this.newName, required this.object});

  @override
  List<Object?> get props => [newName, object];
}

class FileAddFile extends FilesEvent {
  final BuildContext context;

  FileAddFile({required this.context});

  @override
  List<Object?> get props => [context];
}

class FileDownloadFile extends FilesEvent {
  final Record file;

  FileDownloadFile({required this.file});

  @override
  List<Object?> get props => [file];
}

class FileUpdateFiles extends FilesEvent {
  final String? id;

  FileUpdateFiles({this.id});

  @override
  List<Object?> get props => [id];
}

class FileAddFolder extends FilesEvent {
  final String? parentFolderId;
  final String name;

  FileAddFolder({
    required this.name,
    this.parentFolderId,
  });

  @override
  List<Object?> get props => [name, parentFolderId];
}

class FileChangeUploadPercent extends FilesEvent {
  final String id;
  final double? percent;

  FileChangeUploadPercent({
    required this.id,
    required this.percent,
  });

  @override
  List<Object?> get props => [id, percent];
}

class FilesMoveHere extends FilesEvent {
  FilesMoveHere();
}

class FilesNoInternet extends FilesEvent {
  FilesNoInternet();
}

class FilesDiscardSelecting extends FilesEvent {
  FilesDiscardSelecting();
}

class FilesDeleteChosen extends FilesEvent {
  final List<BaseObject> chosenObjects;

  FilesDeleteChosen({required this.chosenObjects});

  @override
  List<Object?> get props => [chosenObjects];
}
