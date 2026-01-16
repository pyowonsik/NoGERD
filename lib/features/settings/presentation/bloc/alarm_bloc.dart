import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/alarm_config.dart';
import 'package:no_gerd/features/settings/domain/repositories/alarm_repository.dart';
import 'package:no_gerd/features/settings/domain/usecases/cancel_alarm_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/get_alarm_configs_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/schedule_alarm_usecase.dart';

part 'alarm_bloc.freezed.dart';
part 'alarm_event.dart';
part 'alarm_state.dart';

/// Alarm BLoC
@injectable
class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  /// 생성자
  AlarmBloc(
    this._getAlarmConfigsUseCase,
    this._scheduleAlarmUseCase,
    this._cancelAlarmUseCase,
    this._alarmRepository,
  ) : super(AlarmState.initial()) {
    on<AlarmEventLoadConfigs>(_onLoadConfigs);
    on<AlarmEventToggleAlarm>(_onToggleAlarm);
    on<AlarmEventUpdateTime>(_onUpdateTime);
    on<AlarmEventRequestPermission>(_onRequestPermission);
  }
  final GetAlarmConfigsUseCase _getAlarmConfigsUseCase;
  final ScheduleAlarmUseCase _scheduleAlarmUseCase;
  final CancelAlarmUseCase _cancelAlarmUseCase;
  final AlarmRepository _alarmRepository;

  Future<void> _onLoadConfigs(
    AlarmEventLoadConfigs event,
    Emitter<AlarmState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // 알림 설정 조회
    final configsResult = await _getAlarmConfigsUseCase(const NoParams());

    // 권한 확인
    final permissionResult = await _alarmRepository.checkPermission();

    configsResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: some(failure.displayMessage),
        ),
      ),
      (configs) {
        final configsMap = <AlarmType, AlarmConfig>{};
        for (final config in configs) {
          configsMap[config.type] = config;
        }

        permissionResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              configs: configsMap,
              hasPermission: false,
              errorMessage: some(failure.displayMessage),
            ),
          ),
          (hasPermission) => emit(
            state.copyWith(
              isLoading: false,
              configs: configsMap,
              hasPermission: hasPermission,
              errorMessage: none(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onToggleAlarm(
    AlarmEventToggleAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    final currentConfig = state.configs[event.type];
    if (currentConfig == null) return;

    // 설정 업데이트
    final updatedConfig = currentConfig.copyWith(enabled: event.enabled);

    if (event.enabled) {
      // 알림 활성화 - 예약
      final result = await _scheduleAlarmUseCase(
        ScheduleAlarmParams(updatedConfig),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: some(failure.displayMessage),
          ),
        ),
        (_) {
          final updatedConfigs =
              Map<AlarmType, AlarmConfig>.from(state.configs);
          updatedConfigs[event.type] = updatedConfig;

          emit(
            state.copyWith(
              configs: updatedConfigs,
              errorMessage: none(),
            ),
          );
        },
      );
    } else {
      // 알림 비활성화 - 취소
      final result = await _cancelAlarmUseCase(
        CancelAlarmParams(event.type.id),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: some(failure.displayMessage),
          ),
        ),
        (_) async {
          // 로컬 설정 업데이트
          await _alarmRepository.saveAlarmConfig(updatedConfig);

          final updatedConfigs =
              Map<AlarmType, AlarmConfig>.from(state.configs);
          updatedConfigs[event.type] = updatedConfig;

          emit(
            state.copyWith(
              configs: updatedConfigs,
              errorMessage: none(),
            ),
          );
        },
      );
    }
  }

  Future<void> _onUpdateTime(
    AlarmEventUpdateTime event,
    Emitter<AlarmState> emit,
  ) async {
    final currentConfig = state.configs[event.type];
    if (currentConfig == null) return;

    // 시간 업데이트
    final updatedConfig = currentConfig.copyWith(
      hour: event.hour,
      minute: event.minute,
    );

    // 로컬 저장
    await _alarmRepository.saveAlarmConfig(updatedConfig);

    // enabled 상태면 재예약
    if (updatedConfig.enabled) {
      final result = await _scheduleAlarmUseCase(
        ScheduleAlarmParams(updatedConfig),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: some(failure.displayMessage),
          ),
        ),
        (_) {
          final updatedConfigs =
              Map<AlarmType, AlarmConfig>.from(state.configs);
          updatedConfigs[event.type] = updatedConfig;

          emit(
            state.copyWith(
              configs: updatedConfigs,
              errorMessage: none(),
            ),
          );
        },
      );
    } else {
      // enabled 아니면 로컬 저장만
      final updatedConfigs = Map<AlarmType, AlarmConfig>.from(state.configs);
      updatedConfigs[event.type] = updatedConfig;

      emit(
        state.copyWith(
          configs: updatedConfigs,
          errorMessage: none(),
        ),
      );
    }
  }

  Future<void> _onRequestPermission(
    AlarmEventRequestPermission event,
    Emitter<AlarmState> emit,
  ) async {
    final result = await _alarmRepository.requestPermission();

    result.fold(
      (failure) => emit(
        state.copyWith(
          hasPermission: false,
          errorMessage: some(failure.displayMessage),
        ),
      ),
      (granted) => emit(
        state.copyWith(
          hasPermission: granted,
          errorMessage: granted ? none() : some('알림 권한이 거부되었습니다.'),
        ),
      ),
    );
  }
}
