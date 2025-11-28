import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/config/app_routes.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';

// AppWidget class moved from main.dart
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo router với AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final router = createAppRouter(authProvider);

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
