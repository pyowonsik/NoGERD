import 'package:no_gerd/features/gerd_record/data/datasources/gerd_record_local_datasource.dart';
import 'package:no_gerd/features/gerd_record/data/models/gerd_record_model.dart';
import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/domain/repositories/gerd_record_repository.dart';

class GerdRecordRepositoryImpl implements GerdRecordRepository {
  final GerdRecordLocalDataSource localDataSource;

  GerdRecordRepositoryImpl(this.localDataSource);

  @override
  Future<void> addRecord(GerdRecord record) async {
    final model = GerdRecordModel.fromEntity(record);
    await localDataSource.addRecord(model);
  }

  @override
  Future<List<GerdRecord>> getAllRecords() async {
    final models = await localDataSource.getAllRecords();
    return models.map((m) => m.toEntity()).toList();
  }

  // @override
  // Future<void> updateRecord(String key, GerdRecord updatedRecord) async {
  //   final model = GerdRecordModel.fromEntity(updatedRecord);
  //   await localDataSource.updateRecord(key, model);
  // }

  // @override
  // Future<void> deleteRecord(String key) async {
  //   await localDataSource.deleteRecord(key);
  // }
}
