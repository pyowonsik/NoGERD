// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DatabaseFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$DatabaseFailureImplCopyWith(_$DatabaseFailureImpl value,
          $Res Function(_$DatabaseFailureImpl) then) =
      __$$DatabaseFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DatabaseFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$DatabaseFailureImpl>
    implements _$$DatabaseFailureImplCopyWith<$Res> {
  __$$DatabaseFailureImplCopyWithImpl(
      _$DatabaseFailureImpl _value, $Res Function(_$DatabaseFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DatabaseFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DatabaseFailureImpl implements DatabaseFailure {
  const _$DatabaseFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.database(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      __$$DatabaseFailureImplCopyWithImpl<_$DatabaseFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return database(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return database?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return database(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return database?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(this);
    }
    return orElse();
  }
}

abstract class DatabaseFailure implements Failure {
  const factory DatabaseFailure(final String message) = _$DatabaseFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(_$ValidationFailureImpl value,
          $Res Function(_$ValidationFailureImpl) then) =
      __$$ValidationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(_$ValidationFailureImpl _value,
      $Res Function(_$ValidationFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ValidationFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.validation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return validation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return validation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure(final String message) =
      _$ValidationFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(_$NotFoundFailureImpl value,
          $Res Function(_$NotFoundFailureImpl) then) =
      __$$NotFoundFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
      _$NotFoundFailureImpl _value, $Res Function(_$NotFoundFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NotFoundFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NotFoundFailureImpl implements NotFoundFailure {
  const _$NotFoundFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.notFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      __$$NotFoundFailureImplCopyWithImpl<_$NotFoundFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return notFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return notFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundFailure implements Failure {
  const factory NotFoundFailure(final String message) = _$NotFoundFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(_$UnexpectedFailureImpl value,
          $Res Function(_$UnexpectedFailureImpl) then) =
      __$$UnexpectedFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(_$UnexpectedFailureImpl _value,
      $Res Function(_$UnexpectedFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnexpectedFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnexpectedFailureImpl implements UnexpectedFailure {
  const _$UnexpectedFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unexpected(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      __$$UnexpectedFailureImplCopyWithImpl<_$UnexpectedFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return unexpected(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return unexpected?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class UnexpectedFailure implements Failure {
  const factory UnexpectedFailure(final String message) =
      _$UnexpectedFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
          _$CacheFailureImpl value, $Res Function(_$CacheFailureImpl) then) =
      __$$CacheFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
      _$CacheFailureImpl _value, $Res Function(_$CacheFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CacheFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CacheFailureImpl implements CacheFailure {
  const _$CacheFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.cache(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return cache(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return cache?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return cache(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return cache?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(this);
    }
    return orElse();
  }
}

abstract class CacheFailure implements Failure {
  const factory CacheFailure(final String message) = _$CacheFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(_$PermissionFailureImpl value,
          $Res Function(_$PermissionFailureImpl) then) =
      __$$PermissionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(_$PermissionFailureImpl _value,
      $Res Function(_$PermissionFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PermissionFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PermissionFailureImpl implements PermissionFailure {
  const _$PermissionFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.permission(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return permission(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return permission?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure implements Failure {
  const factory PermissionFailure(final String message) =
      _$PermissionFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FormatFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$FormatFailureImplCopyWith(
          _$FormatFailureImpl value, $Res Function(_$FormatFailureImpl) then) =
      __$$FormatFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FormatFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FormatFailureImpl>
    implements _$$FormatFailureImplCopyWith<$Res> {
  __$$FormatFailureImplCopyWithImpl(
      _$FormatFailureImpl _value, $Res Function(_$FormatFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FormatFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FormatFailureImpl implements FormatFailure {
  const _$FormatFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.format(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormatFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormatFailureImplCopyWith<_$FormatFailureImpl> get copyWith =>
      __$$FormatFailureImplCopyWithImpl<_$FormatFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unexpected,
    required TResult Function(String message) cache,
    required TResult Function(String message) permission,
    required TResult Function(String message) format,
  }) {
    return format(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unexpected,
    TResult? Function(String message)? cache,
    TResult? Function(String message)? permission,
    TResult? Function(String message)? format,
  }) {
    return format?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unexpected,
    TResult Function(String message)? cache,
    TResult Function(String message)? permission,
    TResult Function(String message)? format,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(FormatFailure value) format,
  }) {
    return format(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(FormatFailure value)? format,
  }) {
    return format?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(CacheFailure value)? cache,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(FormatFailure value)? format,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(this);
    }
    return orElse();
  }
}

abstract class FormatFailure implements Failure {
  const factory FormatFailure(final String message) = _$FormatFailureImpl;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$FormatFailureImplCopyWith<_$FormatFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
