import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/core/usecase/usecase.dart';
import 'package:no_gerd/features/settings/domain/entities/app_settings.dart';
import 'package:no_gerd/features/settings/domain/usecases/delete_all_data_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/export_data_usecase.dart';
import 'package:no_gerd/features/settings/domain/usecases/load_settings_usecase.dart';
import 'package:no_gerd/shared/utils/error_message_helper.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

/// Settings BLoC
@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// 생성자
  SettingsBloc(
    this._loadSettingsUseCase,
    this._exportDataUseCase,
    this._deleteAllDataUseCase,
  ) : super(SettingsState.initial()) {
    on<SettingsEventLoadSettings>(_onLoadSettings);
    on<SettingsEventExportData>(_onExportData);
    on<SettingsEventDeleteAllData>(_onDeleteAllData);
  }
  final LoadSettingsUseCase _loadSettingsUseCase;
  final ExportDataUseCase _exportDataUseCase;
  final DeleteAllDataUseCase _deleteAllDataUseCase;

  Future<void> _onLoadSettings(
    SettingsEventLoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loadSettingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: some(failure),
        ),
      ),
      (settings) => emit(
        state.copyWith(
          isLoading: false,
          settings: settings,
          failure: none(),
        ),
      ),
    );
  }

  Future<void> _onExportData(
    SettingsEventExportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    final result = await _exportDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isProcessing: false,
          failure: some(failure),
          message: some(
            '데이터 내보내기 실패: ${ErrorMessageHelper.toKorean(failure.message)}',
          ),
        ),
      ),
      (filePath) => emit(
        state.copyWith(
          isProcessing: false,
          failure: none(),
          message: some('데이터를 내보냈습니다: $filePath'),
        ),
      ),
    );
  }

  Future<void> _onDeleteAllData(
    SettingsEventDeleteAllData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    final result = await _deleteAllDataUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isProcessing: false,
          failure: some(failure),
          message: some('데이터 삭제 실패'),
        ),
      ),
      (_) => emit(
        state.copyWith(
          isProcessing: false,
          failure: none(),
          message: some('모든 데이터가 삭제되었습니다.'),
        ),
      ),
    );
  }
}
