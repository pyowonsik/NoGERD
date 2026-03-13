import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// 사용자 Entity
@freezed
class User with _$User {
  /// User 생성자
  const factory User({
    required String id,
    required String email,
    required bool emailConfirmed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _User;
}
