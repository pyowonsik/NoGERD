import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/services/connectivity_service.dart';
import 'package:no_gerd/features/record/data/datasources/record_local_datasource.dart';
import 'package:no_gerd/features/record/data/datasources/record_remote_datasource.dart';
import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

/// 오프라인/온라인 지원 하이브리드 Repository
@LazySingleton(as: IRecordRepository)
class HybridRecordRepositoryImpl implements IRecordRepository {
  // 테스트용: 목 데이터 사용 플래그 (App Store 스크린샷용)
  static const _useMockData = false;

  HybridRecordRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._supabase,
    this._connectivityService,
  ) {
    _init();
  }

  Future<void> _init() async {
    _listenConnectivity();
    // 앱 시작 시 온라인이면 대기 중인 레코드 즉시 동기화
    if (_connectivityService.isConnected) {
      await syncPendingRecords();
    }
  }

  final RecordRemoteDataSource _remoteDataSource;
  final RecordLocalDataSource _localDataSource;
  final SupabaseClient _supabase;
  final ConnectivityService _connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;

  void _logError(String message, {Object? error}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'HybridRecordRepository',
        error: error,
      );
    }
  }

  String? _getCurrentUserId() => _supabase.auth.currentUser?.id;

  bool get _isOnline => _connectivityService.isConnected;

  void _listenConnectivity() {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        syncPendingRecords();
      }
    });
  }

  // ========== Symptom Records ==========

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    // ignore: avoid_print
    print('[Repository] getSymptomRecords: $date');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getSymptomRecords(date);
          await _localDataSource.cacheSymptomRecords(date, models);
          await _localDataSource.setLastSyncTime(DateTime.now());
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getSymptomRecords(date);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getSymptomRecords(date);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // ignore: avoid_print
    print('[Repository] getSymptomRecordsInRange: $startDate ~ $endDate');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models =
              await _remoteDataSource.getSymptomRecordsInRange(startDate, endDate);
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models =
              await _localDataSource.getSymptomRecordsInRange(startDate, endDate);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models =
            await _localDataSource.getSymptomRecordsInRange(startDate, endDate);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = SymptomRecordModel.fromEntity(record, userId);

      // 로컬에 먼저 저장
      await _localDataSource.addSymptomRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.addSymptomRecord(model);
        } catch (e) {
          await _addToPendingSync('symptom', 'add', model.toJson());
        }
      } else {
        await _addToPendingSync('symptom', 'add', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSymptomRecord(
    SymptomRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = SymptomRecordModel.fromEntity(record, userId);

      // 로컬 캐시 먼저 업데이트
      await _localDataSource.updateSymptomRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.updateSymptomRecord(model);
        } catch (e) {
          await _addToPendingSync('symptom', 'update', model.toJson());
        }
      } else {
        await _addToPendingSync('symptom', 'update', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      await _localDataSource.deleteSymptomRecord(id);

      if (_isOnline) {
        try {
          await _remoteDataSource.deleteSymptomRecord(id);
        } catch (e) {
          await _addToPendingSync('symptom', 'delete', {'id': id});
        }
      } else {
        await _addToPendingSync('symptom', 'delete', {'id': id});
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Meal Records ==========

  @override
  Future<Either<Failure, List<MealRecord>>> getMealRecords(
    DateTime date,
  ) async {
    // ignore: avoid_print
    print('[Repository] getMealRecords: $date');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getMealRecords(date);
          await _localDataSource.cacheMealRecords(date, models);
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getMealRecords(date);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getMealRecords(date);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealRecord>>> getMealRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // ignore: avoid_print
    print('[Repository] getMealRecordsInRange: $startDate ~ $endDate');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models =
              await _remoteDataSource.getMealRecordsInRange(startDate, endDate);
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models =
              await _localDataSource.getMealRecordsInRange(startDate, endDate);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models =
            await _localDataSource.getMealRecordsInRange(startDate, endDate);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);
      await _localDataSource.addMealRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.addMealRecord(model);
        } catch (e) {
          await _addToPendingSync('meal', 'add', model.toJson());
        }
      } else {
        await _addToPendingSync('meal', 'add', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);

      // 로컬 캐시 먼저 업데이트
      await _localDataSource.updateMealRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.updateMealRecord(model);
        } catch (e) {
          await _addToPendingSync('meal', 'update', model.toJson());
        }
      } else {
        await _addToPendingSync('meal', 'update', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMealRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      await _localDataSource.deleteMealRecord(id);

      if (_isOnline) {
        try {
          await _remoteDataSource.deleteMealRecord(id);
        } catch (e) {
          await _addToPendingSync('meal', 'delete', {'id': id});
        }
      } else {
        await _addToPendingSync('meal', 'delete', {'id': id});
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealRecord?>> getMealRecordByDateAndType(
    DateTime date,
    MealType mealType,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final model = await _remoteDataSource.getMealRecordByDateAndType(
            date,
            mealType.name,
          );
          return Right(model?.toEntity());
        } catch (e) {
          final records = await _localDataSource.getMealRecords(date);
          final found = records.where((r) => r.mealType == mealType.name);
          return Right(found.isEmpty ? null : found.first.toEntity());
        }
      } else {
        final records = await _localDataSource.getMealRecords(date);
        final found = records.where((r) => r.mealType == mealType.name);
        return Right(found.isEmpty ? null : found.first.toEntity());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> upsertMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);

      // 로컬 캐시 upsert
      await _localDataSource.upsertMealRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.upsertMealRecord(model);
        } catch (e) {
          await _addToPendingSync('meal', 'upsert', model.toJson());
        }
      } else {
        await _addToPendingSync('meal', 'upsert', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Medication Records ==========

  @override
  Future<Either<Failure, List<MedicationRecord>>> getMedicationRecords(
    DateTime date,
  ) async {
    // ignore: avoid_print
    print('[Repository] getMedicationRecords: $date');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getMedicationRecords(date);
          await _localDataSource.cacheMedicationRecords(date, models);
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getMedicationRecords(date);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getMedicationRecords(date);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicationRecord>>> getMedicationRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // ignore: avoid_print
    print('[Repository] getMedicationRecordsInRange: $startDate ~ $endDate');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getMedicationRecordsInRange(
            startDate,
            endDate,
          );
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getMedicationRecordsInRange(
            startDate,
            endDate,
          );
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getMedicationRecordsInRange(
          startDate,
          endDate,
        );
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMedicationRecord(
    MedicationRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MedicationRecordModel.fromEntity(record, userId);
      await _localDataSource.addMedicationRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.addMedicationRecord(model);
        } catch (e) {
          await _addToPendingSync('medication', 'add', model.toJson());
        }
      } else {
        await _addToPendingSync('medication', 'add', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMedicationRecord(
    MedicationRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MedicationRecordModel.fromEntity(record, userId);

      // 로컬 캐시 먼저 업데이트
      await _localDataSource.updateMedicationRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.updateMedicationRecord(model);
        } catch (e) {
          await _addToPendingSync('medication', 'update', model.toJson());
        }
      } else {
        await _addToPendingSync('medication', 'update', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedicationRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      await _localDataSource.deleteMedicationRecord(id);

      if (_isOnline) {
        try {
          await _remoteDataSource.deleteMedicationRecord(id);
        } catch (e) {
          await _addToPendingSync('medication', 'delete', {'id': id});
        }
      } else {
        await _addToPendingSync('medication', 'delete', {'id': id});
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Lifestyle Records ==========

  @override
  Future<Either<Failure, List<LifestyleRecord>>> getLifestyleRecords(
    DateTime date,
  ) async {
    // ignore: avoid_print
    print('[Repository] getLifestyleRecords: $date');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getLifestyleRecords(date);
          await _localDataSource.cacheLifestyleRecords(date, models);
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getLifestyleRecords(date);
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getLifestyleRecords(date);
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LifestyleRecord>>> getLifestyleRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // ignore: avoid_print
    print('[Repository] getLifestyleRecordsInRange: $startDate ~ $endDate');
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final models = await _remoteDataSource.getLifestyleRecordsInRange(
            startDate,
            endDate,
          );
          return Right(models.map((m) => m.toEntity()).toList());
        } on RecordDataSourceException {
          final models = await _localDataSource.getLifestyleRecordsInRange(
            startDate,
            endDate,
          );
          return Right(models.map((m) => m.toEntity()).toList());
        }
      } else {
        final models = await _localDataSource.getLifestyleRecordsInRange(
          startDate,
          endDate,
        );
        return Right(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addLifestyleRecord(
    LifestyleRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);
      await _localDataSource.addLifestyleRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.addLifestyleRecord(model);
        } catch (e) {
          await _addToPendingSync('lifestyle', 'add', model.toJson());
        }
      } else {
        await _addToPendingSync('lifestyle', 'add', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLifestyleRecord(
    LifestyleRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);

      // 로컬 캐시 먼저 업데이트
      await _localDataSource.updateLifestyleRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.updateLifestyleRecord(model);
        } catch (e) {
          await _addToPendingSync('lifestyle', 'update', model.toJson());
        }
      } else {
        await _addToPendingSync('lifestyle', 'update', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLifestyleRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      await _localDataSource.deleteLifestyleRecord(id);

      if (_isOnline) {
        try {
          await _remoteDataSource.deleteLifestyleRecord(id);
        } catch (e) {
          await _addToPendingSync('lifestyle', 'delete', {'id': id});
        }
      } else {
        await _addToPendingSync('lifestyle', 'delete', {'id': id});
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LifestyleRecord?>> getLifestyleRecordByDateAndType(
    DateTime date,
    LifestyleType lifestyleType,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      if (_isOnline) {
        try {
          final model = await _remoteDataSource.getLifestyleRecordByDateAndType(
            date,
            lifestyleType.name,
          );
          return Right(model?.toEntity());
        } catch (e) {
          final records = await _localDataSource.getLifestyleRecords(date);
          final found =
              records.where((r) => r.lifestyleType == lifestyleType.name);
          return Right(found.isEmpty ? null : found.first.toEntity());
        }
      } else {
        final records = await _localDataSource.getLifestyleRecords(date);
        final found =
            records.where((r) => r.lifestyleType == lifestyleType.name);
        return Right(found.isEmpty ? null : found.first.toEntity());
      }
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> upsertLifestyleRecord(
    LifestyleRecord record,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);

      // 로컬 캐시 upsert
      await _localDataSource.upsertLifestyleRecord(model);

      if (_isOnline) {
        try {
          await _remoteDataSource.upsertLifestyleRecord(model);
        } catch (e) {
          await _addToPendingSync('lifestyle', 'upsert', model.toJson());
        }
      } else {
        await _addToPendingSync('lifestyle', 'upsert', model.toJson());
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== All Records ==========

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllRecords(
    DateTime date,
  ) async {
    // ignore: avoid_print
    print('[Repository] getAllRecords: $date');

    // 테스트용 목 데이터 반환
    if (_useMockData) {
      return Right(_generateMockRecordsForDay(date));
    }

    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      final symptomResult = await getSymptomRecords(date);
      final mealResult = await getMealRecords(date);
      final medicationResult = await getMedicationRecords(date);
      final lifestyleResult = await getLifestyleRecords(date);

      return Right({
        'symptoms': symptomResult.getOrElse((_) => []),
        'meals': mealResult.getOrElse((_) => []),
        'medications': medicationResult.getOrElse((_) => []),
        'lifestyles': lifestyleResult.getOrElse((_) => []),
      });
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<DateTime, Map<String, dynamic>>>>
      getAllRecordsInRange(DateTime startDate, DateTime endDate) async {
    // ignore: avoid_print
    print('[Repository] getAllRecordsInRange: $startDate ~ $endDate');

    // 테스트용 목 데이터 반환
    if (_useMockData) {
      return Right(_generateMockRecordsInRange(startDate, endDate));
    }

    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return const Left(Failure.permission('로그인이 필요합니다'));
      }

      // 4번의 API 호출로 월별 데이터 가져오기
      List<SymptomRecordModel> symptoms;
      List<MealRecordModel> meals;
      List<MedicationRecordModel> medications;
      List<LifestyleRecordModel> lifestyles;

      if (_isOnline) {
        try {
          // 병렬로 4개 API 호출
          final results = await Future.wait([
            _remoteDataSource.getSymptomRecordsInRange(startDate, endDate),
            _remoteDataSource.getMealRecordsInRange(startDate, endDate),
            _remoteDataSource.getMedicationRecordsInRange(startDate, endDate),
            _remoteDataSource.getLifestyleRecordsInRange(startDate, endDate),
          ]);

          symptoms = results[0] as List<SymptomRecordModel>;
          meals = results[1] as List<MealRecordModel>;
          medications = results[2] as List<MedicationRecordModel>;
          lifestyles = results[3] as List<LifestyleRecordModel>;

          // 로컬 캐시에 날짜별로 저장
          await _cacheRecordsByDate(
            startDate,
            endDate,
            symptoms,
            meals,
            medications,
            lifestyles,
          );
        } on RecordDataSourceException {
          // 오프라인 폴백
          symptoms =
              await _localDataSource.getSymptomRecordsInRange(startDate, endDate);
          meals =
              await _localDataSource.getMealRecordsInRange(startDate, endDate);
          medications = await _localDataSource.getMedicationRecordsInRange(
            startDate,
            endDate,
          );
          lifestyles = await _localDataSource.getLifestyleRecordsInRange(
            startDate,
            endDate,
          );
        }
      } else {
        symptoms =
            await _localDataSource.getSymptomRecordsInRange(startDate, endDate);
        meals =
            await _localDataSource.getMealRecordsInRange(startDate, endDate);
        medications = await _localDataSource.getMedicationRecordsInRange(
          startDate,
          endDate,
        );
        lifestyles = await _localDataSource.getLifestyleRecordsInRange(
          startDate,
          endDate,
        );
      }

      // 날짜별로 그룹핑
      final result = <DateTime, Map<String, dynamic>>{};

      for (final symptom in symptoms) {
        final date = DateTime(
          symptom.recordedAt.year,
          symptom.recordedAt.month,
          symptom.recordedAt.day,
        );
        result.putIfAbsent(
          date,
          () => {
            'symptoms': <SymptomRecord>[],
            'meals': <MealRecord>[],
            'medications': <MedicationRecord>[],
            'lifestyles': <LifestyleRecord>[],
          },
        );
        (result[date]!['symptoms'] as List<SymptomRecord>)
            .add(symptom.toEntity());
      }

      for (final meal in meals) {
        final date = DateTime(
          meal.recordedAt.year,
          meal.recordedAt.month,
          meal.recordedAt.day,
        );
        result.putIfAbsent(
          date,
          () => {
            'symptoms': <SymptomRecord>[],
            'meals': <MealRecord>[],
            'medications': <MedicationRecord>[],
            'lifestyles': <LifestyleRecord>[],
          },
        );
        (result[date]!['meals'] as List<MealRecord>).add(meal.toEntity());
      }

      for (final medication in medications) {
        final date = DateTime(
          medication.recordedAt.year,
          medication.recordedAt.month,
          medication.recordedAt.day,
        );
        result.putIfAbsent(
          date,
          () => {
            'symptoms': <SymptomRecord>[],
            'meals': <MealRecord>[],
            'medications': <MedicationRecord>[],
            'lifestyles': <LifestyleRecord>[],
          },
        );
        (result[date]!['medications'] as List<MedicationRecord>)
            .add(medication.toEntity());
      }

      for (final lifestyle in lifestyles) {
        final date = DateTime(
          lifestyle.recordedAt.year,
          lifestyle.recordedAt.month,
          lifestyle.recordedAt.day,
        );
        result.putIfAbsent(
          date,
          () => {
            'symptoms': <SymptomRecord>[],
            'meals': <MealRecord>[],
            'medications': <MedicationRecord>[],
            'lifestyles': <LifestyleRecord>[],
          },
        );
        (result[date]!['lifestyles'] as List<LifestyleRecord>)
            .add(lifestyle.toEntity());
      }

      return Right(result);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  Future<void> _cacheRecordsByDate(
    DateTime startDate,
    DateTime endDate,
    List<SymptomRecordModel> symptoms,
    List<MealRecordModel> meals,
    List<MedicationRecordModel> medications,
    List<LifestyleRecordModel> lifestyles,
  ) async {
    // 날짜별로 그룹핑하여 캐시
    final symptomsByDate = <DateTime, List<SymptomRecordModel>>{};
    final mealsByDate = <DateTime, List<MealRecordModel>>{};
    final medicationsByDate = <DateTime, List<MedicationRecordModel>>{};
    final lifestylesByDate = <DateTime, List<LifestyleRecordModel>>{};

    for (final s in symptoms) {
      final date =
          DateTime(s.recordedAt.year, s.recordedAt.month, s.recordedAt.day);
      symptomsByDate.putIfAbsent(date, () => []).add(s);
    }
    for (final m in meals) {
      final date =
          DateTime(m.recordedAt.year, m.recordedAt.month, m.recordedAt.day);
      mealsByDate.putIfAbsent(date, () => []).add(m);
    }
    for (final m in medications) {
      final date =
          DateTime(m.recordedAt.year, m.recordedAt.month, m.recordedAt.day);
      medicationsByDate.putIfAbsent(date, () => []).add(m);
    }
    for (final l in lifestyles) {
      final date =
          DateTime(l.recordedAt.year, l.recordedAt.month, l.recordedAt.day);
      lifestylesByDate.putIfAbsent(date, () => []).add(l);
    }

    // 범위 내 모든 날짜에 대해 캐시 (빈 날짜도 빈 리스트로 캐시)
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      await _localDataSource.cacheSymptomRecords(
        current,
        symptomsByDate[current] ?? [],
      );
      await _localDataSource.cacheMealRecords(
        current,
        mealsByDate[current] ?? [],
      );
      await _localDataSource.cacheMedicationRecords(
        current,
        medicationsByDate[current] ?? [],
      );
      await _localDataSource.cacheLifestyleRecords(
        current,
        lifestylesByDate[current] ?? [],
      );
      current = current.add(const Duration(days: 1));
    }

    await _localDataSource.setLastSyncTime(DateTime.now());
  }

  // ========== Pending Sync ==========

  Future<void> _addToPendingSync(
    String type,
    String action,
    Map<String, dynamic> data,
  ) async {
    final id = '${type}_${action}_${DateTime.now().millisecondsSinceEpoch}';
    await _localDataSource.addToPendingSync(
      PendingSyncRecord(
        id: id,
        type: type,
        action: action,
        data: jsonEncode(data),
        createdAt: DateTime.now(),
      ),
    );
  }

  /// 대기 중인 동기화 처리
  Future<void> syncPendingRecords() async {
    if (!_isOnline) return;

    final pendingRecords = await _localDataSource.getPendingSyncRecords();
    if (pendingRecords.isEmpty) return;

    for (final record in pendingRecords) {
      try {
        final data = jsonDecode(record.data) as Map<String, dynamic>;
        await _processPendingRecord(record.type, record.action, data);
        await _localDataSource.removePendingSyncRecord(record.id);
      } catch (e) {
        _logError('Sync failed: ${record.id}', error: e);
      }
    }
  }

  Future<void> _processPendingRecord(
    String type,
    String action,
    Map<String, dynamic> data,
  ) async {
    switch (type) {
      case 'symptom':
        await _syncSymptomRecord(action, data);
      case 'meal':
        await _syncMealRecord(action, data);
      case 'medication':
        await _syncMedicationRecord(action, data);
      case 'lifestyle':
        await _syncLifestyleRecord(action, data);
    }
  }

  Future<void> _syncSymptomRecord(
    String action,
    Map<String, dynamic> data,
  ) async {
    switch (action) {
      case 'add':
        final model = SymptomRecordModel.fromJson(data);
        await _remoteDataSource.addSymptomRecord(model);
      case 'update':
        final model = SymptomRecordModel.fromJson(data);
        await _remoteDataSource.updateSymptomRecord(model);
      case 'delete':
        await _remoteDataSource.deleteSymptomRecord(data['id'] as String);
    }
  }

  Future<void> _syncMealRecord(String action, Map<String, dynamic> data) async {
    switch (action) {
      case 'add':
        final model = MealRecordModel.fromJson(data);
        await _remoteDataSource.addMealRecord(model);
      case 'update':
        final model = MealRecordModel.fromJson(data);
        await _remoteDataSource.updateMealRecord(model);
      case 'upsert':
        final model = MealRecordModel.fromJson(data);
        await _remoteDataSource.upsertMealRecord(model);
      case 'delete':
        await _remoteDataSource.deleteMealRecord(data['id'] as String);
    }
  }

  Future<void> _syncMedicationRecord(
    String action,
    Map<String, dynamic> data,
  ) async {
    switch (action) {
      case 'add':
        final model = MedicationRecordModel.fromJson(data);
        await _remoteDataSource.addMedicationRecord(model);
      case 'update':
        final model = MedicationRecordModel.fromJson(data);
        await _remoteDataSource.updateMedicationRecord(model);
      case 'delete':
        await _remoteDataSource.deleteMedicationRecord(data['id'] as String);
    }
  }

  Future<void> _syncLifestyleRecord(
    String action,
    Map<String, dynamic> data,
  ) async {
    switch (action) {
      case 'add':
        final model = LifestyleRecordModel.fromJson(data);
        await _remoteDataSource.addLifestyleRecord(model);
      case 'update':
        final model = LifestyleRecordModel.fromJson(data);
        await _remoteDataSource.updateLifestyleRecord(model);
      case 'upsert':
        final model = LifestyleRecordModel.fromJson(data);
        await _remoteDataSource.upsertLifestyleRecord(model);
      case 'delete':
        await _remoteDataSource.deleteLifestyleRecord(data['id'] as String);
    }
  }

  /// Repository 정리
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  // ========== Mock Data Generation (App Store 스크린샷용) ==========

  /// 하루 목 데이터 생성 (홈 화면용)
  Map<String, dynamic> _generateMockRecordsForDay(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    if (!isToday) {
      return {
        'symptoms': <SymptomRecord>[],
        'meals': <MealRecord>[],
        'medications': <MedicationRecord>[],
        'lifestyles': <LifestyleRecord>[],
      };
    }

    // 오늘 데이터: 좋은 상태 (스크린샷용)
    final baseDate = DateTime(date.year, date.month, date.day);

    // 증상: 가벼운 증상 1회
    final symptoms = [
      SymptomRecord(
        id: 'mock_symptom_1',
        recordedAt: baseDate.add(const Duration(hours: 14, minutes: 30)),
        symptoms: [GerdSymptom.bloating],
        severity: 2,
        createdAt: baseDate,
        notes: '점심 후 가벼운 더부룩함',
      ),
    ];

    // 식사: 3끼 정상 식사
    final meals = [
      MealRecord(
        id: 'mock_meal_1',
        recordedAt: baseDate.add(const Duration(hours: 8)),
        mealType: MealType.breakfast,
        foods: ['오트밀', '바나나', '두유'],
        fullnessLevel: 6,
        createdAt: baseDate,
      ),
      MealRecord(
        id: 'mock_meal_2',
        recordedAt: baseDate.add(const Duration(hours: 12, minutes: 30)),
        mealType: MealType.lunch,
        foods: ['현미밥', '된장국', '생선구이', '나물'],
        fullnessLevel: 7,
        createdAt: baseDate,
      ),
      MealRecord(
        id: 'mock_meal_3',
        recordedAt: baseDate.add(const Duration(hours: 18, minutes: 30)),
        mealType: MealType.dinner,
        foods: ['닭가슴살 샐러드', '통밀빵'],
        fullnessLevel: 6,
        createdAt: baseDate,
      ),
    ];

    // 약물: PPI 복용
    final medications = [
      MedicationRecord(
        id: 'mock_med_1',
        recordedAt: baseDate.add(const Duration(hours: 7, minutes: 30)),
        isTaken: true,
        medicationName: '에소메프라졸',
        dosage: '20mg',
        medicationTypes: [MedicationType.ppi],
        createdAt: baseDate,
      ),
    ];

    // 생활습관: 양호한 상태
    final lifestyles = [
      LifestyleRecord(
        id: 'mock_lifestyle_1',
        recordedAt: baseDate.add(const Duration(hours: 7)),
        lifestyleType: LifestyleType.sleep,
        details: {
          'sleep_hours': 7.5,
          'stress_level': 3,
          'exercised': true,
        },
        createdAt: baseDate,
      ),
    ];

    return {
      'symptoms': symptoms,
      'meals': meals,
      'medications': medications,
      'lifestyles': lifestyles,
    };
  }

  /// 범위 내 목 데이터 생성 (캘린더, 분석 화면용)
  Map<DateTime, Map<String, dynamic>> _generateMockRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final result = <DateTime, Map<String, dynamic>>{};
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    while (!currentDate.isAfter(normalizedEnd)) {
      // 미래 날짜는 데이터 없음
      if (currentDate.isAfter(today)) {
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }

      // 주말은 데이터 적게
      final isWeekend =
          currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday;

      // 오늘이면 홈 화면과 동일한 데이터
      if (currentDate.isAtSameMomentAs(today)) {
        result[currentDate] = _generateMockRecordsForDay(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }

      // 지난주인지 확인 (AI 분석용 나쁜 데이터)
      final daysAgo = today.difference(currentDate).inDays;
      final isLastWeek = daysAgo >= 7 && daysAgo < 14;

      // 과거 데이터 생성 (지난주 전체는 나쁜 데이터)
      final dayData = _generateDayMockData(
        currentDate,
        isWeekend: isWeekend,
        isBadDay: isLastWeek,  // 지난주 전체를 나쁜 데이터로
      );

      if (dayData['symptoms']!.isNotEmpty ||
          dayData['meals']!.isNotEmpty ||
          dayData['medications']!.isNotEmpty ||
          dayData['lifestyles']!.isNotEmpty) {
        result[currentDate] = dayData;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  /// 개별 날짜 목 데이터 생성
  Map<String, List<dynamic>> _generateDayMockData(
    DateTime date, {
    bool isWeekend = false,
    bool isBadDay = false,
  }) {
    final symptoms = <SymptomRecord>[];
    final meals = <MealRecord>[];
    final medications = <MedicationRecord>[];
    final lifestyles = <LifestyleRecord>[];

    final dayOfMonth = date.day;
    final baseId = '${date.year}${date.month}${date.day}';

    // 주말이 아니거나, 나쁜 날(지난주)이면 기록 있음
    if (!isWeekend || dayOfMonth % 3 == 0 || isBadDay) {
      // 증상 (나쁜 날은 더 많이)
      if (isBadDay) {
        symptoms.addAll([
          SymptomRecord(
            id: 'mock_s_${baseId}_1',
            recordedAt: date.add(const Duration(hours: 13)),
            symptoms: [GerdSymptom.heartburn, GerdSymptom.acidReflux],
            severity: 7,
            createdAt: date,
          ),
          SymptomRecord(
            id: 'mock_s_${baseId}_2',
            recordedAt: date.add(const Duration(hours: 21)),
            symptoms: [GerdSymptom.regurgitation],
            severity: 6,
            createdAt: date,
          ),
        ]);
      } else if (dayOfMonth % 4 == 0) {
        // 일부 날은 가벼운 증상
        symptoms.add(
          SymptomRecord(
            id: 'mock_s_${baseId}_1',
            recordedAt: date.add(const Duration(hours: 14)),
            symptoms: [GerdSymptom.bloating],
            severity: 2,
            createdAt: date,
          ),
        );
      }

      // 식사 (대부분 3끼)
      final mealFoods = [
        ['오트밀', '과일', '두유'],
        ['현미밥', '국', '반찬'],
        ['샐러드', '닭가슴살'],
        ['빵', '수프'],
        ['비빔밥'],
      ];

      meals.addAll([
        MealRecord(
          id: 'mock_m_${baseId}_1',
          recordedAt: date.add(const Duration(hours: 8)),
          mealType: MealType.breakfast,
          foods: mealFoods[dayOfMonth % 5],
          fullnessLevel: 6,
          createdAt: date,
          triggerCategories:
              isBadDay ? [TriggerFoodCategory.caffeine] : null,
        ),
        MealRecord(
          id: 'mock_m_${baseId}_2',
          recordedAt: date.add(const Duration(hours: 12, minutes: 30)),
          mealType: MealType.lunch,
          foods: mealFoods[(dayOfMonth + 1) % 5],
          fullnessLevel: 7,
          createdAt: date,
          triggerCategories: isBadDay ? [TriggerFoodCategory.spicy] : null,
        ),
        MealRecord(
          id: 'mock_m_${baseId}_3',
          recordedAt: date.add(const Duration(hours: 18, minutes: 30)),
          mealType: MealType.dinner,
          foods: mealFoods[(dayOfMonth + 2) % 5],
          fullnessLevel: isBadDay ? 9 : 6,
          createdAt: date,
          triggerCategories:
              isBadDay ? [TriggerFoodCategory.fatty] : null,
        ),
      ]);

      // 약물
      if (dayOfMonth % 2 == 0) {
        medications.add(
          MedicationRecord(
            id: 'mock_md_${baseId}_1',
            recordedAt: date.add(const Duration(hours: 7, minutes: 30)),
            isTaken: true,
            medicationName: '에소메프라졸',
            dosage: '20mg',
            medicationTypes: [MedicationType.ppi],
            createdAt: date,
          ),
        );
      }

      // 생활습관
      lifestyles.add(
        LifestyleRecord(
          id: 'mock_l_${baseId}_1',
          recordedAt: date.add(const Duration(hours: 7)),
          lifestyleType: LifestyleType.sleep,
          details: {
            'sleep_hours': isBadDay ? 5.0 : (isWeekend ? 8.5 : 7.0),
            'stress_level': isBadDay ? 8 : (dayOfMonth % 4 + 2),
            'exercised': !isBadDay && dayOfMonth % 3 != 0,
          },
          createdAt: date,
        ),
      );
    }

    return {
      'symptoms': symptoms,
      'meals': meals,
      'medications': medications,
      'lifestyles': lifestyles,
    };
  }
}
