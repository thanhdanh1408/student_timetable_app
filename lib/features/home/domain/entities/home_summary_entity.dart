class HomeSummaryEntity {
  final int subjectCount;
  final int scheduleCount;
  final int examCount;
  final int notificationCount;
  final List<String> todaySchedules;
  final List<String> upcomingExams;

  HomeSummaryEntity({
    required this.subjectCount,
    required this.scheduleCount,
    required this.examCount,
    required this.notificationCount,
    required this.todaySchedules,
    required this.upcomingExams,
  });
}