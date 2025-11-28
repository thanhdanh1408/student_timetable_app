// lib/features/home/domain/entities/home_summary_entity.dart
class HomeSummaryEntity {
  final int subjectCount;
  final int scheduleTodayCount;
  final int upcomingExamCount;
  final int notificationCount;
  final List<String> todaySchedules;
  final List<String> upcomingExams;

  HomeSummaryEntity({
    required this.subjectCount,
    required this.scheduleTodayCount,
    required this.upcomingExamCount,
    required this.notificationCount,
    required this.todaySchedules,
    required this.upcomingExams,
  });
}