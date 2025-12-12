import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/notifications/domain/entities/notification_entity.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late Box<NotificationEntity> _notificationsBox;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationsBox = Hive.box<NotificationEntity>('notifications_box');

    // Khởi tạo timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    // Android configuration
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS configuration
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Request permissions for Android 13+ (API 33+)
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      // Request notification permission for Android 13+
      await androidImplementation.requestNotificationsPermission();
      // Request exact alarm permission
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'schedule_reminders',
      'Schedule Reminders',
      channelDescription: 'Notifications for upcoming classes and exams',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
    await _saveNotificationToHive(id, title, body, DateTime.now(), payload);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'schedule_reminders',
      'Schedule Reminders',
      channelDescription: 'Notifications for upcoming classes and exams',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    
    // DEBUG LOGGING
    print('=== NOTIFICATION SERVICE DEBUG ===');
    print('Notification ID: $id');
    print('Title: $title');
    print('Scheduled for: $scheduledDate');
    print('TZ Scheduled for: $tzScheduledDate');
    print('==================================');

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    
    // Verify it was scheduled
    final pending = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('📋 Pending notifications count: ${pending.length}');
    for (var p in pending) {
      print('  - ID: ${p.id}, Title: ${p.title}');
    }
    
    await _saveNotificationToHive(id, title, body, scheduledDate, payload);
  }

  Future<void> _saveNotificationToHive(
    int id,
    String title,
    String body,
    DateTime createdAt,
    String? payload,
  ) async {
    final type = payload?.split('_')[0] ?? 'unknown';

    final notification = NotificationEntity(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: false,
      type: type,
    );

    await _notificationsBox.put(id, notification);
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    await _notificationsBox.delete(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    await _notificationsBox.clear();
  }

  // Helper method để kiểm tra các thông báo đã lên lịch
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
