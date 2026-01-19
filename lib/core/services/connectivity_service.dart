import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// 네트워크 연결 상태 서비스
@lazySingleton
class ConnectivityService {
  ConnectivityService() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _connectivityController = StreamController<bool>.broadcast();
  bool _isConnected = true;

  /// 현재 연결 상태
  bool get isConnected => _isConnected;

  /// 연결 상태 변경 스트림
  Stream<bool> get connectivityStream => _connectivityController.stream;

  void _log(String message) {
    developer.log('[오프라인동기화] $message', name: 'ConnectivityService');
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);

    _log('Connectivity changed: $_isConnected (was: $wasConnected)');

    if (_isConnected != wasConnected) {
      _connectivityController.add(_isConnected);
    }
  }

  /// 현재 연결 상태 확인 (강제 체크)
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
    return _isConnected;
  }

  /// 서비스 정리
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}
