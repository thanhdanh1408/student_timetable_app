// lib/core/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  
  // Callback to save notification to database.
  // relatedId: schedule/exam id
  // scheduledFor: when the notification is intended to be shown
  Future<void> Function(String relatedId, String title, String body, String type, DateTime scheduledFor)? onNotificationScheduled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone and set location to Vietnam
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    
    print('🌍 Timezone set to: ${tz.local.name}');
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
    
    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to appropriate page
    print('Notification tapped: ${response.payload}');
  }

  /// Schedule a notification for a specific date/time
  /// scheduledTime: the exact date/time when the notification should appear
  /// type: 'exam' or 'schedule' for categorization
  /// 
  /// IMPORTANT: Calculate the notification time BEFORE passing to this method.
  /// If you want a notification 5 minutes before an event at 2:00 PM,
  /// pass scheduledTime as 1:55 PM (event time minus reminder duration).
  /// 
  /// This method will check if scheduledTime is in the future and only schedule if it is.
  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String type = 'schedule', // 'exam', 'schedule', or 'general'
  }) async {
    if (!_isInitialized) await initialize();

    // Convert String id to int hash for notification ID (required by Flutter notifications API)
    final notificationId = id.hashCode;

    // Cancel existing notification with same ID to avoid duplicates
    await cancelNotification(id);

    print('🔔 ========================================');
    print('🔔 SCHEDULING NOTIFICATION');
    print('🔔 ID: $id (notification #$notificationId)');
    print('🔔 Title: $title');
    print('🔔 Body: $body');
    print('🔔 Scheduled Time (notification): $scheduledTime');
    print('🔔 Current Time: ${DateTime.now()}');
    print('🔔 Time Until Notification: ${scheduledTime.difference(DateTime.now()).inMinutes} minutes');
    print('🔔 Timezone: ${tz.local.name}');
    
    // Only schedule if notification time is in the future
    if (scheduledTime.isBefore(DateTime.now())) {
      print('⚠️ Notification time is in the past, skipping: $scheduledTime');
      print('🔔 ========================================');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Lịch học và thi',
      channelDescription: 'Thông báo nhắc nhở về lịch học và lịch thi',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      
      print('✅ Successfully scheduled notification #$notificationId');
      print('🔔 ========================================');
      
      // Save notification to database via callback (record will be visible when due)
      if (onNotificationScheduled != null) {
        await onNotificationScheduled!.call(id, title, body, type, scheduledTime);
      }
    } catch (e) {
      print('❌ Error scheduling notification: $e');
      print('🔔 ========================================');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(String id) async {
    if (!_isInitialized) {
      await initialize();
    }
    final notificationId = id.hashCode;
    await _notifications.cancel(notificationId);
    print('🗑️ Cancelled notification #$notificationId (ID: $id)');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) {
      await initialize();
    }
    await _notifications.cancelAll();
    print('🗑️ Cancelled all notifications');
  }

  /// Get list of pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _notifications.pendingNotificationRequests();
  }

  /// Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String id,
    required String title,
    required String body,
    String? payload,
    String type = 'general',
  }) async {
    if (!_isInitialized) await initialize();

    final notificationId = id.hashCode;

    const androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Thông báo ngay',
      channelDescription: 'Thông báo hiển thị ngay lập tức',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(notificationId, title, body, details, payload: payload);

    // Save immediate notification to database as due now
    if (onNotificationScheduled != null) {
      await onNotificationScheduled!.call(id, title, body, type, DateTime.now());
    }
  }
}
