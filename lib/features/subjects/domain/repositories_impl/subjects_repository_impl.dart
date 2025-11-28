// lib/features/subjects/domain/repositories_impl/subjects_repository_impl.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../entities/subject_entity.dart';
import '../repositories/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  static final SubjectsRepositoryImpl _instance = SubjectsRepositoryImpl._internal();
  factory SubjectsRepositoryImpl() => _instance;
  SubjectsRepositoryImpl._internal();

  static const String _boxName = 'subjects_box';
  late Box<SubjectEntity> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<SubjectEntity>(_boxName);
    } else {
      _box = Hive.box<SubjectEntity>(_boxName);
    }
    _initialized = true;
  }

  @override
  Future<List<SubjectEntity>> getAll() async {
    await init();
    return _box.values.toList();
  }

  @override
  Future<void> add(SubjectEntity subject) async {
    await init();
    final newId = _box.isEmpty ? 1 : (_box.values.last.id ?? 0) + 1;
    await _box.add(subject.copyWith(id: newId));
  }

  @override
  Future<void> update(SubjectEntity subject) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == subject.id);
    if (index != -1) {
      await _box.putAt(index, subject);
    }
  }

  @override
  Future<void> delete(int id) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }
}