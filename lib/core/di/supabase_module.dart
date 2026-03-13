import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 모듈 - SupabaseClient 등록
@module
abstract class SupabaseModule {
  /// SupabaseClient 인스턴스 제공
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
