import 'package:hive/hive.dart';

import 'package:no_gerd/features/gerd_record/data/models/gerd_record_model.dart';

abstract class GerdRecordLocalDataSource {
  Future<void> addRecord(GerdRecordModel record);
  Future<List<GerdRecordModel>> getAllRecords();
  // Future<void> updateRecord(String key, GerdRecordModel updatedRecord);
  // Future<void> deleteRecord(String key);
}

class GerdRecordLocalDataSourceImpl implements GerdRecordLocalDataSource {
  final Box<GerdRecordModel> _box;

  GerdRecordLocalDataSourceImpl(this._box);

  @override
  Future<void> addRecord(GerdRecordModel record) async {
    await _box.put(record.date, record);
  }

  @override
  Future<List<GerdRecordModel>> getAllRecords() async {
    return _box.values.toList();
  }

  /** 추후 구현 로직 */
  // @override
  // Future<void> updateRecord(String key, GerdRecordModel updatedRecord) async {
  //   await _box.put(key, updatedRecord);
  // }

  // @override
  // Future<void> deleteRecord(String key) async {
  //   await _box.delete(key);
  // }
}
