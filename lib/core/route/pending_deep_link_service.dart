import 'package:flutter/foundation.dart';

/// 딥링크를 임시로 저장하고 인증 완료 후 복원하는 서비스
/// TTL(Time To Live) 5분 적용
class PendingDeepLinkService {
  PendingDeepLinkService._();
  static final instance = PendingDeepLinkService._();

  static const _ttl = Duration(minutes: 5);

  String? _pendingDeepLink;
  DateTime? _pendingDeepLinkTimestamp;

  String? get pendingDeepLink => _pendingDeepLink;

  /// 딥링크 저장
  void setPendingDeepLink(String routePath) {
    _pendingDeepLink = routePath;
    _pendingDeepLinkTimestamp = DateTime.now();
    debugPrint('📌 Pending deep link saved: $routePath');
  }

  /// 보류 중인 딥링크 가져오고 초기화 (TTL 체크)
  String? consumePendingDeepLink() {
    if (_pendingDeepLink != null && _pendingDeepLinkTimestamp != null) {
      final elapsed = DateTime.now().difference(_pendingDeepLinkTimestamp!);
      if (elapsed > _ttl) {
        debugPrint('⏰ Pending deep link expired (TTL: ${_ttl.inMinutes}m)');
        clear();
        return null;
      }
    }

    final link = _pendingDeepLink;
    if (link != null) {
      debugPrint('✅ Consuming pending deep link: $link');
      _pendingDeepLink = null;
      _pendingDeepLinkTimestamp = null;
    }
    return link;
  }

  void clear() {
    _pendingDeepLink = null;
    _pendingDeepLinkTimestamp = null;
  }
}
