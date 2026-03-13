import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "com.pyowonsik.nogerd/alarm"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 포그라운드 알림을 위한 delegate 설정
    UNUserNotificationCenter.current().delegate = self

    // 1. FlutterMethodChannel 설정 - Flutter와 iOS 네이티브 코드 통신
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let alarmChannel = FlutterMethodChannel(name: CHANNEL,
                                            binaryMessenger: controller.binaryMessenger)

    // 2. MethodChannel 수신 - Flutter에서 호출한 메서드를 네이티브에서 처리
    alarmChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }

      // 3. 메서드 이름에 따라 분기 처리
      switch call.method {
      case "scheduleAlarm":
        // 4. Flutter에서 전달한 파라미터 추출
        guard let args = call.arguments as? [String: Any],
              let id = args["id"] as? Int,
              let title = args["title"] as? String,
              let body = args["body"] as? String,
              let hour = args["hour"] as? Int,
              let minute = args["minute"] as? Int else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Missing required arguments",
                            details: nil))
          return
        }
        // 5. UNUserNotificationCenter로 알림 예약
        self.scheduleAlarm(id: id, title: title, body: body, hour: hour, minute: minute, result: result)

      case "cancelAlarm":
        guard let args = call.arguments as? [String: Any],
              let id = args["id"] as? Int else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Missing alarm id",
                            details: nil))
          return
        }
        self.cancelAlarm(id: id, result: result)

      case "cancelAllAlarms":
        self.cancelAllAlarms(result: result)

      case "requestPermission":
        self.requestPermission(result: result)

      case "checkPermission":
        self.checkPermission(result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // UNUserNotificationCenter를 사용한 알림 예약
  // iOS 네이티브 UserNotifications API로 정확한 시간에 알림 트리거
  private func scheduleAlarm(id: Int, title: String, body: String, hour: Int, minute: Int, result: @escaping FlutterResult) {
    // 1. UNUserNotificationCenter 인스턴스 획득
    let center = UNUserNotificationCenter.current()

    // 2. 알림 콘텐츠 설정 (제목, 내용, 사운드)
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    // 3. 알림 시간 설정 (매일 반복)
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute

    // 4. 트리거 생성 - 매일 지정된 시간에 반복
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    // 5. 알림 요청 생성 및 예약
    let identifier = "alarm_\(id)"
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    center.add(request) { error in
      if let error = error {
        result(FlutterError(code: "SCHEDULE_ERROR",
                          message: "Failed to schedule alarm: \(error.localizedDescription)",
                          details: nil))
      } else {
        result(true)
      }
    }
  }

  private func cancelAlarm(id: Int, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    let identifier = "alarm_\(id)"

    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    result(true)
  }

  private func cancelAllAlarms(result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()

    // 7개의 알림 ID (1-7) 모두 취소
    var identifiers: [String] = []
    for id in 1...7 {
      identifiers.append("alarm_\(id)")
    }

    center.removePendingNotificationRequests(withIdentifiers: identifiers)
    result(true)
  }

  private func requestPermission(result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        result(FlutterError(code: "PERMISSION_ERROR",
                          message: "Failed to request permission: \(error.localizedDescription)",
                          details: nil))
      } else {
        result(granted)
      }
    }
  }

  private func checkPermission(result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()

    center.getNotificationSettings { settings in
      let isAuthorized = settings.authorizationStatus == .authorized
      result(isAuthorized)
    }
  }

  // MARK: - UNUserNotificationCenterDelegate (포그라운드 알림 표시)

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // 앱이 포그라운드에 있어도 알림 배너와 사운드 표시
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    // 사용자가 알림을 탭했을 때 처리 (필요시 확장 가능)
    completionHandler()
  }
}
