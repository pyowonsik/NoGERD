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

  /// 식사 기록 조회 (날짜 + MealType) - UPSERT용
  const factory RecordEvent.loadMealRecord({
    required DateTime date,
    required MealType mealType,
  }) = RecordEventLoadMealRecord;

  /// 식사 기록 UPSERT (있으면 수정, 없으면 추가)
  const factory RecordEvent.upsertMealRecord(MealRecord record) =
      RecordEventUpsertMealRecord;

  /// 생활습관 기록 조회 (날짜 + LifestyleType) - UPSERT용
  const factory RecordEvent.loadLifestyleRecord({
    required DateTime date,
    required LifestyleType lifestyleType,
  }) = RecordEventLoadLifestyleRecord;

  /// 생활습관 기록 UPSERT (있으면 수정, 없으면 추가)
  const factory RecordEvent.upsertLifestyleRecord(LifestyleRecord record) =
      RecordEventUpsertLifestyleRecord;

  /// 현재 편집 중인 기록 초기화
  const factory RecordEvent.clearCurrentRecord() = RecordEventClearCurrentRecord;
}
