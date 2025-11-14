import 'package:student_timetable_app/features/home/domain/entities/home_summary_entity.dart';
import 'package:student_timetable_app/features/home/domain/repositories/home_repository.dart';
import 'package:student_timetable_app/features/subjects/data/repositories/subjects_repository_impl.dart';  // Singleton

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<HomeSummaryEntity> getSummary() async {
    await Future.delayed(const Duration(seconds: 1));  // Mock delay
    final subjectsRepo = SubjectsRepositoryImpl();  // Singleton, same instance
    final subjects = await subjectsRepo.getSubjects();
    return HomeSummaryEntity(
      subjectCount: subjects.length,  // Real từ shared _subjects
      scheduleCount: 2,  // Mock
      examCount: 0,  // Mock
      notificationCount: 0,  // Mock
      todaySchedules: ['Lập trình cơ bản - 15:00-16:30 - A2.201'],
      upcomingExams: ['Lập trình cơ bản - 28/10/2025 - A2.201'],
    );
  }
}