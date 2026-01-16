import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:no_gerd/features/auth/data/models/user_model.dart';

/// Auth DataSource Interface
abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({required String email, required String password});
  Future<UserModel> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
  Future<void> resendVerificationEmail();
  Future<void> sendPasswordResetEmail(String email);
}

/// Supabase Auth DataSource 구현
@LazySingleton(as: AuthRemoteDataSource)
class SupabaseAuthDataSource implements AuthRemoteDataSource {
  const SupabaseAuthDataSource(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('회원가입 실패');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('회원가입 중 오류 발생: ${e}');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('로그인 실패');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('로그인 중 오류 발생: ${e}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('로그아웃 중 오류 발생: ${e}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw AuthDataSourceException('사용자 정보 조회 실패: ${e}');
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: user.email,
      );
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('인증 이메일 발송 실패: ${e}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthDataSourceException(e.message);
    } catch (e) {
      throw AuthDataSourceException('비밀번호 재설정 이메일 발송 실패: ${e}');
    }
  }
}

/// Auth DataSource Exception
class AuthDataSourceException implements Exception {
  const AuthDataSourceException(this.message);

  final String message;

  @override
  String toString() => 'AuthDataSourceException: $message';
}
