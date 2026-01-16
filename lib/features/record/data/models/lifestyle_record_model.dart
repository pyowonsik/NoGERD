import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:no_gerd/features/record/domain/entities/lifestyle_record.dart';
import 'package:no_gerd/shared/constants/gerd_constants.dart';

part 'lifestyle_record_model.freezed.dart';
part 'lifestyle_record_model.g.dart';

@freezed
class LifestyleRecordModel with _$LifestyleRecordModel {
  factory LifestyleRecordModel.fromEntity(
    LifestyleRecord entity,
    String userId,
  ) {
    return LifestyleRecordModel(
      id: entity.id,
      userId: userId,
      recordedAt: entity.recordedAt,
      lifestyleType: entity.lifestyleType.name,
      details: entity.details,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
  const factory LifestyleRecordModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'record_datetime') required DateTime recordedAt,
    @JsonKey(name: 'lifestyle_type') required String lifestyleType,
    required Map<String, dynamic> details,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? notes,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LifestyleRecordModel;

  const LifestyleRecordModel._();

  factory LifestyleRecordModel.fromJson(Map<String, dynamic> json) =>
      _$LifestyleRecordModelFromJson(json);

  LifestyleRecord toEntity() {
    return LifestyleRecord(
      id: id,
      recordedAt: recordedAt,
      lifestyleType: LifestyleType.values.firstWhere(
        (e) => e.name == lifestyleType,
        orElse: () => LifestyleType.sleep,
      ),
      details: details,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
