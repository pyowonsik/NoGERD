import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/home/domain/models/recent_record.dart';
import 'package:no_gerd/features/home/domain/models/record_summary.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

/// Home BLoC
///
/// 홈 화면의 상태를 관리합니다.
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IRecordRepository _recordRepository;

  /// 생성자
  HomeBloc(this._recordRepository) : super(HomeState.initial()) {
    on<HomeEventStarted>(_onStarted);
    on<HomeEventRefreshed>(_onRefreshed);
    on<HomeEventDateChanged>(_onDateChanged);
  }

  Future<void> _onStarted(
    HomeEventStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final today = DateTime.now();
    final result = await _recordRepository.getAllRecords(today);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (records) {
        final symptoms = records['symptoms'] as List<SymptomRecord>;
        final meals = records['meals'] as List<MealRecord>;
        final medications = records['medications'] as List<MedicationRecord>;
        final lifestyles = records['lifestyles'] as List<LifestyleRecord>;

        final healthScore = _calculateHealthScore(symptoms, meals);
        final todaySummary = _generateSummary(
          symptoms,
          meals,
          medications,
          lifestyles,
        );
        final recentRecords = _generateRecentRecords(
          symptoms,
          meals,
          medications,
          lifestyles,
        );

        emit(
          state.copyWith(
            isLoading: false,
            healthScore: healthScore,
            previousScore: state.healthScore,
            todaySummary: todaySummary,
            recentRecords: recentRecords,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshed(
    HomeEventRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await _onStarted(const HomeEventStarted(), emit);
  }

  Future<void> _onDateChanged(
    HomeEventDateChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _onStarted(const HomeEventStarted(), emit);
  }

  int _calculateHealthScore(
    List<SymptomRecord> symptoms,
    List<MealRecord> meals,
  ) {
    int score = 100;

    for (final symptom in symptoms) {
      score -= symptom.severity * 2;
    }

    if (meals.isEmpty) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  List<RecordSummary> _generateSummary(
    List<SymptomRecord> symptoms,
    List<MealRecord> meals,
    List<MedicationRecord> medications,
    List<LifestyleRecord> lifestyles,
  ) {
    final avgSeverity = symptoms.isEmpty
        ? 0
        : symptoms.map((s) => s.severity).reduce((a, b) => a + b) ~/
            symptoms.length;

    final sleepRecord = lifestyles.firstWhere(
      (l) => l.lifestyleType == LifestyleType.sleep,
      orElse: () => LifestyleRecord(
        id: '',
        recordedAt: DateTime.now(),
        lifestyleType: LifestyleType.sleep,
        details: {'sleep_hours': 0.0},
        createdAt: DateTime.now(),
      ),
    );

    // sleep_hours는 double 타입으로 저장됨
    final sleepHoursValue = sleepRecord.details['sleep_hours'];
    final sleepHours = sleepHoursValue is num ? sleepHoursValue.round() : 0;

    return [
      RecordSummary(
        label: '증상',
        value: '${symptoms.length}회',
        subValue: avgSeverity <= 3
            ? '가벼움'
            : avgSeverity <= 6
                ? '보통'
                : '심함',
        iconCode: RecordType.symptom.icon.codePoint,
        colorValue: RecordType.symptom.color.value,
      ),
      RecordSummary(
        label: '식사',
        value: '${meals.length}회',
        subValue: meals.length >= 3 ? '정상' : '부족',
        iconCode: RecordType.meal.icon.codePoint,
        colorValue: RecordType.meal.color.value,
      ),
      RecordSummary(
        label: '약물',
        value: '${medications.length}회',
        subValue: medications.isEmpty ? '복용 안함' : '복용 완료',
        iconCode: RecordType.medication.icon.codePoint,
        colorValue: RecordType.medication.color.value,
      ),
      RecordSummary(
        label: '수면',
        value: '${sleepHours}시간',
        subValue: sleepHours >= 7
            ? '양호'
            : sleepHours >= 5
                ? '보통'
                : '부족',
        iconCode: RecordType.lifestyle.icon.codePoint,
        colorValue: RecordType.lifestyle.color.value,
      ),
    ];
  }

  List<RecentRecord> _generateRecentRecords(
    List<SymptomRecord> symptoms,
    List<MealRecord> meals,
    List<MedicationRecord> medications,
    List<LifestyleRecord> lifestyles,
  ) {
    final List<RecentRecord> records = [];

    for (final symptom in symptoms) {
      records.add(
        RecentRecord(
          title: symptom.symptoms.first.label,
          subtitle: '강도: ${symptom.severity}/10',
          time: _formatTime(symptom.recordedAt),
          emoji: symptom.symptoms.first.emoji,
          colorValue: RecordType.symptom.color.value,
        ),
      );
    }

    for (final meal in meals) {
      records.add(
        RecentRecord(
          title: meal.mealType.label,
          subtitle: meal.foods.take(2).join(', '),
          time: _formatTime(meal.recordedAt),
          emoji: meal.mealType.emoji,
          colorValue: RecordType.meal.color.value,
        ),
      );
    }

    for (final medication in medications) {
      records.add(
        RecentRecord(
          title: medication.medicationName,
          subtitle: medication.dosage,
          time: _formatTime(medication.recordedAt),
          emoji: medication.medicationType.emoji,
          colorValue: RecordType.medication.color.value,
        ),
      );
    }

    for (final lifestyle in lifestyles) {
      String title;
      String subtitle;
      String emoji;

      switch (lifestyle.lifestyleType) {
        case LifestyleType.sleep:
          final hours = lifestyle.details['sleep_hours'];
          title = '수면';
          subtitle = hours is num ? '${hours.toStringAsFixed(1)}시간' : '기록됨';
          emoji = '😴';
        case LifestyleType.stress:
          final level = lifestyle.details['stress_level'];
          title = '스트레스';
          subtitle = level is num ? '레벨 $level/10' : '기록됨';
          emoji = level is num && level > 6 ? '😰' : '😌';
        case LifestyleType.exercise:
          final exercised = lifestyle.details['exercised'] == true;
          title = '운동';
          subtitle = exercised ? '운동함' : '운동 안함';
          emoji = '🏃';
        case LifestyleType.smoking:
          final smoked = lifestyle.details['smoked'] == true;
          title = '흡연';
          subtitle = smoked ? '흡연함' : '금연';
          emoji = '🚬';
        case LifestyleType.posture:
          title = '자세';
          subtitle = lifestyle.details['posture'] as String? ?? '기록됨';
          emoji = '🧘';
      }

      records.add(
        RecentRecord(
          title: title,
          subtitle: subtitle,
          time: _formatTime(lifestyle.recordedAt),
          emoji: emoji,
          colorValue: RecordType.lifestyle.color.value,
        ),
      );
    }

    records.sort((a, b) => b.time.compareTo(a.time));
    return records.take(5).toList();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
