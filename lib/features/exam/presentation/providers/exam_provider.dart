// lib/features/exam/presentation/providers/exam_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/usecases/get_exams_usecase.dart';
import '../../domain/usecases/add_exam_usecase.dart';
import '../../domain/usecases/update_exam_usecase.dart';
import '../../domain/usecases/delete_exam_usecase.dart';
import '/core/services/notification_service.dart';
import '/core/providers/notification_settings_provider.dart';

class ExamProvider with ChangeNotifier {
  final GetExamsUsecase _get;
  final AddExamUsecase _add;
  final UpdateExamUsecase _update;
  final DeleteExamUsecase _delete;
  final NotificationSettingsProvider? _notificationSettings;

  ExamProvider({
    required GetExamsUsecase get,
    required AddExamUsecase add,
    required UpdateExamUsecase update,
    required DeleteExamUsecase delete,
    NotificationSettingsProvider? notificationSettings,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete,
        _notificationSettings = notificationSettings;
  // Don't call load() here - wait for page to initialize

  List<ExamEntity> _exams = [];
  bool _isLoading = false;
  String? _error;

  List<ExamEntity> get exams => _exams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _exams = await _get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ExamEntity e) async {
    try {
      await _add(e);
      await load();
      // Schedule notification for this exam
      await _scheduleNotificationForExam(e);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(ExamEntity e) async {
    try {
      await _update(e);
      await load();
      // Reschedule notification
      if (e.id != null) {
        await NotificationService().cancelNotification(e.id!);
      }
      await _scheduleNotificationForExam(e);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _delete(id);
      // Cancel notification for this exam
      await NotificationService().cancelNotification(id);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Schedule notification for an exam (based on user's reminder preference)
  Future<void> _scheduleNotificationForExam(ExamEntity exam) async {
    print('📝 [ENTER] _scheduleNotificationForExam for ${exam.subjectName}, ID: ${exam.id}');
    
    if (exam.id == null) {
      print('❌ [EXIT] exam.id is NULL! Cannot schedule notification');
      return;
    }

    print('✅ exam.id is ${exam.id}, continuing...');

    // Check if exam notifications are enabled
    if (_notificationSettings != null && 
        !_notificationSettings!.enableExamNotifications) {
      print('⚠️ Exam notifications are disabled in settings');
      return;
    }

    // Get reminder time from settings (default to 60 minutes if settings not available)
    final reminderMinutes = _notificationSettings?.examReminderMinutes ?? 60;

    // Parse time
    final timeParts = exam.startTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Create exact exam date/time
    final examDateTime = DateTime(
      exam.examDate.year,
      exam.examDate.month,
      exam.examDate.day,
      hour,
      minute,
    );

    // Calculate notification time based on user's preference
    final notificationTime = examDateTime.subtract(Duration(minutes: reminderMinutes));

    print('📝 ========================================');
    print('📝 EXAM NOTIFICATION SETUP');
    print('📝 Subject: ${exam.subjectName}');
    print('📝 Exam date/time: $examDateTime');
    print('📝 Reminder time setting: $reminderMinutes minutes before');
    print('📝 Notification time: $notificationTime');
    print('📝 Current time: ${DateTime.now()}');
    print('📝 Minutes until notification: ${notificationTime.difference(DateTime.now()).inMinutes}');

    // Only schedule if notification time is in the future
    if (notificationTime.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: exam.id!,
        title: '📝 Sắp đến giờ thi: ${exam.subjectName}',
        body: 'Phòng ${exam.room} • ${exam.startTime}${exam.endTime != null ? " - ${exam.endTime}" : ""}',
        scheduledTime: notificationTime,
        payload: 'exam_${exam.id}',
      );
      print('✅ Exam notification scheduled successfully');
    } else {
      print('❌ Notification NOT scheduled - reminder time already passed');
    }
  }
}