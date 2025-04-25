import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/domain/repositories/gerd_record_repository.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/usecase.dart';

class GetAllRecordsUseCase implements UseCase<List<GerdRecord>, NoParams> {
  final GerdRecordRepository repository;

  GetAllRecordsUseCase(this.repository);

  @override
  Future<List<GerdRecord>> call(NoParams params) async {
    return await repository.getAllRecords();
  }
}
