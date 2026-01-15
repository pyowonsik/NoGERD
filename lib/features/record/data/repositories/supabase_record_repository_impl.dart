import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:no_gerd/core/error/failures.dart';
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

@LazySingleton(as: IRecordRepository)
class SupabaseRecordRepositoryImpl implements IRecordRepository {
  final RecordRemoteDataSource _remoteDataSource;
  final SupabaseClient _supabase;

  SupabaseRecordRepositoryImpl(
    this._remoteDataSource,
    this._supabase,
  );

  String? _getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // ========== Symptom Records ==========

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final models = await _remoteDataSource.getSymptomRecords(date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = SymptomRecordModel.fromEntity(record, userId);
      await _remoteDataSource.addSymptomRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = SymptomRecordModel.fromEntity(record, userId);
      await _remoteDataSource.updateSymptomRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      await _remoteDataSource.deleteSymptomRecord(id);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Meal Records ==========

  @override
  Future<Either<Failure, List<MealRecord>>> getMealRecords(
    DateTime date,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final models = await _remoteDataSource.getMealRecords(date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);
      await _remoteDataSource.addMealRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);
      await _remoteDataSource.updateMealRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMealRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      await _remoteDataSource.deleteMealRecord(id);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = await _remoteDataSource.getMealRecordByDateAndType(
        date,
        mealType.name,
      );
      return Right(model?.toEntity());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> upsertMealRecord(MealRecord record) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MealRecordModel.fromEntity(record, userId);
      await _remoteDataSource.upsertMealRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Medication Records ==========

  @override
  Future<Either<Failure, List<MedicationRecord>>> getMedicationRecords(
    DateTime date,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final models = await _remoteDataSource.getMedicationRecords(date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MedicationRecordModel.fromEntity(record, userId);
      await _remoteDataSource.addMedicationRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = MedicationRecordModel.fromEntity(record, userId);
      await _remoteDataSource.updateMedicationRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedicationRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      await _remoteDataSource.deleteMedicationRecord(id);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== Lifestyle Records ==========

  @override
  Future<Either<Failure, List<LifestyleRecord>>> getLifestyleRecords(
    DateTime date,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final models = await _remoteDataSource.getLifestyleRecords(date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);
      await _remoteDataSource.addLifestyleRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);
      await _remoteDataSource.updateLifestyleRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLifestyleRecord(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      await _remoteDataSource.deleteLifestyleRecord(id);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = await _remoteDataSource.getLifestyleRecordByDateAndType(
        date,
        lifestyleType.name,
      );
      return Right(model?.toEntity());
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
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
        return Left(Failure.permission('로그인이 필요합니다'));
      }

      final model = LifestyleRecordModel.fromEntity(record, userId);
      await _remoteDataSource.upsertLifestyleRecord(model);
      return const Right(unit);
    } on RecordDataSourceException catch (e) {
      return Left(Failure.database(e.message));
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  // ========== All Records ==========

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllRecords(
    DateTime date,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        return Left(Failure.permission('로그인이 필요합니다'));
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
}
