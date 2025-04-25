import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/add_record_usecase.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/get_all_records_usecase.dart';
import 'package:no_gerd/features/gerd_record/domain/usecases/usecase.dart';

class GerdViewModel {
  final GetAllRecordsUseCase _getAllRecordsUseCase;
  final AddRecordUseCase _addRecordUseCase;

  GerdViewModel({
    GetAllRecordsUseCase? getAllRecordsUseCase,
    AddRecordUseCase? addRecordUseCase,
  })  : _getAllRecordsUseCase =
            getAllRecordsUseCase ?? GetIt.instance<GetAllRecordsUseCase>(),
        _addRecordUseCase =
            addRecordUseCase ?? GetIt.instance<AddRecordUseCase>();

  final _recordsSubject = BehaviorSubject<List<GerdRecord>>.seeded([]);

  Stream<List<GerdRecord>> get recordsStream => _recordsSubject.stream;
  List<GerdRecord> get currentRecords => _recordsSubject.value;

  Future<void> loadAllRecords() async {
    final records = await _getAllRecordsUseCase.call(const NoParams());
    _recordsSubject.add(records);
  }

  Future<void> addRecord(GerdRecord record) async {
    await _addRecordUseCase.call(AddRecordParams(record));

    final updated = List<GerdRecord>.from(currentRecords)
      ..removeWhere((r) => r.date == record.date)
      ..add(record);

    // 날짜 기준 정렬 (오름차순: 옛날 → 최신)
    updated.sort((a, b) => b.date.compareTo(a.date));

    _recordsSubject.add(updated);
  }

  void dispose() {
    _recordsSubject.close();
  }
}
