import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/domain/repositories/gerd_record_repository.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/usecase.dart';

class AddRecordParams {
  final GerdRecord record;

  const AddRecordParams(this.record);
}

class AddRecordUseCase implements UseCase<void, AddRecordParams> {
  final GerdRecordRepository repository;

  AddRecordUseCase(this.repository);

  @override
  Future<void> call(AddRecordParams params) async {
    await repository.addRecord(params.record);
  }
}
