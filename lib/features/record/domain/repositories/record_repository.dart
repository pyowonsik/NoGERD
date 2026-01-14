import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';

/// Record Repository Interface
///
/// 모든 기록 타입의 CRUD 작업을 정의합니다.
abstract class IRecordRepository {
  // ========== Symptom Records ==========

  /// 특정 날짜의 증상 기록 조회
  Future<Either<Failure, List<SymptomRecord>>> getSymptomRecords(
    DateTime date,
  );

  /// 증상 기록 추가
  Future<Either<Failure, Unit>> addSymptomRecord(SymptomRecord record);

  /// 증상 기록 수정
  Future<Either<Failure, Unit>> updateSymptomRecord(SymptomRecord record);

  /// 증상 기록 삭제
  Future<Either<Failure, Unit>> deleteSymptomRecord(String id);

  // ========== Meal Records ==========

  /// 특정 날짜의 식사 기록 조회
  Future<Either<Failure, List<MealRecord>>> getMealRecords(DateTime date);

  /// 식사 기록 추가
  Future<Either<Failure, Unit>> addMealRecord(MealRecord record);

  /// 식사 기록 수정
  Future<Either<Failure, Unit>> updateMealRecord(MealRecord record);

  /// 식사 기록 삭제
  Future<Either<Failure, Unit>> deleteMealRecord(String id);

  // ========== Medication Records ==========

  /// 특정 날짜의 약물 기록 조회
  Future<Either<Failure, List<MedicationRecord>>> getMedicationRecords(
    DateTime date,
  );

  /// 약물 기록 추가
  Future<Either<Failure, Unit>> addMedicationRecord(MedicationRecord record);

  /// 약물 기록 수정
  Future<Either<Failure, Unit>> updateMedicationRecord(MedicationRecord record);

  /// 약물 기록 삭제
  Future<Either<Failure, Unit>> deleteMedicationRecord(String id);

  // ========== Lifestyle Records ==========

  /// 특정 날짜의 생활습관 기록 조회
  Future<Either<Failure, List<LifestyleRecord>>> getLifestyleRecords(
    DateTime date,
  );

  /// 생활습관 기록 추가
  Future<Either<Failure, Unit>> addLifestyleRecord(LifestyleRecord record);

  /// 생활습관 기록 수정
  Future<Either<Failure, Unit>> updateLifestyleRecord(LifestyleRecord record);

  /// 생활습관 기록 삭제
  Future<Either<Failure, Unit>> deleteLifestyleRecord(String id);

  // ========== All Records ==========

  /// 특정 날짜의 모든 기록 조회
  Future<Either<Failure, Map<String, dynamic>>> getAllRecords(DateTime date);
}
