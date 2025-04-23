import 'package:rxdart/rxdart.dart';

import 'package:no_gerd/features/record/domain/entities/gerd_record.dart';

class GerdViewModel {
  // BehaviorSubject: 현재 값 유지 + 스트림 제공
  final _recordsSubject = BehaviorSubject<List<GerdRecord>>.seeded([]);

  // 스트림 getter (읽기 전용)
  Stream<List<GerdRecord>> get recordsStream => _recordsSubject.stream;

  // 현재 값
  List<GerdRecord> get currentRecords => _recordsSubject.value;

  // 초기화 (예: demo 데이터 세팅)
  void loadInitialData(List<GerdRecord> demo) {
    _recordsSubject.add(demo);
  }

  // 새 기록 추가
  void addRecord(GerdRecord record) {
    final updated = List<GerdRecord>.from(currentRecords)..insert(0, record);
    _recordsSubject.add(updated);
  }

  // 기록 삭제
  void deleteRecord(GerdRecord record) {
    final updated = List<GerdRecord>.from(currentRecords)..remove(record);
    _recordsSubject.add(updated);
  }

  // 자원 해제
  void dispose() {
    _recordsSubject.close();
  }
}
