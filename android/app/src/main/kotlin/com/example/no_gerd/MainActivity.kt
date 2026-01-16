package com.example.no_gerd

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.no_gerd/alarm"
    private val NOTIFICATION_CHANNEL_ID = "alarm_notifications"
    private val POST_NOTIFICATIONS_PERMISSION_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Notification Channel 생성 (Android 8.0+)
        createNotificationChannel()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleAlarm" -> {
                    val id = call.argument<Int>("id")
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")
                    val hour = call.argument<Int>("hour")
                    val minute = call.argument<Int>("minute")

                    if (id == null || title == null || body == null || hour == null || minute == null) {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                        return@setMethodCallHandler
                    }

                    val success = scheduleAlarm(id, title, body, hour, minute)
                    result.success(success)
                }
                "cancelAlarm" -> {
                    val id = call.argument<Int>("id")
                    if (id == null) {
                        result.error("INVALID_ARGUMENTS", "Missing alarm id", null)
                        return@setMethodCallHandler
                    }

                    val success = cancelAlarm(id)
                    result.success(success)
                }
                "cancelAllAlarms" -> {
                    val success = cancelAllAlarms()
                    result.success(success)
                }
                "requestPermission" -> {
                    val success = requestPermission()
                    result.success(success)
                }
                "checkPermission" -> {
                    val hasPermission = checkPermission()
                    result.success(hasPermission)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "알림"
            val descriptionText = "식사, 약물 복용, 취침 시간 알림"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun scheduleAlarm(id: Int, title: String, body: String, hour: Int, minute: Int): Boolean {
        return try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, AlarmReceiver::class.java).apply {
                putExtra("id", id)
                putExtra("title", title)
                putExtra("body", body)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                this,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // 다음 알림 시간 계산
            val calendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)

                // 현재 시간보다 이전이면 다음 날로 설정
                if (timeInMillis <= System.currentTimeMillis()) {
                    add(Calendar.DAY_OF_YEAR, 1)
                }
            }

            // Android 6.0+ Doze 모드 대응
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setRepeating(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    AlarmManager.INTERVAL_DAY,
                    pendingIntent
                )
            }

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun cancelAlarm(id: Int): Boolean {
        return try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, AlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun cancelAllAlarms(): Boolean {
        return try {
            // 7개의 알림 ID (1-7) 모두 취소
            for (id in 1..7) {
                cancelAlarm(id)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun requestPermission(): Boolean {
        // Android 13+ (API 33+) POST_NOTIFICATIONS 권한 필요
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    POST_NOTIFICATIONS_PERMISSION_CODE
                )
                return false
            }
        }
        return true
    }

    private fun checkPermission(): Boolean {
        // Android 13+ (API 33+) POST_NOTIFICATIONS 권한 확인
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        }
        // Android 13 미만은 권한 필요 없음
        return true
    }
}
