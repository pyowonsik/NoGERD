import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:no_gerd/features/gerd_record/domain/entities/gerd_record.dart';
import 'package:no_gerd/features/gerd_record/domain/repositories/gerd_record_repository.dart';

class GerdViewModel {
  final GerdRecordRepository _repository =
      GetIt.instance<GerdRecordRepository>();

  final _recordsSubject = BehaviorSubject<List<GerdRecord>>.seeded([]);

  Stream<List<GerdRecord>> get recordsStream => _recordsSubject.stream;
  List<GerdRecord> get currentRecords => _recordsSubject.value;

  // 초기 로딩
  Future<void> loadAllRecords() async {
    final records = await _repository.getAllRecords();
    _recordsSubject.add(records);
  }

  Future<void> addRecord(GerdRecord record) async {
    // DB에 무조건 덮어쓰기
    await _repository.addRecord(record);

    // 메모리에서도 동일 날짜 기록 제거 후 새로 추가
    final updated = List<GerdRecord>.from(currentRecords)
      ..removeWhere((r) => r.date == record.date)
      ..add(record); // 먼저 추가하고

    // 날짜 기준 정렬 (오름차순: 옛날 → 최신)
    updated.sort((a, b) => b.date.compareTo(b.date));

    _recordsSubject.add(updated);
  }

  // // 기록 삭제
  // Future<void> deleteRecord(String key, GerdRecord record) async {
  //   await _repository.deleteRecord(key);
  //   final updated = List<GerdRecord>.from(currentRecords)..remove(record);
  //   _recordsSubject.add(updated);
  // }

  void dispose() {
    _recordsSubject.close();
  }
}
