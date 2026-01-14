import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/home/domain/models/recent_record.dart';
import 'package:no_gerd/features/home/domain/models/record_summary.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

/// Home BLoC
///
/// 홈 화면의 상태를 관리합니다.
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// 생성자
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEventStarted>(_onStarted);
    on<HomeEventRefreshed>(_onRefreshed);
    on<HomeEventDateChanged>(_onDateChanged);
  }

  Future<void> _onStarted(
    HomeEventStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // TODO: 실제 데이터 로드 로직 구현
    // 현재는 샘플 데이터로 대체
    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(
        isLoading: false,
        healthScore: 78,
        previousScore: 72,
        todaySummary: _getSampleSummary(),
        recentRecords: _getSampleRecentRecords(),
      ),
    );
  }

  Future<void> _onRefreshed(
    HomeEventRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    // 새로고침 로직
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(
        isLoading: false,
        healthScore: 80,
        previousScore: 78,
      ),
    );
  }

  Future<void> _onDateChanged(
    HomeEventDateChanged event,
    Emitter<HomeState> emit,
  ) async {
    // 날짜 변경 로직
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(isLoading: false));
  }

  List<RecordSummary> _getSampleSummary() {
    return const [
      RecordSummary(
        label: '증상',
        value: '2회',
        subValue: '가벼움',
        iconCode: 0xe1f6, // Icons.local_fire_department_rounded
        colorValue: 0xFFEF5350,
      ),
      RecordSummary(
        label: '식사',
        value: '3회',
        subValue: '정상',
        iconCode: 0xe56c, // Icons.restaurant_rounded
        colorValue: 0xFF66BB6A,
      ),
      RecordSummary(
        label: '약물',
        value: '1회',
        subValue: '복용 완료',
        iconCode: 0xe3f9, // Icons.medication_rounded
        colorValue: 0xFF42A5F5,
      ),
      RecordSummary(
        label: '수면',
        value: '7시간',
        subValue: '양호',
        iconCode: 0xe3bb, // Icons.nightlight_round
        colorValue: 0xFFAB47BC,
      ),
    ];
  }

  List<RecentRecord> _getSampleRecentRecords() {
    return const [
      RecentRecord(
        title: '가슴쓰림',
        subtitle: '강도: 중간 (5/10)',
        time: '오후 2:30',
        emoji: '🔥',
        colorValue: 0xFFEF5350,
      ),
      RecentRecord(
        title: '점심 식사',
        subtitle: '김치찌개, 밥, 반찬',
        time: '오후 12:00',
        emoji: '🍽️',
        colorValue: 0xFF66BB6A,
      ),
      RecentRecord(
        title: '약 복용',
        subtitle: '오메프라졸 20mg',
        time: '오전 8:00',
        emoji: '💊',
        colorValue: 0xFF42A5F5,
      ),
    ];
  }
}
