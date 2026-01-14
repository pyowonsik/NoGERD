// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/calendar/domain/usecases/get_records_for_month_usecase.dart'
    as _i86;
import '../../features/calendar/presentation/bloc/calendar_bloc.dart' as _i1021;
import '../../features/home/presentation/bloc/home_bloc.dart' as _i202;
import '../../features/insights/domain/usecases/analyze_triggers_usecase.dart'
    as _i152;
import '../../features/insights/domain/usecases/calculate_health_score_usecase.dart'
    as _i382;
import '../../features/insights/domain/usecases/get_symptom_trends_usecase.dart'
    as _i106;
import '../../features/insights/domain/usecases/get_weekly_pattern_usecase.dart'
    as _i1039;
import '../../features/insights/presentation/bloc/insights_bloc.dart' as _i658;
import '../../features/record/data/repositories/record_repository_impl.dart'
    as _i670;
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
import '../../features/record/domain/usecases/get_records_usecase.dart'
    as _i580;
import '../../features/record/presentation/bloc/record_bloc.dart' as _i7;
import '../../features/settings/domain/usecases/backup_data_usecase.dart'
    as _i597;
import '../../features/settings/domain/usecases/delete_all_data_usecase.dart'
    as _i885;
import '../../features/settings/domain/usecases/export_data_usecase.dart'
    as _i142;
import '../../features/settings/domain/usecases/load_settings_usecase.dart'
    as _i42;
import '../../features/settings/domain/usecases/save_settings_usecase.dart'
    as _i109;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i202.HomeBloc>(() => _i202.HomeBloc());
    gh.factory<_i885.DeleteAllDataUseCase>(
        () => const _i885.DeleteAllDataUseCase());
    gh.factory<_i109.SaveSettingsUseCase>(
        () => const _i109.SaveSettingsUseCase());
    gh.factory<_i42.LoadSettingsUseCase>(
        () => const _i42.LoadSettingsUseCase());
    gh.factory<_i142.ExportDataUseCase>(() => const _i142.ExportDataUseCase());
    gh.factory<_i597.BackupDataUseCase>(() => const _i597.BackupDataUseCase());
    gh.factory<_i585.SettingsBloc>(() => _i585.SettingsBloc());
    gh.lazySingleton<_i968.IRecordRepository>(
        () => _i670.RecordRepositoryImpl());
    gh.factory<_i580.GetAllRecordsUseCase>(
        () => _i580.GetAllRecordsUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i857.AddSymptomRecordUseCase>(
        () => _i857.AddSymptomRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i675.AddMealRecordUseCase>(
        () => _i675.AddMealRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i893.AddMedicationRecordUseCase>(
        () => _i893.AddMedicationRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i680.AddLifestyleRecordUseCase>(
        () => _i680.AddLifestyleRecordUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i86.GetRecordsForMonthUseCase>(
        () => _i86.GetRecordsForMonthUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i152.AnalyzeTriggersUseCase>(
        () => _i152.AnalyzeTriggersUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i106.GetSymptomTrendsUseCase>(
        () => _i106.GetSymptomTrendsUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i1039.GetWeeklyPatternUseCase>(
        () => _i1039.GetWeeklyPatternUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i382.CalculateHealthScoreUseCase>(
        () => _i382.CalculateHealthScoreUseCase(gh<_i968.IRecordRepository>()));
    gh.factory<_i7.RecordBloc>(() => _i7.RecordBloc(
          gh<_i857.AddSymptomRecordUseCase>(),
          gh<_i675.AddMealRecordUseCase>(),
          gh<_i893.AddMedicationRecordUseCase>(),
          gh<_i680.AddLifestyleRecordUseCase>(),
          gh<_i580.GetAllRecordsUseCase>(),
        ));
    gh.factory<_i1021.CalendarBloc>(
        () => _i1021.CalendarBloc(gh<_i86.GetRecordsForMonthUseCase>()));
    gh.factory<_i658.InsightsBloc>(() => _i658.InsightsBloc(
          gh<_i382.CalculateHealthScoreUseCase>(),
          gh<_i152.AnalyzeTriggersUseCase>(),
          gh<_i106.GetSymptomTrendsUseCase>(),
          gh<_i1039.GetWeeklyPatternUseCase>(),
        ));
    return this;
  }
}
