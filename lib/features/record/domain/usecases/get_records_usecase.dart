import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/record/domain/repositories/record_repository.dart';

/// 특정 날짜의 모든 기록 조회 UseCase
@injectable
class GetAllRecordsUseCase implements UseCase<Map<String, dynamic>, DateTime> {
  /// 생성자
  const GetAllRecordsUseCase(this._repository);

  final IRecordRepository _repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(DateTime params) {
    return _repository.getAllRecords(params);
  }
}
