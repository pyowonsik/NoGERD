part of 'record_bloc.dart';

/// Record Event
@freezed
class RecordEvent with _$RecordEvent {
  /// 증상 기록 추가
  const factory RecordEvent.addSymptomRecord(SymptomRecord record) =
      RecordEventAddSymptomRecord;

  /// 식사 기록 추가
  const factory RecordEvent.addMealRecord(MealRecord record) =
      RecordEventAddMealRecord;

  /// 약물 기록 추가
  const factory RecordEvent.addMedicationRecord(MedicationRecord record) =
      RecordEventAddMedicationRecord;

  /// 생활습관 기록 추가
  const factory RecordEvent.addLifestyleRecord(LifestyleRecord record) =
      RecordEventAddLifestyleRecord;

  /// 특정 날짜의 모든 기록 조회
  const factory RecordEvent.loadRecords(DateTime date) =
      RecordEventLoadRecords;

  /// 기록 삭제 (공통)
  const factory RecordEvent.deleteRecord({
    required String id,
    required RecordType recordType,
  }) = RecordEventDeleteRecord;
}
