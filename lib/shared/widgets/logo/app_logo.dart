import 'package:flutter/material.dart';

import 'package:no_gerd/shared/theme/app_theme.dart';

/// 앱 공통 로고 위젯
class AppLogo extends StatelessWidget {
  /// 로고 크기 (small, medium, large)
  final LogoSize size;

  /// 애니메이션 활성화 여부
  final bool animated;

  const AppLogo({
    super.key,
    this.size = LogoSize.medium,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();

    return SizedBox(
      width: dimensions.containerSize,
      height: dimensions.containerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외부 컨테이너
          Container(
            width: dimensions.containerSize,
            height: dimensions.containerSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(64),
                  Colors.white.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
              border: Border.all(
                color: Colors.white.withAlpha(77),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(77),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // 배경 원형 그라디언트
          Container(
            width: dimensions.innerCircleSize,
            height: dimensions.innerCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withAlpha(51),
                  Colors.white.withAlpha(13),
                ],
              ),
            ),
          ),
          // 메인 아이콘
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 하트 아이콘 배경
              Container(
                width: dimensions.iconBoxSize,
                height: dimensions.iconBoxSize,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(dimensions.iconBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(102),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: dimensions.iconSize,
                ),
              ),
              // 체크 마크
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: dimensions.checkSize,
                  height: dimensions.checkSize,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.success,
                        Color(0xFF4CAF50),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: dimensions.checkBorderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withAlpha(102),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: dimensions.checkIconSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _LogoDimensions _getDimensions() {
    switch (size) {
      case LogoSize.small:
        return const _LogoDimensions(
          containerSize: 80,
          borderRadius: 20,
          innerCircleSize: 55,
          iconBoxSize: 40,
          iconBorderRadius: 12,
          iconSize: 22,
          checkSize: 16,
          checkBorderWidth: 2,
          checkIconSize: 10,
        );
      case LogoSize.medium:
        return const _LogoDimensions(
          containerSize: 120,
          borderRadius: 30,
          innerCircleSize: 82,
          iconBoxSize: 60,
          iconBorderRadius: 18,
          iconSize: 33,
          checkSize: 24,
          checkBorderWidth: 2.5,
          checkIconSize: 14,
        );
      case LogoSize.large:
        return const _LogoDimensions(
          containerSize: 160,
          borderRadius: 40,
          innerCircleSize: 110,
          iconBoxSize: 80,
          iconBorderRadius: 24,
          iconSize: 44,
          checkSize: 32,
          checkBorderWidth: 3,
          checkIconSize: 18,
        );
    }
  }
}

/// 로고 크기 열거형
enum LogoSize {
  small,
  medium,
  large,
}

class _LogoDimensions {
  final double containerSize;
  final double borderRadius;
  final double innerCircleSize;
  final double iconBoxSize;
  final double iconBorderRadius;
  final double iconSize;
  final double checkSize;
  final double checkBorderWidth;
  final double checkIconSize;

  const _LogoDimensions({
    required this.containerSize,
    required this.borderRadius,
    required this.innerCircleSize,
    required this.iconBoxSize,
    required this.iconBorderRadius,
    required this.iconSize,
    required this.checkSize,
    required this.checkBorderWidth,
    required this.checkIconSize,
  });
}
