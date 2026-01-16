import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:no_gerd/core/di/injection.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/presentation/bloc/alarm_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

/// 알람 설정 화면
/// 식사 알림, 약물 복용 알림 설정
class AlarmSettingsPage extends StatelessWidget {
  const AlarmSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AlarmBloc>()..add(const AlarmEvent.loadConfigs()),
      child: const _AlarmSettingsView(),
    );
  }
}

class _AlarmSettingsView extends StatelessWidget {
  const _AlarmSettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlarmBloc, AlarmState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        state.errorMessage.fold(
          () => null,
          (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '알람 설정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                if (!state.hasPermission && !state.isLoading) {
                  return IconButton(
                    icon: const Icon(Icons.notifications_off),
                    onPressed: () {
                      context.read<AlarmBloc>().add(
                            const AlarmEvent.requestPermission(),
                          );
                    },
                    tooltip: '알림 권한 요청',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AlarmBloc, AlarmState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 권한 안내
                  if (!state.hasPermission) _buildPermissionWarning(context),

                  // 식사 알림 섹션
                  _buildSectionHeader(context, '🍽️', '식사 알림'),
                  const SizedBox(height: 4),
                  Text(
                    '식사 시간을 알려드립니다',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.breakfast,
                    emoji: '🌅',
                    title: '아침 식사',
                    color: const Color(0xFFFF9800),
                    timePickerTitle: '아침 식사 알림',
                    timePickerSubtitle: '아침 식사 시간을 설정하세요',
                  ),
                  const SizedBox(height: 12),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.lunch,
                    emoji: '☀️',
                    title: '점심 식사',
                    color: const Color(0xFF43A047),
                    timePickerTitle: '점심 식사 알림',
                    timePickerSubtitle: '점심 식사 시간을 설정하세요',
                  ),
                  const SizedBox(height: 12),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.dinner,
                    emoji: '🌙',
                    title: '저녁 식사',
                    color: const Color(0xFF3949AB),
                    timePickerTitle: '저녁 식사 알림',
                    timePickerSubtitle: '저녁 식사 시간을 설정하세요',
                  ),

                  const SizedBox(height: 32),

                  // 약물 알림 섹션
                  _buildSectionHeader(context, '💊', '약물 복용 알림'),
                  const SizedBox(height: 4),
                  Text(
                    '약물 복용 시간을 알려드립니다',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.morningMedicine,
                    emoji: '☕',
                    title: '아침 약물',
                    color: AppTheme.medicationColor,
                    timePickerTitle: '아침 약물 알림',
                    timePickerSubtitle: '아침 약물 복용 시간을 설정하세요',
                  ),
                  const SizedBox(height: 12),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.lunchMedicine,
                    emoji: '🍵',
                    title: '점심 약물',
                    color: AppTheme.medicationColor,
                    timePickerTitle: '점심 약물 알림',
                    timePickerSubtitle: '점심 약물 복용 시간을 설정하세요',
                  ),
                  const SizedBox(height: 12),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.dinnerMedicine,
                    emoji: '🌃',
                    title: '저녁 약물',
                    color: AppTheme.medicationColor,
                    timePickerTitle: '저녁 약물 알림',
                    timePickerSubtitle: '저녁 약물 복용 시간을 설정하세요',
                  ),

                  const SizedBox(height: 32),

                  // 생활습관 알림 섹션
                  _buildSectionHeader(context, '🏃', '생활습관 알림'),
                  const SizedBox(height: 4),
                  Text(
                    '건강한 생활습관을 위한 알림',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAlarmItem(
                    context,
                    state,
                    type: AlarmType.bedtime,
                    emoji: '😴',
                    title: '취침 시간',
                    color: AppTheme.lifestyleColor,
                    timePickerTitle: '취침 시간 알림',
                    timePickerSubtitle: '건강한 수면을 위한 시간을 설정하세요',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '알림 권한이 필요합니다. 상단 아이콘을 눌러 권한을 허용해주세요.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String emoji,
    String title,
  ) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmItem(
    BuildContext context,
    AlarmState state, {
    required AlarmType type,
    required String emoji,
    required String title,
    required Color color,
    required String timePickerTitle,
    required String timePickerSubtitle,
  }) {
    final config = state.configs[type];
    if (config == null) return const SizedBox.shrink();

    final enabled = config.enabled;
    final time = TimeOfDay(hour: config.hour, minute: config.minute);

    const cardBgColor = Colors.white;
    final borderColor =
        enabled ? color.withValues(alpha: 0.3) : Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: enabled ? 2 : 1,
        ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: enabled
                  ? color.withValues(alpha: 0.15)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _selectTime(
                    context,
                    type,
                    time,
                    title: timePickerTitle,
                    subtitle: timePickerSubtitle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: enabled
                          ? color.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: enabled ? color : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: enabled ? color : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time.format(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: enabled ? color : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) {
              context.read<AlarmBloc>().add(
                    AlarmEvent.toggleAlarm(type: type, enabled: value),
                  );
            },
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    AlarmType type,
    TimeOfDay currentTime, {
    String title = '시간 선택',
    String? subtitle,
  }) async {
    final picked = await CustomTimePicker.show(
      context: context,
      initialTime: currentTime,
      title: title,
      subtitle: subtitle,
    );

    if (picked != null && picked != currentTime && context.mounted) {
      context.read<AlarmBloc>().add(
            AlarmEvent.updateTime(
              type: type,
              hour: picked.hour,
              minute: picked.minute,
            ),
          );
    }
  }
}
