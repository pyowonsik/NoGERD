import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/record/domain/entities/symptom_record.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'symptom_record_model.freezed.dart';
part 'symptom_record_model.g.dart';

@freezed
class SymptomRecordModel with _$SymptomRecordModel {
  factory SymptomRecordModel.fromEntity(SymptomRecord entity, String userId) {
    return SymptomRecordModel(
      id: entity.id,
      userId: userId,
      recordedAt: entity.recordedAt,
      symptoms: entity.symptoms.map((s) => s.name).toList(),
      severity: entity.severity,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  const factory SymptomRecordModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'record_datetime') required DateTime recordedAt,
    required List<String> symptoms,
    required int severity,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? notes,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SymptomRecordModel;

  const SymptomRecordModel._();

  factory SymptomRecordModel.fromJson(Map<String, dynamic> json) =>
      _$SymptomRecordModelFromJson(json);

  SymptomRecord toEntity() {
    return SymptomRecord(
      id: id,
      recordedAt: recordedAt,
      symptoms: symptoms
          .map(
            (s) => GerdSymptom.values.firstWhere(
              (e) => e.name == s,
              orElse: () => GerdSymptom.heartburn,
            ),
          )
          .toList(),
      severity: severity,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
