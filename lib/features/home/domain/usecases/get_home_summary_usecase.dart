import 'package:student_timetable_app/features/home/domain/entities/home_summary_entity.dart';
import 'package:student_timetable_app/features/home/domain/repositories/home_repository.dart';

class GetHomeSummaryUsecase {
  final HomeRepository repository;

  GetHomeSummaryUsecase(this.repository);

  Future<HomeSummaryEntity> call() async {
    return await repository.getSummary();
  }
}