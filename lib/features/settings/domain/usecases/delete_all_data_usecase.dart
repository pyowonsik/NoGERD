import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';

/// 모든 데이터 삭제 UseCase
@injectable
class DeleteAllDataUseCase implements UseCase<Unit, NoParams> {
  /// 생성자
  const DeleteAllDataUseCase();

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      // TODO: Hive 박스에서 모든 데이터 삭제
      // final recordBox = await Hive.openBox('records');
      // await recordBox.clear();
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      return right(unit);
    } catch (e) {
      return left(Failure.database('데이터 삭제 실패: $e'));
    }
  }
}
