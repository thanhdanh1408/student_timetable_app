// lib/features/home/domain/repositories_impl/home_repository_impl.dart
import '../../../../features/subjects/domain/repositories_impl/subjects_repository_impl.dart';
import '../../../../features/schedule/domain/repositories_impl/schedule_repository_impl.dart';
import '../entities/home_summary_entity.dart';
import '../repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<HomeSummaryEntity> getSummary() async {
    final subjects = await SubjectsRepositoryImpl().getAll();
    final allSchedules = await ScheduleRepositoryImpl().getAll();

    // Hôm nay là thứ mấy? (2=Thứ 2, ..., 8=CN)
    final todayWeekday = DateTime.now().weekday == 7 ? 8 : DateTime.now().weekday + 1;

    final todaySchedules = allSchedules
        .where((s) => s.dayOfWeek == todayWeekday)
        .map((s) => "${s.subjectName} • ${s.startTime}-${s.endTime} • ${s.room}")
        .toList();

    final upcomingExams = <String>["Chưa có lịch thi"]; // Sẽ làm sau

    return HomeSummaryEntity(
      subjectCount: subjects.length,
      scheduleTodayCount: todaySchedules.length,
      upcomingExamCount: upcomingExams.length - 1,
      notificationCount: 0,
      todaySchedules: todaySchedules.isEmpty ? ["Hôm nay không có tiết học"] : todaySchedules,
      upcomingExams: upcomingExams,
    );
  }
}