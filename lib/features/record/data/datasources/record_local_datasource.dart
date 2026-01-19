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
  RecordLocalDataSourceException(this.message);
  final String message;

  @override
  String toString() => 'RecordLocalDataSourceException: $message';
}

/// 동기화 대기 중인 레코드
class PendingSyncRecord {
  PendingSyncRecord({
    required this.id,
    required this.type,
    required this.action,
    required this.data,
    required this.createdAt,
  });

  factory PendingSyncRecord.fromJson(Map<String, dynamic> json) {
    return PendingSyncRecord(
      id: json['id'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      data: json['data'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  final String id;
  final String type;
  final String action;
  final String data;
  final DateTime createdAt;

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
  Future<void> init();

  // Symptom Records
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);
  Future<List<SymptomRecordModel>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> cacheSymptomRecords(
    DateTime date,
    List<SymptomRecordModel> records,
  );
  Future<void> addSymptomRecord(SymptomRecordModel record);
  Future<void> updateSymptomRecord(SymptomRecordModel record);
  Future<void> upsertSymptomRecord(SymptomRecordModel record);
  Future<void> deleteSymptomRecord(String id);

  // Meal Records
  Future<List<MealRecordModel>> getMealRecords(DateTime date);
  Future<List<MealRecordModel>> getMealRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> cacheMealRecords(DateTime date, List<MealRecordModel> records);
  Future<void> addMealRecord(MealRecordModel record);
  Future<void> updateMealRecord(MealRecordModel record);
  Future<void> upsertMealRecord(MealRecordModel record);
  Future<void> deleteMealRecord(String id);

  // Medication Records
  Future<List<MedicationRecordModel>> getMedicationRecords(DateTime date);
  Future<List<MedicationRecordModel>> getMedicationRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> cacheMedicationRecords(
    DateTime date,
    List<MedicationRecordModel> records,
  );
  Future<void> addMedicationRecord(MedicationRecordModel record);
  Future<void> updateMedicationRecord(MedicationRecordModel record);
  Future<void> upsertMedicationRecord(MedicationRecordModel record);
  Future<void> deleteMedicationRecord(String id);

  // Lifestyle Records
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date);
  Future<List<LifestyleRecordModel>> getLifestyleRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> cacheLifestyleRecords(
    DateTime date,
    List<LifestyleRecordModel> records,
  );
  Future<void> addLifestyleRecord(LifestyleRecordModel record);
  Future<void> updateLifestyleRecord(LifestyleRecordModel record);
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record);
  Future<void> deleteLifestyleRecord(String id);

  // Pending Sync
  Future<void> addToPendingSync(PendingSyncRecord record);
  Future<List<PendingSyncRecord>> getPendingSyncRecords();
  Future<void> removePendingSyncRecord(String id);
  Future<void> clearPendingSyncRecords();

  // Cache Management
  Future<void> clearAllCache();
  Future<DateTime?> getLastSyncTime();
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
