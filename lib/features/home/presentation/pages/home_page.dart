import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/features/home/presentation/bloc/home_bloc.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

import '../widgets/health_score_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/quick_tips_section.dart';
import '../widgets/recent_records_section.dart';
import '../widgets/today_summary_section.dart';

/// 홈 화면 (BLoC 적용)
class HomePage extends StatefulWidget {
  /// 생성자
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 한 번만 데이터 로드
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
        // RecordBloc에서 성공 메시지가 있으면 HomeBloc을 새로고침
        state.successMessage.fold(
          () {},
          (_) => context.read<HomeBloc>().add(const HomeEvent.refreshed()),
        );
      },
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading ||
              previous.healthScore != current.healthScore ||
              previous.todaySummary != current.todaySummary ||
              previous.recentRecords != current.recentRecords,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeEvent.refreshed());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  _buildAppBar(context),

                  // Content
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

                          // 건강 점수 카드
                          HealthScoreCard(
                            score: state.healthScore,
                            previousScore: state.previousScore,
                            message: state.healthScore > state.previousScore
                                ? '지난 주보다 상태가 좋아졌어요!'
                                : '건강 관리를 계속하세요!',
                          ),

                          const SizedBox(height: 20),

                          // 오늘 요약 카드들
                          TodaySummarySection(summary: state.todaySummary),

                          const SizedBox(height: 24),

                          // 빠른 기록 버튼들
                          const QuickActionsSection(),

                          const SizedBox(height: 24),

                          // 최근 기록 섹션
                          RecentRecordsSection(records: state.recentRecords),

                          const SizedBox(height: 24),

                          // 건강 팁 섹션
                          const QuickTipsSection(),

                          const SizedBox(height: 100), // Bottom Nav 공간
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요 👋',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '오늘의 건강 상태',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
