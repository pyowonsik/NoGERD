import 'package:injectable/injectable.dart';

/// Record Feature DI 모듈
///
/// Injectable을 사용하여 Record Feature의 의존성을 등록합니다.
@module
abstract class RecordModule {
  // Repository, UseCases, Bloc은 모두 @injectable/@lazySingleton으로
  // 자동 등록되므로 별도의 provider 메서드가 필요 없습니다.
}
