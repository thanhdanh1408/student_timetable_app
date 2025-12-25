// lib/core/services/background_task_handler.dart
import 'package:workmanager/workmanager.dart';

const String _examReminderTaskId = 'exam_reminder_task';

// Hàm được gọi từ background khi workmanager kích hoạt
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // NOTE: Background task chạy ngoài main thread, không có Context
      // Không gọi NotificationService().initialize() vì sẽ crash
      // (Context bị null)
      
      // NOTE: Schedule reminders are handled in ScheduleViewModel when users add/update schedules.
      // Only exam reminders use background tasks to check for upcoming exams periodically.
      // NOTE: Exam data is now fetched from Supabase via ExamViewModel, not from local Hive storage.
      
      if (task == _examReminderTaskId) {
        // Background task for periodic exam checks
        // Exam reminders are scheduled when users add/update exams.
        print('✅ Background exam reminder check executed');
      }

      return true;
    } catch (e) {
      print('Error in background task: $e');
      return false;
    }
  });
}

class BackgroundTaskHandler {
  static final BackgroundTaskHandler _instance =
      BackgroundTaskHandler._internal();

  factory BackgroundTaskHandler() {
    return _instance;
  }

  BackgroundTaskHandler._internal();

  // Khởi tạo workmanager
  Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,  // Tắt debug notifications
    );
  }

  // Đăng ký các background tasks
  Future<void> registerTasks() async {
    // NOTE: Chỉ đăng ký exam reminder task
    // Schedule notifications được xử lý trực tiếp trong ScheduleViewModel
    
    // Schedule task kiểm tra lịch thi mỗi 1 giờ
    await Workmanager().registerPeriodicTask(
      _examReminderTaskId,
      _examReminderTaskId,
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(minutes: 5),
    );
  }

  // Hủy tất cả background tasks
  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }

  // Hủy một task cụ thể
  Future<void> cancelTask(String taskName) async {
    await Workmanager().cancelByUniqueName(taskName);
  }
}
