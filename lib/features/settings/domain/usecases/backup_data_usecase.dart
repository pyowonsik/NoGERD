import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';

/// 데이터 백업 UseCase
@injectable
class BackupDataUseCase implements UseCase<Unit, NoParams> {
  /// 생성자
  const BackupDataUseCase();

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      // TODO: 클라우드 백업 구현 (Firebase, Google Drive 등)
      // 1. 모든 기록 데이터 수집
      // 2. JSON으로 직렬화
      // 3. 클라우드 스토리지에 업로드
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      return right(unit);
    } catch (e) {
      return left(Failure.unexpected('백업 실패: $e'));
    }
  }
}
