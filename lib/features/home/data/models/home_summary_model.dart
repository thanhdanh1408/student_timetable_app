import 'package:student_timetable_app/features/home/domain/entities/home_summary_entity.dart';

class HomeSummaryModel extends HomeSummaryEntity {
  HomeSummaryModel({
    required int subjectCount,
    required int scheduleCount,
    required int examCount,
    required int notificationCount,
    required List<String> todaySchedules,
    required List<String> upcomingExams,
  }) : super(
          subjectCount: subjectCount,
          scheduleCount: scheduleCount,
          examCount: examCount,
          notificationCount: notificationCount,
          todaySchedules: todaySchedules,
          upcomingExams: upcomingExams,
        );

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return HomeSummaryModel(
      subjectCount: json['subject_count'],
      scheduleCount: json['schedule_count'],
      examCount: json['exam_count'],
      notificationCount: json['notification_count'],
      todaySchedules: List<String>.from(json['today_schedules']),
      upcomingExams: List<String>.from(json['upcoming_exams']),
    );
  }
}