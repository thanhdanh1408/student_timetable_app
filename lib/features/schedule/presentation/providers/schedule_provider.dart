// lib/features/schedule/presentation/providers/schedule_provider.dart
import 'package:flutter/material.dart';
import '../../../../core/services/reminder_service.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/add_schedule_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';

class ScheduleProvider with ChangeNotifier {
  final GetSchedulesUsecase _get;
  final AddScheduleUsecase _add;
  final UpdateScheduleUsecase _update;
  final DeleteScheduleUsecase _delete;
  final ReminderService _reminderService;

  ScheduleProvider({
    required GetSchedulesUsecase get,
    required AddScheduleUsecase add,
    required UpdateScheduleUsecase update,
    required DeleteScheduleUsecase delete,
    required ReminderService reminderService,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete,
        _reminderService = reminderService;
  // Don't call load() here - wait for page to initialize

  List<ScheduleEntity> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleEntity> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _schedules = await _get();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ScheduleEntity s) async {
    try {
      print('📝 Adding new schedule: ${s.subjectName}');
      final newId = await _add(s);
      print('✅ Schedule added with ID: $newId');
      
      await _reminderService.scheduleClassReminder(
        id: newId,
        subjectName: s.subjectName,
        room: s.room,
        dayOfWeek: s.dayOfWeek,
        startTime: s.startTime,
      );
      
      await load();
    } catch (e) {
      _error = e.toString();
      print('❌ Error adding schedule: $e');
      notifyListeners();
    }
  }

  Future<void> update(ScheduleEntity s) async {
    try {
      await _update(s);
      if (s.id != null) {
        await _reminderService.scheduleClassReminder(
          id: s.id!,
          subjectName: s.subjectName,
          room: s.room,
          dayOfWeek: s.dayOfWeek,
          startTime: s.startTime,
        );
      }
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _delete(id);
      await _reminderService.cancelReminder(id);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
