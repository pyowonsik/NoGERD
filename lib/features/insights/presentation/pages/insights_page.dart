import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

/// 인사이트 페이지 (BLoC 통합)
class InsightsPage extends StatefulWidget {
  /// 생성자
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 한 번만 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InsightsBloc>().add(const InsightsEvent.loadData(7));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _InsightsPageContent();
  }
}

class _InsightsPageContent extends StatelessWidget {
  const _InsightsPageContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
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

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<InsightsBloc, InsightsState>(
                  buildWhen: (previous, current) =>
                      previous.isLoading != current.isLoading ||
                      previous.selectedDays != current.selectedDays ||
                      previous.healthScore != current.healthScore ||
                      previous.symptomTrends != current.symptomTrends ||
                      previous.triggerAnalysis != current.triggerAnalysis ||
                      previous.weeklyPatterns != current.weeklyPatterns,
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
                        // 기간 선택
                        _buildPeriodSelector(context, state),

                        const SizedBox(height: 20),

                        // 건강 점수 트렌드 (라인 차트)
                        _buildHealthScoreTrend(state),

                        const SizedBox(height: 20),

                        // 증상 분포 (도넛 차트)
                        _buildSymptomDistribution(state),

                        const SizedBox(height: 20),

                        // 트리거 분석
                        _buildTriggerAnalysis(state),

                        const SizedBox(height: 20),

                        // 시간대별 패턴
                        _buildTimePattern(state),

                        const SizedBox(height: 20),

                        // AI 인사이트
                        _buildAIInsights(state),

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
    );
  }

  Widget _buildPeriodSelector(BuildContext context, InsightsState state) {
    final periods = [
      (7, '7일'),
      (14, '14일'),
      (30, '30일'),
    ];

    return Row(
      children: periods.map((period) {
        final days = period.$1;
        final label = period.$2;
        final isSelected = state.selectedDays == days;

        return Expanded(
          child: GestureDetector(
            onTap: () => context.read<InsightsBloc>().add(
                  InsightsEvent.loadData(days),
                ),
            child: Container(
              margin: EdgeInsets.only(right: days != 30 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHealthScoreTrend(InsightsState state) {
    final scoreDiff = state.healthScore - state.previousHealthScore;
    final isImproving = scoreDiff > 0;

    // 최근 7일 점수 데이터 (샘플)
    final scores = state.symptomTrends.reversed.take(7).map((trend) {
      return 100 - (trend.averageSeverity * 10).toInt();
    }).toList();

    // 데이터가 부족하면 현재 점수로 채움
    while (scores.length < 7) {
      scores.insert(0, state.healthScore);
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '건강 점수 추이',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (state.previousHealthScore > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isImproving ? AppTheme.success : AppTheme.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isImproving
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 16,
                        color: isImproving ? AppTheme.success : AppTheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isImproving ? '+' : ''}$scoreDiff점',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              isImproving ? AppTheme.success : AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          // 라인 차트
          SizedBox(
            height: 150,
            child: CustomPaint(
              size: const Size(double.infinity, 150),
              painter: _LineChartPainter(
                data: scores,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['월', '화', '수', '목', '금', '토', '일'].map((day) {
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

  Widget _buildSymptomDistribution(InsightsState state) {
    if (state.symptomTrends.isEmpty) {
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

    // 샘플 데이터 (실제로는 증상별 집계 필요)
    final symptoms = [
      _SymptomData('가슴쓰림', 35, AppTheme.error),
      _SymptomData('역류', 25, AppTheme.accent),
      _SymptomData('기침', 20, AppTheme.warning),
      _SymptomData('목이물감', 12, AppTheme.info),
      _SymptomData('기타', 8, AppTheme.textTertiary),
    ];

    final totalCount =
        state.symptomTrends.fold<int>(0, (sum, trend) => sum + trend.count);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '증상 분포',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 도넛 차트와 범례
          Row(
            children: [
              // 도넛 차트
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
              // 범례
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

  Widget _buildTriggerAnalysis(InsightsState state) {
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
                '트리거 음식 분석',
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
            '증상 발생과 연관된 음식을 분석했어요',
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

  Widget _buildTimePattern(InsightsState state) {
    // 시간대별 집계 (샘플)
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '시간대별 증상 패턴',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _TimeSlot(time: '아침\n(6-12시)', count: 5, isHighest: false),
              _TimeSlot(time: '오후\n(12-18시)', count: 12, isHighest: true),
              _TimeSlot(time: '저녁\n(18-24시)', count: 8, isHighest: false),
              _TimeSlot(time: '야간\n(0-6시)', count: 3, isHighest: false),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppTheme.info,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '오후에 증상이 가장 많이 발생해요. 점심 식사 후 활동에 주의하세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.info,
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

  Widget _buildAIInsights(InsightsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              'AI 인사이트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _InsightCard(
          icon: Icons.trending_up_rounded,
          title: '좋은 소식!',
          message: '지난 주 대비 증상 빈도가 감소 추세예요. 현재 관리 방법을 유지하세요.',
          color: AppTheme.success,
        ),
        const SizedBox(height: 10),
        _InsightCard(
          icon: Icons.restaurant_rounded,
          title: '식습관 팁',
          message: state.triggerAnalysis.isNotEmpty
              ? '${state.triggerAnalysis.first.category.label} 섭취 후 증상이 자주 발생해요.'
              : '균형 잡힌 식사를 유지하세요.',
          color: AppTheme.mealColor,
        ),
        const SizedBox(height: 10),
        const _InsightCard(
          icon: Icons.medication_rounded,
          title: '약물 복용',
          message: '규칙적인 약물 복용이 증상 완화에 도움이 됩니다.',
          color: AppTheme.medicationColor,
        ),
      ],
    );
  }
}

// ========== 위젯 컴포넌트 ==========

class _TimeSlot extends StatelessWidget {
  const _TimeSlot({
    required this.time,
    required this.count,
    required this.isHighest,
  });
  final String time;
  final int count;
  final bool isHighest;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isHighest
              ? AppTheme.symptomColor.withValues(alpha: 0.15)
              : AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: isHighest
              ? Border.all(color: AppTheme.symptomColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Text(
              '$count회',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isHighest ? AppTheme.symptomColor : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
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

/// 라인 차트 페인터
class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.data, required this.color});
  final List<int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final minValue = data.reduce(math.min) - 10;
    final maxValue = data.reduce(math.max) + 10;
    final range = maxValue - minValue;

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // 점 그리기
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = color,
      );
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
