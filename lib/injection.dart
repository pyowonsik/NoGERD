import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:no_gerd/features/gerd_record/data/models/gerd_record_model.dart';

import 'features/gerd_record/data/datasources/gerd_record_local_datasource.dart';
import 'features/gerd_record/data/repositories/gerd_record_repository_impl.dart';
import 'features/gerd_record/domain/repositories/gerd_record_repository.dart';

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

  // 추후 UseCase나 Bloc도 여기 등록 가능
}
