import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_gerd/core/di/injection.config.dart';

/// 전역 GetIt 인스턴스
final getIt = GetIt.instance;

/// 의존성 주입 초기화
///
/// Injectable을 사용하여 자동으로 의존성을 등록합니다.
/// 앱 시작 시 main()에서 호출해야 합니다.
@InjectableInit(
  preferRelativeImports: true,
)
Future<void> configureDependencies() async => getIt.init();

/// Core Module - SharedPreferences 등록
@module
abstract class CoreModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
