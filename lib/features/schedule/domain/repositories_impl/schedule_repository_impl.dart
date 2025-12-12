// lib/features/schedule/domain/repositories_impl/schedule_repository_impl.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  static final ScheduleRepositoryImpl _instance = ScheduleRepositoryImpl._internal();
  factory ScheduleRepositoryImpl() => _instance;
  ScheduleRepositoryImpl._internal();

  static const String _boxName = 'schedules_box';
  late Box<ScheduleEntity> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<ScheduleEntity>(_boxName);
    } else {
      _box = Hive.box<ScheduleEntity>(_boxName);
    }
    _initialized = true;
  }

  @override
  Future<List<ScheduleEntity>> getAll() async {
    await init();
    return _box.values.toList();
  }

  @override
  Future<int> add(ScheduleEntity schedule) async {
    await init();
    final newId = _box.isEmpty ? 1 : (_box.values.last.id ?? 0) + 1;
    await _box.add(schedule.copyWith(id: newId));
    return newId;
  }

  @override
  Future<void> update(ScheduleEntity schedule) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == schedule.id);
    if (index != -1) await _box.putAt(index, schedule);
  }

  @override
  Future<void> delete(int id) async {
    await init();
    final index = _box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) await _box.deleteAt(index);
  }
}