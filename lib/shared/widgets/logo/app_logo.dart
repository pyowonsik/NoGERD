import 'package:flutter/material.dart';

/// 앱 공통 로고 위젯
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = LogoSize.medium,
    this.animated = false,
  });

  /// 로고 크기 (small, medium, large)
  final LogoSize size;

  /// 애니메이션 활성화 여부
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final imageSize = _getImageSize();

    return Image.asset(
      'assets/icon.png',
      width: imageSize,
      height: imageSize,
      fit: BoxFit.contain,
    );
  }

  double _getImageSize() {
    switch (size) {
      case LogoSize.small:
        return 80;
      case LogoSize.medium:
        return 120;
      case LogoSize.large:
        return 160;
    }
  }
}

/// 로고 크기 열거형
enum LogoSize {
  small,
  medium,
  large,
}
