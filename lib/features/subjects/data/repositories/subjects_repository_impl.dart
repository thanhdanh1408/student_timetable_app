import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/domain/repositories/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  static final SubjectsRepositoryImpl _instance = SubjectsRepositoryImpl._internal();

  factory SubjectsRepositoryImpl() {
    return _instance;
  }

  SubjectsRepositoryImpl._internal();

  List<SubjectEntity> _subjects = [
    SubjectEntity(subjectId: 1, name: 'Lập trình cơ bản', credit: 3, teacher: 'TS. Nguyễn Thị Liên', room: 'HK1.2024-2025'),
  ];

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_subjects);
  }

  @override
  Future<void> addSubject(SubjectEntity subject) async {
    await Future.delayed(const Duration(seconds: 1));
    final newId = _subjects.isEmpty ? 1 : _subjects.last.subjectId! + 1;
    _subjects.add(subject.copyWith(subjectId: newId));
  }

  @override
  Future<void> editSubject(SubjectEntity subject) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _subjects.indexWhere((s) => s.subjectId == subject.subjectId);
    if (index != -1) {
      _subjects[index] = subject;
    } else {
      throw Exception('Subject not found');
    }
  }

  @override
  Future<void> deleteSubject(int subjectId) async {
    await Future.delayed(const Duration(seconds: 1));
    _subjects.removeWhere((s) => s.subjectId == subjectId);
  }
}

extension on SubjectEntity {
  SubjectEntity copyWith({
    int? subjectId,
    String? name,
    int? credit,
    String? teacher,
    String? room,
  }) {
    return SubjectEntity(
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      credit: credit ?? this.credit,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
    );
  }
}