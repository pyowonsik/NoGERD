import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/repositories/settings_repository.dart';

/// 설정 Repository 구현체
@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;
  final SupabaseClient _supabaseClient;

  /// 생성자
  SettingsRepositoryImpl(
    this._localDataSource,
    this._supabaseClient,
  );

  @override
  Future<Either<Failure, AppSettings>> loadSettings() async {
    try {
      final settings = await _localDataSource.getSettings();
      return right(settings);
    } catch (e) {
      return left(Failure.database('설정 로드 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings) async {
    try {
      await _localDataSource.saveSettings(settings);
      return right(unit);
    } catch (e) {
      return left(Failure.database('설정 저장 실패: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportData() async {
    try {
      // 1. Supabase에서 현재 사용자 ID 가져오기
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return left(Failure.unauthorized('로그인이 필요합니다.'));
      }

      // 2. 모든 기록 가져오기
      final symptomData = await _supabaseClient
          .from('symptom_records')
          .select()
          .eq('user_id', userId)
          .order('record_datetime');
      final symptomRecords = symptomData as List<dynamic>? ?? [];

      final mealData = await _supabaseClient
          .from('meal_records')
          .select()
          .eq('user_id', userId)
          .order('record_datetime');
      final mealRecords = mealData as List<dynamic>? ?? [];

      final medicationData = await _supabaseClient
          .from('medication_records')
          .select()
          .eq('user_id', userId)
          .order('record_datetime');
      final medicationRecords = medicationData as List<dynamic>? ?? [];

      final lifestyleData = await _supabaseClient
          .from('lifestyle_records')
          .select()
          .eq('user_id', userId)
          .order('record_datetime');
      final lifestyleRecords = lifestyleData as List<dynamic>? ?? [];

      // 3. CSV 데이터 생성
      List<List<dynamic>> rows = [
        [
          '타입',
          '날짜',
          '시간',
          '증상',
          '심각도',
          '식사 유형',
          '음식',
          '약물명',
          '생활습관 유형',
          '메모'
        ],
      ];

      // 증상 기록 추가
      for (var record in symptomRecords) {
        rows.add([
          '증상',
          record['record_datetime'] ?? '',
          '',
          (record['symptoms'] as List?)?.join(', ') ?? '',
          record['severity'] ?? '',
          '',
          '',
          '',
          '',
          record['notes'] ?? '',
        ]);
      }

      // 식사 기록 추가
      for (var record in mealRecords) {
        rows.add([
          '식사',
          record['record_datetime'] ?? '',
          '',
          '',
          '',
          record['meal_type'] ?? '',
          (record['foods'] as List?)?.join(', ') ?? '',
          '',
          '',
          record['notes'] ?? '',
        ]);
      }

      // 약물 기록 추가
      for (var record in medicationRecords) {
        rows.add([
          '약물',
          record['record_datetime'] ?? '',
          '',
          '',
          '',
          '',
          '',
          record['medication_name'] ?? '',
          '',
          record['notes'] ?? '',
        ]);
      }

      // 생활습관 기록 추가
      for (var record in lifestyleRecords) {
        rows.add([
          '생활습관',
          record['record_datetime'] ?? '',
          '',
          '',
          '',
          '',
          '',
          '',
          record['lifestyle_type'] ?? '',
          record['notes'] ?? '',
        ]);
      }

      // 4. CSV 파일 생성
      final csv = const ListToCsvConverter().convert(rows);

      // 5. 파일 저장
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/nogerd_data_$timestamp.csv';
      final file = File(path);
      await file.writeAsString(csv, encoding: utf8);

      return right(path);
    } catch (e, stackTrace) {
      print('❌ CSV Export Error: $e');
      print('Stack trace: $stackTrace');
      return left(Failure.unexpected('데이터 내보내기 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAllData() async {
    try {
      // Supabase에서 현재 사용자 ID 가져오기
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return left(Failure.unauthorized('로그인이 필요합니다.'));
      }

      // 모든 테이블에서 사용자 데이터 삭제
      await _supabaseClient
          .from('symptom_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('meal_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('medication_records')
          .delete()
          .eq('user_id', userId);

      await _supabaseClient
          .from('lifestyle_records')
          .delete()
          .eq('user_id', userId);

      return right(unit);
    } catch (e) {
      return left(Failure.database('데이터 삭제 실패: $e'));
    }
  }
}
