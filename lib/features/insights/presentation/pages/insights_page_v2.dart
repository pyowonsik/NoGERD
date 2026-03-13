import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_meal_symptom_correlation_usecase.dart';
import 'package:no_gerd/features/insights/domain/usecases/get_symptom_trends_usecase.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

/// 분석 페이지 V2 - 점수 없이 증상 기반 분석
class InsightsPageV2 extends StatefulWidget {
  /// 생성자
  const InsightsPageV2({super.key});

  @override
  State<InsightsPageV2> createState() => _InsightsPageV2State();
}

class _InsightsPageV2State extends State<InsightsPageV2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 14일 데이터 로드 (지난 주 전체 포함)
        context.read<InsightsBloc>()
          ..add(const InsightsEvent.loadData(14))
          ..add(const InsightsEvent.loadSavedInsight());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        // RecordBloc에서 성공 메시지가 있으면 InsightsBloc을 새로고침
        state.successMessage.fold(
          () {},
          (_) =>
              context.read<InsightsBloc>().add(const InsightsEvent.refresh()),
        );
      },
      child: const _InsightsPageV2Content(),
    );
  }
}

class _InsightsPageV2Content extends StatelessWidget {
  const _InsightsPageV2Content();

  @override
  Widget build(BuildContext context) {
    return BlocListener<InsightsBloc, InsightsState>(
      listenWhen: (prev, curr) => prev.failure != curr.failure,
      listener: (context, state) {
        state.failure.fold(
          () => null,
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.displayMessage),
                backgroundColor: AppTheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '분석 리포트',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<InsightsBloc, InsightsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 증상 빈도 추이 (라인 차트)
                          _SymptomFrequencyTrend(state: state),

                          const SizedBox(height: 20),

                          // 증상 분포 (도넛 차트)
                          _SymptomDistribution(state: state),

                          const SizedBox(height: 20),

                          // 식사별 증상 연관성
                          _MealSymptomCorrelation(state: state),

                          const SizedBox(height: 20),

                          // 트리거 음식 분석
                          _TriggerAnalysis(state: state),

                          const SizedBox(height: 20),

                          // 생활습관 영향
                          _LifestyleImpact(state: state),

                          const SizedBox(height: 20),

                          // AI 인사이트
                          _AIInsights(state: state),

                          const SizedBox(height: 100),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 증상 빈도 추이
class _SymptomFrequencyTrend extends StatelessWidget {
  const _SymptomFrequencyTrend({required this.state});
  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    final totalSymptoms = state.symptomTrends.fold<int>(
      0,
      (sum, trend) => sum + trend.count,
    );

    // 이번 주 월요일 계산
    final now = DateTime.now();
    final weekday = now.weekday; // 1(월) ~ 7(일)
    final monday = now.subtract(Duration(days: weekday - 1));

    // 이번 주 월~일 각 날짜의 데이터 매핑
    final frequencies = List.generate(7, (index) {
      final targetDate = monday.add(Duration(days: index));
      final normalizedTarget = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );

      // symptomTrends에서 해당 날짜의 데이터 찾기
      final trend = state.symptomTrends.firstWhere(
        (t) {
          final trendDate = DateTime(t.date.year, t.date.month, t.date.day);
          return trendDate.isAtSameMomentAs(normalizedTarget);
        },
        orElse: () => SymptomTrend(
          date: normalizedTarget,
          count: 0,
          averageSeverity: 0,
        ),
      );

      return trend.count;
    });

    // 요일 레이블은 항상 월~일로 고정
    final dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

    // 이번 주 증상 횟수 계산
    final weekSymptoms = frequencies.reduce((a, b) => a + b);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '증상 빈도 추이',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.symptomColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '이번 주 $weekSymptoms회',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.symptomColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 바 차트
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = frequencies[index];
                final maxValue = frequencies.reduce(math.max);
                final height = maxValue > 0 ? (value / maxValue) * 80 : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height + 10,
                          decoration: BoxDecoration(
                            gradient: AppTheme.symptomGradient,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayLabels.map((day) {
              return Text(
                day,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 증상 분포
class _SymptomDistribution extends StatelessWidget {
  const _SymptomDistribution({required this.state});
  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    if (state.symptomDistribution.isEmpty) {
      return const GlassCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '증상 기록이 없습니다',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ),
      );
    }

    // 증상별 색상 매핑
    final colorMap = {
      GerdSymptom.heartburn: AppTheme.error,
      GerdSymptom.acidReflux: AppTheme.accent,
      GerdSymptom.regurgitation: AppTheme.accent,
      GerdSymptom.chestPain: AppTheme.error,
      GerdSymptom.dysphagia: AppTheme.warning,
      GerdSymptom.chronicCough: AppTheme.warning,
      GerdSymptom.hoarseness: AppTheme.info,
      GerdSymptom.throatPain: AppTheme.info,
      GerdSymptom.globusSensation: AppTheme.info,
      GerdSymptom.nausea: AppTheme.warning,
      GerdSymptom.bloating: AppTheme.textTertiary,
      GerdSymptom.burping: AppTheme.textTertiary,
    };

    final totalCount = state.symptomDistribution.fold<int>(
      0,
      (sum, dist) => sum + dist.count,
    );

    // 상위 5개만 표시하고 나머지는 기타로 묶음
    final top5 = state.symptomDistribution.take(5).toList();
    final otherCount = state.symptomDistribution.skip(5).fold<int>(
          0,
          (sum, dist) => sum + dist.count,
        );

    final symptoms = top5.map((dist) {
      final percentage =
          totalCount > 0 ? ((dist.count / totalCount) * 100).round() : 0;
      return _SymptomData(
        dist.symptom.label,
        percentage,
        colorMap[dist.symptom] ?? AppTheme.textTertiary,
      );
    }).toList();

    // 기타가 있으면 추가
    if (otherCount > 0) {
      final otherPercentage = ((otherCount / totalCount) * 100).round();
      symptoms.add(_SymptomData('기타', otherPercentage, AppTheme.textTertiary));
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '증상 분포',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '이번 주',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _DonutChartPainter(symptoms: symptoms),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$totalCount회',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Text(
                          '총 증상',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: symptoms.map((symptom) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: symptom.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              symptom.name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            '${symptom.percentage}%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: symptom.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 식사별 증상 연관성
class _MealSymptomCorrelation extends StatelessWidget {
  const _MealSymptomCorrelation({required this.state});
  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    // 기본값 또는 실제 데이터 사용
    final breakfast = state.mealSymptomCorrelation.firstWhere(
      (c) => c.mealType == MealType.breakfast,
      orElse: () => const MealSymptomCorrelation(
        mealType: MealType.breakfast,
        symptomCount: 0,
        totalMealCount: 0,
      ),
    );
    final lunch = state.mealSymptomCorrelation.firstWhere(
      (c) => c.mealType == MealType.lunch,
      orElse: () => const MealSymptomCorrelation(
        mealType: MealType.lunch,
        symptomCount: 0,
        totalMealCount: 0,
      ),
    );
    final dinner = state.mealSymptomCorrelation.firstWhere(
      (c) => c.mealType == MealType.dinner,
      orElse: () => const MealSymptomCorrelation(
        mealType: MealType.dinner,
        symptomCount: 0,
        totalMealCount: 0,
      ),
    );

    // 가장 높은 비율 찾기
    final maxPercentage = [
      breakfast.percentage,
      lunch.percentage,
      dinner.percentage,
    ].reduce((a, b) => a > b ? a : b);

    final highestMeal = maxPercentage == breakfast.percentage
        ? '아침'
        : maxPercentage == lunch.percentage
            ? '점심'
            : '저녁';

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_rounded,
                    color: AppTheme.mealColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '식사 후 증상 발생률',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '이번 주',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '식사 후 2시간 이내 증상 발생 비율',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MealCorrelationItem(
                emoji: '🌅',
                label: '아침',
                percentage: breakfast.percentage,
                color: const Color(0xFFFF9800),
              ),
              const SizedBox(width: 10),
              _MealCorrelationItem(
                emoji: '☀️',
                label: '점심',
                percentage: lunch.percentage,
                color: const Color(0xFF43A047),
              ),
              const SizedBox(width: 10),
              _MealCorrelationItem(
                emoji: '🌙',
                label: '저녁',
                percentage: dinner.percentage,
                color: const Color(0xFF3949AB),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (maxPercentage > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppTheme.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$highestMeal 식사 후 증상이 가장 많이 발생해요. '
                      '$highestMeal 식사량을 줄여보세요.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.warning,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MealCorrelationItem extends StatelessWidget {
  const _MealCorrelationItem({
    required this.emoji,
    required this.label,
    required this.percentage,
    required this.color,
  });
  final String emoji;
  final String label;
  final int percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 트리거 음식 분석
class _TriggerAnalysis extends StatelessWidget {
  const _TriggerAnalysis({required this.state});
  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    if (state.triggerAnalysis.isEmpty) {
      return const GlassCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '트리거 음식 기록이 없습니다',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ),
      );
    }

    final maxCount = state.triggerAnalysis.isNotEmpty
        ? state.triggerAnalysis.first.count
        : 1;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.warning,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '트리거 음식 TOP 5',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '증상 발생과 연관된 음식',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          ...state.triggerAnalysis.take(5).map((trigger) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    trigger.category.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trigger.category.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${trigger.count}회',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: trigger.count / maxCount,
                          backgroundColor:
                              AppTheme.warning.withValues(alpha: 0.15),
                          valueColor:
                              const AlwaysStoppedAnimation(AppTheme.warning),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 생활습관 영향
class _LifestyleImpact extends StatelessWidget {
  const _LifestyleImpact({required this.state});
  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    if (state.lifestyleImpacts.isEmpty) {
      return const GlassCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '생활습관 기록이 없습니다',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ),
      );
    }

    // 아이콘 매핑
    final iconMap = {
      LifestyleType.sleep: Icons.bedtime_rounded,
      LifestyleType.exercise: Icons.fitness_center_rounded,
      LifestyleType.stress: Icons.sentiment_dissatisfied_rounded,
      LifestyleType.smoking: Icons.smoking_rooms_rounded,
      LifestyleType.posture: Icons.airline_seat_recline_normal_rounded,
    };

    // 색상 매핑
    Color getColor(String status) {
      switch (status) {
        case '양호':
          return AppTheme.success;
        case '보통':
          return AppTheme.info;
        case '부족':
        case '주의':
          return AppTheme.warning;
        default:
          return AppTheme.textSecondary;
      }
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_run_rounded,
                    color: AppTheme.lifestyleColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '생활습관 영향',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '이번 주',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...state.lifestyleImpacts.asMap().entries.map((entry) {
            final index = entry.key;
            final impact = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < state.lifestyleImpacts.length - 1 ? 10 : 0,
              ),
              child: _LifestyleItem(
                icon: iconMap[impact.lifestyleType] ?? Icons.help_outline,
                label: impact.lifestyleType.label,
                status: impact.statusLabel,
                description: impact.description,
                color: getColor(impact.statusLabel),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LifestyleItem extends StatelessWidget {
  const _LifestyleItem({
    required this.icon,
    required this.label,
    required this.status,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String status;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AI 인사이트
class _AIInsights extends StatelessWidget {
  const _AIInsights({required this.state});
  final InsightsState state;

  /// 지난 주 월요일 계산
  DateTime get _lastMonday {
    final now = DateTime.now();
    final weekday = now.weekday; // 1(월) ~ 7(일)
    // 이번 주 월요일에서 7일 빼면 지난 주 월요일
    final thisMonday = now.subtract(Duration(days: weekday - 1));
    return DateTime(thisMonday.year, thisMonday.month, thisMonday.day)
        .subtract(const Duration(days: 7));
  }

  /// 지난 주 일요일 계산
  DateTime get _lastSunday {
    return _lastMonday.add(const Duration(days: 6));
  }

  /// 지난 주 기록된 일수 계산 (lastWeekSymptomTrends 사용)
  int get lastWeekRecordedDays {
    // lastWeekSymptomTrends는 이미 지난 주 데이터만 포함
    return state.lastWeekSymptomTrends.where((t) => t.count > 0).length;
  }

  /// 최소 기록 일수
  static const int minRequiredDays = 3;

  // TODO: 테스트 완료 후 false로 변경
  static const bool _testMode = true;

  /// 데이터가 충분한지 확인 (지난 주 3일 이상 기록)
  bool get hasEnoughData =>
      _testMode || lastWeekRecordedDays >= minRequiredDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              '지난주 AI 리포트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // AI 로딩 중
        if (state.isAILoading)
          const _AILoadingIndicator()
        // AI 결과 있음
        else if (state.aiInsight.isSome())
          _AIInsightCards(
            insight: state.aiInsight.toNullable()!,
            nextReportDate: state.nextReportDate,
          )
        // 데이터 부족 - 기록 유도
        else if (!hasEnoughData)
          _InsufficientDataCard(
            recordedDays: lastWeekRecordedDays,
            minRequiredDays: minRequiredDays,
          )
        // AI 결과 없음 - 생성 버튼 표시
        else
          _GenerateAIButton(
            onPressed: () {
              context
                  .read<InsightsBloc>()
                  .add(const InsightsEvent.loadAIInsights());
            },
          ),
      ],
    );
  }
}

/// 데이터 부족 안내 카드
class _InsufficientDataCard extends StatelessWidget {
  const _InsufficientDataCard({
    required this.recordedDays,
    required this.minRequiredDays,
  });
  final int recordedDays;
  final int minRequiredDays;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '지난 주 $minRequiredDays일 이상 기록이 필요해요',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // 진행률 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '지난 주 기록: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textTertiary,
                  ),
                ),
                Text(
                  '$recordedDays일',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                Text(
                  ' / $minRequiredDays일',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// AI 로딩 인디케이터
class _AILoadingIndicator extends StatelessWidget {
  const _AILoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 2.5,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'AI가 건강 데이터를 분석하고 있어요...',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI 생성 버튼
class _GenerateAIButton extends StatelessWidget {
  const _GenerateAIButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Icon(
            Icons.psychology_rounded,
            size: 48,
            color: AppTheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          const Text(
            '지난 주 건강 리포트를 받아보세요',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '기록된 데이터를 기반으로 AI가 분석해드려요',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('주간 리포트 생성'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '매주 1회 생성 · 기록 기반 분석',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// AI 인사이트 카드들
class _AIInsightCards extends StatelessWidget {
  const _AIInsightCards({
    required this.insight,
    this.nextReportDate,
  });
  final AIInsight insight;
  final DateTime? nextReportDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 요약 카드
        _AIInsightCard(
          icon: Icons.summarize_rounded,
          title: '지난 주 건강 요약',
          message: insight.summary,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 10),

        // 식단 조언
        _AIInsightCard(
          icon: Icons.restaurant_menu_rounded,
          title: '이번 주 식단 조언',
          message: insight.dietAdvice,
          color: AppTheme.mealColor,
        ),
        const SizedBox(height: 10),

        // 생활습관 조언
        _AIInsightCard(
          icon: Icons.self_improvement_rounded,
          title: '이번 주 생활습관 조언',
          message: insight.lifestyleAdvice,
          color: AppTheme.lifestyleColor,
        ),
        const SizedBox(height: 10),

        // 트리거 경고
        if (insight.triggerWarning.isNotEmpty)
          _AIInsightCard(
            icon: Icons.warning_amber_rounded,
            title: '주의 사항',
            message: insight.triggerWarning,
            color: AppTheme.warning,
          ),

        // 생성 시간 및 다음 리포트 안내
        const SizedBox(height: 12),
        Text(
          '${_formatDate(insight.generatedAt)} 생성'
          '${nextReportDate != null ? ' · 다음 리포트: '
              '${_formatNextDate(nextReportDate!)}' : ''}',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일';
  }

  String _formatNextDate(DateTime date) {
    return '${date.month}/${date.day} (월)';
  }
}

/// AI 인사이트 개별 카드
class _AIInsightCard extends StatelessWidget {
  const _AIInsightCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== 데이터 클래스 ==========

class _SymptomData {
  _SymptomData(this.name, this.percentage, this.color);
  final String name;
  final int percentage;
  final Color color;
}

// ========== Custom Painters ==========

/// 도넛 차트 페인터
class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({required this.symptoms});
  final List<_SymptomData> symptoms;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 16.0;

    var startAngle = -90.0 * (math.pi / 180);

    for (final symptom in symptoms) {
      final sweepAngle = (symptom.percentage / 100) * 2 * math.pi;

      final paint = Paint()
        ..color = symptom.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
