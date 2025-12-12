// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

// Entities (Hive)
import 'features/subjects/domain/entities/subject_entity.dart';
import 'features/schedule/domain/entities/schedule_entity.dart';
import 'features/exam/domain/entities/exam_entity.dart';
import 'features/notifications/domain/entities/notification_entity.dart';
import 'features/settings/domain/entities/user_settings_entity.dart';

// Providers
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/subjects/presentation/providers/subjects_provider.dart';
import 'features/schedule/presentation/providers/schedule_provider.dart';
import 'features/exam/presentation/providers/exam_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'core/providers/notification_settings_provider.dart';

// Repository Impl (Hive)
import 'features/subjects/domain/repositories_impl/subjects_repository_impl.dart';
import 'features/schedule/domain/repositories_impl/schedule_repository_impl.dart';
import 'features/exam/domain/repositories_impl/exam_repository_impl.dart';
import 'features/notifications/domain/repositories_impl/notification_repository_impl.dart';
import 'features/settings/domain/repositories_impl/settings_repository_impl.dart';

// Usecases
import 'features/subjects/domain/usecases/get_subjects_usecase.dart';
import 'features/subjects/domain/usecases/add_subject_usecase.dart';
import 'features/subjects/domain/usecases/update_subject_usecase.dart';
import 'features/subjects/domain/usecases/delete_subject_usecase.dart';
import 'features/schedule/domain/usecases/get_schedules_usecase.dart';
import 'features/schedule/domain/usecases/add_schedule_usecase.dart';
import 'features/schedule/domain/usecases/update_schedule_usecase.dart';
import 'features/schedule/domain/usecases/delete_schedule_usecase.dart';
import 'features/exam/domain/usecases/get_exams_usecase.dart';
import 'features/exam/domain/usecases/add_exam_usecase.dart';
import 'features/exam/domain/usecases/update_exam_usecase.dart';
import 'features/exam/domain/usecases/delete_exam_usecase.dart';
import 'features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'features/notifications/domain/usecases/add_notification_usecase.dart';
import 'features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'features/settings/domain/usecases/get_settings_usecase.dart';
import 'features/settings/domain/usecases/save_settings_usecase.dart';
import 'utils/demo_data_initializer.dart';
import 'core/services/background_task_handler.dart';
import 'core/services/reminder_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Hive
  await Hive.initFlutter();

  // Đăng ký adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SubjectEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ScheduleEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ExamEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(NotificationEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(UserSettingsEntityAdapter());
  }

  // Mở Hive boxes
  await Hive.openBox('auth_user');
  await Hive.openBox<SubjectEntity>('subjects_box');
  await Hive.openBox<ScheduleEntity>('schedules_box');
  await Hive.openBox<ExamEntity>('exams_box');
  await Hive.openBox<NotificationEntity>('notifications_box');
  await Hive.openBox<UserSettingsEntity>('settings_box');

  // 2. Khởi tạo Repository (Hive)
  final subjectsRepo = SubjectsRepositoryImpl();
  final scheduleRepo = ScheduleRepositoryImpl();
  final examRepo = ExamRepositoryImpl();
  final notificationRepo = NotificationRepositoryImpl();
  final settingsRepo = SettingsRepositoryImpl();

  await subjectsRepo.init();
  await scheduleRepo.init();
  await examRepo.init();
  await notificationRepo.init();
  await settingsRepo.init();

  // Khởi tạo SharedPreferences và ReminderService
  final prefs = await SharedPreferences.getInstance();
  final reminderService = ReminderService(prefs);
  
  // Khởi tạo NotificationService
  final notificationService = NotificationService();
  await notificationService.init();

  // Initialize demo data if storage is empty
  await initializeDemoData();
  // Khởi tạo và đăng ký background tasks
  final backgroundTaskHandler = BackgroundTaskHandler();
  await backgroundTaskHandler.init();
  await backgroundTaskHandler.registerTasks();

  // 3. Khởi tạo Usecases
  final getSubjectsUsecase = GetSubjectsUsecase(subjectsRepo);
  final addSubjectUsecase = AddSubjectUsecase(subjectsRepo);
  final updateSubjectUsecase = UpdateSubjectUsecase(subjectsRepo);
  final deleteSubjectUsecase = DeleteSubjectUsecase(subjectsRepo);

  final getSchedulesUsecase = GetSchedulesUsecase(scheduleRepo);
  final addScheduleUsecase = AddScheduleUsecase(scheduleRepo);
  final updateScheduleUsecase = UpdateScheduleUsecase(scheduleRepo);
  final deleteScheduleUsecase = DeleteScheduleUsecase(scheduleRepo);

  final getExamsUsecase = GetExamsUsecase(examRepo);
  final addExamUsecase = AddExamUsecase(examRepo);
  final updateExamUsecase = UpdateExamUsecase(examRepo);
  final deleteExamUsecase = DeleteExamUsecase(examRepo);

  final getNotificationsUsecase = GetNotificationsUsecase(notificationRepo);
  final addNotificationUsecase = AddNotificationUsecase(notificationRepo);
  final deleteNotificationUsecase = DeleteNotificationUsecase(notificationRepo);

  final getSettingsUsecase = GetSettingsUsecase(settingsRepo);
  final saveSettingsUsecase = SaveSettingsUsecase(settingsRepo);

  // 4. Chạy app
  runApp(
    MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Notification Settings
        ChangeNotifierProvider(
          create: (_) {
            final provider = NotificationSettingsProvider();
            provider.init();
            return provider;
          },
        ),

        // Subjects
        ChangeNotifierProvider(
          create: (_) => SubjectsProvider(
            get: getSubjectsUsecase,
            add: addSubjectUsecase,
            update: updateSubjectUsecase,
            delete: deleteSubjectUsecase,
          )..load(), // Load data on creation
        ),

        // Schedule
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(
            get: getSchedulesUsecase,
            add: addScheduleUsecase,
            update: updateScheduleUsecase,
            delete: deleteScheduleUsecase,
            reminderService: reminderService,
          )..load(), // Load data on creation
        ),

        // Exam
        ChangeNotifierProvider(
          create: (_) => ExamProvider(
            get: getExamsUsecase,
            add: addExamUsecase,
            update: updateExamUsecase,
            delete: deleteExamUsecase,
          )..load(), // Load data on creation
        ),

        // Notifications
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            get: getNotificationsUsecase,
            add: addNotificationUsecase,
            delete: deleteNotificationUsecase,
            notificationService: notificationService,
          )..load(), // Load data on creation
        ),

        // Settings
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            get: getSettingsUsecase,
            save: saveSettingsUsecase,
          ),
        ),

        // Home - tạo với đầy đủ các provider khác
        ChangeNotifierProxyProvider3<SubjectsProvider, ScheduleProvider, ExamProvider, HomeProvider>(
          create: (_) => HomeProvider(
            subjectsProvider: null,
            scheduleProvider: null,
            examProvider: null,
          ),
          update: (_, subjectsProvider, scheduleProvider, examProvider, previousHomeProvider) =>
              HomeProvider(
            subjectsProvider: subjectsProvider,
            scheduleProvider: scheduleProvider,
            examProvider: examProvider,
          ),
        ),
      ],
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}
