// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthEventCheckStatusImplCopyWith<$Res> {
  factory _$$AuthEventCheckStatusImplCopyWith(_$AuthEventCheckStatusImpl value,
          $Res Function(_$AuthEventCheckStatusImpl) then) =
      __$$AuthEventCheckStatusImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthEventCheckStatusImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventCheckStatusImpl>
    implements _$$AuthEventCheckStatusImplCopyWith<$Res> {
  __$$AuthEventCheckStatusImplCopyWithImpl(_$AuthEventCheckStatusImpl _value,
      $Res Function(_$AuthEventCheckStatusImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthEventCheckStatusImpl implements AuthEventCheckStatus {
  const _$AuthEventCheckStatusImpl();

  @override
  String toString() {
    return 'AuthEvent.checkStatus()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventCheckStatusImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) {
    return checkStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) {
    return checkStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) {
    return checkStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) {
    return checkStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus(this);
    }
    return orElse();
  }
}

abstract class AuthEventCheckStatus implements AuthEvent {
  const factory AuthEventCheckStatus() = _$AuthEventCheckStatusImpl;
}

/// @nodoc
abstract class _$$AuthEventSignInImplCopyWith<$Res> {
  factory _$$AuthEventSignInImplCopyWith(_$AuthEventSignInImpl value,
          $Res Function(_$AuthEventSignInImpl) then) =
      __$$AuthEventSignInImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$AuthEventSignInImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventSignInImpl>
    implements _$$AuthEventSignInImplCopyWith<$Res> {
  __$$AuthEventSignInImplCopyWithImpl(
      _$AuthEventSignInImpl _value, $Res Function(_$AuthEventSignInImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$AuthEventSignInImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthEventSignInImpl implements AuthEventSignIn {
  const _$AuthEventSignInImpl({required this.email, required this.password});

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.signIn(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventSignInImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEventSignInImplCopyWith<_$AuthEventSignInImpl> get copyWith =>
      __$$AuthEventSignInImplCopyWithImpl<_$AuthEventSignInImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) {
    return signIn(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) {
    return signIn?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) {
    if (signIn != null) {
      return signIn(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) {
    return signIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) {
    return signIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) {
    if (signIn != null) {
      return signIn(this);
    }
    return orElse();
  }
}

abstract class AuthEventSignIn implements AuthEvent {
  const factory AuthEventSignIn(
      {required final String email,
      required final String password}) = _$AuthEventSignInImpl;

  String get email;
  String get password;
  @JsonKey(ignore: true)
  _$$AuthEventSignInImplCopyWith<_$AuthEventSignInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthEventSignUpImplCopyWith<$Res> {
  factory _$$AuthEventSignUpImplCopyWith(_$AuthEventSignUpImpl value,
          $Res Function(_$AuthEventSignUpImpl) then) =
      __$$AuthEventSignUpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$AuthEventSignUpImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventSignUpImpl>
    implements _$$AuthEventSignUpImplCopyWith<$Res> {
  __$$AuthEventSignUpImplCopyWithImpl(
      _$AuthEventSignUpImpl _value, $Res Function(_$AuthEventSignUpImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$AuthEventSignUpImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthEventSignUpImpl implements AuthEventSignUp {
  const _$AuthEventSignUpImpl({required this.email, required this.password});

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.signUp(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventSignUpImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEventSignUpImplCopyWith<_$AuthEventSignUpImpl> get copyWith =>
      __$$AuthEventSignUpImplCopyWithImpl<_$AuthEventSignUpImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) {
    return signUp(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) {
    return signUp?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) {
    if (signUp != null) {
      return signUp(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) {
    return signUp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) {
    return signUp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) {
    if (signUp != null) {
      return signUp(this);
    }
    return orElse();
  }
}

abstract class AuthEventSignUp implements AuthEvent {
  const factory AuthEventSignUp(
      {required final String email,
      required final String password}) = _$AuthEventSignUpImpl;

  String get email;
  String get password;
  @JsonKey(ignore: true)
  _$$AuthEventSignUpImplCopyWith<_$AuthEventSignUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthEventSignOutImplCopyWith<$Res> {
  factory _$$AuthEventSignOutImplCopyWith(_$AuthEventSignOutImpl value,
          $Res Function(_$AuthEventSignOutImpl) then) =
      __$$AuthEventSignOutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthEventSignOutImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventSignOutImpl>
    implements _$$AuthEventSignOutImplCopyWith<$Res> {
  __$$AuthEventSignOutImplCopyWithImpl(_$AuthEventSignOutImpl _value,
      $Res Function(_$AuthEventSignOutImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthEventSignOutImpl implements AuthEventSignOut {
  const _$AuthEventSignOutImpl();

  @override
  String toString() {
    return 'AuthEvent.signOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthEventSignOutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) {
    return signOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) {
    return signOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) {
    return signOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) {
    return signOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut(this);
    }
    return orElse();
  }
}

abstract class AuthEventSignOut implements AuthEvent {
  const factory AuthEventSignOut() = _$AuthEventSignOutImpl;
}

/// @nodoc
abstract class _$$AuthEventResendVerificationImplCopyWith<$Res> {
  factory _$$AuthEventResendVerificationImplCopyWith(
          _$AuthEventResendVerificationImpl value,
          $Res Function(_$AuthEventResendVerificationImpl) then) =
      __$$AuthEventResendVerificationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthEventResendVerificationImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventResendVerificationImpl>
    implements _$$AuthEventResendVerificationImplCopyWith<$Res> {
  __$$AuthEventResendVerificationImplCopyWithImpl(
      _$AuthEventResendVerificationImpl _value,
      $Res Function(_$AuthEventResendVerificationImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthEventResendVerificationImpl implements AuthEventResendVerification {
  const _$AuthEventResendVerificationImpl();

  @override
  String toString() {
    return 'AuthEvent.resendVerification()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventResendVerificationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function() resendVerification,
  }) {
    return resendVerification();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function()? resendVerification,
  }) {
    return resendVerification?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function()? resendVerification,
    required TResult orElse(),
  }) {
    if (resendVerification != null) {
      return resendVerification();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEventCheckStatus value) checkStatus,
    required TResult Function(AuthEventSignIn value) signIn,
    required TResult Function(AuthEventSignUp value) signUp,
    required TResult Function(AuthEventSignOut value) signOut,
    required TResult Function(AuthEventResendVerification value)
        resendVerification,
  }) {
    return resendVerification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
  }) {
    return resendVerification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    required TResult orElse(),
  }) {
    if (resendVerification != null) {
      return resendVerification(this);
    }
    return orElse();
  }
}

abstract class AuthEventResendVerification implements AuthEvent {
  const factory AuthEventResendVerification() =
      _$AuthEventResendVerificationImpl;
}
