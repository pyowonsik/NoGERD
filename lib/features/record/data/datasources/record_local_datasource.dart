import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';

/// 로컬 데이터소스 예외
class RecordLocalDataSourceException implements Exception {
  /// 생성자
  RecordLocalDataSourceException(this.message);

  /// 예외 메시지
  final String message;

  @override
  String toString() => 'RecordLocalDataSourceException: $message';
}

/// 동기화 대기 중인 레코드
class PendingSyncRecord {
  /// 생성자
  PendingSyncRecord({
    required this.id,
    required this.type,
    required this.action,
    required this.data,
    required this.createdAt,
  });

  /// JSON에서 PendingSyncRecord 생성
  factory PendingSyncRecord.fromJson(Map<String, dynamic> json) {
    return PendingSyncRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      data: json['data'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 레코드 ID
  final String id;

  /// 레코드 타입
  final String type;

  /// 동기화 액션
  final String action;

  /// 레코드 데이터
  final String data;

  /// 생성 시간
  final DateTime createdAt;

  /// JSON으로 변환
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'action': action,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Record 로컬 데이터 소스 인터페이스
abstract class RecordLocalDataSource {
  /// 초기화
  Future<void> init();

  // Symptom Records
  /// 증상 기록 조회
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);

  /// 증상 기록 범위 조회
  Future<List<SymptomRecordModel>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 증상 기록 캐싱
  Future<void> cacheSymptomRecords(
    DateTime date,
    List<SymptomRecordModel> records,
  );

  /// 증상 기록 추가
  Future<void> addSymptomRecord(SymptomRecordModel record);

  /// 증상 기록 수정
  Future<void> updateSymptomRecord(SymptomRecordModel record);

  /// 증상 기록 upsert
  Future<void> upsertSymptomRecord(SymptomRecordModel record);

  /// 증상 기록 삭제
  Future<void> deleteSymptomRecord(String id);

  // Meal Records
  /// 식사 기록 조회
  Future<List<MealRecordModel>> getMealRecords(DateTime date);

  /// 식사 기록 범위 조회
  Future<List<MealRecordModel>> getMealRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 식사 기록 캐싱
  Future<void> cacheMealRecords(DateTime date, List<MealRecordModel> records);

  /// 식사 기록 추가
  Future<void> addMealRecord(MealRecordModel record);

  /// 식사 기록 수정
  Future<void> updateMealRecord(MealRecordModel record);

  /// 식사 기록 upsert
  Future<void> upsertMealRecord(MealRecordModel record);

  /// 식사 기록 삭제
  Future<void> deleteMealRecord(String id);

  // Medication Records
  /// 약물 기록 조회
  Future<List<MedicationRecordModel>> getMedicationRecords(DateTime date);

  /// 약물 기록 범위 조회
  Future<List<MedicationRecordModel>> getMedicationRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 약물 기록 캐싱
  Future<void> cacheMedicationRecords(
    DateTime date,
    List<MedicationRecordModel> records,
  );

  /// 약물 기록 추가
  Future<void> addMedicationRecord(MedicationRecordModel record);

  /// 약물 기록 수정
  Future<void> updateMedicationRecord(MedicationRecordModel record);

  /// 약물 기록 upsert
  Future<void> upsertMedicationRecord(MedicationRecordModel record);

  /// 약물 기록 삭제
  Future<void> deleteMedicationRecord(String id);

  // Lifestyle Records
  /// 생활습관 기록 조회
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date);

  /// 생활습관 기록 범위 조회
  Future<List<LifestyleRecordModel>> getLifestyleRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 생활습관 기록 캐싱
  Future<void> cacheLifestyleRecords(
    DateTime date,
    List<LifestyleRecordModel> records,
  );

  /// 생활습관 기록 추가
  Future<void> addLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 수정
  Future<void> updateLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 upsert
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 삭제
  Future<void> deleteLifestyleRecord(String id);

  // Pending Sync
  /// 동기화 대기열에 추가
  Future<void> addToPendingSync(PendingSyncRecord record);

  /// 동기화 대기 레코드 조회
  Future<List<PendingSyncRecord>> getPendingSyncRecords();

  /// 동기화 대기 레코드 삭제
  Future<void> removePendingSyncRecord(String id);

  /// 동기화 대기 레코드 전체 삭제
  Future<void> clearPendingSyncRecords();

  // Cache Management
  /// 캐시 전체 삭제
  Future<void> clearAllCache();

  /// 마지막 동기화 시간 조회
  Future<DateTime?> getLastSyncTime();

  /// 마지막 동기화 시간 설정
  Future<void> setLastSyncTime(DateTime time);
}

/// Hive 기반 로컬 데이터소스 구현
@LazySingleton(as: RecordLocalDataSource)
class HiveRecordLocalDataSource implements RecordLocalDataSource {
  static const String _symptomBoxName = 'symptom_records_cache';
  static const String _mealBoxName = 'meal_records_cache';
  static const String _medicationBoxName = 'medication_records_cache';
  static const String _lifestyleBoxName = 'lifestyle_records_cache';
  static const String _pendingSyncBoxName = 'pending_sync_records';
  static const String _metaBoxName = 'record_cache_meta';

  Box<String>? _symptomBox;
  Box<String>? _mealBox;
  Box<String>? _medicationBox;
  Box<String>? _lifestyleBox;
  Box<String>? _pendingSyncBox;
  Box<String>? _metaBox;

  void _logError(String message, {Object? error}) {
    if (kDebugMode) {
      developer.log(message, name: 'HiveRecordLocalDataSource', error: error);
    }
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Future<void> init() async {
    try {
      _symptomBox = await Hive.openBox<String>(_symptomBoxName);
      _mealBox = await Hive.openBox<String>(_mealBoxName);
      _medicationBox = await Hive.openBox<String>(_medicationBoxName);
      _lifestyleBox = await Hive.openBox<String>(_lifestyleBoxName);
      _pendingSyncBox = await Hive.openBox<String>(_pendingSyncBoxName);
      _metaBox = await Hive.openBox<String>(_metaBoxName);
    } catch (e) {
      _logError('Failed to initialize Hive boxes', error: e);
      throw RecordLocalDataSourceException('로컬 저장소 초기화 실패: $e');
    }
  }

  // ========== Symptom Records ==========

  @override
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date) async {
    try {
      final key = _dateKey(date);
      final cached = _symptomBox?.get(key);
      if (cached == null) return [];

      final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
      return jsonList
          .map((e) => SymptomRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getSymptomRecords failed', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheSymptomRecords(
    DateTime date,
    List<SymptomRecordModel> records,
  ) async {
    try {
      final key = _dateKey(date);
      final jsonList = records.map((r) => r.toJson()).toList();
      await _symptomBox?.put(key, jsonEncode(jsonList));
    } catch (e) {
      _logError('cacheSymptomRecords failed', error: e);
    }
  }

  @override
  Future<void> addSymptomRecord(SymptomRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getSymptomRecords(date);
      existing.add(record);
      await cacheSymptomRecords(date, existing);
    } catch (e) {
      _logError('addSymptomRecord failed', error: e);
    }
  }

  @override
  Future<void> updateSymptomRecord(SymptomRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getSymptomRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
        await cacheSymptomRecords(date, existing);
      }
    } catch (e) {
      _logError('updateSymptomRecord failed', error: e);
    }
  }

  @override
  Future<void> upsertSymptomRecord(SymptomRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getSymptomRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
      } else {
        existing.add(record);
      }
      await cacheSymptomRecords(date, existing);
    } catch (e) {
      _logError('upsertSymptomRecord failed', error: e);
    }
  }

  @override
  Future<void> deleteSymptomRecord(String id) async {
    try {
      final keys = _symptomBox?.keys ?? [];
      for (final key in keys) {
        final cached = _symptomBox?.get(key);
        if (cached == null) continue;

        final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
        final filtered =
            jsonList.where((e) => (e as Map<String, dynamic>)['id'] != id);
        if (filtered.length != jsonList.length) {
          await _symptomBox?.put(key, jsonEncode(filtered.toList()));
          break;
        }
      }
    } catch (e) {
      _logError('deleteSymptomRecord failed', error: e);
    }
  }

  @override
  Future<List<SymptomRecordModel>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final results = <SymptomRecordModel>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      final records = await getSymptomRecords(current);
      results.addAll(records);
      current = current.add(const Duration(days: 1));
    }
    return results;
  }

  // ========== Meal Records ==========

  @override
  Future<List<MealRecordModel>> getMealRecords(DateTime date) async {
    try {
      final key = _dateKey(date);
      final cached = _mealBox?.get(key);
      if (cached == null) return [];

      final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
      return jsonList
          .map((e) => MealRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMealRecords failed', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheMealRecords(
    DateTime date,
    List<MealRecordModel> records,
  ) async {
    try {
      final key = _dateKey(date);
      final jsonList = records.map((r) => r.toJson()).toList();
      await _mealBox?.put(key, jsonEncode(jsonList));
    } catch (e) {
      _logError('cacheMealRecords failed', error: e);
    }
  }

  @override
  Future<void> addMealRecord(MealRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMealRecords(date);
      existing.add(record);
      await cacheMealRecords(date, existing);
    } catch (e) {
      _logError('addMealRecord failed', error: e);
    }
  }

  @override
  Future<void> updateMealRecord(MealRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMealRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
        await cacheMealRecords(date, existing);
      }
    } catch (e) {
      _logError('updateMealRecord failed', error: e);
    }
  }

  @override
  Future<void> upsertMealRecord(MealRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMealRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
      } else {
        existing.add(record);
      }
      await cacheMealRecords(date, existing);
    } catch (e) {
      _logError('upsertMealRecord failed', error: e);
    }
  }

  @override
  Future<void> deleteMealRecord(String id) async {
    try {
      final keys = _mealBox?.keys ?? [];
      for (final key in keys) {
        final cached = _mealBox?.get(key);
        if (cached == null) continue;

        final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
        final filtered =
            jsonList.where((e) => (e as Map<String, dynamic>)['id'] != id);
        if (filtered.length != jsonList.length) {
          await _mealBox?.put(key, jsonEncode(filtered.toList()));
          break;
        }
      }
    } catch (e) {
      _logError('deleteMealRecord failed', error: e);
    }
  }

  @override
  Future<List<MealRecordModel>> getMealRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final results = <MealRecordModel>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      final records = await getMealRecords(current);
      results.addAll(records);
      current = current.add(const Duration(days: 1));
    }
    return results;
  }

  // ========== Medication Records ==========

  @override
  Future<List<MedicationRecordModel>> getMedicationRecords(
    DateTime date,
  ) async {
    try {
      final key = _dateKey(date);
      final cached = _medicationBox?.get(key);
      if (cached == null) return [];

      final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
      return jsonList
          .map((e) => MedicationRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getMedicationRecords failed', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheMedicationRecords(
    DateTime date,
    List<MedicationRecordModel> records,
  ) async {
    try {
      final key = _dateKey(date);
      final jsonList = records.map((r) => r.toJson()).toList();
      await _medicationBox?.put(key, jsonEncode(jsonList));
    } catch (e) {
      _logError('cacheMedicationRecords failed', error: e);
    }
  }

  @override
  Future<void> addMedicationRecord(MedicationRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMedicationRecords(date);
      existing.add(record);
      await cacheMedicationRecords(date, existing);
    } catch (e) {
      _logError('addMedicationRecord failed', error: e);
    }
  }

  @override
  Future<void> updateMedicationRecord(MedicationRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMedicationRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
        await cacheMedicationRecords(date, existing);
      }
    } catch (e) {
      _logError('updateMedicationRecord failed', error: e);
    }
  }

  @override
  Future<void> upsertMedicationRecord(MedicationRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getMedicationRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
      } else {
        existing.add(record);
      }
      await cacheMedicationRecords(date, existing);
    } catch (e) {
      _logError('upsertMedicationRecord failed', error: e);
    }
  }

  @override
  Future<void> deleteMedicationRecord(String id) async {
    try {
      final keys = _medicationBox?.keys ?? [];
      for (final key in keys) {
        final cached = _medicationBox?.get(key);
        if (cached == null) continue;

        final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
        final filtered =
            jsonList.where((e) => (e as Map<String, dynamic>)['id'] != id);
        if (filtered.length != jsonList.length) {
          await _medicationBox?.put(key, jsonEncode(filtered.toList()));
          break;
        }
      }
    } catch (e) {
      _logError('deleteMedicationRecord failed', error: e);
    }
  }

  @override
  Future<List<MedicationRecordModel>> getMedicationRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final results = <MedicationRecordModel>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      final records = await getMedicationRecords(current);
      results.addAll(records);
      current = current.add(const Duration(days: 1));
    }
    return results;
  }

  // ========== Lifestyle Records ==========

  @override
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date) async {
    try {
      final key = _dateKey(date);
      final cached = _lifestyleBox?.get(key);
      if (cached == null) return [];

      final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
      return jsonList
          .map((e) => LifestyleRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logError('getLifestyleRecords failed', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheLifestyleRecords(
    DateTime date,
    List<LifestyleRecordModel> records,
  ) async {
    try {
      final key = _dateKey(date);
      final jsonList = records.map((r) => r.toJson()).toList();
      await _lifestyleBox?.put(key, jsonEncode(jsonList));
    } catch (e) {
      _logError('cacheLifestyleRecords failed', error: e);
    }
  }

  @override
  Future<void> addLifestyleRecord(LifestyleRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getLifestyleRecords(date);
      existing.add(record);
      await cacheLifestyleRecords(date, existing);
    } catch (e) {
      _logError('addLifestyleRecord failed', error: e);
    }
  }

  @override
  Future<void> updateLifestyleRecord(LifestyleRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getLifestyleRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
        await cacheLifestyleRecords(date, existing);
      }
    } catch (e) {
      _logError('updateLifestyleRecord failed', error: e);
    }
  }

  @override
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record) async {
    try {
      final date = record.recordedAt;
      final existing = await getLifestyleRecords(date);
      final index = existing.indexWhere((r) => r.id == record.id);
      if (index >= 0) {
        existing[index] = record;
      } else {
        existing.add(record);
      }
      await cacheLifestyleRecords(date, existing);
    } catch (e) {
      _logError('upsertLifestyleRecord failed', error: e);
    }
  }

  @override
  Future<void> deleteLifestyleRecord(String id) async {
    try {
      final keys = _lifestyleBox?.keys ?? [];
      for (final key in keys) {
        final cached = _lifestyleBox?.get(key);
        if (cached == null) continue;

        final List<dynamic> jsonList = jsonDecode(cached) as List<dynamic>;
        final filtered =
            jsonList.where((e) => (e as Map<String, dynamic>)['id'] != id);
        if (filtered.length != jsonList.length) {
          await _lifestyleBox?.put(key, jsonEncode(filtered.toList()));
          break;
        }
      }
    } catch (e) {
      _logError('deleteLifestyleRecord failed', error: e);
    }
  }

  @override
  Future<List<LifestyleRecordModel>> getLifestyleRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final results = <LifestyleRecordModel>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      final records = await getLifestyleRecords(current);
      results.addAll(records);
      current = current.add(const Duration(days: 1));
    }
    return results;
  }

  // ========== Pending Sync ==========

  @override
  Future<void> addToPendingSync(PendingSyncRecord record) async {
    try {
      await _pendingSyncBox?.put(record.id, jsonEncode(record.toJson()));
    } catch (e) {
      _logError('addToPendingSync failed', error: e);
    }
  }

  @override
  Future<List<PendingSyncRecord>> getPendingSyncRecords() async {
    try {
      final records = <PendingSyncRecord>[];
      for (final key in _pendingSyncBox?.keys ?? []) {
        final json = _pendingSyncBox?.get(key);
        if (json != null) {
          records.add(
            PendingSyncRecord.fromJson(
              jsonDecode(json) as Map<String, dynamic>,
            ),
          );
        }
      }
      return records;
    } catch (e) {
      _logError('getPendingSyncRecords failed', error: e);
      return [];
    }
  }

  @override
  Future<void> removePendingSyncRecord(String id) async {
    try {
      await _pendingSyncBox?.delete(id);
    } catch (e) {
      _logError('removePendingSyncRecord failed', error: e);
    }
  }

  @override
  Future<void> clearPendingSyncRecords() async {
    try {
      await _pendingSyncBox?.clear();
    } catch (e) {
      _logError('clearPendingSyncRecords failed', error: e);
    }
  }

  // ========== Cache Management ==========

  @override
  Future<void> clearAllCache() async {
    try {
      await _symptomBox?.clear();
      await _mealBox?.clear();
      await _medicationBox?.clear();
      await _lifestyleBox?.clear();
      await _metaBox?.clear();
    } catch (e) {
      _logError('clearAllCache failed', error: e);
    }
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    try {
      final timeStr = _metaBox?.get('last_sync_time');
      if (timeStr == null) return null;
      return DateTime.parse(timeStr);
    } catch (e) {
      _logError('getLastSyncTime failed', error: e);
      return null;
    }
  }

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    try {
      await _metaBox?.put('last_sync_time', time.toIso8601String());
    } catch (e) {
      _logError('setLastSyncTime failed', error: e);
    }
  }
}
