import 'package:flutter/material.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/features/record/domain/entities/meal_record.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/shared/shared.dart';
import 'package:intl/intl.dart';

/// 기록 상세 보기 화면 (읽기 전용)
class RecordDetailPage extends StatelessWidget {
  /// 생성자
  const RecordDetailPage({super.key, required this.record});

  /// 기록 데이터
  final dynamic record;

  @override
  Widget build(BuildContext context) {
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
          _getTitle(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildContent(context),
      ),
    );
  }

  String _getTitle() {
    if (record is SymptomRecord) return '증상 기록 상세';
    if (record is MealRecord) return '식사 기록 상세';
    if (record is MedicationRecord) return '약물 기록 상세';
    if (record is LifestyleRecord) return '생활습관 기록 상세';
    return '기록 상세';
  }

  Widget _buildContent(BuildContext context) {
    if (record is SymptomRecord) {
      return _buildSymptomDetail(record as SymptomRecord);
    } else if (record is MealRecord) {
      return _buildMealDetail(record as MealRecord);
    } else if (record is MedicationRecord) {
      return _buildMedicationDetail(record as MedicationRecord);
    } else if (record is LifestyleRecord) {
      return _buildLifestyleDetail(record as LifestyleRecord);
    }
    return const Text('알 수 없는 기록 타입');
  }

  // 증상 기록 상세
  Widget _buildSymptomDetail(SymptomRecord record) {
    Color severityColor;
    String severityLabel;
    if (record.severity <= 3) {
      severityColor = AppTheme.success;
      severityLabel = '약함';
    } else if (record.severity <= 6) {
      severityColor = AppTheme.warning;
      severityLabel = '보통';
    } else {
      severityColor = AppTheme.error;
      severityLabel = '심함';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기록 시간
        _buildInfoCard(
          icon: Icons.access_time_rounded,
          title: '발생 시간',
          content: DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.recordedAt),
          color: AppTheme.symptomColor,
        ),
        const SizedBox(height: 16),

        // 증상
        const Text(
          '증상',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: record.symptoms.map((symptom) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.symptomColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.symptomColor, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(symptom.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    symptom.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.symptomColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // 강도
        const Text(
          '증상 강도',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: severityColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${record.severity}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                severityLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: severityColor,
                ),
              ),
            ],
          ),
        ),

        // 메모
        if (record.notes != null) ...[
          const SizedBox(height: 20),
          const Text(
            '메모',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              record.notes!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // 식사 기록 상세
  Widget _buildMealDetail(MealRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 식사 종류 및 시간
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mealColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                record.mealType.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.mealType.label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mealColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy년 MM월 dd일 HH:mm')
                          .format(record.recordedAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 먹은 음식
        const Text(
          '먹은 음식',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: record.foods.map((food) {
            return Chip(
              label: Text(food),
              backgroundColor: AppTheme.mealColor.withValues(alpha: 0.1),
              side: BorderSide.none,
            );
          }).toList(),
        ),

        // 트리거 음식
        if (record.triggerCategories != null &&
            record.triggerCategories!.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            '트리거 음식',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: record.triggerCategories!.map((trigger) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.warning, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trigger.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      trigger.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warning,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // 약물 기록 상세
  Widget _buildMedicationDetail(MedicationRecord record) {
    if (!record.isTaken) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.cancel_rounded,
                  size: 64,
                  color: AppTheme.info,
                ),
                const SizedBox(height: 16),
                const Text(
                  '약물 복용 안함',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.info,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(record.recordedAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 복용 시간
        _buildInfoCard(
          icon: Icons.access_time_rounded,
          title: '복용 시간',
          content: DateFormat('yyyy년 MM월 dd일 HH:mm').format(record.recordedAt),
          color: AppTheme.medicationColor,
        ),
        const SizedBox(height: 16),

        // 약물 종류
        if (record.medicationTypes != null &&
            record.medicationTypes!.isNotEmpty) ...[
          const Text(
            '약물 종류',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: record.medicationTypes!.map((type) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.medicationColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.medicationColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      type.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.medicationColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // 약물 이름
        if (record.medicationName != null) ...[
          _buildInfoCard(
            icon: Icons.local_pharmacy_rounded,
            title: '약물 이름',
            content: record.medicationName!,
            color: AppTheme.medicationColor,
          ),
          const SizedBox(height: 16),
        ],

        // 용량
        if (record.dosage != null) ...[
          _buildInfoCard(
            icon: Icons.science_rounded,
            title: '용량',
            content: record.dosage!,
            color: AppTheme.medicationColor,
          ),
          const SizedBox(height: 16),
        ],

        // 효과
        if (record.effectiveness != null) ...[
          const Text(
            '효과 평가',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(
                  record.effectiveness! >= 7
                      ? '😊'
                      : record.effectiveness! >= 4
                          ? '😐'
                          : '😞',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Text(
                  record.effectiveness! >= 7
                      ? '좋음'
                      : record.effectiveness! >= 4
                          ? '보통'
                          : '별로',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // 생활습관 기록 상세
  Widget _buildLifestyleDetail(LifestyleRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기록 시간
        _buildInfoCard(
          icon: Icons.access_time_rounded,
          title: '기록 시간',
          content: DateFormat('yyyy년 MM월 dd일').format(record.recordedAt),
          color: AppTheme.lifestyleColor,
        ),
        const SizedBox(height: 24),

        // 수면 섹션
        _buildLifestyleSectionHeader('💤', '수면'),
        const SizedBox(height: 12),
        _buildLifestyleInfoBox([
          if (record.details['sleep_hours'] != null)
            _buildLifestyleInfoItem(
              '수면 시간',
              '${(record.details['sleep_hours'] as num).toStringAsFixed(1)}시간',
            ),
          if (record.details['sleep_position'] != null)
            _buildLifestyleInfoItem(
              '수면 자세',
              _formatValue(record.details['sleep_position']),
            ),
          if (record.details['late_night_meal'] != null)
            _buildLifestyleInfoItem(
              '야식',
              _formatValue(record.details['late_night_meal']),
            ),
        ]),
        const SizedBox(height: 20),

        // 스트레스 섹션
        _buildLifestyleSectionHeader('😰', '스트레스'),
        const SizedBox(height: 12),
        _buildLifestyleInfoBox([
          if (record.details['stress_level'] != null)
            _buildLifestyleInfoItem(
              '스트레스 레벨',
              '${record.details['stress_level']}/10',
            ),
        ]),
        const SizedBox(height: 20),

        // 활동 섹션
        _buildLifestyleSectionHeader('🏃', '활동'),
        const SizedBox(height: 12),
        _buildLifestyleInfoBox([
          if (record.details['exercised'] != null)
            _buildLifestyleInfoItem(
              '운동 여부',
              _formatValue(record.details['exercised']),
            ),
        ]),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLifestyleSectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLifestyleInfoBox(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLifestyleInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 정보 카드 위젯
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    switch (key) {
      case 'sleep_hours':
        return '수면 시간';
      case 'sleep_position':
        return '수면 자세';
      case 'late_night_meal':
        return '야식';
      case 'stress_level':
        return '스트레스 레벨';
      case 'exercised':
        return '운동 여부';
      default:
        return key;
    }
  }

  String _formatValue(dynamic value) {
    if (value is bool) {
      return value ? '예' : '아니오';
    }
    if (value is num) {
      return value.toString();
    }
    return value.toString();
  }
}
