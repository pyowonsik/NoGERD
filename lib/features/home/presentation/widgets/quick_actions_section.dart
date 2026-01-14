import 'package:flutter/material.dart';

import 'package:no_gerd/shared/shared.dart';

/// 빠른 기록 액션 섹션
class QuickActionsSection extends StatelessWidget {
  /// 생성자
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '빠른 기록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                emoji: '🔥',
                label: '증상',
                gradient: AppTheme.symptomGradient,
                onTap: () {
                  // TODO: 증상 기록 화면으로 이동
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                emoji: '🍽️',
                label: '식사',
                gradient: AppTheme.mealGradient,
                onTap: () {
                  // TODO: 식사 기록 화면으로 이동
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                emoji: '💊',
                label: '약물',
                gradient: AppTheme.medicationGradient,
                onTap: () {
                  // TODO: 약물 기록 화면으로 이동
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                emoji: '🏃',
                label: '생활',
                gradient: AppTheme.lifestyleGradient,
                onTap: () {
                  // TODO: 생활습관 기록 화면으로 이동
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.emoji,
    required this.label,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
