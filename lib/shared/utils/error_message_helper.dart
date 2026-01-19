/// 영어 에러 메시지를 한국어로 변환하는 헬퍼
class ErrorMessageHelper {
  ErrorMessageHelper._();

  /// Supabase/서버 에러 메시지를 한국어로 변환
  static String toKorean(String message) {
    // 인증 관련
    if (message.contains('Invalid login credentials')) {
      return '이메일 또는 비밀번호가 올바르지 않습니다';
    }
    if (message.contains('Email not confirmed')) {
      return '이메일 인증이 완료되지 않았습니다';
    }
    if (message.contains('User already registered')) {
      return '이미 가입된 이메일입니다';
    }
    if (message.contains('Password should contain at least')) {
      return '12자 이상 입력 (특수문자 + 영어 대소문자 + 숫자 조합)';
    }
    if (message.contains('expired') || message.contains('invalid')) {
      if (message.toLowerCase().contains('token')) {
        return '인증 코드가 만료되었거나 올바르지 않습니다';
      }
    }
    if (message.contains('Email rate limit exceeded')) {
      return '너무 많은 요청입니다. 잠시 후 다시 시도해주세요';
    }
    if (message.contains('For security purposes')) {
      return '보안을 위해 잠시 후 다시 시도해주세요';
    }

    // 네트워크 관련
    if (message.contains('network') ||
        message.contains('Network') ||
        message.contains('SocketException')) {
      return '네트워크 연결을 확인해주세요';
    }
    if (message.contains('timeout') || message.contains('Timeout')) {
      return '요청 시간이 초과되었습니다. 다시 시도해주세요';
    }

    // 서버 에러
    if (message.contains('500') || message.contains('Internal Server Error')) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요';
    }
    if (message.contains('503') || message.contains('Service Unavailable')) {
      return '서비스를 일시적으로 사용할 수 없습니다';
    }

    // 데이터 관련
    if (message.contains('not found') || message.contains('Not Found')) {
      return '데이터를 찾을 수 없습니다';
    }
    if (message.contains('already exists')) {
      return '이미 존재하는 데이터입니다';
    }
    if (message.contains('permission denied') ||
        message.contains('Permission denied')) {
      return '권한이 없습니다';
    }

    // 기본값: 원본 메시지 반환
    return message;
  }
}
