import 'package:flutter/material.dart';

import 'package:no_gerd/features/calendar/presentation/pages/calendar_page.dart';
import 'package:no_gerd/features/home/presentation/pages/home_page.dart';
import 'package:no_gerd/features/insights/presentation/pages/insights_page.dart';
import 'package:no_gerd/features/settings/presentation/pages/settings_page.dart';
import 'package:no_gerd/screens/record/quick_record_modal.dart';
import 'package:no_gerd/shared/shared.dart';

/// 메인 스크린 (Bottom Navigation 포함)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const CalendarPage(),
    const InsightsPage(),
    const SettingsPage(),
  ];

  void _showQuickRecordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickRecordModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: CustomFAB(
        onPressed: _showQuickRecordModal,
        icon: Icons.add,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, '홈'),
              _buildNavItem(1, Icons.calendar_month_rounded,
                  Icons.calendar_month_outlined, '캘린더'),
              const SizedBox(width: 64), // FAB 공간
              _buildNavItem(
                  2, Icons.insights_rounded, Icons.insights_outlined, '분석'),
              _buildNavItem(
                  3, Icons.settings_rounded, Icons.settings_outlined, '설정'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? AppTheme.primary : AppTheme.textTertiary,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
