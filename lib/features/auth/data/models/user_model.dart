import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:no_gerd/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 Model
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'email_confirmed_at') DateTime? emailConfirmedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email!,
      emailConfirmedAt: user.emailConfirmedAt != null
          ? DateTime.parse(user.emailConfirmedAt!)
          : null,
      createdAt: DateTime.parse(user.createdAt!),
      updatedAt: user.updatedAt != null
          ? DateTime.parse(user.updatedAt!)
          : null,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      emailConfirmed: emailConfirmedAt != null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
