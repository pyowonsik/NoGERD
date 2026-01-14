import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 로드 UseCase
@injectable
class LoadSettingsUseCase implements UseCase<AppSettings, NoParams> {
  /// 생성자
  const LoadSettingsUseCase();

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    try {
      // TODO: SharedPreferences 또는 Hive에서 로드
      // final prefs = await SharedPreferences.getInstance();
      // final dailyReminder = prefs.getBool('daily_reminder') ?? true;
      // final hour = prefs.getInt('reminder_hour') ?? 21;
      // final minute = prefs.getInt('reminder_minute') ?? 0;
      // final medicationReminder = prefs.getBool('medication_reminder') ?? true;
      // final darkMode = prefs.getBool('dark_mode') ?? false;
      // final language = prefs.getString('language') ?? 'ko';

      // 지금은 초기값 반환
      return right(AppSettings.initial());
    } catch (e) {
      return left(Failure.database('설정 로드 실패: $e'));
    }
  }
}
