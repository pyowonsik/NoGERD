import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';

abstract class GerdRecordRepository {
  Future<void> addRecord(GerdRecord record);
  Future<List<GerdRecord>> getAllRecords();
  Future<void> updateRecord(String key, GerdRecord updatedRecord);
  Future<void> deleteRecord(String key);
}
