// lib/features/exam/presentation/providers/exam_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/usecases/get_exams_usecase.dart';
import '../../domain/usecases/add_exam_usecase.dart';
import '../../domain/usecases/update_exam_usecase.dart';
import '../../domain/usecases/delete_exam_usecase.dart';

class ExamProvider with ChangeNotifier {
  final GetExamsUsecase _get;
  final AddExamUsecase _add;
  final UpdateExamUsecase _update;
  final DeleteExamUsecase _delete;

  ExamProvider({
    required GetExamsUsecase get,
    required AddExamUsecase add,
    required UpdateExamUsecase update,
    required DeleteExamUsecase delete,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete;
  // Don't call load() here - wait for page to initialize

  List<ExamEntity> _exams = [];
  bool _isLoading = false;
  String? _error;

  List<ExamEntity> get exams => _exams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _exams = await _get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ExamEntity e) async {
    try {
      await _add(e);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(ExamEntity e) async {
    try {
      await _update(e);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _delete(id);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}