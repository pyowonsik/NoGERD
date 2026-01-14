import 'package:injectable/injectable.dart';

/// Insights Feature DI 모듈
///
/// Injectable을 사용하여 Insights Feature의 의존성을 등록합니다.
@module
abstract class InsightsModule {
  // UseCase와 Bloc은 모두 @injectable로 자동 등록되므로
  // 별도의 provider 메서드가 필요 없습니다.
}
