import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_timetable_app/app.dart';
import 'package:student_timetable_app/features/authentication/presentation/providers/auth_provider.dart';
import 'package:student_timetable_app/features/home/presentation/providers/home_provider.dart';
import 'package:student_timetable_app/features/subjects/presentation/providers/subjects_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SubjectsProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}