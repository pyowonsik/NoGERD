import 'package:freezed_annotation/freezed_annotation.dart';

part 'gerd_record.freezed.dart';
part 'gerd_record.g.dart';

@freezed
class GerdRecord with _$GerdRecord {
  const factory GerdRecord({
    required String date,
    required List<String> symptoms,
    required String status,
    required String notes,
  }) = _GerdRecord;

  factory GerdRecord.fromJson(Map<String, dynamic> json) =>
      _$GerdRecordFromJson(json);
}
