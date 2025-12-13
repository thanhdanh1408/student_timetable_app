// lib/core/services/background_task_handler.dart
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/schedule/domain/entities/schedule_entity.dart';
import '../../features/exam/domain/entities/exam_entity.dart';
import 'notification_service.dart';
import 'reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _examReminderTaskId = 'exam_reminder_task';

// Hàm được gọi từ background khi workmanager kích hoạt
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Hive.initFlutter();
      
      // Đăng ký adapters nếu chưa được đăng ký
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(ScheduleEntityAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ExamEntityAdapter());
      }

      // Mở các box
      final schedulesBox = await Hive.openBox<ScheduleEntity>('schedules_box');
      final examsBox = await Hive.openBox<ExamEntity>('exams_box');

      // Khởi tạo services
      final notificationService = NotificationService();
      await notificationService.initialize();
      
      final prefs = await SharedPreferences.getInstance();
      final reminderService = ReminderService(prefs);

      // Lấy thông tin hôm nay
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      // Chuyển đổi weekday từ Flutter (1-7) sang app dayOfWeek (2-8)
      final todayDayOfWeek = today.weekday == 7 ? 8 : today.weekday + 1;

      // NOTE: Schedule reminders are handled in ScheduleProvider when users add/update schedules.
      // Only exam reminders use background tasks to check for upcoming exams periodically.
      
      if (task == _examReminderTaskId) {
        // Kiểm tra các lịch thi sắp tới (trong 3 ngày)
        final exams = examsBox.values.where((exam) {
          final examDate = exam.examDate;
          return !examDate.isBefore(startOfDay) && 
                 examDate.isBefore(endOfDay.add(const Duration(days: 2)));
        }).toList();

        for (int i = 0; i < exams.length; i++) {
          final exam = exams[i];
          
          // Parse giờ bắt đầu từ string "HH:mm"
          final startTimeParts = exam.startTime.split(':');
          if (startTimeParts.length == 2) {
            final hour = int.tryParse(startTimeParts[0]) ?? 0;
            final minute = int.tryParse(startTimeParts[1]) ?? 0;
            
            final examTime = DateTime(
              exam.examDate.year,
              exam.examDate.month,
              exam.examDate.day,
              hour,
              minute,
            );

            // Schedule thông báo
            await reminderService.scheduleExamReminder(
              id: exam.examDate.millisecondsSinceEpoch ~/ 1000 + i,
              subjectName: exam.subjectName,
              room: exam.room,
              examTime: examTime,
            );
          }
        }
      }

      await schedulesBox.close();
      await examsBox.close();

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
      isInDebugMode: true,
    );
  }

  // Đăng ký các background tasks
  Future<void> registerTasks() async {
    // NOTE: Chỉ đăng ký exam reminder task
    // Schedule notifications được xử lý trực tiếp trong ScheduleProvider
    
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
