import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';

// AppWidget class moved from main.dart
class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
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
