import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';

/// 기본 UseCase 인터페이스
///
/// Clean Architecture의 UseCase 패턴을 구현합니다.
/// 모든 UseCase는 이 인터페이스를 구현해야 합니다.
///
/// [T] - 반환 타입
/// [Params] - 파라미터 타입
abstract class UseCase<T, Params> {
  /// UseCase 실행
  ///
  /// [params] - UseCase 실행에 필요한 파라미터
  /// Returns: Either<Failure, T> - 실패 또는 성공 결과
  Future<Either<Failure, T>> call(Params params);
}

/// 파라미터가 없는 UseCase용
///
/// 파라미터가 필요 없는 UseCase에서 사용합니다.
/// ```dart
/// class GetAllRecordsUseCase extends UseCase<List<Record>, NoParams> {
///   @override
///   Future<Either<Failure, List<Record>>> call(NoParams params) async {
///     return repository.getAllRecords();
///   }
/// }
/// ```
class NoParams extends Equatable {
  /// 생성자
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// ID 파라미터
///
/// 단일 ID를 필요로 하는 UseCase에서 사용합니다.
class IdParams extends Equatable {
  /// 생성자
  const IdParams(this.id);

  /// ID 값
  final String id;

  @override
  List<Object?> get props => [id];
}

/// 날짜 파라미터
///
/// 날짜를 필요로 하는 UseCase에서 사용합니다.
class DateParams extends Equatable {
  /// 생성자
  const DateParams(this.date);

  /// 날짜
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

/// 날짜 범위 파라미터
///
/// 시작일과 종료일을 필요로 하는 UseCase에서 사용합니다.
class DateRangeParams extends Equatable {
  /// 생성자
  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  /// 시작 날짜
  final DateTime startDate;

  /// 종료 날짜
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

/// 페이지네이션 파라미터
///
/// 페이지네이션이 필요한 UseCase에서 사용합니다.
class PaginationParams extends Equatable {
  /// 생성자
  const PaginationParams({
    this.page = 0,
    this.limit = 20,
  });

  /// 페이지 번호 (0부터 시작)
  final int page;

  /// 페이지당 아이템 수
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}
