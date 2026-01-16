import 'package:no_gerd/features/record/data/models/lifestyle_record_model.dart';
import 'package:no_gerd/features/record/data/models/meal_record_model.dart';
import 'package:no_gerd/features/record/data/models/medication_record_model.dart';
import 'package:no_gerd/features/record/data/models/symptom_record_model.dart';

abstract class RecordRemoteDataSource {
  // Symptom Records
  Future<List<SymptomRecordModel>> getSymptomRecords(DateTime date);
  Future<void> addSymptomRecord(SymptomRecordModel record);
  Future<void> updateSymptomRecord(SymptomRecordModel record);
  Future<void> deleteSymptomRecord(String id);

  // Meal Records
  Future<List<MealRecordModel>> getMealRecords(DateTime date);
  Future<MealRecordModel?> getMealRecordByDateAndType(
    DateTime date,
    String mealType,
  );
  Future<void> addMealRecord(MealRecordModel record);
  Future<void> updateMealRecord(MealRecordModel record);
  Future<void> upsertMealRecord(MealRecordModel record);
  Future<void> deleteMealRecord(String id);

  // Medication Records
  Future<List<MedicationRecordModel>> getMedicationRecords(DateTime date);
  Future<void> addMedicationRecord(MedicationRecordModel record);
  Future<void> updateMedicationRecord(MedicationRecordModel record);
  Future<void> deleteMedicationRecord(String id);

  // Lifestyle Records
  Future<List<LifestyleRecordModel>> getLifestyleRecords(DateTime date);
  Future<LifestyleRecordModel?> getLifestyleRecordByDateAndType(
    DateTime date,
    String lifestyleType,
  );
  Future<void> addLifestyleRecord(LifestyleRecordModel record);
  Future<void> updateLifestyleRecord(LifestyleRecordModel record);
  Future<void> upsertLifestyleRecord(LifestyleRecordModel record);
  Future<void> deleteLifestyleRecord(String id);
}

class RecordDataSourceException implements Exception {
  RecordDataSourceException(this.message);
  final String message;

  @override
  String toString() => 'RecordDataSourceException: $message';
}
