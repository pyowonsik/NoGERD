import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:no_gerd/features/gerd_record/data/datasources/gerd_record_local_datasource.dart';
import 'package:no_gerd/features/gerd_record/data/models/gerd_record_model.dart';
import 'package:no_gerd/features/gerd_record/data/repositories/gerd_record_repository_impl.dart';
import 'package:no_gerd/features/gerd_record/domain/repositories/gerd_record_repository.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/add_record_usecase.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/get_all_records_usecase.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // Hive 박스
  final box = await Hive.openBox<GerdRecordModel>('gerd_records');
  sl.registerSingleton<Box<GerdRecordModel>>(box);

  // DataSource
  sl.registerLazySingleton<GerdRecordLocalDataSource>(
    () => GerdRecordLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<GerdRecordRepository>(
    () => GerdRecordRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAllRecordsUseCase(sl()));
  sl.registerLazySingleton(() => AddRecordUseCase(sl()));
}
