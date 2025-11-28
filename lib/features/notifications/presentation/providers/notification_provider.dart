// lib/features/notifications/presentation/providers/notification_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/add_notification_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';

class NotificationProvider with ChangeNotifier {
  final GetNotificationsUsecase _getUsecase;
  final AddNotificationUsecase _addUsecase;
  final DeleteNotificationUsecase _deleteUsecase;

  List<NotificationEntity> _notifications = [];
  String? _error;
  bool _isLoading = false;

  NotificationProvider({
    required GetNotificationsUsecase get,
    required AddNotificationUsecase add,
    required DeleteNotificationUsecase delete,
  })  : _getUsecase = get,
        _addUsecase = add,
        _deleteUsecase = delete;

  List<NotificationEntity> get notifications => _notifications;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _notifications = await _getUsecase();
      // Sort by date descending (newest first)
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(NotificationEntity notification) async {
    try {
      await _addUsecase(notification);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(int index) async {
    try {
      await _deleteUsecase(index);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(int index) async {
    try {
      if (index < _notifications.length) {
        // For now, just delete old notification after reading
        await delete(index);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
