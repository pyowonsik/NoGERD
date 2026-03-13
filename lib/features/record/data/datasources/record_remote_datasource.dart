import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';

/// Record 원격 데이터 소스 인터페이스
abstract class RecordRemoteDataSource {
  // Symptom Records
  /// 증상 기록 조회
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);

  /// 증상 기록 범위 조회
  Future<List<SymptomRecordModel>> getSymptomRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 증상 기록 추가
  Future<void> addSymptomRecord(SymptomRecordModel record);

  /// 증상 기록 수정
  Future<void> updateSymptomRecord(SymptomRecordModel record);

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

  /// 날짜 및 식사 타입으로 식사 기록 조회
  Future<MealRecordModel?> getMealRecordByDateAndType(
    DateTime date,
    String mealType,
  );

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

  /// 약물 기록 추가
  Future<void> addMedicationRecord(MedicationRecordModel record);

  /// 약물 기록 수정
  Future<void> updateMedicationRecord(MedicationRecordModel record);

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

  /// 날짜 및 타입으로 생활습관 기록 조회
  Future<LifestyleRecordModel?> getLifestyleRecordByDateAndType(
    DateTime date,
    String lifestyleType,
  );

  /// 생활습관 기록 추가
  Future<void> addLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 수정
  Future<void> updateLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 upsert
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record);

  /// 생활습관 기록 삭제
  Future<void> deleteLifestyleRecord(String id);
}

/// Record 데이터소스 예외
class RecordDataSourceException implements Exception {
  /// 생성자
  RecordDataSourceException(this.message);

  /// 예외 메시지
  final String message;

  @override
  String toString() => 'RecordDataSourceException: $message';
}
