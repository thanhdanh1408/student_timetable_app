import 'package:flutter/material.dart';
import 'package:student_timetable_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:student_timetable_app/features/home/domain/entities/home_summary_entity.dart';
import 'package:student_timetable_app/features/home/domain/usecases/get_home_summary_usecase.dart';

class HomeProvider with ChangeNotifier {
  final GetHomeSummaryUsecase getSummaryUsecase = GetHomeSummaryUsecase(HomeRepositoryImpl());

  HomeSummaryEntity? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  HomeSummaryEntity? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSummary() async {
    _isLoading = true;
    notifyListeners();
    try {
      _summary = await getSummaryUsecase();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}