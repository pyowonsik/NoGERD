import 'package:flutter/material.dart';

import 'package:no_gerd/shared/shared.dart';

/// 설정 항목 타일
class SettingTile extends StatelessWidget {
  /// 아이콘
  final IconData icon;

  /// 아이콘 색상
  final Color iconColor;

  /// 제목
  final String title;

  /// 서브타이틀
  final String subtitle;

  /// 오른쪽 위젯 (Switch 등)
  final Widget? trailing;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 생성자
  const SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textTertiary)
              : null),
    );
  }
}
