import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';

part 'gerd_record_model.g.dart';

@HiveType(typeId: 0)
class GerdRecordModel {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<String> symptoms;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String notes;

  GerdRecordModel({
    required this.date,
    required this.symptoms,
    required this.status,
    required this.notes,
  });

  /// Model → Entity
  GerdRecord toEntity() {
    return GerdRecord(
      date: date,
      symptoms: symptoms,
      status: status,
      notes: notes,
    );
  }

  /// Entity → Model
  factory GerdRecordModel.fromEntity(GerdRecord entity) {
    return GerdRecordModel(
      date: entity.date,
      symptoms: entity.symptoms,
      status: entity.status,
      notes: entity.notes,
    );
  }
}
