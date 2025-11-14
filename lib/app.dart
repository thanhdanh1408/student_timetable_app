import 'package:flutter/material.dart';
import 'package:student_timetable_app/core/config/app_routes.dart';
import 'package:student_timetable_app/core/config/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Timetable App',
      theme: appLightTheme,  // Từ app_theme.dart, hỗ trợ dark mode sau
      routerConfig: appRouter,  // Từ app_routes.dart
      debugShowCheckedModeBanner: false,
    );
  }
}