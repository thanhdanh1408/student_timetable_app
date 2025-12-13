// lib/features/schedule/presentation/providers/schedule_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/add_schedule_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';
import '/core/services/notification_service.dart';
import '/core/providers/notification_settings_provider.dart';

class ScheduleProvider with ChangeNotifier {
  final GetSchedulesUsecase _get;
  final AddScheduleUsecase _add;
  final UpdateScheduleUsecase _update;
  final DeleteScheduleUsecase _delete;
  final NotificationSettingsProvider? _notificationSettings;

  ScheduleProvider({
    required GetSchedulesUsecase get,
    required AddScheduleUsecase add,
    required UpdateScheduleUsecase update,
    required DeleteScheduleUsecase delete,
    NotificationSettingsProvider? notificationSettings,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete,
        _notificationSettings = notificationSettings;
  // Don't call load() here - wait for page to initialize

  List<ScheduleEntity> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleEntity> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _schedules = await _get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ScheduleEntity s) async {
    print('📌 [ScheduleProvider] Adding schedule: ${s.subjectName}');
    try {
      await _add(s);
      await load();
      print('📌 [ScheduleProvider] Schedule added, now scheduling notification...');
      
      // Find the newly added schedule from the loaded list (it will have an ID now)
      final addedSchedule = _schedules.firstWhere(
        (schedule) => schedule.subjectName == s.subjectName &&
                     schedule.dayOfWeek == s.dayOfWeek &&
                     schedule.startTime == s.startTime &&
                     schedule.room == s.room,
        orElse: () => s, // Fallback to original if not found
      );
      
      print('📌 [ScheduleProvider] Found schedule with ID: ${addedSchedule.id}');
      
      // Schedule notification for this schedule
      await _scheduleNotificationForSchedule(addedSchedule);
      print('📌 [ScheduleProvider] Notification scheduling completed');
    } catch (e) {
      print('❌ [ScheduleProvider] Error adding schedule: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(ScheduleEntity s) async {
    try {
      await _update(s);
      await load();
      // Reschedule notification
      if (s.id != null) {
        await NotificationService().cancelNotification(s.id!);
      }
      await _scheduleNotificationForSchedule(s);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _delete(id);
      // Cancel notification for this schedule
      await NotificationService().cancelNotification(id);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Schedule notification for a schedule (based on user's reminder preference)
  Future<void> _scheduleNotificationForSchedule(ScheduleEntity schedule) async {
    print('📅 [ENTER] _scheduleNotificationForSchedule for ${schedule.subjectName}, ID: ${schedule.id}');
    
    if (schedule.id == null) {
      print('❌ [EXIT] schedule.id is NULL! Cannot schedule notification');
      return;
    }

    print('✅ schedule.id is ${schedule.id}, continuing...');

    // Check if schedule notifications are enabled
    if (_notificationSettings != null && 
        !_notificationSettings!.enableScheduleNotifications) {
      print('⚠️ Schedule notifications are disabled in settings');
      return;
    }

    // Get reminder time from settings (default to 10 minutes if settings not available)
    final reminderMinutes = _notificationSettings?.scheduleReminderMinutes ?? 10;

    // Find next occurrence of this day of week
    final now = DateTime.now();
    DateTime nextOccurrence = _getNextOccurrence(schedule.dayOfWeek, schedule.startTime);
    
    // Calculate notification time based on user's preference
    final notificationTime = nextOccurrence.subtract(Duration(minutes: reminderMinutes));

    print('📅 ========================================');
    print('📅 SCHEDULE NOTIFICATION SETUP');
    print('📅 Subject: ${schedule.subjectName}');
    print('📅 Day of week: ${schedule.dayOfWeek}');
    print('📅 Start time: ${schedule.startTime}');
    print('📅 Next occurrence (class time): $nextOccurrence');
    print('📅 Reminder time setting: $reminderMinutes minutes before');
    print('📅 Notification time: $notificationTime');
    print('📅 Current time: $now');
    print('📅 Minutes until notification: ${notificationTime.difference(now).inMinutes}');

    // Schedule notification - _getNextOccurrence already handles finding next valid time
    await NotificationService().scheduleNotification(
      id: schedule.id!,
      title: '📚 Sắp đến giờ học: ${schedule.subjectName}',
      body: 'Phòng ${schedule.room} • ${schedule.startTime} - ${schedule.endTime}',
      scheduledTime: notificationTime,
      payload: 'schedule_${schedule.id}',
      type: 'schedule',
    );
    
    if (notificationTime.difference(now).inDays >= 7) {
      print('✅ Notification scheduled for next week: ${notificationTime.toString()}');
    } else if (notificationTime.isAfter(now)) {
      print('✅ Notification scheduled successfully: ${notificationTime.toString()}');
    } else {
      print('⚠️ Warning: Notification time is in the past, but scheduled anyway as ${notificationTime.toString()}');
    }
    print('📅 ========================================');
  }

  /// Get next occurrence of a specific day of week and time
  DateTime _getNextOccurrence(int dayOfWeek, String timeStr) {
    final now = DateTime.now();
    final timeParts = timeStr.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Get reminder time setting (default 10 minutes)
    final reminderMinutes = _notificationSettings?.scheduleReminderMinutes ?? 10;

    // Convert from app's dayOfWeek (2-8: T2-CN) to Dart's weekday (1-7: Mon-Sun)
    // App: 2=Thứ 2, 3=Thứ 3, ..., 8=Chủ nhật
    // Dart: 1=Monday, 2=Tuesday, ..., 7=Sunday
    final targetWeekday = dayOfWeek == 8 ? 7 : dayOfWeek - 1;

    // Find next occurrence of this day
    int daysToAdd = (targetWeekday - now.weekday) % 7;
    if (daysToAdd == 0) {
      // Same day - check if class time is still in the future
      final todayClassTime = DateTime(now.year, now.month, now.day, hour, minute);
      // Check if class time itself is still in the future
      // (notification time = class_time - reminder, so class_time must be after now)
      if (todayClassTime.isAfter(now)) {
        return todayClassTime;
      } else {
        daysToAdd = 7; // Schedule for next week
      }
    }

    return DateTime(
      now.year,
      now.month,
      now.day + daysToAdd,
      hour,
      minute,
    );
  }
}