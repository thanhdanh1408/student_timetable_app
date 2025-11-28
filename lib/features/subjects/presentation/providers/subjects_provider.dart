// lib/features/subjects/presentation/providers/subjects_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/add_subject_usecase.dart';
import '../../domain/usecases/update_subject_usecase.dart';
import '../../domain/usecases/delete_subject_usecase.dart';

class SubjectsProvider with ChangeNotifier {
  final GetSubjectsUsecase _get;
  final AddSubjectUsecase _add;
  final UpdateSubjectUsecase _update;
  final DeleteSubjectUsecase _delete;

  SubjectsProvider({
    required GetSubjectsUsecase get,
    required AddSubjectUsecase add,
    required UpdateSubjectUsecase update,
    required DeleteSubjectUsecase delete,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete;
  // Don't call load() here - wait for page to initialize

  List<SubjectEntity> _subjects = [];
  bool _isLoading = false;
  String? _error;

  List<SubjectEntity> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await _get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(SubjectEntity s) async {
    try {
      await _add(s);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(SubjectEntity s) async {
    try {
      await _update(s);
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