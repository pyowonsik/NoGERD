import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/usecases/add_lifestyle_record_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/add_meal_record_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/add_medication_record_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/add_symptom_record_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/get_lifestyle_record_by_date_type_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/get_meal_record_by_date_type_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/get_records_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/upsert_lifestyle_record_usecase.dart';
import 'package:no_gerd/features/record/domain/usecases/upsert_meal_record_usecase.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'record_bloc.freezed.dart';
part 'record_event.dart';
part 'record_state.dart';

/// Record BLoC
@injectable
class RecordBloc extends Bloc<RecordEvent, RecordState> {
  /// 생성자
  RecordBloc(
    this._addSymptomRecordUseCase,
    this._addMealRecordUseCase,
    this._addMedicationRecordUseCase,
    this._addLifestyleRecordUseCase,
    this._getAllRecordsUseCase,
    this._getMealRecordByDateAndTypeUseCase,
    this._upsertMealRecordUseCase,
    this._getLifestyleRecordByDateAndTypeUseCase,
    this._upsertLifestyleRecordUseCase,
  ) : super(RecordState.initial()) {
    on<RecordEventAddSymptomRecord>(_onAddSymptomRecord);
    on<RecordEventAddMealRecord>(_onAddMealRecord);
    on<RecordEventAddMedicationRecord>(_onAddMedicationRecord);
    on<RecordEventAddLifestyleRecord>(_onAddLifestyleRecord);
    on<RecordEventLoadRecords>(_onLoadRecords);
    on<RecordEventDeleteRecord>(_onDeleteRecord);
    on<RecordEventLoadMealRecord>(_onLoadMealRecord);
    on<RecordEventUpsertMealRecord>(_onUpsertMealRecord);
    on<RecordEventLoadLifestyleRecord>(_onLoadLifestyleRecord);
    on<RecordEventUpsertLifestyleRecord>(_onUpsertLifestyleRecord);
    on<RecordEventClearCurrentRecord>(_onClearCurrentRecord);
  }

  final AddSymptomRecordUseCase _addSymptomRecordUseCase;
  final AddMealRecordUseCase _addMealRecordUseCase;
  final AddMedicationRecordUseCase _addMedicationRecordUseCase;
  final AddLifestyleRecordUseCase _addLifestyleRecordUseCase;
  final GetAllRecordsUseCase _getAllRecordsUseCase;
  final GetMealRecordByDateAndTypeUseCase _getMealRecordByDateAndTypeUseCase;
  final UpsertMealRecordUseCase _upsertMealRecordUseCase;
  final GetLifestyleRecordByDateAndTypeUseCase
      _getLifestyleRecordByDateAndTypeUseCase;
  final UpsertLifestyleRecordUseCase _upsertLifestyleRecordUseCase;

  Future<void> _onAddSymptomRecord(
    RecordEventAddSymptomRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _addSymptomRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            symptomRecords: [...state.symptomRecords, event.record],
            successMessage: some('증상 기록이 추가되었습니다'),
          ),
        );
        // 성공 메시지 초기화
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  Future<void> _onAddMealRecord(
    RecordEventAddMealRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _addMealRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            mealRecords: [...state.mealRecords, event.record],
            successMessage: some('식사 기록이 추가되었습니다'),
          ),
        );
        // 성공 메시지 초기화
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  Future<void> _onAddMedicationRecord(
    RecordEventAddMedicationRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _addMedicationRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            medicationRecords: [...state.medicationRecords, event.record],
            successMessage: some('약물 기록이 추가되었습니다'),
          ),
        );
        // 성공 메시지 초기화
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  Future<void> _onAddLifestyleRecord(
    RecordEventAddLifestyleRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _addLifestyleRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            lifestyleRecords: [...state.lifestyleRecords, event.record],
            successMessage: some('생활습관 기록이 추가되었습니다'),
          ),
        );
        // 성공 메시지 초기화
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  Future<void> _onLoadRecords(
    RecordEventLoadRecords event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _getAllRecordsUseCase(event.date);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (records) {
        emit(
          state.copyWith(
            isLoading: false,
            symptomRecords: records['symptoms'] as List<SymptomRecord>,
            mealRecords: records['meals'] as List<MealRecord>,
            medicationRecords: records['medications'] as List<MedicationRecord>,
            lifestyleRecords: records['lifestyles'] as List<LifestyleRecord>,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteRecord(
    RecordEventDeleteRecord event,
    Emitter<RecordState> emit,
  ) async {
    // TODO: Implement delete logic when delete UseCases are added
    emit(
      state.copyWith(
        successMessage: some('기록이 삭제되었습니다'),
      ),
    );
    emit(state.copyWith(successMessage: none()));
  }

  /// 식사 기록 조회 (UPSERT용)
  Future<void> _onLoadMealRecord(
    RecordEventLoadMealRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: none(),
        currentMealRecord: null,
        isEditMode: false,
      ),
    );

    final result = await _getMealRecordByDateAndTypeUseCase(
      GetMealRecordParams(date: event.date, mealType: event.mealType),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (record) => emit(
        state.copyWith(
          isLoading: false,
          currentMealRecord: record,
          isEditMode: record != null,
        ),
      ),
    );
  }

  /// 식사 기록 UPSERT
  Future<void> _onUpsertMealRecord(
    RecordEventUpsertMealRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _upsertMealRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        final message = state.isEditMode ? '기록이 수정되었습니다' : '기록이 저장되었습니다';
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: some(message),
            currentMealRecord: null,
            isEditMode: false,
          ),
        );
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  /// 생활습관 기록 조회 (UPSERT용)
  Future<void> _onLoadLifestyleRecord(
    RecordEventLoadLifestyleRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: none(),
        currentLifestyleRecord: null,
        isEditMode: false,
      ),
    );

    final result = await _getLifestyleRecordByDateAndTypeUseCase(
      GetLifestyleRecordParams(
        date: event.date,
        lifestyleType: event.lifestyleType,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (record) => emit(
        state.copyWith(
          isLoading: false,
          currentLifestyleRecord: record,
          isEditMode: record != null,
        ),
      ),
    );
  }

  /// 생활습관 기록 UPSERT
  Future<void> _onUpsertLifestyleRecord(
    RecordEventUpsertLifestyleRecord event,
    Emitter<RecordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: none()));

    final result = await _upsertLifestyleRecordUseCase(event.record);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (_) {
        final message = state.isEditMode ? '기록이 수정되었습니다' : '기록이 저장되었습니다';
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: some(message),
            currentLifestyleRecord: null,
            isEditMode: false,
          ),
        );
        emit(state.copyWith(successMessage: none()));
      },
    );
  }

  /// 현재 편집 기록 초기화
  void _onClearCurrentRecord(
    RecordEventClearCurrentRecord event,
    Emitter<RecordState> emit,
  ) {
    emit(
      state.copyWith(
        currentMealRecord: null,
        currentLifestyleRecord: null,
        isEditMode: false,
      ),
    );
  }
}
