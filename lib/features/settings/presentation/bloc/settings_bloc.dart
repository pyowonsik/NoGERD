import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

/// Settings BLoC
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// 생성자
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsEventLoadSettings>(_onLoadSettings);
    on<SettingsEventUpdateDailyReminder>(_onUpdateDailyReminder);
    on<SettingsEventUpdateReminderTime>(_onUpdateReminderTime);
    on<SettingsEventUpdateMedicationReminder>(_onUpdateMedicationReminder);
    on<SettingsEventUpdateDarkMode>(_onUpdateDarkMode);
    on<SettingsEventUpdateLanguage>(_onUpdateLanguage);
    on<SettingsEventBackupData>(_onBackupData);
    on<SettingsEventExportData>(_onExportData);
    on<SettingsEventDeleteAllData>(_onDeleteAllData);
  }

  Future<void> _onLoadSettings(
    SettingsEventLoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // TODO: SharedPreferences 또는 Hive에서 설정 로드
    // 지금은 초기값 사용
    final settings = AppSettings.initial();

    emit(state.copyWith(
      isLoading: false,
      settings: settings,
    ));
  }

  Future<void> _onUpdateDailyReminder(
    SettingsEventUpdateDailyReminder event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      dailyReminderEnabled: event.enabled,
    );

    emit(state.copyWith(settings: updatedSettings));

    // TODO: SharedPreferences에 저장
  }

  Future<void> _onUpdateReminderTime(
    SettingsEventUpdateReminderTime event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      reminderTime: event.time,
    );

    emit(state.copyWith(settings: updatedSettings));

    // TODO: SharedPreferences에 저장
  }

  Future<void> _onUpdateMedicationReminder(
    SettingsEventUpdateMedicationReminder event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      medicationReminderEnabled: event.enabled,
    );

    emit(state.copyWith(settings: updatedSettings));

    // TODO: SharedPreferences에 저장
  }

  Future<void> _onUpdateDarkMode(
    SettingsEventUpdateDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      darkModeEnabled: event.enabled,
    );

    emit(state.copyWith(settings: updatedSettings));

    // TODO: SharedPreferences에 저장
  }

  Future<void> _onUpdateLanguage(
    SettingsEventUpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      languageCode: event.languageCode,
    );

    emit(state.copyWith(settings: updatedSettings));

    // TODO: SharedPreferences에 저장
  }

  Future<void> _onBackupData(
    SettingsEventBackupData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    // TODO: 백업 UseCase 호출
    await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

    emit(state.copyWith(
      isProcessing: false,
      message: some('백업이 완료되었습니다'),
    ));
  }

  Future<void> _onExportData(
    SettingsEventExportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    // TODO: 내보내기 UseCase 호출
    await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

    emit(state.copyWith(
      isProcessing: false,
      message: some('데이터 내보내기가 완료되었습니다'),
    ));
  }

  Future<void> _onDeleteAllData(
    SettingsEventDeleteAllData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    // TODO: 삭제 UseCase 호출
    await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

    emit(state.copyWith(
      isProcessing: false,
      message: some('모든 데이터가 삭제되었습니다'),
    ));
  }
}
