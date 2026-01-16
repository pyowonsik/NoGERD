import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// 애플리케이션 실패(에러) 타입 정의
///
/// Either<Failure, T> 패턴으로 함수형 에러 처리에 사용됩니다.
/// KOBIC 아키텍처를 참고하여 다양한 실패 유형을 정의합니다.
@freezed
class Failure with _$Failure {
  /// 데이터베이스 관련 실패 (Hive 저장/조회 실패)
  const factory Failure.database(String message) = DatabaseFailure;

  /// 유효성 검사 실패 (입력값 검증 실패)
  const factory Failure.validation(String message) = ValidationFailure;

  /// 데이터 없음 (조회 결과 없음)
  const factory Failure.notFound(String message) = NotFoundFailure;

  /// 예상치 못한 오류
  const factory Failure.unexpected(String message) = UnexpectedFailure;

  /// 캐시 관련 실패
  const factory Failure.cache(String message) = CacheFailure;

  /// 권한 관련 실패 (알림 권한 등)
  const factory Failure.permission(String message) = PermissionFailure;

  /// 인증 실패 (로그인 필요)
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;

  /// 데이터 형식 오류
  const factory Failure.format(String message) = FormatFailure;
}

/// Failure 확장 메서드
extension FailureX on Failure {
  /// 사용자에게 보여줄 메시지 반환
  String get displayMessage {
    return when(
      database: (msg) => '데이터 저장 중 오류가 발생했습니다: $msg',
      validation: (msg) => msg,
      notFound: (msg) => msg,
      unexpected: (msg) => '예상치 못한 오류가 발생했습니다: $msg',
      cache: (msg) => '캐시 오류가 발생했습니다: $msg',
      permission: (msg) => '권한이 필요합니다: $msg',
      unauthorized: (msg) => msg,
      format: (msg) => '데이터 형식 오류: $msg',
    );
  }
}
