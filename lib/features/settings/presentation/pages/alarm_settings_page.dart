import 'package:flutter/material.dart';
import 'package:no_gerd/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 알람 설정 화면
/// 식사 알림, 약물 복용 알림 설정
class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({super.key});

  @override
  State<AlarmSettingsPage> createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  // 식사 알림
  bool _breakfastMealEnabled = false;
  TimeOfDay _breakfastMealTime = const TimeOfDay(hour: 7, minute: 30);

  bool _lunchMealEnabled = false;
  TimeOfDay _lunchMealTime = const TimeOfDay(hour: 12, minute: 0);

  bool _dinnerMealEnabled = false;
  TimeOfDay _dinnerMealTime = const TimeOfDay(hour: 18, minute: 30);

  // 약물 알림
  bool _breakfastMedicationEnabled = false;
  TimeOfDay _breakfastMedicationTime = const TimeOfDay(hour: 8, minute: 0);

  bool _lunchMedicationEnabled = false;
  TimeOfDay _lunchMedicationTime = const TimeOfDay(hour: 12, minute: 30);

  bool _dinnerMedicationEnabled = false;
  TimeOfDay _dinnerMedicationTime = const TimeOfDay(hour: 19, minute: 0);

  // 생활습관 알림
  bool _sleepEnabled = false;
  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // 식사 알림
      _breakfastMealEnabled = prefs.getBool('alarm_breakfast_meal_enabled') ?? false;
      _breakfastMealTime = TimeOfDay(
        hour: prefs.getInt('alarm_breakfast_meal_hour') ?? 7,
        minute: prefs.getInt('alarm_breakfast_meal_minute') ?? 30,
      );

      _lunchMealEnabled = prefs.getBool('alarm_lunch_meal_enabled') ?? false;
      _lunchMealTime = TimeOfDay(
        hour: prefs.getInt('alarm_lunch_meal_hour') ?? 12,
        minute: prefs.getInt('alarm_lunch_meal_minute') ?? 0,
      );

      _dinnerMealEnabled = prefs.getBool('alarm_dinner_meal_enabled') ?? false;
      _dinnerMealTime = TimeOfDay(
        hour: prefs.getInt('alarm_dinner_meal_hour') ?? 18,
        minute: prefs.getInt('alarm_dinner_meal_minute') ?? 30,
      );

      // 약물 알림
      _breakfastMedicationEnabled =
          prefs.getBool('alarm_breakfast_medication_enabled') ?? false;
      _breakfastMedicationTime = TimeOfDay(
        hour: prefs.getInt('alarm_breakfast_medication_hour') ?? 8,
        minute: prefs.getInt('alarm_breakfast_medication_minute') ?? 0,
      );

      _lunchMedicationEnabled =
          prefs.getBool('alarm_lunch_medication_enabled') ?? false;
      _lunchMedicationTime = TimeOfDay(
        hour: prefs.getInt('alarm_lunch_medication_hour') ?? 12,
        minute: prefs.getInt('alarm_lunch_medication_minute') ?? 30,
      );

      _dinnerMedicationEnabled =
          prefs.getBool('alarm_dinner_medication_enabled') ?? false;
      _dinnerMedicationTime = TimeOfDay(
        hour: prefs.getInt('alarm_dinner_medication_hour') ?? 19,
        minute: prefs.getInt('alarm_dinner_medication_minute') ?? 0,
      );

      // 생활습관 알림
      _sleepEnabled = prefs.getBool('alarm_sleep_enabled') ?? false;
      _sleepTime = TimeOfDay(
        hour: prefs.getInt('alarm_sleep_hour') ?? 22,
        minute: prefs.getInt('alarm_sleep_minute') ?? 0,
      );
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '알람 설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 식사 알림 섹션
            _buildSectionHeader('🍽️', '식사 알림'),
            const SizedBox(height: 4),
            const Text(
              '식사 시간을 알려드립니다',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlarmItem(
              emoji: '🌅',
              title: '아침 식사',
              enabled: _breakfastMealEnabled,
              time: _breakfastMealTime,
              onToggle: (value) {
                setState(() => _breakfastMealEnabled = value);
                _saveSetting('alarm_breakfast_meal_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _breakfastMealTime,
                (time) {
                  setState(() => _breakfastMealTime = time);
                  _saveSetting('alarm_breakfast_meal_hour', time.hour);
                  _saveSetting('alarm_breakfast_meal_minute', time.minute);
                },
                title: '아침 식사 알림',
                subtitle: '아침 식사 시간을 설정하세요',
              ),
              color: const Color(0xFFFF9800),
            ),
            const SizedBox(height: 12),
            _buildAlarmItem(
              emoji: '☀️',
              title: '점심 식사',
              enabled: _lunchMealEnabled,
              time: _lunchMealTime,
              onToggle: (value) {
                setState(() => _lunchMealEnabled = value);
                _saveSetting('alarm_lunch_meal_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _lunchMealTime,
                (time) {
                  setState(() => _lunchMealTime = time);
                  _saveSetting('alarm_lunch_meal_hour', time.hour);
                  _saveSetting('alarm_lunch_meal_minute', time.minute);
                },
                title: '점심 식사 알림',
                subtitle: '점심 식사 시간을 설정하세요',
              ),
              color: const Color(0xFF43A047),
            ),
            const SizedBox(height: 12),
            _buildAlarmItem(
              emoji: '🌙',
              title: '저녁 식사',
              enabled: _dinnerMealEnabled,
              time: _dinnerMealTime,
              onToggle: (value) {
                setState(() => _dinnerMealEnabled = value);
                _saveSetting('alarm_dinner_meal_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _dinnerMealTime,
                (time) {
                  setState(() => _dinnerMealTime = time);
                  _saveSetting('alarm_dinner_meal_hour', time.hour);
                  _saveSetting('alarm_dinner_meal_minute', time.minute);
                },
                title: '저녁 식사 알림',
                subtitle: '저녁 식사 시간을 설정하세요',
              ),
              color: const Color(0xFF3949AB),
            ),

            const SizedBox(height: 32),

            // 약물 알림 섹션
            _buildSectionHeader('💊', '약물 복용 알림'),
            const SizedBox(height: 4),
            const Text(
              '약물 복용 시간을 알려드립니다',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlarmItem(
              emoji: '☕',
              title: '아침 약물',
              enabled: _breakfastMedicationEnabled,
              time: _breakfastMedicationTime,
              onToggle: (value) {
                setState(() => _breakfastMedicationEnabled = value);
                _saveSetting('alarm_breakfast_medication_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _breakfastMedicationTime,
                (time) {
                  setState(() => _breakfastMedicationTime = time);
                  _saveSetting('alarm_breakfast_medication_hour', time.hour);
                  _saveSetting('alarm_breakfast_medication_minute', time.minute);
                },
                title: '아침 약물 알림',
                subtitle: '아침 약물 복용 시간을 설정하세요',
              ),
              color: AppTheme.medicationColor,
            ),
            const SizedBox(height: 12),
            _buildAlarmItem(
              emoji: '🍵',
              title: '점심 약물',
              enabled: _lunchMedicationEnabled,
              time: _lunchMedicationTime,
              onToggle: (value) {
                setState(() => _lunchMedicationEnabled = value);
                _saveSetting('alarm_lunch_medication_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _lunchMedicationTime,
                (time) {
                  setState(() => _lunchMedicationTime = time);
                  _saveSetting('alarm_lunch_medication_hour', time.hour);
                  _saveSetting('alarm_lunch_medication_minute', time.minute);
                },
                title: '점심 약물 알림',
                subtitle: '점심 약물 복용 시간을 설정하세요',
              ),
              color: AppTheme.medicationColor,
            ),
            const SizedBox(height: 12),
            _buildAlarmItem(
              emoji: '🌃',
              title: '저녁 약물',
              enabled: _dinnerMedicationEnabled,
              time: _dinnerMedicationTime,
              onToggle: (value) {
                setState(() => _dinnerMedicationEnabled = value);
                _saveSetting('alarm_dinner_medication_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _dinnerMedicationTime,
                (time) {
                  setState(() => _dinnerMedicationTime = time);
                  _saveSetting('alarm_dinner_medication_hour', time.hour);
                  _saveSetting('alarm_dinner_medication_minute', time.minute);
                },
                title: '저녁 약물 알림',
                subtitle: '저녁 약물 복용 시간을 설정하세요',
              ),
              color: AppTheme.medicationColor,
            ),

            const SizedBox(height: 32),

            // 생활습관 알림 섹션
            _buildSectionHeader('🏃', '생활습관 알림'),
            const SizedBox(height: 4),
            const Text(
              '건강한 생활습관을 위한 알림',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlarmItem(
              emoji: '😴',
              title: '취침 시간',
              enabled: _sleepEnabled,
              time: _sleepTime,
              onToggle: (value) {
                setState(() => _sleepEnabled = value);
                _saveSetting('alarm_sleep_enabled', value);
              },
              onTimeTap: () => _selectTime(
                _sleepTime,
                (time) {
                  setState(() => _sleepTime = time);
                  _saveSetting('alarm_sleep_hour', time.hour);
                  _saveSetting('alarm_sleep_minute', time.minute);
                },
                title: '취침 시간 알림',
                subtitle: '건강한 수면을 위한 시간을 설정하세요',
              ),
              color: AppTheme.lifestyleColor,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAlarmItem({
    required String emoji,
    required String title,
    required bool enabled,
    required TimeOfDay time,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTimeTap,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: enabled ? color.withValues(alpha: 0.3) : Colors.grey.shade300,
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
                    color: enabled ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTimeTap,
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
                        width: 1,
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
            onChanged: onToggle,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
    TimeOfDay currentTime,
    ValueChanged<TimeOfDay> onTimeSelected, {
    String title = '시간 선택',
    String? subtitle,
  }) async {
    final TimeOfDay? picked = await CustomTimePicker.show(
      context: context,
      initialTime: currentTime,
      title: title,
      subtitle: subtitle,
    );

    if (picked != null && picked != currentTime) {
      onTimeSelected(picked);
    }
  }
}
