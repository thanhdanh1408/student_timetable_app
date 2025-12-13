// lib/core/services/reminder_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class ReminderService {
  static const String _scheduleReminderKey = 'schedule_reminder_minutes';
  static const String _examReminderKey = 'exam_reminder_minutes';

  final SharedPreferences _prefs;
  final NotificationService _notificationService = NotificationService();

  ReminderService(this._prefs);

  // Getter/Setter cho cài đặt nhắc nhở
  int getScheduleReminderMinutes() {
    return _prefs.getInt(_scheduleReminderKey) ?? 15; // Mặc định 15 phút
  }

  int getExamReminderMinutes() {
    return _prefs.getInt(_examReminderKey) ?? 60; // Mặc định 1 giờ
  }

  Future<void> setScheduleReminderMinutes(int minutes) async {
    await _prefs.setInt(_scheduleReminderKey, minutes);
  }

  Future<void> setExamReminderMinutes(int minutes) async {
    await _prefs.setInt(_examReminderKey, minutes);
  }

  // Tính toán thời gian nhắc nhở
  DateTime calculateReminderTime(DateTime originalTime, int minutesBefore) {
    return originalTime.subtract(Duration(minutes: minutesBefore));
  }

  // Tính toán ngày giờ buổi học tiếp theo
  DateTime _getNextClassDateTime(int dayOfWeek, String startTime) {
    final now = DateTime.now();
    final timeParts = startTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    // Chuyển đổi dayOfWeek từ hệ thống app (2-8) sang Flutter weekday (1-7)
    // dayOfWeek: 2=Thứ 2, 3=Thứ 3, ..., 8=Chủ nhật
    // Flutter weekday: 1=Monday, 2=Tuesday, ..., 7=Sunday
    final targetWeekday = dayOfWeek == 8 ? 7 : dayOfWeek - 1;
    
    // Tìm ngày tiếp theo có weekday này
    int daysUntilTarget = (targetWeekday - now.weekday) % 7;
    if (daysUntilTarget == 0) {
      // Nếu là cùng ngày, kiểm tra xem giờ học đã qua chưa
      final todayClassTime = DateTime(now.year, now.month, now.day, hour, minute);
      if (todayClassTime.isAfter(now)) {
        return todayClassTime;
      } else {
        // Nếu giờ học hôm nay đã qua, lấy tuần sau
        daysUntilTarget = 7;
      }
    }
    
    final nextClassDate = now.add(Duration(days: daysUntilTarget));
    return DateTime(
      nextClassDate.year,
      nextClassDate.month,
      nextClassDate.day,
      hour,
      minute,
    );
  }

  // Schedule thông báo cho buổi học
  Future<void> scheduleClassReminder({
    required int id,
    required String subjectName,
    required String room,
    required int dayOfWeek,
    required String startTime,
  }) async {
    final classTime = _getNextClassDateTime(dayOfWeek, startTime);
    final reminderMinutes = getScheduleReminderMinutes();
    final reminderTime = calculateReminderTime(classTime, reminderMinutes);
    
    final now = DateTime.now();
    
    // DEBUG LOGGING
    print('=== SCHEDULE CLASS REMINDER DEBUG ===');
    print('Subject: $subjectName');
    print('Current time: $now');
    print('Class time: $classTime');
    print('Reminder minutes: $reminderMinutes');
    print('Reminder time: $reminderTime');
    print('Time difference: ${reminderTime.difference(now).inMinutes} minutes');
    print('Is future: ${reminderTime.isAfter(now)}');
    print('=====================================');

    // Chỉ schedule nếu thời gian nhắc nhở chưa qua
    if (reminderTime.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: id,
        title: 'Nhắc nhở buổi học',
        body:
            '$reminderMinutes phút nữa bạn có môn $subjectName – Phòng $room',
        scheduledTime: reminderTime, // Pass reminderTime directly
        payload: 'class_$id',
      );
      print('✅ Notification scheduled successfully');
    } else {
      print('❌ Notification NOT scheduled - reminder time already passed');
    }
  }

  Future<void> scheduleExamReminder({
    required int id,
    required String subjectName,
    required String room,
    required DateTime examTime,
  }) async {
    final reminderMinutes = getExamReminderMinutes();
    final reminderTime = calculateReminderTime(examTime, reminderMinutes);

    await _notificationService.scheduleNotification(
      id: id,
      title: 'Nhắc nhở lịch thi',
      body:
          '$reminderMinutes phút nữa bạn thi $subjectName – Phòng $room',
      scheduledTime: reminderTime, // Pass reminderTime directly
      payload: 'exam_$id',
    );
  }

  // Hủy thông báo
  Future<void> cancelReminder(int id) async {
    await _notificationService.cancelNotification(id);
  }

  // Lấy dayOfWeek từ DateTime (2-8 cho Thứ 2 - Chủ nhật)
  static int getAppDayOfWeek(DateTime dateTime) {
    final flutterWeekday = dateTime.weekday; // 1-7 (Monday-Sunday)
    return flutterWeekday == 7 ? 8 : flutterWeekday + 1; // Convert to 2-8 (Thứ 2 - Chủ nhật)
  }
}
