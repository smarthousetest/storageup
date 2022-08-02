// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'local_storage.errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$LocalStorageErrorTearOff {
  const _$LocalStorageErrorTearOff();

  ObjectsReferenceNotFound objectsReferenceNotFound() {
    return const ObjectsReferenceNotFound();
  }
}

/// @nodoc
const $LocalStorageError = _$LocalStorageErrorTearOff();

/// @nodoc
mixin _$LocalStorageError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() objectsReferenceNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? objectsReferenceNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? objectsReferenceNotFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ObjectsReferenceNotFound value)
        objectsReferenceNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ObjectsReferenceNotFound value)? objectsReferenceNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ObjectsReferenceNotFound value)? objectsReferenceNotFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalStorageErrorCopyWith<$Res> {
  factory $LocalStorageErrorCopyWith(
          LocalStorageError value, $Res Function(LocalStorageError) then) =
      _$LocalStorageErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$LocalStorageErrorCopyWithImpl<$Res>
    implements $LocalStorageErrorCopyWith<$Res> {
  _$LocalStorageErrorCopyWithImpl(this._value, this._then);

  final LocalStorageError _value;
  // ignore: unused_field
  final $Res Function(LocalStorageError) _then;
}

/// @nodoc
abstract class $ObjectsReferenceNotFoundCopyWith<$Res> {
  factory $ObjectsReferenceNotFoundCopyWith(ObjectsReferenceNotFound value,
          $Res Function(ObjectsReferenceNotFound) then) =
      _$ObjectsReferenceNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class _$ObjectsReferenceNotFoundCopyWithImpl<$Res>
    extends _$LocalStorageErrorCopyWithImpl<$Res>
    implements $ObjectsReferenceNotFoundCopyWith<$Res> {
  _$ObjectsReferenceNotFoundCopyWithImpl(ObjectsReferenceNotFound _value,
      $Res Function(ObjectsReferenceNotFound) _then)
      : super(_value, (v) => _then(v as ObjectsReferenceNotFound));

  @override
  ObjectsReferenceNotFound get _value =>
      super._value as ObjectsReferenceNotFound;
}

/// @nodoc

class _$ObjectsReferenceNotFound
    with DiagnosticableTreeMixin
    implements ObjectsReferenceNotFound {
  const _$ObjectsReferenceNotFound();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LocalStorageError.objectsReferenceNotFound()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'type', 'LocalStorageError.objectsReferenceNotFound'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ObjectsReferenceNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() objectsReferenceNotFound,
  }) {
    return objectsReferenceNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? objectsReferenceNotFound,
  }) {
    return objectsReferenceNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? objectsReferenceNotFound,
    required TResult orElse(),
  }) {
    if (objectsReferenceNotFound != null) {
      return objectsReferenceNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ObjectsReferenceNotFound value)
        objectsReferenceNotFound,
  }) {
    return objectsReferenceNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ObjectsReferenceNotFound value)? objectsReferenceNotFound,
  }) {
    return objectsReferenceNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ObjectsReferenceNotFound value)? objectsReferenceNotFound,
    required TResult orElse(),
  }) {
    if (objectsReferenceNotFound != null) {
      return objectsReferenceNotFound(this);
    }
    return orElse();
  }
}

abstract class ObjectsReferenceNotFound implements LocalStorageError {
  const factory ObjectsReferenceNotFound() = _$ObjectsReferenceNotFound;
}
