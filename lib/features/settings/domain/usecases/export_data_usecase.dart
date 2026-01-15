import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';

/// 데이터 내보내기 UseCase
@injectable
class ExportDataUseCase implements UseCase<String, NoParams> {
  /// 생성자
  const ExportDataUseCase();

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      // TODO: CSV 파일 생성 구현
      // 1. 모든 기록 데이터 수집
      // 2. CSV 형식으로 변환
      // 3. 파일 시스템에 저장
      // 4. 파일 경로 반환
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      return right('/storage/emulated/0/Download/nogerd_data.csv');
    } catch (e) {
      return left(Failure.unexpected('내보내기 실패: $e'));
    }
  }
}
