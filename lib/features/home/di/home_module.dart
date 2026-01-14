import 'package:injectable/injectable.dart';

/// Home Feature DI 모듈
///
/// Injectable을 사용하여 Home Feature의 의존성을 등록합니다.
@module
abstract class HomeModule {
  // 현재는 HomeBloc만 @injectable로 등록되어 있으므로
  // 별도의 provider 메서드가 필요 없습니다.

  // 향후 UseCase나 Repository가 추가되면 여기에 등록합니다.
  // @lazySingleton
  // IHomeRepository get homeRepository => HomeRepository();
}
