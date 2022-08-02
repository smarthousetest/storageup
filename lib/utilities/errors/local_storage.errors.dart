import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_storage.errors.freezed.dart';

@freezed
class LocalStorageError with _$LocalStorageError {
  const factory LocalStorageError.objectsReferenceNotFound() =
      ObjectsReferenceNotFound;
}
