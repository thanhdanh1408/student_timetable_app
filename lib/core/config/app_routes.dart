import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_timetable_app/features/authentication/presentation/pages/login_page.dart';
import 'package:student_timetable_app/features/authentication/presentation/pages/register_page.dart';
import 'package:student_timetable_app/features/home/presentation/pages/home_page.dart';  // Thêm
import 'package:student_timetable_app/features/subjects/presentation/pages/subjects_page.dart';
import 'package:student_timetable_app/shared/widgets/placeholder_page.dart';  // Thêm

// Bottom Nav Shell
ShellRoute bottomNavShell() {
  return ShellRoute(
    builder: (context, state, child) {
      return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Môn học'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch học'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Lịch thi'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
          ],
          currentIndex: _calculateSelectedIndex(state.uri.path),
          onTap: (int index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/subjects',
        builder: (context, state) => const SubjectsPage(),
      ),
      // Thêm route cho lịch học, lịch thi, etc. sau
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const PlaceholderPage(title: 'Lịch học'),
      ),
      GoRoute(
        path: '/exams',
        builder: (context, state) => const PlaceholderPage(title: 'Lịch thi'),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const PlaceholderPage(title: 'Thông báo'),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const PlaceholderPage(title: 'Cài đặt'),
      ),
    ],
  );
}

int _calculateSelectedIndex(String path) {
  if (path == '/subjects') return 1;
  if (path == '/schedule') return 2;
  if (path == '/exams') return 3;
  if (path == '/notifications') return 4;
  if (path == '/settings') return 5;
  return 0;  // Default home
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      GoRouter.of(context).go('/home');
      break;
    case 1:
      GoRouter.of(context).go('/subjects');
      break;
    case 2:
      GoRouter.of(context).go('/schedule');
      break;
    case 3:
      GoRouter.of(context).go('/exams');
      break;
    case 4:
      GoRouter.of(context).go('/notifications');
      break;
    case 5:
      GoRouter.of(context).go('/settings');
      break;
  }
}

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    bottomNavShell(),  // Wrap các route sau auth
  ],
);