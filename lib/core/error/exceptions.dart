/// 애플리케이션 예외 타입 정의
///
/// Data Layer에서 발생하는 예외들을 정의합니다.
/// Repository에서 이 예외들을 catch하여 Failure로 변환합니다.
library;

/// 기본 앱 예외
abstract class AppException implements Exception {
  const AppException(this.message, [this.cause]);
  final String message;
  final dynamic cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// 데이터베이스 예외 (Hive 관련)
class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.cause]);
}

/// 캐시 예외
class CacheException extends AppException {
  const CacheException(super.message, [super.cause]);
}

/// 데이터 없음 예외
class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.cause]);
}

/// 유효성 검사 예외
class ValidationException extends AppException {
  const ValidationException(super.message, [super.cause]);
}

/// 권한 예외
class PermissionException extends AppException {
  const PermissionException(super.message, [super.cause]);
}

/// 데이터 형식 예외
class FormatException extends AppException {
  const FormatException(super.message, [super.cause]);
}
