import 'package:flutter/material.dart';

import 'package:no_gerd/shared/theme/app_theme.dart';

/// 증상 강도 슬라이더
class SeveritySlider extends StatelessWidget {
  /// 생성자
  const SeveritySlider({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  /// 현재 값 (1-10)
  final int value;

  /// 값 변경 콜백
  final ValueChanged<int>? onChanged;

  /// 라벨
  final String? label;

  Color get _severityColor {
    if (value <= 3) return AppTheme.success;
    if (value <= 6) return AppTheme.warning;
    return AppTheme.error;
  }

  String get _severityText {
    if (value <= 3) return '약함';
    if (value <= 6) return '보통';
    return '심함';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: _severityColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _severityColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _severityColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _severityText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _severityColor,
                        ),
                      ),
                    ],
                  ),
                  _buildSeverityIndicator(),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                  activeTrackColor: _severityColor,
                  inactiveTrackColor: _severityColor.withValues(alpha: 0.2),
                  thumbColor: _severityColor,
                  overlayColor: _severityColor.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => onChanged?.call(v.round()),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '약함',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  Text(
                    '보통',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  Text(
                    '심함',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = (index == 0 && value <= 3) ||
            (index == 1 && value > 3 && value <= 6) ||
            (index == 2 && value > 6);
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? [AppTheme.success, AppTheme.warning, AppTheme.error][index]
                : Colors.grey.shade300,
          ),
        );
      }),
    );
  }
}

/// 시간 선택기
class TimeSelector extends StatelessWidget {
  /// 생성자
  const TimeSelector({
    super.key,
    required this.selectedTime,
    this.onChanged,
    this.label,
  });

  /// 선택된 시간
  final TimeOfDay selectedTime;

  /// 변경 콜백
  final ValueChanged<TimeOfDay>? onChanged;

  /// 라벨
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppTheme.primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (time != null) {
              onChanged?.call(time);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.textTertiary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppTheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 노트 입력 필드
class NoteInput extends StatelessWidget {
  /// 생성자
  const NoteInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.maxLines = 4,
    this.maxLength,
  });

  /// 컨트롤러
  final TextEditingController? controller;

  /// 라벨
  final String? label;

  /// 힌트
  final String? hint;

  /// 최대 줄 수
  final int maxLines;

  /// 최대 글자 수
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint ?? '메모를 입력하세요...',
            hintStyle: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: AppTheme.textTertiary.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: AppTheme.textTertiary.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
