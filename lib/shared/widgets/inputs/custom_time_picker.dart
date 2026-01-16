import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no_gerd/shared/theme/app_theme.dart';

/// 앱 컨셉에 맞는 커스텀 시간 선택기
/// iOS 스타일 휠 피커 + Teal 기반 디자인
class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
    super.key,
    required this.initialTime,
    this.title = '시간 선택',
    this.subtitle,
  });
  final TimeOfDay initialTime;
  final String title;
  final String? subtitle;

  /// 시간 선택 Bottom Sheet 표시
  static Future<TimeOfDay?> show({
    required BuildContext context,
    required TimeOfDay initialTime,
    String title = '시간 선택',
    String? subtitle,
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomTimePicker(
        initialTime: initialTime,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildTimeSelector(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Column(
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryLight.withValues(alpha: 0.3),
                      AppTheme.primary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          // 선택 영역 하이라이트
          Center(
            child: Container(
              height: 52,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryLight.withValues(alpha: 0.2),
                    AppTheme.primary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // 피커
          Row(
            children: [
              // 시간 선택
              Expanded(
                child: _buildWheelPicker(
                  controller: _hourController,
                  itemCount: 24,
                  selectedValue: _selectedHour,
                  onChanged: (value) => setState(() => _selectedHour = value),
                  labelBuilder: (value) => value.toString().padLeft(2, '0'),
                ),
              ),

              // 구분자
              const Text(
                ':',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),

              // 분 선택
              Expanded(
                child: _buildWheelPicker(
                  controller: _minuteController,
                  itemCount: 60,
                  selectedValue: _selectedMinute,
                  onChanged: (value) => setState(() => _selectedMinute = value),
                  labelBuilder: (value) => value.toString().padLeft(2, '0'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedValue,
    required ValueChanged<int> onChanged,
    required String Function(int) labelBuilder,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 50,
      diameterRatio: 1.5,
      squeeze: 1,
      selectionOverlay: const SizedBox.shrink(),
      onSelectedItemChanged: onChanged,
      children: List.generate(itemCount, (index) {
        final isSelected = index == selectedValue;
        return Center(
          child: Text(
            labelBuilder(index),
            style: TextStyle(
              fontSize: isSelected ? 32 : 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected ? AppTheme.primaryDark : AppTheme.textTertiary,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Row(
        children: [
          // 취소 버튼
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: AppTheme.primaryLight.withValues(alpha: 0.5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 확인 버튼
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                  TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} 설정',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
