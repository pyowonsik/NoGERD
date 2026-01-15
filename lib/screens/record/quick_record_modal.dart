import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/features/record/presentation/bloc/record_bloc.dart';
import 'package:no_gerd/shared/shared.dart';

const _uuid = Uuid();

/// 24시간제 시간 포맷
String _formatTime24(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// 빠른 기록 모달 (FAB 클릭 시 표시)
class QuickRecordModal extends StatelessWidget {
  const QuickRecordModal({super.key});

  @override
  Widget build(BuildContext context) {
    final recordBloc = context.read<RecordBloc>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                '무엇을 기록할까요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '기록하고 싶은 항목을 선택하세요',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              // Record Options
              _RecordOption(
                emoji: '🔥',
                title: '증상 기록',
                subtitle: '가슴쓰림, 역류, 기침 등 증상을 기록합니다',
                gradient: AppTheme.symptomGradient,
                onTap: () {
                  Navigator.pop(context);
                  context.push('/record/symptom', extra: recordBloc);
                },
              ),
              const SizedBox(height: 12),
              _RecordOption(
                emoji: '🍽️',
                title: '식사 기록',
                subtitle: '먹은 음식과 시간을 기록합니다',
                gradient: AppTheme.mealGradient,
                onTap: () {
                  Navigator.pop(context);
                  context.push('/record/meal', extra: recordBloc);
                },
              ),
              const SizedBox(height: 12),
              _RecordOption(
                emoji: '💊',
                title: '약물 복용',
                subtitle: '복용한 약물을 기록합니다',
                gradient: AppTheme.medicationGradient,
                onTap: () {
                  Navigator.pop(context);
                  context.push('/record/medication', extra: recordBloc);
                },
              ),
              const SizedBox(height: 12),
              _RecordOption(
                emoji: '🏃',
                title: '생활습관',
                subtitle: '수면, 운동, 스트레스 등을 기록합니다',
                gradient: AppTheme.lifestyleGradient,
                onTap: () {
                  Navigator.pop(context);
                  context.push('/record/lifestyle', extra: recordBloc);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _RecordOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      title: title,
      subtitle: subtitle,
      emoji: emoji,
      gradient: gradient,
      onTap: onTap,
    );
  }
}

// ============================================================
// 증상 기록 화면
// ============================================================
class SymptomRecordScreen extends StatefulWidget {
  const SymptomRecordScreen({super.key});

  @override
  State<SymptomRecordScreen> createState() => _SymptomRecordScreenState();
}

class _SymptomRecordScreenState extends State<SymptomRecordScreen> {
  final Set<GerdSymptom> _selectedSymptoms = {};
  int _severity = 5;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (!state.isLoading && _isLoading) {
          setState(() => _isLoading = false);
          state.successMessage.fold(
            () {},
            (message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
          state.failure.fold(
            () {},
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '증상 기록',
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
              // 증상 선택
              const Text(
                '어떤 증상이 있나요?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '해당하는 증상을 모두 선택하세요',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GerdSymptom.values.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSymptoms.remove(symptom);
                        } else {
                          _selectedSymptoms.add(symptom);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.symptomColor.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.symptomColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(symptom.emoji,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 6),
                          Text(
                            symptom.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.symptomColor
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // 강도 선택
              const Text(
                '증상 강도',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildSeveritySlider(),

              const SizedBox(height: 28),

              // 시간 선택
              const Text(
                '발생 시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildTimeSelector(),

              const SizedBox(height: 28),

              // 메모
              const Text(
                '메모 (선택)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '추가로 기록하고 싶은 내용을 입력하세요',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedSymptoms.isNotEmpty && !_isLoading
                      ? _saveRecord
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.symptomColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          '기록 저장',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeveritySlider() {
    Color severityColor;
    String severityLabel;
    if (_severity <= 3) {
      severityColor = AppTheme.success;
      severityLabel = '약함';
    } else if (_severity <= 6) {
      severityColor = AppTheme.warning;
      severityLabel = '보통';
    } else {
      severityColor = AppTheme.error;
      severityLabel = '심함';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: severityColor.withValues(alpha: 0.3)),
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
                      color: severityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '$_severity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: severityColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    severityLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: severityColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(3, (index) {
                  final isActive = (index == 0 && _severity <= 3) ||
                      (index == 1 && _severity > 3 && _severity <= 6) ||
                      (index == 2 && _severity > 6);
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? [
                              AppTheme.success,
                              AppTheme.warning,
                              AppTheme.error
                            ][index]
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              activeTrackColor: severityColor,
              inactiveTrackColor: severityColor.withValues(alpha: 0.2),
              thumbColor: severityColor,
              overlayColor: severityColor.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _severity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _severity = v.round()),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('약함',
                  style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
              Text('보통',
                  style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
              Text('심함',
                  style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: () async {
        final time = await CustomTimePicker.show(
          context: context,
          initialTime: _selectedTime,
          title: '발생 시간',
          subtitle: '증상이 발생한 시간을 선택하세요',
        );
        if (time != null) {
          setState(() => _selectedTime = time);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time_rounded, color: AppTheme.primary),
            const SizedBox(width: 12),
            Text(
              _formatTime24(_selectedTime),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }

  void _saveRecord() {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final recordedAt = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final record = SymptomRecord(
      id: _uuid.v4(),
      recordedAt: recordedAt,
      symptoms: _selectedSymptoms.toList(),
      severity: _severity,
      notes: _noteController.text.isNotEmpty ? _noteController.text : null,
      createdAt: now,
    );

    // ignore: avoid_print
    print('[SymptomRecordScreen] Saving record: $record');

    context.read<RecordBloc>().add(RecordEvent.addSymptomRecord(record));
  }
}

// ============================================================
// 식사 기록 화면 (UPSERT 지원)
// ============================================================
class MealRecordScreen extends StatefulWidget {
  /// 초기 식사 타입 (홈에서 아침/점심/저녁 버튼 클릭 시 전달)
  final MealType? initialMealType;

  const MealRecordScreen({super.key, this.initialMealType});

  @override
  State<MealRecordScreen> createState() => _MealRecordScreenState();
}

class _MealRecordScreenState extends State<MealRecordScreen> {
  late MealType _selectedMealType;
  final List<String> _foods = [];
  final _foodController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final Set<TriggerFoodCategory> _selectedTriggers = {};
  int _fullnessLevel = 5;
  bool _isLoading = false;
  bool _isDataLoaded = false;
  String? _existingRecordId;

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.initialMealType ?? MealType.lunch;

    // initialMealType이 있으면 기존 기록 조회 (UPSERT용)
    if (widget.initialMealType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RecordBloc>().add(
              RecordEvent.loadMealRecord(
                date: DateTime.now(),
                mealType: widget.initialMealType!,
              ),
            );
      });
    }
  }

  @override
  void dispose() {
    _foodController.dispose();
    // 화면 종료 시 현재 기록 초기화
    if (mounted) {
      context.read<RecordBloc>().add(const RecordEvent.clearCurrentRecord());
    }
    super.dispose();
  }

  /// 기존 기록 데이터를 폼에 채우기
  void _populateFormWithExistingRecord(MealRecord record) {
    if (_isDataLoaded) return;
    _isDataLoaded = true;
    _existingRecordId = record.id;

    setState(() {
      _foods.clear();
      _foods.addAll(record.foods);
      _selectedTime = TimeOfDay(
        hour: record.recordedAt.hour,
        minute: record.recordedAt.minute,
      );
      if (record.triggerCategories != null) {
        _selectedTriggers.clear();
        _selectedTriggers.addAll(record.triggerCategories!);
      }
      if (record.fullnessLevel != null) {
        _fullnessLevel = record.fullnessLevel!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        // 기존 기록이 로드되면 폼에 채우기
        if (state.currentMealRecord != null && !_isDataLoaded) {
          _populateFormWithExistingRecord(state.currentMealRecord!);
        }

        if (!state.isLoading && _isLoading) {
          setState(() => _isLoading = false);
          state.successMessage.fold(
            () {},
            (message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
          state.failure.fold(
            () {},
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }
      },
      child: BlocBuilder<RecordBloc, RecordState>(
        builder: (context, state) {
          final isEditMode = state.isEditMode;
          final isLoadingRecord = state.isLoading && !_isLoading;

          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isEditMode ? '${_selectedMealType.label} 기록 수정' : '식사 기록',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              centerTitle: true,
            ),
            body: isLoadingRecord
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 식사 종류 (initialMealType이 없을 때만 표시)
                        if (widget.initialMealType == null) ...[
                          const Text(
                            '식사 종류',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: MealType.values.map((type) {
                              final isSelected = _selectedMealType == type;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedMealType = type),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right:
                                          type != MealType.values.last ? 8 : 0,
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.mealColor
                                              .withValues(alpha: 0.15)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.mealColor
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        type.label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? AppTheme.mealColor
                                              : AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          // initialMealType이 있으면 식사 타입 표시만
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.mealColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _selectedMealType.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${_selectedMealType.label} 기록',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.mealColor,
                                  ),
                                ),
                                const Spacer(),
                                if (isEditMode)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.info.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '수정 모드',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.info,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 시간 선택
                        const Text(
                          '식사 시간',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            final time = await CustomTimePicker.show(
                              context: context,
                              initialTime: _selectedTime,
                              title: '식사 시간',
                              subtitle: '식사한 시간을 선택하세요',
                            );
                            if (time != null) {
                              setState(() => _selectedTime = time);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: AppTheme.mealColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatTime24(_selectedTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppTheme.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 음식 입력
                        const Text(
                          '먹은 음식',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _foodController,
                                decoration: InputDecoration(
                                  hintText: '음식 이름을 입력하세요',
                                  hintStyle: TextStyle(
                                    color: AppTheme.textTertiary,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppTheme.mealColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                if (_foodController.text.trim().isNotEmpty) {
                                  setState(() {
                                    _foods.add(_foodController.text.trim());
                                    _foodController.clear();
                                  });
                                }
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.mealColor,
                                padding: const EdgeInsets.all(12),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                        if (_foods.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _foods.map((food) {
                              return Chip(
                                label: Text(food),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () =>
                                    setState(() => _foods.remove(food)),
                                backgroundColor:
                                    AppTheme.mealColor.withValues(alpha: 0.1),
                                side: BorderSide.none,
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // 트리거 음식 태그
                        const Text(
                          '트리거 음식 확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '해당하는 항목이 있으면 선택하세요',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: TriggerFoodCategory.values.map((trigger) {
                            final isSelected =
                                _selectedTriggers.contains(trigger);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedTriggers.remove(trigger);
                                  } else {
                                    _selectedTriggers.add(trigger);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.warning.withValues(alpha: 0.15)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.warning
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      trigger.emoji,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      trigger.label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.warning
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        // 저장 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _foods.isNotEmpty && !_isLoading
                                ? _saveRecord
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.mealColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditMode ? '기록 수정' : '기록 저장',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  void _saveRecord() {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final recordedAt = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // UPSERT 모드: initialMealType이 있으면 기존 ID 사용 또는 새 ID 생성
    final recordId = _existingRecordId ?? _uuid.v4();

    final record = MealRecord(
      id: recordId,
      recordedAt: recordedAt,
      mealType: _selectedMealType,
      foods: _foods,
      triggerCategories:
          _selectedTriggers.isNotEmpty ? _selectedTriggers.toList() : null,
      fullnessLevel: _fullnessLevel,
      createdAt: now,
    );

    // ignore: avoid_print
    print('[MealRecordScreen] Saving record: $record');

    // initialMealType이 있으면 UPSERT, 없으면 ADD
    if (widget.initialMealType != null) {
      context.read<RecordBloc>().add(RecordEvent.upsertMealRecord(record));
    } else {
      context.read<RecordBloc>().add(RecordEvent.addMealRecord(record));
    }
  }
}

// ============================================================
// 약물 기록 화면
// ============================================================
class MedicationRecordScreen extends StatefulWidget {
  /// 초기 복용 안함 상태 (홈에서 토글 ON 시 true)
  final bool initialNotTaking;

  const MedicationRecordScreen({super.key, this.initialNotTaking = false});

  @override
  State<MedicationRecordScreen> createState() => _MedicationRecordScreenState();
}

class _MedicationRecordScreenState extends State<MedicationRecordScreen> {
  late bool _notTakingMedication;
  final Set<MedicationType> _selectedTypes = {};
  String _medicationName = '';
  String _dosage = '';
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _effectiveness = 6;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notTakingMedication = widget.initialNotTaking;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (!state.isLoading && _isLoading) {
          setState(() => _isLoading = false);
          state.successMessage.fold(
            () {},
            (message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
          state.failure.fold(
            () {},
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '약물 복용 기록',
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
              // 약물 복용 안함 토글
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _notTakingMedication
                      ? AppTheme.info.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _notTakingMedication
                        ? AppTheme.info
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _notTakingMedication
                          ? Icons.cancel_rounded
                          : Icons.medication_rounded,
                      color: _notTakingMedication
                          ? AppTheme.info
                          : AppTheme.medicationColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '오늘 약물 복용 안함',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _notTakingMedication
                                  ? AppTheme.info
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '약물을 복용하지 않은 날도 기록하세요',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notTakingMedication,
                      onChanged: (value) {
                        setState(() => _notTakingMedication = value);
                      },
                      activeColor: AppTheme.info,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 약물 복용하는 경우에만 입력 필드 표시
              if (!_notTakingMedication) ...[
                // 약물 종류 (중복 선택 가능)
                const Text(
                  '약물 종류',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '복용한 약물 종류를 모두 선택하세요',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              const SizedBox(height: 12),
              ...MedicationType.values.map((type) {
                final isSelected = _selectedTypes.contains(type);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTypes.remove(type);
                        } else {
                          _selectedTypes.add(type);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.medicationColor.withValues(alpha: 0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.medicationColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(type.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppTheme.medicationColor
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  type.examples.join(', '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.medicationColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // 약물 이름
              const Text(
                '약물 이름',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => _medicationName = v,
                decoration: InputDecoration(
                  hintText: '예: 오메프라졸',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppTheme.medicationColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 용량
              const Text(
                '용량',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => _dosage = v,
                decoration: InputDecoration(
                  hintText: '예: 20mg',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppTheme.medicationColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 복용 시간
              const Text(
                '복용 시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final time = await CustomTimePicker.show(
                    context: context,
                    initialTime: _selectedTime,
                    title: '복용 시간',
                    subtitle: '약물을 복용한 시간을 선택하세요',
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: AppTheme.medicationColor),
                      const SizedBox(width: 12),
                      Text(
                        _formatTime24(_selectedTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.textTertiary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 효과 평가
              const Text(
                '효과 평가 (선택)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  {'label': '좋음', 'value': 8, 'emoji': '😊'},
                  {'label': '보통', 'value': 5, 'emoji': '😐'},
                  {'label': '별로', 'value': 2, 'emoji': '😞'},
                ].map((effect) {
                  final isSelected = _effectiveness == effect['value'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _effectiveness = effect['value'] as int),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: effect['label'] != '별로' ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.medicationColor.withValues(alpha: 0.15)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.medicationColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              effect['emoji'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              effect['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppTheme.medicationColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              ],

              const SizedBox(height: 32),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_notTakingMedication ||
                          (_selectedTypes.isNotEmpty &&
                              _medicationName.isNotEmpty &&
                              _dosage.isNotEmpty)) &&
                      !_isLoading
                      ? _saveRecord
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _notTakingMedication
                        ? AppTheme.info
                        : AppTheme.medicationColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _notTakingMedication ? '복용 안함 기록' : '기록 저장',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecord() {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final recordedAt = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final record = MedicationRecord(
      id: _uuid.v4(),
      recordedAt: recordedAt,
      isTaken: !_notTakingMedication,
      medicationTypes:
          _notTakingMedication ? null : _selectedTypes.toList(),
      medicationName: _notTakingMedication ? null : _medicationName,
      dosage: _notTakingMedication ? null : _dosage,
      effectiveness: _notTakingMedication ? null : _effectiveness,
      createdAt: now,
    );

    // ignore: avoid_print
    print('[MedicationRecordScreen] Saving record: $record');

    context.read<RecordBloc>().add(RecordEvent.addMedicationRecord(record));
  }
}

// ============================================================
// 생활습관 기록 화면 (UPSERT 지원)
// ============================================================
class LifestyleRecordScreen extends StatefulWidget {
  const LifestyleRecordScreen({super.key});

  @override
  State<LifestyleRecordScreen> createState() => _LifestyleRecordScreenState();
}

class _LifestyleRecordScreenState extends State<LifestyleRecordScreen> {
  // 수면 관련
  double _sleepHours = 7;
  String _sleepPosition = 'back';
  bool _lateNightMeal = false;

  // 스트레스 관련
  int _stressLevel = 5;

  // 운동 관련
  bool _exercisedToday = false;

  bool _isLoading = false;
  bool _isDataLoaded = false;
  String? _existingRecordId;

  @override
  void initState() {
    super.initState();
    // 오늘의 생활습관 기록 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayRecord();
    });
  }

  @override
  void dispose() {
    // 화면 종료 시 현재 기록 초기화
    if (mounted) {
      context.read<RecordBloc>().add(const RecordEvent.clearCurrentRecord());
    }
    super.dispose();
  }

  /// 오늘의 생활습관 기록 조회 (통합 기록)
  void _loadTodayRecord() {
    _isDataLoaded = false;
    _existingRecordId = null;
    context.read<RecordBloc>().add(
          RecordEvent.loadLifestyleRecord(
            date: DateTime.now(),
            lifestyleType: LifestyleType.sleep, // 임시로 sleep 사용
          ),
        );
  }

  /// 기존 기록 데이터를 폼에 채우기 (모든 항목)
  void _populateFormWithExistingRecord(LifestyleRecord record) {
    if (_isDataLoaded) return;
    _isDataLoaded = true;
    _existingRecordId = record.id;

    setState(() {
      // 수면 정보
      final sleepHours = record.details['sleep_hours'] as num?;
      _sleepHours = sleepHours?.toDouble() ?? 7;
      _sleepPosition = record.details['sleep_position'] as String? ?? 'back';
      _lateNightMeal = record.details['late_night_meal'] as bool? ?? false;

      // 스트레스 정보
      final stressLevel = record.details['stress_level'] as num?;
      _stressLevel = stressLevel?.toInt() ?? 5;

      // 운동 정보
      _exercisedToday = record.details['exercised'] as bool? ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        // 기존 기록이 로드되면 폼에 채우기
        if (state.currentLifestyleRecord != null && !_isDataLoaded) {
          _populateFormWithExistingRecord(state.currentLifestyleRecord!);
        }

        if (!state.isLoading && _isLoading) {
          setState(() => _isLoading = false);
          state.successMessage.fold(
            () {},
            (message) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
          state.failure.fold(
            () {},
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }
      },
      child: BlocBuilder<RecordBloc, RecordState>(
        builder: (context, state) {
          final isEditMode = state.isEditMode;
          final isLoadingRecord = state.isLoading && !_isLoading;

          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isEditMode ? '생활습관 기록 수정' : '생활습관 기록',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              centerTitle: true,
            ),
            body: isLoadingRecord
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 수면 섹션
                        _buildSectionHeader('💤', '수면'),
                        const SizedBox(height: 16),
                        _buildSleepSection(),

                        const SizedBox(height: 32),

                        // 스트레스 섹션
                        _buildSectionHeader('😰', '스트레스'),
                        const SizedBox(height: 16),
                        _buildStressSection(),

                        const SizedBox(height: 32),

                        // 활동 섹션
                        _buildSectionHeader('🏃', '활동'),
                        const SizedBox(height: 16),
                        _buildActivitySection(),

                        const SizedBox(height: 32),

                        // 저장 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: !_isLoading ? _saveRecord : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.lifestyleColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditMode ? '기록 수정' : '기록 저장',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lifestyleColor.withValues(alpha: 0.3),
                  AppTheme.lifestyleColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '수면 시간',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bedtime_rounded,
                      color: AppTheme.lifestyleColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    '${_sleepHours.toStringAsFixed(1)}시간',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: _sleepHours,
                min: 0,
                max: 12,
                divisions: 24,
                activeColor: AppTheme.lifestyleColor,
                onChanged: (v) => setState(() => _sleepHours = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '수면 자세',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            {'label': '똑바로', 'value': 'back'},
            {'label': '옆으로(왼쪽)', 'value': 'left_side'},
            {'label': '옆으로(오른쪽)', 'value': 'right_side'},
            {'label': '엎드려', 'value': 'prone'},
          ].map((pos) {
            final isSelected = _sleepPosition == pos['value'];
            return GestureDetector(
              onTap: () => setState(() => _sleepPosition = pos['value']!),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lifestyleColor.withValues(alpha: 0.15)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.lifestyleColor : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  pos['label']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.lifestyleColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('🌙', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '야식을 먹었나요?',
                  style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                ),
              ),
              Switch(
                value: _lateNightMeal,
                onChanged: (v) => setState(() => _lateNightMeal = v),
                activeColor: AppTheme.lifestyleColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '스트레스 레벨',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                _stressLevel <= 3
                    ? '😌'
                    : _stressLevel <= 6
                        ? '😐'
                        : '😰',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                _stressLevel <= 3
                    ? '낮음'
                    : _stressLevel <= 6
                        ? '보통'
                        : '높음',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _stressLevel.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                activeColor: AppTheme.lifestyleColor,
                onChanged: (v) => setState(() => _stressLevel = v.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('낮음',
                      style:
                          TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  Text('보통',
                      style:
                          TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  Text('높음',
                      style:
                          TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InsightCard(
          icon: Icons.lightbulb_outline_rounded,
          title: '스트레스 관리 팁',
          message: '스트레스는 위산 분비를 증가시킬 수 있습니다. 심호흡, 명상, 가벼운 운동이 도움됩니다.',
          color: AppTheme.info,
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Text('🏃', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘 운동을 했나요?',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '30분 이상의 가벼운 운동도 포함됩니다',
                      style:
                          TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _exercisedToday,
                onChanged: (v) => setState(() => _exercisedToday = v),
                activeColor: AppTheme.lifestyleColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InsightCard(
          icon: Icons.directions_walk_rounded,
          title: '식후 활동 팁',
          message: '식사 직후 격렬한 운동은 피하고, 가벼운 산책은 소화에 도움이 됩니다.',
          color: AppTheme.success,
        ),
      ],
    );
  }

  void _saveRecord() {
    setState(() => _isLoading = true);

    final now = DateTime.now();

    // 모든 생활습관 정보를 하나의 details에 통합
    final details = {
      // 수면 정보
      'sleep_hours': _sleepHours,
      'sleep_position': _sleepPosition,
      'late_night_meal': _lateNightMeal,
      // 스트레스 정보
      'stress_level': _stressLevel,
      // 운동 정보
      'exercised': _exercisedToday,
    };

    // UPSERT: 기존 ID가 있으면 사용, 없으면 새 ID 생성
    final recordId = _existingRecordId ?? _uuid.v4();

    // lifestyleType은 sleep으로 통일 (통합 기록)
    final record = LifestyleRecord(
      id: recordId,
      recordedAt: now,
      lifestyleType: LifestyleType.sleep, // 통합 기록은 sleep으로 저장
      details: details,
      createdAt: now,
    );

    // ignore: avoid_print
    print('[LifestyleRecordScreen] Saving combined lifestyle record: $record');

    // UPSERT 사용 (오늘 날짜 기준 통합 기록 upsert)
    context.read<RecordBloc>().add(RecordEvent.upsertLifestyleRecord(record));
  }
}
