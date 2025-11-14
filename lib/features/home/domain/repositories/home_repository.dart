import 'package:student_timetable_app/features/home/domain/entities/home_summary_entity.dart';

abstract class HomeRepository {
  Future<HomeSummaryEntity> getSummary();
}