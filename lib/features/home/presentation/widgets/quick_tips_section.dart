import 'package:flutter/material.dart';

import 'package:no_gerd/shared/shared.dart';

/// 건강 팁 섹션
class QuickTipsSection extends StatelessWidget {
  /// 생성자
  const QuickTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      _TipData(
        icon: Icons.restaurant_menu_rounded,
        title: '식사 후 바로 눕지 마세요',
        message: '식사 후 2-3시간은 눕지 않는 것이 좋습니다. 위산 역류를 예방할 수 있어요.',
        color: AppTheme.mealColor,
      ),
      _TipData(
        icon: Icons.bedtime_rounded,
        title: '수면 자세를 바꿔보세요',
        message: '침대 머리를 15-20cm 높이면 야간 역류 증상을 줄일 수 있습니다.',
        color: AppTheme.lifestyleColor,
      ),
      _TipData(
        icon: Icons.no_food_rounded,
        title: '트리거 음식을 피하세요',
        message: '기름진 음식, 카페인, 탄산음료는 역류를 유발할 수 있어요.',
        color: AppTheme.symptomColor,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              color: AppTheme.warning,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              '건강 팁',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _TipCard(data: tips[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _TipData {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  _TipData({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
}

class _TipCard extends StatelessWidget {
  final _TipData data;

  const _TipCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  data.icon,
                  color: data.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              data.message,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
