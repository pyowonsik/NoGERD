// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/sign_in_usecase.dart' as _i259;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/domain/usecases/sign_up_usecase.dart' as _i860;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/calendar/domain/usecases/get_records_for_month_usecase.dart'
    as _i86;
import '../../features/calendar/presentation/bloc/calendar_bloc.dart' as _i1021;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/insights/data/datasources/ai_remote_datasource.dart'
    as _i1069;
import '../../features/insights/domain/usecases/analyze_triggers_usecase.dart'
    as _i152;
import '../../features/insights/domain/usecases/calculate_health_score_usecase.dart'
    as _i382;
import '../../features/insights/domain/usecases/get_ai_insights_usecase.dart'
    as _i65;
import '../../features/insights/domain/usecases/get_lifestyle_impact_usecase.dart'
    as _i588;
import '../../features/insights/domain/usecases/get_meal_symptom_correlation_usecase.dart'
    as _i102;
import '../../features/insights/domain/usecases/get_symptom_distribution_usecase.dart'
    as _i84;
import '../../features/insights/domain/usecases/get_symptom_trends_usecase.dart'
    as _i106;
import '../../features/insights/domain/usecases/get_weekly_pattern_usecase.dart'
    as _i1039;
import '../../features/insights/presentation/bloc/insights_bloc.dart' as _i658;
import '../../features/record/data/datasources/record_remote_datasource.dart'
    as _i1004;
import '../../features/record/data/datasources/supabase_record_datasource.dart'
    as _i865;
import '../../features/record/data/repositories/supabase_record_repository_impl.dart'
    as _i982;
import '../../features/record/domain/repositories/record_repository.dart'
    as _i968;
import '../../features/record/domain/usecases/add_lifestyle_record_usecase.dart'
    as _i680;
import '../../features/record/domain/usecases/add_meal_record_usecase.dart'
    as _i675;
import '../../features/record/domain/usecases/add_medication_record_usecase.dart'
    as _i893;
import '../../features/record/domain/usecases/add_symptom_record_usecase.dart'
    as _i857;
import '../../features/record/domain/usecases/get_lifestyle_record_by_date_type_usecase.dart'
    as _i373;
import '../../features/record/domain/usecases/get_meal_record_by_date_type_usecase.dart'
    as _i374;
import '../../features/record/domain/usecases/get_records_usecase.dart'
    as _i580;
import '../../features/record/domain/usecases/upsert_lifestyle_record_usecase.dart'
    as _i146;
import '../../features/record/domain/usecases/upsert_meal_record_usecase.dart'
    as _i674;
import '../../features/record/presentation/bloc/record_bloc.dart' as _i7;
import '../../features/settings/data/datasources/alarm_local_datasource.dart'
    as _i852;
import '../../features/settings/data/datasources/alarm_platform_datasource.dart'
    as _i92;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/alarm_repository_impl.dart'
    as _i282;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/alarm_repository.dart'
    as _i1003;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/cancel_alarm_usecase.dart'
    as _i1045;
import '../../features/settings/domain/usecases/delete_all_data_usecase.dart'
    as _i885;
import '../../features/settings/domain/usecases/export_data_usecase.dart'
    as _i142;
import '../../features/settings/domain/usecases/get_alarm_configs_usecase.dart'
    as _i123;
import '../../features/settings/domain/usecases/load_settings_usecase.dart'
    as _i42;
import '../../features/settings/domain/usecases/save_settings_usecase.dart'
    as _i109;
import '../../features/settings/domain/usecases/schedule_alarm_usecase.dart'
    as _i57;
import '../../features/settings/presentation/bloc/alarm_bloc.dart' as _i528;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import 'injection.dart' as _i464;
import 'supabase_module.dart' as _i695;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final coreModule = _$CoreModule();
    final supabaseModule = _$SupabaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i1069.AIRemoteDataSource>(
        () => _i1069.AIRemoteDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
        () => _i599.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.SupabaseAuthDataSource(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i92.AlarmPlatformDataSource>(
        () => const _i92.AlarmPlatformDataSourceImpl());
    gh.factory<_i65.GetAIInsightsUseCase>(
        () => _i65.GetAIInsightsUseCase(gh<_i1069.AIRemoteDataSource>()));
    gh.lazySingleton<_i852.AlarmLocalDataSource>(
        () => _i852.AlarmLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i1004.RecordRemoteDataSource>(
        () => _i865.SupabaseRecordDataSource(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i787.IAuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i161.AuthRemoteDataSource>()));
    gh.lazySingleton<_i1003.AlarmRepository>(() => _i282.AlarmRepositoryImpl(
          gh<_i92.AlarmPlatformDataSource>(),
          gh<_i852.AlarmLocalDataSource>(),
        ));
    gh.lazySingleton<_i968.IRecordRepository>(
        () => _i982.SupabaseRecordRepositoryImpl(
              gh<_i1004.RecordRemoteDataSource>(),
              gh<_i454.SupabaseClient>(),
            ));
    gh.lazySingleton<_i674.SettingsRepository>(
        () => _i955.SettingsRepositoryImpl(
              gh<_i599.SettingsLocalDataSource>(),
              gh<_i454.SupabaseClient>(),
            ));
    gh.factory<_i885.DeleteAllDataUseCase>(
        () => _i885.DeleteAllDataUseCase(gh<_i674.SettingsRepository>()));
    gh.factory<_i109.SaveSettingsUseCase>(
        () => _i109.SaveSettingsUseCase(gh<_i674.SettingsRepository>()));
    gh.factory<_i42.LoadSettingsUseCase>(
        () => _i42.LoadSettingsUseCase(gh<_i674.SettingsRepository>()));
    gh.factory<_i142.ExportDataUseCase>(
        () => _i142.ExportDataUseCase(gh<_i674.SettingsRepository>()));
    gh.factory<_i259.SignInUseCase>(
        () => _i259.SignInUseCase(gh<_i787.IAuthRepository>()));
    gh.factory<_i860.SignUpUseCase>(
        () => _i860.SignUpUseCase(gh<_i787.IAuthRepository>()));
    gh.factory<_i17.GetCurrentUserUseCase>(
        () => _i17.GetCurrentUserUseCase(gh<_i787.IAuthRepository>()));
    gh.factory<_i915.SignOutUseCase>(
        () => _i915.SignOutUseCase(gh<_i787.IAuthRepository>()));
    gh.factory<_i588.GetLifestyleImpactUseCase>(
        () => _i588.GetLifestyleImpactUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i84.GetSymptomDistributionUseCase>(() =>
        _i84.GetSymptomDistributionUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i152.AnalyzeTriggersUseCase>(
        () => _i152.AnalyzeTriggersUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i106.GetSymptomTrendsUseCase>(
        () => _i106.GetSymptomTrendsUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i102.GetMealSymptomCorrelationUseCase>(() =>
        _i102.GetMealSymptomCorrelationUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i1039.GetWeeklyPatternUseCase>(
        () => _i1039.GetWeeklyPatternUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i382.CalculateHealthScoreUseCase>(
        () => _i382.CalculateHealthScoreUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i86.GetRecordsForMonthUseCase>(
        () => _i86.GetRecordsForMonthUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i580.GetAllRecordsUseCase>(
        () => _i580.GetAllRecordsUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i674.UpsertMealRecordUseCase>(
        () => _i674.UpsertMealRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i857.AddSymptomRecordUseCase>(
        () => _i857.AddSymptomRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i675.AddMealRecordUseCase>(
        () => _i675.AddMealRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i893.AddMedicationRecordUseCase>(
        () => _i893.AddMedicationRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i146.UpsertLifestyleRecordUseCase>(() =>
        _i146.UpsertLifestyleRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i373.GetLifestyleRecordByDateAndTypeUseCase>(() =>
        _i373.GetLifestyleRecordByDateAndTypeUseCase(
            gh<_i968.IRecordRepository>()));
    gh.factory<_i374.GetMealRecordByDateAndTypeUseCase>(() =>
        _i374.GetMealRecordByDateAndTypeUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i680.AddLifestyleRecordUseCase>(
        () => _i680.AddLifestyleRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i57.ScheduleAlarmUseCase>(
        () => _i57.ScheduleAlarmUseCase(gh<_i1003.AlarmRepository>()));
    gh.factory<_i123.GetAlarmConfigsUseCase>(
        () => _i123.GetAlarmConfigsUseCase(gh<_i1003.AlarmRepository>()));
    gh.factory<_i1045.CancelAlarmUseCase>(
        () => _i1045.CancelAlarmUseCase(gh<_i1003.AlarmRepository>()));
    gh.factory<_i585.SettingsBloc>(() => _i585.SettingsBloc(
          gh<_i42.LoadSettingsUseCase>(),
          gh<_i142.ExportDataUseCase>(),
          gh<_i885.DeleteAllDataUseCase>(),
        ));
    gh.factory<_i528.AlarmBloc>(() => _i528.AlarmBloc(
          gh<_i123.GetAlarmConfigsUseCase>(),
          gh<_i57.ScheduleAlarmUseCase>(),
          gh<_i1045.CancelAlarmUseCase>(),
          gh<_i1003.AlarmRepository>(),
        ));
    gh.factory<_i7.RecordBloc>(() => _i7.RecordBloc(
          gh<_i857.AddSymptomRecordUseCase>(),
          gh<_i675.AddMealRecordUseCase>(),
          gh<_i893.AddMedicationRecordUseCase>(),
          gh<_i680.AddLifestyleRecordUseCase>(),
          gh<_i580.GetAllRecordsUseCase>(),
          gh<_i374.GetMealRecordByDateAndTypeUseCase>(),
          gh<_i674.UpsertMealRecordUseCase>(),
          gh<_i373.GetLifestyleRecordByDateAndTypeUseCase>(),
          gh<_i146.UpsertLifestyleRecordUseCase>(),
        ));
    gh.factory<_i202.HomeBloc>(
        () => _i202.HomeBloc(gh<_i968.IRecordRepository>()));
    gh.singleton<_i797.AuthBloc>(() => _i797.AuthBloc(
          gh<_i259.SignInUseCase>(),
          gh<_i860.SignUpUseCase>(),
          gh<_i915.SignOutUseCase>(),
          gh<_i17.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i658.InsightsBloc>(() => _i658.InsightsBloc(
          gh<_i382.CalculateHealthScoreUseCase>(),
          gh<_i152.AnalyzeTriggersUseCase>(),
          gh<_i106.GetSymptomTrendsUseCase>(),
          gh<_i1039.GetWeeklyPatternUseCase>(),
          gh<_i84.GetSymptomDistributionUseCase>(),
          gh<_i102.GetMealSymptomCorrelationUseCase>(),
          gh<_i588.GetLifestyleImpactUseCase>(),
          gh<_i65.GetAIInsightsUseCase>(),
        ));
    gh.factory<_i1021.CalendarBloc>(
        () => _i1021.CalendarBloc(gh<_i86.GetRecordsForMonthUseCase>()));
    return this;
  }
}

class _$CoreModule extends _i464.CoreModule {}

class _$SupabaseModule extends _i695.SupabaseModule {}
