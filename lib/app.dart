import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
import 'core/services/notification_service.dart';
import 'core/services/background_task_handler.dart';

// AppWidget class moved from main.dart
class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Khởi tạo notification service
      final notificationService = NotificationService();
      await notificationService.initialize();

      // Khởi tạo background task handler
      final backgroundHandler = BackgroundTaskHandler();
      await backgroundHandler.init();
      await backgroundHandler.registerTasks();
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get router from AppRoutes
    final router = AppRoutes.router;

    return MaterialApp.router(
      title: 'Student Timetable',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: router,
    );
  }
}
