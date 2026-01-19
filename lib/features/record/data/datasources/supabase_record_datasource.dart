import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:no_gerd/features/record/data/datasources/record_remote_datasource.dart';
import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';

@LazySingleton(as: RecordRemoteDataSource)
class SupabaseRecordDataSource implements RecordRemoteDataSource {
  SupabaseRecordDataSource(this._supabase);
  final SupabaseClient _supabase;

  void _logError(String message, {Object? error}) {
    if (kDebugMode) {
      developer.log(message, name: 'SupabaseRecordDataSource', error: error);
    }
  }

  @override
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('symptom_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              SymptomRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getSymptomRecords failed', error: e);
      throw RecordDataSourceException('증상 기록 조회 실패: $e');
    }
  }

  @override
  Future<List<SymptomRecordModel>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day)
          .add(const Duration(days: 1));

      final response = await _supabase
          .from('symptom_records')
          .select()
          .gte('record_datetime', start.toIso8601String())
          .lt('record_datetime', end.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              SymptomRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getSymptomRecordsInRange failed', error: e);
      throw RecordDataSourceException('증상 기록 범위 조회 실패: $e');
    }
  }

  @override
  Future<void> addSymptomRecord(SymptomRecordModel record) async {
    try {
      await _supabase.from('symptom_records').insert(record.toJson()).select();
    } catch (e) {
      _logError('addSymptomRecord failed', error: e);
      throw RecordDataSourceException('증상 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateSymptomRecord(SymptomRecordModel record) async {
    try {
      await _supabase
          .from('symptom_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      _logError('updateSymptomRecord failed', error: e);
      throw RecordDataSourceException('증상 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteSymptomRecord(String id) async {
    try {
      await _supabase.from('symptom_records').delete().eq('id', id);
    } catch (e) {
      _logError('deleteSymptomRecord failed', error: e);
      throw RecordDataSourceException('증상 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<MealRecordModel>> getMealRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('meal_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) => MealRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMealRecords failed', error: e);
      throw RecordDataSourceException('식사 기록 조회 실패: $e');
    }
  }

  @override
  Future<List<MealRecordModel>> getMealRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day)
          .add(const Duration(days: 1));

      final response = await _supabase
          .from('meal_records')
          .select()
          .gte('record_datetime', start.toIso8601String())
          .lt('record_datetime', end.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) => MealRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMealRecordsInRange failed', error: e);
      throw RecordDataSourceException('식사 기록 범위 조회 실패: $e');
    }
  }

  @override
  Future<void> addMealRecord(MealRecordModel record) async {
    try {
      await _supabase.from('meal_records').insert(record.toJson()).select();
    } catch (e) {
      _logError('addMealRecord failed', error: e);
      throw RecordDataSourceException('식사 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateMealRecord(MealRecordModel record) async {
    try {
      await _supabase
          .from('meal_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      _logError('updateMealRecord failed', error: e);
      throw RecordDataSourceException('식사 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteMealRecord(String id) async {
    try {
      await _supabase.from('meal_records').delete().eq('id', id);
    } catch (e) {
      _logError('deleteMealRecord failed', error: e);
      throw RecordDataSourceException('식사 기록 삭제 실패: $e');
    }
  }

  @override
  Future<MealRecordModel?> getMealRecordByDateAndType(
    DateTime date,
    String mealType,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('meal_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .eq('meal_type', mealType)
          .maybeSingle();

      if (response == null) return null;
      return MealRecordModel.fromJson(response);
    } catch (e) {
      _logError('getMealRecordByDateAndType failed', error: e);
      throw RecordDataSourceException('식사 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> upsertMealRecord(MealRecordModel record) async {
    try {
      await _supabase.from('meal_records').upsert(record.toJson());
    } catch (e) {
      _logError('upsertMealRecord failed', error: e);
      throw RecordDataSourceException('식사 기록 저장 실패: $e');
    }
  }

  @override
  Future<List<MedicationRecordModel>> getMedicationRecords(
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('medication_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              MedicationRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMedicationRecords failed', error: e);
      throw RecordDataSourceException('약물 기록 조회 실패: $e');
    }
  }

  @override
  Future<List<MedicationRecordModel>> getMedicationRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day)
          .add(const Duration(days: 1));

      final response = await _supabase
          .from('medication_records')
          .select()
          .gte('record_datetime', start.toIso8601String())
          .lt('record_datetime', end.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              MedicationRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMedicationRecordsInRange failed', error: e);
      throw RecordDataSourceException('약물 기록 범위 조회 실패: $e');
    }
  }

  @override
  Future<void> addMedicationRecord(MedicationRecordModel record) async {
    try {
      await _supabase
          .from('medication_records')
          .insert(record.toJson())
          .select();
    } catch (e) {
      _logError('addMedicationRecord failed', error: e);
      throw RecordDataSourceException('약물 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateMedicationRecord(MedicationRecordModel record) async {
    try {
      await _supabase
          .from('medication_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      _logError('updateMedicationRecord failed', error: e);
      throw RecordDataSourceException('약물 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteMedicationRecord(String id) async {
    try {
      await _supabase.from('medication_records').delete().eq('id', id);
    } catch (e) {
      _logError('deleteMedicationRecord failed', error: e);
      throw RecordDataSourceException('약물 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('lifestyle_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              LifestyleRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getLifestyleRecords failed', error: e);
      throw RecordDataSourceException('생활습관 기록 조회 실패: $e');
    }
  }

  @override
  Future<List<LifestyleRecordModel>> getLifestyleRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day)
          .add(const Duration(days: 1));

      final response = await _supabase
          .from('lifestyle_records')
          .select()
          .gte('record_datetime', start.toIso8601String())
          .lt('record_datetime', end.toIso8601String())
          .order('record_datetime', ascending: false);

      return (response as List)
          .map((json) =>
              LifestyleRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getLifestyleRecordsInRange failed', error: e);
      throw RecordDataSourceException('생활습관 기록 범위 조회 실패: $e');
    }
  }

  @override
  Future<void> addLifestyleRecord(LifestyleRecordModel record) async {
    try {
      await _supabase
          .from('lifestyle_records')
          .insert(record.toJson())
          .select();
    } catch (e) {
      _logError('addLifestyleRecord failed', error: e);
      throw RecordDataSourceException('생활습관 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateLifestyleRecord(LifestyleRecordModel record) async {
    try {
      await _supabase
          .from('lifestyle_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      _logError('updateLifestyleRecord failed', error: e);
      throw RecordDataSourceException('생활습관 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteLifestyleRecord(String id) async {
    try {
      await _supabase.from('lifestyle_records').delete().eq('id', id);
    } catch (e) {
      _logError('deleteLifestyleRecord failed', error: e);
      throw RecordDataSourceException('생활습관 기록 삭제 실패: $e');
    }
  }

  @override
  Future<LifestyleRecordModel?> getLifestyleRecordByDateAndType(
    DateTime date,
    String lifestyleType,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('lifestyle_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .eq('lifestyle_type', lifestyleType)
          .maybeSingle();

      if (response == null) return null;
      return LifestyleRecordModel.fromJson(response);
    } catch (e) {
      _logError('getLifestyleRecordByDateAndType failed', error: e);
      throw RecordDataSourceException('생활습관 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record) async {
    try {
      await _supabase.from('lifestyle_records').upsert(record.toJson());
    } catch (e) {
      _logError('upsertLifestyleRecord failed', error: e);
      throw RecordDataSourceException('생활습관 기록 저장 실패: $e');
    }
  }
}
