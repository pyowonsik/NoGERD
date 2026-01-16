import 'package:fpdart/fpdart.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

/// 설정 Repository 인터페이스
abstract class SettingsRepository {
  /// 설정 로드
  Future<Either<Failure, AppSettings>> loadSettings();

  /// 설정 저장
  Future<Either<Failure, Unit>> saveSettings(AppSettings settings);

  /// 데이터 내보내기 (CSV)
  Future<Either<Failure, String>> exportData();

  /// 전체 데이터 삭제
  Future<Either<Failure, Unit>> deleteAllData();
}
