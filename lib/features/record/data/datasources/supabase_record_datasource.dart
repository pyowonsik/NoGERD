import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:no_gerd/features/record/data/datasources/record_remote_datasource.dart';
import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';

@LazySingleton(as: RecordRemoteDataSource)
class SupabaseRecordDataSource implements RecordRemoteDataSource {
  final SupabaseClient _supabase;

  SupabaseRecordDataSource(this._supabase);

  void _log(String message, {Object? error}) {
    developer.log(
      message,
      name: 'SupabaseRecordDataSource',
      error: error,
    );
    // ignore: avoid_print
    print('[SupabaseRecordDataSource] $message');
    if (error != null) {
      // ignore: avoid_print
      print('[SupabaseRecordDataSource] Error: $error');
    }
  }

  @override
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      _log('getSymptomRecords: date=$date, start=$startOfDay, end=$endOfDay');
      _log('Current user: ${_supabase.auth.currentUser?.id}');

      final response = await _supabase
          .from('symptom_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      _log('getSymptomRecords response: $response');

      return (response as List)
          .map((json) => SymptomRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log('getSymptomRecords failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('증상 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> addSymptomRecord(SymptomRecordModel record) async {
    try {
      final json = record.toJson();
      _log('addSymptomRecord: $json');
      _log('Current user: ${_supabase.auth.currentUser?.id}');

      final response = await _supabase.from('symptom_records').insert(json).select();
      _log('addSymptomRecord response: $response');
    } catch (e, st) {
      _log('addSymptomRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('증상 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateSymptomRecord(SymptomRecordModel record) async {
    try {
      final json = record.toJson();
      _log('updateSymptomRecord: id=${record.id}, json=$json');

      await _supabase
          .from('symptom_records')
          .update(json)
          .eq('id', record.id);

      _log('updateSymptomRecord success');
    } catch (e, st) {
      _log('updateSymptomRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('증상 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteSymptomRecord(String id) async {
    try {
      _log('deleteSymptomRecord: id=$id');

      await _supabase.from('symptom_records').delete().eq('id', id);

      _log('deleteSymptomRecord success');
    } catch (e, st) {
      _log('deleteSymptomRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('증상 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<MealRecordModel>> getMealRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      _log('getMealRecords: date=$date');

      final response = await _supabase
          .from('meal_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      _log('getMealRecords response: $response');

      return (response as List)
          .map((json) => MealRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log('getMealRecords failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('식사 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> addMealRecord(MealRecordModel record) async {
    try {
      final json = record.toJson();
      _log('addMealRecord: $json');
      _log('Current user: ${_supabase.auth.currentUser?.id}');

      final response = await _supabase.from('meal_records').insert(json).select();
      _log('addMealRecord response: $response');
    } catch (e, st) {
      _log('addMealRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('식사 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateMealRecord(MealRecordModel record) async {
    try {
      final json = record.toJson();
      _log('updateMealRecord: id=${record.id}');

      await _supabase
          .from('meal_records')
          .update(json)
          .eq('id', record.id);

      _log('updateMealRecord success');
    } catch (e, st) {
      _log('updateMealRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('식사 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteMealRecord(String id) async {
    try {
      _log('deleteMealRecord: id=$id');

      await _supabase.from('meal_records').delete().eq('id', id);

      _log('deleteMealRecord success');
    } catch (e, st) {
      _log('deleteMealRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('식사 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<MedicationRecordModel>> getMedicationRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      _log('getMedicationRecords: date=$date');

      final response = await _supabase
          .from('medication_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      _log('getMedicationRecords response: $response');

      return (response as List)
          .map((json) => MedicationRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log('getMedicationRecords failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('약물 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> addMedicationRecord(MedicationRecordModel record) async {
    try {
      final json = record.toJson();
      _log('addMedicationRecord: $json');
      _log('Current user: ${_supabase.auth.currentUser?.id}');

      final response = await _supabase.from('medication_records').insert(json).select();
      _log('addMedicationRecord response: $response');
    } catch (e, st) {
      _log('addMedicationRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('약물 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateMedicationRecord(MedicationRecordModel record) async {
    try {
      final json = record.toJson();
      _log('updateMedicationRecord: id=${record.id}');

      await _supabase
          .from('medication_records')
          .update(json)
          .eq('id', record.id);

      _log('updateMedicationRecord success');
    } catch (e, st) {
      _log('updateMedicationRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('약물 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteMedicationRecord(String id) async {
    try {
      _log('deleteMedicationRecord: id=$id');

      await _supabase.from('medication_records').delete().eq('id', id);

      _log('deleteMedicationRecord success');
    } catch (e, st) {
      _log('deleteMedicationRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('약물 기록 삭제 실패: $e');
    }
  }

  @override
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      _log('getLifestyleRecords: date=$date');

      final response = await _supabase
          .from('lifestyle_records')
          .select()
          .gte('record_datetime', startOfDay.toIso8601String())
          .lt('record_datetime', endOfDay.toIso8601String())
          .order('record_datetime', ascending: false);

      _log('getLifestyleRecords response: $response');

      return (response as List)
          .map((json) => LifestyleRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log('getLifestyleRecords failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('생활습관 기록 조회 실패: $e');
    }
  }

  @override
  Future<void> addLifestyleRecord(LifestyleRecordModel record) async {
    try {
      final json = record.toJson();
      _log('addLifestyleRecord: $json');
      _log('Current user: ${_supabase.auth.currentUser?.id}');

      final response = await _supabase.from('lifestyle_records').insert(json).select();
      _log('addLifestyleRecord response: $response');
    } catch (e, st) {
      _log('addLifestyleRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('생활습관 기록 추가 실패: $e');
    }
  }

  @override
  Future<void> updateLifestyleRecord(LifestyleRecordModel record) async {
    try {
      final json = record.toJson();
      _log('updateLifestyleRecord: id=${record.id}');

      await _supabase
          .from('lifestyle_records')
          .update(json)
          .eq('id', record.id);

      _log('updateLifestyleRecord success');
    } catch (e, st) {
      _log('updateLifestyleRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('생활습관 기록 수정 실패: $e');
    }
  }

  @override
  Future<void> deleteLifestyleRecord(String id) async {
    try {
      _log('deleteLifestyleRecord: id=$id');

      await _supabase.from('lifestyle_records').delete().eq('id', id);

      _log('deleteLifestyleRecord success');
    } catch (e, st) {
      _log('deleteLifestyleRecord failed', error: e);
      _log('Stack trace: $st');
      throw RecordDataSourceException('생활습관 기록 삭제 실패: $e');
    }
  }
}
