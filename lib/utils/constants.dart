class AppConstants {
  // App Info
  static const String appName = 'Campus Connect';
  static const String appVersion = '1.0.0';
  static const String appId = 'com.campusconnect.app';

  // API Endpoints (placeholder)
  static const String baseUrl = 'https://api.campusconnect.edu';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String themeMode = 'theme_mode';
  static const String notificationsEnabled = 'notifications_enabled';

  // Default Values
  static const int defaultPageSize = 20;
  static const int cacheExpiryMinutes = 60;

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int initialPage = 1;
  static const int pageSize = 10;
}

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';

  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';

  static const String courses = '/courses';
  static const String enrolledCourses = '/courses/enrolled';
  static const String courseRegistration = '/courses/register';

  static const String grades = '/grades';
  static const String cgpa = '/grades/cgpa';

  static const String events = '/events';
  static const String eventRegistration = '/events/register';

  static const String notifications = '/notifications';
  static const String marksAsRead = '/notifications/read';

  static const String buildings = '/buildings';
  static const String directions = '/directions';

  static const String fees = '/fees';
  static const String payment = '/fees/payment';

  static const String transport = '/transport';
  static const String busTracking = '/transport/bus';
}