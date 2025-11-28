// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter/material.dart';
import '/features/subjects/presentation/providers/subjects_provider.dart';
import '/features/schedule/presentation/providers/schedule_provider.dart';
import '/features/exam/presentation/providers/exam_provider.dart';

class HomeSummary {
  final int subjectCount;
  final int scheduleTodayCount;
  final int upcomingExamCount;
  final int notificationCount;
  final List<String> todaySchedules;
  final List<String> upcomingExams;

  HomeSummary({
    required this.subjectCount,
    required this.scheduleTodayCount,
    required this.upcomingExamCount,
    required this.notificationCount,
    required this.todaySchedules,
    required this.upcomingExams,
  });
}

class HomeProvider with ChangeNotifier {
  bool _isLoading = false;
  HomeSummary? _summary;

  final SubjectsProvider? _subjectsProvider;
  final ScheduleProvider? _scheduleProvider;
  final ExamProvider? _examProvider;

  bool get isLoading => _isLoading;
  HomeSummary? get summary => _summary;

  HomeProvider({
    SubjectsProvider? subjectsProvider,
    ScheduleProvider? scheduleProvider,
    ExamProvider? examProvider,
  })  : _subjectsProvider = subjectsProvider,
        _scheduleProvider = scheduleProvider,
        _examProvider = examProvider {
    // Listen to changes from other providers to auto-reload
    _subjectsProvider?.addListener(_onProviderChange);
    _scheduleProvider?.addListener(_onProviderChange);
    _examProvider?.addListener(_onProviderChange);
  }

  void _onProviderChange() {
    // Auto-reload summary when dependent providers change
    loadSummary();
  }

  @override
  void dispose() {
    _subjectsProvider?.removeListener(_onProviderChange);
    _scheduleProvider?.removeListener(_onProviderChange);
    _examProvider?.removeListener(_onProviderChange);
    super.dispose();
  }

  Future<void> loadSummary() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kiểm tra providers có được set chưa
      if (_subjectsProvider == null || _scheduleProvider == null || _examProvider == null) {
        throw Exception("Providers chưa được khởi tạo");
      }

      // Lấy data hiện tại từ các provider (không load lại để tránh vòng lặp)
      final subjects = _subjectsProvider!.subjects;
      final schedules = _scheduleProvider!.schedules;
      final exams = _examProvider!.exams;

      // Filter: hôm nay (so sánh dayOfWeek as integer)
      final now = DateTime.now();
      final todayDayOfWeek = now.weekday; // 1=Mon, 2=Tue, ..., 7=Sun
      
      // Chuyển dayOfWeek: schedule dùng 1-7 (ISO), subjects dùng 2-8, nên cần check cả 2
      final todaySchedules = schedules
          .where((s) => s.dayOfWeek == todayDayOfWeek || s.dayOfWeek == (todayDayOfWeek % 7) + 1)
          .map((s) => "${s.subjectName} • ${s.startTime} - ${s.endTime} • Phòng ${s.room}")
          .toList();

      // Filter: kỳ thi sắp tới (3 ngày)
      final upcomingExams = exams.where((e) {
        try {
          final diff = e.examDate.difference(now).inDays;
          return diff >= 0 && diff <= 3;
        } catch (_) {
          return false;
        }
      }).map((e) => "${e.subjectName} - ${e.examDate.toString().split(' ')[0]}").toList();

      _summary = HomeSummary(
        subjectCount: subjects.length,
        scheduleTodayCount: todaySchedules.length,
        upcomingExamCount: upcomingExams.length,
        notificationCount: todaySchedules.length + upcomingExams.length,
        todaySchedules: todaySchedules,
        upcomingExams: upcomingExams,
      );
    } catch (e) {
      // Fallback nếu có lỗi
      _summary = HomeSummary(
        subjectCount: 0,
        scheduleTodayCount: 0,
        upcomingExamCount: 0,
        notificationCount: 0,
        todaySchedules: [],
        upcomingExams: [],
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}