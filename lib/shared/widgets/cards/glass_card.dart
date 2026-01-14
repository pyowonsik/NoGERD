import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:no_gerd/shared/theme/app_theme.dart';

/// 유리 효과가 적용된 카드 위젯
class GlassCard extends StatelessWidget {
  /// 카드 내용
  final Widget child;

  /// 내부 패딩
  final EdgeInsetsGeometry? padding;

  /// 외부 마진
  final EdgeInsetsGeometry? margin;

  /// 카드 너비
  final double? width;

  /// 카드 높이
  final double? height;

  /// 모서리 둥글기
  final double borderRadius;

  /// 배경 색상
  final Color? backgroundColor;

  /// 블러 강도
  final double blur;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 그라디언트
  final Gradient? gradient;

  /// 생성자
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = AppTheme.radiusLarge,
    this.backgroundColor,
    this.blur = 10,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  gradient: gradient,
                  color: gradient == null
                      ? (backgroundColor ?? Colors.white.withValues(alpha: 0.9))
                      : null,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 상태 카드 (숫자 통계 표시용)
class StatCard extends StatelessWidget {
  /// 제목
  final String title;

  /// 값
  final String value;

  /// 부제목
  final String? subtitle;

  /// 아이콘
  final IconData? icon;

  /// 값 색상
  final Color? valueColor;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 생성자
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 액션 카드 (기록하기 버튼용)
class ActionCard extends StatelessWidget {
  /// 제목
  final String title;

  /// 부제목
  final String subtitle;

  /// 이모지
  final String emoji;

  /// 그라디언트
  final Gradient gradient;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 생성자
  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      gradient: gradient,
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: 18,
          ),
        ],
      ),
    );
  }
}

/// 인사이트 카드 (팁 표시용)
class InsightCard extends StatelessWidget {
  /// 제목
  final String title;

  /// 메시지
  final String message;

  /// 아이콘
  final IconData icon;

  /// 색상
  final Color color;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 생성자
  const InsightCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
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
