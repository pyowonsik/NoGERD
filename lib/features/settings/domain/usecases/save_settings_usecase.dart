import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 저장 UseCase
@injectable
class SaveSettingsUseCase implements UseCase<Unit, AppSettings> {
  /// 생성자
  const SaveSettingsUseCase();

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) async {
    try {
      // TODO: SharedPreferences 또는 Hive에 저장
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('daily_reminder', params.dailyReminderEnabled);
      // await prefs.setInt('reminder_hour', params.reminderTime.hour);
      // await prefs.setInt('reminder_minute', params.reminderTime.minute);
      // await prefs.setBool('medication_reminder', params.medicationReminderEnabled);
      // await prefs.setBool('dark_mode', params.darkModeEnabled);
      // await prefs.setString('language', params.languageCode);

      return right(unit);
    } catch (e) {
      return left(Failure.database('설정 저장 실패: $e'));
    }
  }
}
