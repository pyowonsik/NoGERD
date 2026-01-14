import 'package:injectable/injectable.dart';

/// Calendar Feature DI 모듈
///
/// Injectable을 사용하여 Calendar Feature의 의존성을 등록합니다.
@module
abstract class CalendarModule {
  // UseCase와 Bloc은 모두 @injectable로 자동 등록되므로
  // 별도의 provider 메서드가 필요 없습니다.
}
