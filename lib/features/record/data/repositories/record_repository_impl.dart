import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// Record Repository 구현
///
/// 현재는 인메모리 저장소를 사용하며, 추후 Hive 등으로 교체 가능
@LazySingleton(as: IRecordRepository)
class RecordRepositoryImpl implements IRecordRepository {
  /// 증상 기록 저장소
  final List<SymptomRecord> _symptomRecords = [];

  /// 식사 기록 저장소
  final List<MealRecord> _mealRecords = [];

  /// 약물 기록 저장소
  final List<MedicationRecord> _medicationRecords = [];

  /// 생활습관 기록 저장소
  final List<LifestyleRecord> _lifestyleRecords = [];

  // ========== Symptom Records ==========

  @override
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  ) async {
    try {
      final records = _symptomRecords.where((record) {
        final recordDate = record.recordedAt;
        return recordDate.year == date.year &&
            recordDate.month == date.month &&
            recordDate.day == date.day;
      }).toList();

      return Right(records);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record) async {
    try {
      _symptomRecords.add(record);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSymptomRecord(
    SymptomRecord record,
  ) async {
    try {
      final index = _symptomRecords.indexWhere((r) => r.id == record.id);
      if (index == -1) {
        return const Left(Failure.notFound('기록을 찾을 수 없습니다'));
      }
      _symptomRecords[index] = record;
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id) async {
    try {
      _symptomRecords.removeWhere((record) => record.id == id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  // ========== Meal Records ==========

  @override
  Future<Either<Failure, List<MealRecord>>> getMealRecords(DateTime date) async {
    try {
      final records = _mealRecords.where((record) {
        final recordDate = record.recordedAt;
        return recordDate.year == date.year &&
            recordDate.month == date.month &&
            recordDate.day == date.day;
      }).toList();

      return Right(records);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMealRecord(MealRecord record) async {
    try {
      _mealRecords.add(record);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMealRecord(MealRecord record) async {
    try {
      final index = _mealRecords.indexWhere((r) => r.id == record.id);
      if (index == -1) {
        return const Left(Failure.notFound('기록을 찾을 수 없습니다'));
      }
      _mealRecords[index] = record;
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMealRecord(String id) async {
    try {
      _mealRecords.removeWhere((record) => record.id == id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  // ========== Medication Records ==========

  @override
  Future<Either<Failure, List<MedicationRecord>>> getMedicationRecords(
    DateTime date,
  ) async {
    try {
      final records = _medicationRecords.where((record) {
        final recordDate = record.recordedAt;
        return recordDate.year == date.year &&
            recordDate.month == date.month &&
            recordDate.day == date.day;
      }).toList();

      return Right(records);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMedicationRecord(
    MedicationRecord record,
  ) async {
    try {
      _medicationRecords.add(record);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMedicationRecord(
    MedicationRecord record,
  ) async {
    try {
      final index = _medicationRecords.indexWhere((r) => r.id == record.id);
      if (index == -1) {
        return const Left(Failure.notFound('기록을 찾을 수 없습니다'));
      }
      _medicationRecords[index] = record;
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedicationRecord(String id) async {
    try {
      _medicationRecords.removeWhere((record) => record.id == id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  // ========== Lifestyle Records ==========

  @override
  Future<Either<Failure, List<LifestyleRecord>>> getLifestyleRecords(
    DateTime date,
  ) async {
    try {
      final records = _lifestyleRecords.where((record) {
        final recordDate = record.recordedAt;
        return recordDate.year == date.year &&
            recordDate.month == date.month &&
            recordDate.day == date.day;
      }).toList();

      return Right(records);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addLifestyleRecord(
    LifestyleRecord record,
  ) async {
    try {
      _lifestyleRecords.add(record);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLifestyleRecord(
    LifestyleRecord record,
  ) async {
    try {
      final index = _lifestyleRecords.indexWhere((r) => r.id == record.id);
      if (index == -1) {
        return const Left(Failure.notFound('기록을 찾을 수 없습니다'));
      }
      _lifestyleRecords[index] = record;
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLifestyleRecord(String id) async {
    try {
      _lifestyleRecords.removeWhere((record) => record.id == id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.database(e.toString()));
    }
  }

  // ========== All Records ==========

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllRecords(
    DateTime date,
  ) async {
    try {
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
      return Left(Failure.database(e.toString()));
    }
  }
}
