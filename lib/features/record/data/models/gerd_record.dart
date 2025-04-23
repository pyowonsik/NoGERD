import 'package:hive/hive.dart';
import 'package:no_gerd/features/record/domain/entities/gerd_record.dart';

part 'gerd_record.g.dart';

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

  // GerdRecordModel을 GerdRecord로 변환
  GerdRecord toEntity() {
    return GerdRecord(
      date: date,
      symptoms: symptoms,
      status: status,
      notes: notes,
    );
  }

  // GerdRecord를 GerdRecordModel로 변환
  factory GerdRecordModel.fromEntity(GerdRecord entity) {
    return GerdRecordModel(
      date: entity.date,
      symptoms: entity.symptoms,
      status: entity.status,
      notes: entity.notes,
    );
  }
}
