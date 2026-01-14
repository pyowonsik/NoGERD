part of 'record_bloc.dart';

/// Record State
@freezed
class RecordState with _$RecordState {
  /// 생성자
  const factory RecordState({
    /// 로딩 상태
    required bool isLoading,

    /// 증상 기록 목록
    required List<SymptomRecord> symptomRecords,

    /// 식사 기록 목록
    required List<MealRecord> mealRecords,

    /// 약물 기록 목록
    required List<MedicationRecord> medicationRecords,

    /// 생활습관 기록 목록
    required List<LifestyleRecord> lifestyleRecords,

    /// 에러
    required Option<Failure> failure,

    /// 성공 메시지
    required Option<String> successMessage,
  }) = _RecordState;

  /// 초기 상태
  factory RecordState.initial() => RecordState(
        isLoading: false,
        symptomRecords: [],
        mealRecords: [],
        medicationRecords: [],
        lifestyleRecords: [],
        failure: none(),
        successMessage: none(),
      );
}
