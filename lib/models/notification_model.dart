
enum NotificationType {
  academic,
  event,
  assignment,
  grades,
  announcement,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  static Future<List<NotificationModel>> getMockNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      NotificationModel(
        id: '1',
        title: 'Assignment Due Tomorrow',
        message: 'Your Data Structures assignment is due tomorrow at 11:59 PM.',
        type: NotificationType.assignment,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Mid-Semester Schedule Released',
        message: 'The mid-semester exam schedule has been published.',
        type: NotificationType.academic,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '3',
        title: 'Tech Fest Registration Open',
        message: 'Register now for Tech Fest 2024. Limited seats available!',
        type: NotificationType.event,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '4',
        title: 'Grades Posted',
        message: 'Your Object Oriented Programming results are available.',
        type: NotificationType.grades,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Library Maintenance Notice',
        message: 'The main library will be closed on Sunday from 6 AM to 12 PM.',
        type: NotificationType.announcement,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: false,
      ),
    ];
  }
}