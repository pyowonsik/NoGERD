import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/presentation/viewmodels/gerd_view_model.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/characters/empty_character.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/characters/main_character.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/chart.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/glass_app_bar.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/glass_card.dart';
import 'package:no_gerd/features/gerd_record/presentation/widgets/gradient_button.dart';
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
  int currentPage = 0;
  final int recordsPerPage = 3;

  @override
  void initState() {
    super.initState();
    viewModel.loadAllRecords();
  }

  void _nextPage(int totalRecords) {
    final maxPage = (totalRecords / recordsPerPage).ceil() - 1;
    if (currentPage < maxPage) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  // 최근 날짜 기준으로 currentPage 설정
  int _getInitialPage(List<GerdRecord> records) {
    if (records.isEmpty) return 0;
    records.sort((a, b) => b.date.compareTo(a.date));

    final latestRecord = records.first;
    final index = records.indexOf(latestRecord);

    return (index / recordsPerPage).floor();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GerdRecord>>(
      stream: viewModel.recordsStream,
      builder: (context, snapshot) {
        final records = snapshot.data ?? [];

        if (currentPage == 0 && records.isNotEmpty) {
          currentPage = _getInitialPage(records);
        }

        final start = currentPage * recordsPerPage;
        final end = (start + recordsPerPage) > records.length
            ? records.length
            : (start + recordsPerPage);
        final pagedRecords = records.sublist(start, end);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const GlassAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const MainCharacter(),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              text: '오늘 기록하기',
                              icon: Icons.add_circle_outline,
                              colors: const [
                                Color(0xFF1E88E5),
                                Color(0xFF42A5F5),
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
                                Color(0xFF81C784),
                              ],
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CalendarModal(viewModel: viewModel),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GlassCard(
                        title: '최근 상태 요약',
                        subtitle: '지난 7일간의 증상 요약',
                        color: const Color(0xFF1E88E5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 250,
                              child: Chart(records: records),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlassCard(
                        title: '최근 기록',
                        subtitle: '최근 입력한 기록들',
                        color: const Color(0xFF66BB6A),
                        child: pagedRecords.isEmpty
                            ? const EmptyCharacter()
                            : Column(
                                children: [
                                  ...pagedRecords.map(
                                    (e) => Column(
                                      children: [
                                        RecentEntry(
                                            record: e, viewModel: viewModel),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: _prevPage,
                                      ),
                                      Text(
                                        '${records.isEmpty ? 0 : currentPage + 1} / ${(records.length / recordsPerPage).ceil()}',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: () =>
                                            _nextPage(records.length),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
