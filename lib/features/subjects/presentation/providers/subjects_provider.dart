import 'package:flutter/material.dart';
import 'package:student_timetable_app/features/subjects/data/repositories/subjects_repository_impl.dart';
import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/domain/usecases/add_subject_usecase.dart';
import 'package:student_timetable_app/features/subjects/domain/usecases/delete_subject_usecase.dart';
import 'package:student_timetable_app/features/subjects/domain/usecases/edit_subject_usecase.dart';
import 'package:student_timetable_app/features/subjects/domain/usecases/get_subjects_usecase.dart';

class SubjectsProvider with ChangeNotifier {
  final GetSubjectsUsecase getUsecase = GetSubjectsUsecase(SubjectsRepositoryImpl());
  final AddSubjectUsecase addUsecase = AddSubjectUsecase(SubjectsRepositoryImpl());
  final EditSubjectUsecase editUsecase = EditSubjectUsecase(SubjectsRepositoryImpl());
  final DeleteSubjectUsecase deleteUsecase = DeleteSubjectUsecase(SubjectsRepositoryImpl());

  List<SubjectEntity> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SubjectEntity> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await getUsecase();
      print('Fetched ${_subjects.length} subjects');  // Debug console
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSubject(SubjectEntity subject) async {
    try {
      await addUsecase(subject);
      await fetchSubjects();
      print('Added subject: ${subject.name}');  // Debug
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> editSubject(SubjectEntity subject) async {
    try {
      await editUsecase(subject);
      await fetchSubjects();
      print('Edited subject ID: ${subject.subjectId}');  // Debug
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteSubject(int subjectId) async {
    try {
      await deleteUsecase(subjectId);
      await fetchSubjects();
      print('Deleted subject ID: $subjectId');  // Debug
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}