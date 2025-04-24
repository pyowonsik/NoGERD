import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/presentation/viewmodels/gerd_view_model.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/chart.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/glass_app_bar.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/glass_card.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/gradient_button.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/legned_item.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/mascot.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/modals/add_record_modal.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/modals/calendar_modal.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/recent_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final viewModel = GerdViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GerdRecord>>(
        stream: viewModel.recordsStream,
        builder: (context, snapshot) {
          final records = snapshot.data ?? [];

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFE8F5E9)
                ], // 연한 파란색에서 연한 녹색으로
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 글래스모피즘 앱바
                  const GlassAppBar(),
                  // 메인 콘텐츠
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // 마스코트와 환영 메시지
                        const Mascot(),
                        const SizedBox(height: 8),
                        const Text(
                          '오늘 어떠세요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          '증상을 기록하고 건강을 관리해보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 빠른 액션 버튼 (기록하기, 달력 보기)
                        Row(
                          children: [
                            Expanded(
                              child: GradientButton(
                                text: '오늘 기록하기',
                                icon: Icons.add_circle_outline,
                                colors: const [
                                  Color(0xFF1E88E5),
                                  Color(0xFF42A5F5)
                                ],
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AddRecordModal(viewModel: viewModel),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GradientButton(
                                text: '달력 보기',
                                icon: Icons.calendar_today,
                                colors: const [
                                  Color(0xFF66BB6A),
                                  Color(0xFF81C784)
                                ],
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CalendarModal(
                                      viewModel: viewModel,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 최근 상태 차트
                        GlassCard(
                          title: '최근 상태 요약',
                          subtitle: '지난 7일간의 증상 요약',
                          color: const Color(0xFF1E88E5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Chart(records: records),
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LegendItem(
                                      text: '가슴쓰림', color: Color(0xFF1E88E5)),
                                  SizedBox(width: 16),
                                  LegendItem(
                                      text: '역류', color: Color(0xFF66BB6A)),
                                  SizedBox(width: 16),
                                  LegendItem(
                                      text: '소화불량', color: Color(0xFFFFB74D))
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 최근 기록
                        GlassCard(
                          title: '최근 기록',
                          subtitle: '최근 입력한 기록들',
                          color: const Color(0xFF66BB6A),
                          child: Column(
                            children: records
                                .map(
                                  (e) => Column(
                                    children: [
                                      RecentEntry(
                                        record: e,
                                        viewModel: viewModel,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      )
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
