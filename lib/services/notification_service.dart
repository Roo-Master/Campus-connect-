import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  NotificationService() {
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Assignment Due Tomorrow',
        message: 'Your Data Structures assignment is due tomorrow.',
        type: NotificationType.assignment,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        title: 'Mid-Sem Exam Schedule Released',
        message: 'Check the portal for your updated exam timetable.',
        type: NotificationType.academic,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: '3',
        title: 'Tech Fest Registration Open',
        message: 'Register now for Tech Fest 2024.',
        type: NotificationType.event,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '4',
        title: 'Grades Posted',
        message: 'Your OOP results have been published.',
        type: NotificationType.grades,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] =
          _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] =
          _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}