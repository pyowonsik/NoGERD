import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/record/domain/entities/medication_record.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'medication_record_model.freezed.dart';
part 'medication_record_model.g.dart';

@freezed
class MedicationRecordModel with _$MedicationRecordModel {
  const factory MedicationRecordModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'record_datetime') required DateTime recordedAt,
    @JsonKey(name: 'is_taken') @Default(true) bool isTaken,
    @JsonKey(name: 'medication_types') List<String>? medicationTypes,
    @JsonKey(name: 'medication_name') String? medicationName,
    String? dosage,
    String? purpose,
    int? effectiveness,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MedicationRecordModel;

  const MedicationRecordModel._();

  factory MedicationRecordModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationRecordModelFromJson(json);

  MedicationRecord toEntity() {
    return MedicationRecord(
      id: id,
      recordedAt: recordedAt,
      isTaken: isTaken,
      medicationTypes: medicationTypes
          ?.map((typeString) => MedicationType.values.firstWhere(
                (e) => e.name == typeString,
                orElse: () => MedicationType.ppi,
              ))
          .toList(),
      medicationName: medicationName,
      dosage: dosage,
      purpose: purpose,
      effectiveness: effectiveness,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory MedicationRecordModel.fromEntity(
    MedicationRecord entity,
    String userId,
  ) {
    return MedicationRecordModel(
      id: entity.id,
      userId: userId,
      recordedAt: entity.recordedAt,
      isTaken: entity.isTaken,
      medicationTypes:
          entity.medicationTypes?.map((type) => type.name).toList(),
      medicationName: entity.medicationName,
      dosage: entity.dosage,
      purpose: entity.purpose,
      effectiveness: entity.effectiveness,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
