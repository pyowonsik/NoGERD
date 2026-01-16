import 'package:flutter/material.dart';

import 'package:no_gerd/shared/theme/app_theme.dart';

/// 그라디언트 버튼 위젯
class GradientButton extends StatelessWidget {
  /// 생성자
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.width,
    this.height = 52,
    this.borderRadius = AppTheme.radiusMedium,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
  });

  /// 버튼 텍스트
  final String text;

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 그라디언트
  final Gradient? gradient;

  /// 버튼 너비
  final double? width;

  /// 버튼 높이
  final double height;

  /// 모서리 둥글기
  final double borderRadius;

  /// 아이콘
  final IconData? icon;

  /// 로딩 중 여부
  final bool isLoading;

  /// 비활성화 여부
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppTheme.primaryGradient;
    final isDisabled = disabled || isLoading;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isDisabled
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              )
            : effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDisabled ? null : AppTheme.buttonShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

/// 아웃라인 버튼
class OutlineButton extends StatelessWidget {
  /// 생성자
  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.icon,
  });

  /// 버튼 텍스트
  final String text;

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 테두리 색상
  final Color? borderColor;

  /// 텍스트 색상
  final Color? textColor;

  /// 버튼 너비
  final double? width;

  /// 버튼 높이
  final double height;

  /// 아이콘
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppTheme.primary;
    final effectiveTextColor = textColor ?? AppTheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: effectiveTextColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 칩 버튼 (선택용)
class SelectableChip extends StatelessWidget {
  /// 생성자
  const SelectableChip({
    super.key,
    required this.label,
    this.emoji,
    required this.isSelected,
    this.onTap,
    this.selectedColor,
  });

  /// 라벨
  final String label;

  /// 이모지
  final String? emoji;

  /// 선택 여부
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 선택 색상
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected
                ? color
                : AppTheme.textTertiary.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : AppTheme.textSecondary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check_circle,
                color: color,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// FAB (플로팅 액션 버튼)
class CustomFAB extends StatelessWidget {
  /// 생성자
  const CustomFAB({
    super.key,
    this.onPressed,
    this.icon = Icons.add,
    this.gradient,
    this.size = 64,
  });

  /// 탭 콜백
  final VoidCallback? onPressed;

  /// 아이콘
  final IconData icon;

  /// 그라디언트
  final Gradient? gradient;

  /// 크기
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            icon,
            color: Colors.white,
            size: size * 0.4,
          ),
        ),
      ),
    );
  }
}
