// lib/features/home/domain/repositories/home_repository.dart
import '../entities/home_summary_entity.dart';

abstract class HomeRepository {
  Future<HomeSummaryEntity> getSummary();
}