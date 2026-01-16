import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:no_gerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/shared/shared.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

import 'package:no_gerd/features/home/presentation/widgets/recent_records_section.dart';
import 'package:no_gerd/features/home/presentation/widgets/today_summary_section.dart';

/// 홈 화면 V2 - 새로운 기획
/// 기록 방법: [아침][점심][저녁] + [약물][생활습관][증상] (upsert 방식)
/// 오늘 요약 + 최근 기록만 표시
class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeEvent.started());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        state.successMessage.fold(
          () {},
          (_) => context.read<HomeBloc>().add(const HomeEvent.refreshed()),
        );
      },
      child: const _HomePageV2Content(),
    );
  }
}

class _HomePageV2Content extends StatelessWidget {
  const _HomePageV2Content();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeEvent.refreshed());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // 로딩 인디케이터
                          if (state.isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            ),

                          // 기록 방법 섹션
                          _RecordMethodSection(
                            onMealTap: (mealType) {
                              final recordBloc = context.read<RecordBloc>();
                              context.push(
                                '/record/meal',
                                extra: {
                                  'bloc': recordBloc,
                                  'mealType': mealType,
                                },
                              );
                            },
                            onMedicationTap: (notTaking) {
                              final recordBloc = context.read<RecordBloc>();
                              context.push(
                                '/record/medication',
                                extra: {
                                  'bloc': recordBloc,
                                  'notTaking': notTaking,
                                },
                              );
                            },
                            onLifestyleTap: () {
                              final recordBloc = context.read<RecordBloc>();
                              context.push('/record/lifestyle',
                                  extra: recordBloc);
                            },
                            onSymptomTap: () {
                              final recordBloc = context.read<RecordBloc>();
                              context.push(
                                '/record/symptom',
                                extra: recordBloc,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // 오늘 요약
                          TodaySummarySection(summary: state.todaySummary),

                          const SizedBox(height: 24),

                          // 최근 기록
                          RecentRecordsSection(
                            records: state.recentRecords,
                            allRecords: state.allRecentRecords,
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Builder(
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '오늘의 건강 기록',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 기록 방법 섹션
/// 첫 번째 줄: 아침, 점심, 저녁 (식사 시간대)
/// 두 번째 줄: 약물, 생활습관, 증상 (기록 유형)
class _RecordMethodSection extends StatefulWidget {
  const _RecordMethodSection({
    required this.onMealTap,
    required this.onMedicationTap,
    required this.onLifestyleTap,
    required this.onSymptomTap,
  });

  /// 식사 기록 탭 (MealType enum)
  final void Function(MealType mealType) onMealTap;

  /// 약물 기록 탭 (bool: 복용 안함 여부)
  final void Function(bool notTaking) onMedicationTap;

  /// 생활습관 기록 탭
  final VoidCallback onLifestyleTap;

  /// 증상 기록 탭
  final VoidCallback onSymptomTap;

  @override
  State<_RecordMethodSection> createState() => _RecordMethodSectionState();
}

class _RecordMethodSectionState extends State<_RecordMethodSection> {
  bool _notTakingMedication = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '기록하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _notTakingMedication
                    ? AppTheme.info.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _notTakingMedication
                      ? AppTheme.info
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _notTakingMedication
                        ? Icons.cancel_rounded
                        : Icons.medication_rounded,
                    size: 16,
                    color: _notTakingMedication
                        ? AppTheme.info
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '약물 복용',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _notTakingMedication
                          ? AppTheme.info
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 20,
                    child: Switch(
                      value: _notTakingMedication,
                      onChanged: (value) {
                        setState(() => _notTakingMedication = value);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeThumbColor: AppTheme.info,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 첫 번째 줄: 식사 시간대
        Row(
          children: [
            Expanded(
              child: _RecordButton(
                emoji: '🌅',
                label: '아침',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => widget.onMealTap(MealType.breakfast),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RecordButton(
                emoji: '☀️',
                label: '점심',
                gradient: const LinearGradient(
                  colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => widget.onMealTap(MealType.lunch),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RecordButton(
                emoji: '🌙',
                label: '저녁',
                gradient: const LinearGradient(
                  colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => widget.onMealTap(MealType.dinner),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 두 번째 줄: 기록 유형
        Row(
          children: [
            Expanded(
              child: _RecordButton(
                emoji: _notTakingMedication ? '🚫' : '💊',
                label: _notTakingMedication ? '안먹음' : '약물',
                gradient: _notTakingMedication
                    ? const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : AppTheme.medicationGradient,
                onTap: () => widget.onMedicationTap(_notTakingMedication),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RecordButton(
                emoji: '🏃',
                label: '생활습관',
                gradient: AppTheme.lifestyleGradient,
                onTap: widget.onLifestyleTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RecordButton(
                emoji: '🔥',
                label: '증상',
                gradient: AppTheme.symptomGradient,
                onTap: widget.onSymptomTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({
    required this.emoji,
    required this.label,
    required this.gradient,
    this.onTap,
    this.disabled = false,
  });
  final String emoji;
  final String label;
  final Gradient gradient;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            gradient: disabled
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : gradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: disabled
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
