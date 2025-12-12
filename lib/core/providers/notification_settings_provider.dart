// lib/core/providers/notification_settings_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  static const String _scheduleReminderKey = 'schedule_reminder_minutes';
  static const String _examReminderKey = 'exam_reminder_minutes';
  static const String _enableScheduleNotificationsKey =
      'enable_schedule_notifications';
  static const String _enableExamNotificationsKey = 'enable_exam_notifications';

  late SharedPreferences _prefs;

  // Các giá trị mặc định
  int _scheduleReminderMinutes = 15;
  int _examReminderMinutes = 60;
  bool _enableScheduleNotifications = true;
  bool _enableExamNotifications = true;

  // Getters
  int get scheduleReminderMinutes => _scheduleReminderMinutes;
  int get examReminderMinutes => _examReminderMinutes;
  bool get enableScheduleNotifications => _enableScheduleNotifications;
  bool get enableExamNotifications => _enableExamNotifications;

  // Danh sách các tùy chọn thời gian
  static const List<int> reminderOptions = [5, 10, 15, 30, 60];

  // Khởi tạo provider
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  // Tải cài đặt từ SharedPreferences
  Future<void> _loadSettings() async {
    _scheduleReminderMinutes =
        _prefs.getInt(_scheduleReminderKey) ?? 15;
    _examReminderMinutes = _prefs.getInt(_examReminderKey) ?? 60;
    _enableScheduleNotifications =
        _prefs.getBool(_enableScheduleNotificationsKey) ?? true;
    _enableExamNotifications =
        _prefs.getBool(_enableExamNotificationsKey) ?? true;
    notifyListeners();
  }

  // Cập nhật thời gian nhắc nhở cho buổi học
  Future<void> setScheduleReminderMinutes(int minutes) async {
    _scheduleReminderMinutes = minutes;
    await _prefs.setInt(_scheduleReminderKey, minutes);
    notifyListeners();
  }

  // Cập nhật thời gian nhắc nhở cho lịch thi
  Future<void> setExamReminderMinutes(int minutes) async {
    _examReminderMinutes = minutes;
    await _prefs.setInt(_examReminderKey, minutes);
    notifyListeners();
  }

  // Bật/tắt thông báo buổi học
  Future<void> setEnableScheduleNotifications(bool enable) async {
    _enableScheduleNotifications = enable;
    await _prefs.setBool(_enableScheduleNotificationsKey, enable);
    notifyListeners();
  }

  // Bật/tắt thông báo lịch thi
  Future<void> setEnableExamNotifications(bool enable) async {
    _enableExamNotifications = enable;
    await _prefs.setBool(_enableExamNotificationsKey, enable);
    notifyListeners();
  }

  // Lấy text mô tả thời gian nhắc nhở
  String getReminderText(int minutes) {
    if (minutes < 60) {
      return '$minutes phút trước';
    } else if (minutes == 60) {
      return '1 giờ trước';
    } else {
      final hours = minutes ~/ 60;
      return '$hours giờ trước';
    }
  }
}
