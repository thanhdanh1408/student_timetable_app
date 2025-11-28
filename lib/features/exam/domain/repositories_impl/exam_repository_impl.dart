// lib/features/exam/domain/repositories_impl/exam_repository_impl.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../entities/exam_entity.dart';
import '../repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  static final ExamRepositoryImpl _instance = ExamRepositoryImpl._internal();
  factory ExamRepositoryImpl() => _instance;
  ExamRepositoryImpl._internal();

  static const String _boxName = 'exams_box';
  late Box<ExamEntity> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<ExamEntity>(_boxName);
    } else {
      _box = Hive.box<ExamEntity>(_boxName);
    }
    _initialized = true;
  }

  @override
  Future<List<ExamEntity>> getAll() async {
    await init();
    return _box.values.toList()..sort((a, b) => a.examDate.compareTo(b.examDate));
  }

  @override
  Future<void> add(ExamEntity exam) async {
    await init();
    final newId = _box.isEmpty ? 1 : (_box.values.last.id ?? 0) + 1;
    await _box.add(exam.copyWith(id: newId));
  }

  @override
  Future<void> update(ExamEntity exam) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == exam.id);
    if (index != -1) await _box.putAt(index, exam);
  }

  @override
  Future<void> delete(int id) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) await _box.deleteAt(index);
  }
}