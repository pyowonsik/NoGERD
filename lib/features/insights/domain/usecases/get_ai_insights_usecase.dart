import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:no_gerd/core/error/failures.dart';
import 'package:no_gerd/features/insights/data/datasources/ai_remote_datasource.dart';
import 'package:no_gerd/features/insights/domain/entities/ai_insight.dart';
import 'package:no_gerd/features/insights/presentation/bloc/insights_bloc.dart';

/// AI 인사이트 생성 UseCase
@injectable
class GetAIInsightsUseCase {
  /// 생성자
  const GetAIInsightsUseCase(this._dataSource);

  final AIRemoteDataSource _dataSource;

  /// AI 인사이트 생성
  Future<Either<Failure, AIInsight>> call(InsightsState state) async {
    return _dataSource.generateInsight(state);
  }

  /// 저장된 리포트 로드
  AIInsight? getSavedInsight() {
    return _dataSource.getSavedInsight();
  }

  /// 이번 주 생성 가능 여부
  bool canGenerateThisWeek() {
    return _dataSource.canGenerateThisWeek();
  }

  /// 다음 월요일 날짜
  DateTime getNextMonday() {
    return _dataSource.getNextMonday();
  }
}
