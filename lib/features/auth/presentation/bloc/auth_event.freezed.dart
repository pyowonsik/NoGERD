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
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
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
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
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
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
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
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
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
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
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
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
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
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
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
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
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
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
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
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
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
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
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
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
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
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
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
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
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
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
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
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
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
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
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
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
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
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
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
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
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
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
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
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$AuthEventResendVerificationImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventResendVerificationImpl>
    implements _$$AuthEventResendVerificationImplCopyWith<$Res> {
  __$$AuthEventResendVerificationImplCopyWithImpl(
      _$AuthEventResendVerificationImpl _value,
      $Res Function(_$AuthEventResendVerificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$AuthEventResendVerificationImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthEventResendVerificationImpl implements AuthEventResendVerification {
  const _$AuthEventResendVerificationImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.resendVerification(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventResendVerificationImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEventResendVerificationImplCopyWith<_$AuthEventResendVerificationImpl>
      get copyWith => __$$AuthEventResendVerificationImplCopyWithImpl<
          _$AuthEventResendVerificationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
  }) {
    return resendVerification(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
  }) {
    return resendVerification?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
    required TResult orElse(),
  }) {
    if (resendVerification != null) {
      return resendVerification(email);
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
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
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
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
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
    required TResult orElse(),
  }) {
    if (resendVerification != null) {
      return resendVerification(this);
    }
    return orElse();
  }
}

abstract class AuthEventResendVerification implements AuthEvent {
  const factory AuthEventResendVerification({required final String email}) =
      _$AuthEventResendVerificationImpl;

  String get email;
  @JsonKey(ignore: true)
  _$$AuthEventResendVerificationImplCopyWith<_$AuthEventResendVerificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthEventVerifyOtpImplCopyWith<$Res> {
  factory _$$AuthEventVerifyOtpImplCopyWith(_$AuthEventVerifyOtpImpl value,
          $Res Function(_$AuthEventVerifyOtpImpl) then) =
      __$$AuthEventVerifyOtpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String token});
}

/// @nodoc
class __$$AuthEventVerifyOtpImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEventVerifyOtpImpl>
    implements _$$AuthEventVerifyOtpImplCopyWith<$Res> {
  __$$AuthEventVerifyOtpImplCopyWithImpl(_$AuthEventVerifyOtpImpl _value,
      $Res Function(_$AuthEventVerifyOtpImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? token = null,
  }) {
    return _then(_$AuthEventVerifyOtpImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthEventVerifyOtpImpl implements AuthEventVerifyOtp {
  const _$AuthEventVerifyOtpImpl({required this.email, required this.token});

  @override
  final String email;
  @override
  final String token;

  @override
  String toString() {
    return 'AuthEvent.verifyOtp(email: $email, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEventVerifyOtpImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEventVerifyOtpImplCopyWith<_$AuthEventVerifyOtpImpl> get copyWith =>
      __$$AuthEventVerifyOtpImplCopyWithImpl<_$AuthEventVerifyOtpImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkStatus,
    required TResult Function(String email, String password) signIn,
    required TResult Function(String email, String password) signUp,
    required TResult Function() signOut,
    required TResult Function(String email) resendVerification,
    required TResult Function(String email, String token) verifyOtp,
  }) {
    return verifyOtp(email, token);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkStatus,
    TResult? Function(String email, String password)? signIn,
    TResult? Function(String email, String password)? signUp,
    TResult? Function()? signOut,
    TResult? Function(String email)? resendVerification,
    TResult? Function(String email, String token)? verifyOtp,
  }) {
    return verifyOtp?.call(email, token);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkStatus,
    TResult Function(String email, String password)? signIn,
    TResult Function(String email, String password)? signUp,
    TResult Function()? signOut,
    TResult Function(String email)? resendVerification,
    TResult Function(String email, String token)? verifyOtp,
    required TResult orElse(),
  }) {
    if (verifyOtp != null) {
      return verifyOtp(email, token);
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
    required TResult Function(AuthEventVerifyOtp value) verifyOtp,
  }) {
    return verifyOtp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEventCheckStatus value)? checkStatus,
    TResult? Function(AuthEventSignIn value)? signIn,
    TResult? Function(AuthEventSignUp value)? signUp,
    TResult? Function(AuthEventSignOut value)? signOut,
    TResult? Function(AuthEventResendVerification value)? resendVerification,
    TResult? Function(AuthEventVerifyOtp value)? verifyOtp,
  }) {
    return verifyOtp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEventCheckStatus value)? checkStatus,
    TResult Function(AuthEventSignIn value)? signIn,
    TResult Function(AuthEventSignUp value)? signUp,
    TResult Function(AuthEventSignOut value)? signOut,
    TResult Function(AuthEventResendVerification value)? resendVerification,
    TResult Function(AuthEventVerifyOtp value)? verifyOtp,
    required TResult orElse(),
  }) {
    if (verifyOtp != null) {
      return verifyOtp(this);
    }
    return orElse();
  }
}

abstract class AuthEventVerifyOtp implements AuthEvent {
  const factory AuthEventVerifyOtp(
      {required final String email,
      required final String token}) = _$AuthEventVerifyOtpImpl;

  String get email;
  String get token;
  @JsonKey(ignore: true)
  _$$AuthEventVerifyOtpImplCopyWith<_$AuthEventVerifyOtpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
