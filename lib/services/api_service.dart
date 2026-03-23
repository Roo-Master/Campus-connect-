import 'package:flutter/widgets.dart';

import '../models/course_model.dart';
import '../models/event_model.dart';
import '../models/grade_model.dart';
import '../models/notification_model.dart';
import '../models/building_model.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Mock delay to simulate network request
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // User APIs
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    await _simulateNetworkDelay();
    return {
      'success': true,
      'data': {
        'id': userId,
        'name': getUserProfile(AutofillHints.username),
        'email': getUserProfile(AutofillHints.email),
      }
    };
  }

  // Course APIs
  Future<List<CourseModel>> getAvailableCourses(String courselistId) async {
    await _simulateNetworkDelay();
    return CourseModel.getMockCourses();
  }

  Future<List<CourseModel>> getEnrolledCourses(String courseId) async {
    await _simulateNetworkDelay();
    return CourseModel.getEnrolledCourses();
  }

  Future<CourseModel?> getCourseDetails(String courseId) async {
    await _simulateNetworkDelay();
    final courses = CourseModel.getMockCourses();
    try {
      return courses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerCourse(String courseId) async {
    await _simulateNetworkDelay();
    return true;
  }

  Future<bool> dropCourse(String courseId) async {
    await _simulateNetworkDelay();
    return true;
  }

  // Grade APIs
  Future<List<GradeModel>> getGrades() async {
    await _simulateNetworkDelay();
    return GradeModel.getMockGrades();
  }

  Future<double> getCGPA() async {
    await _simulateNetworkDelay();
    final grades = GradeModel.getMockGrades();
    return GradeModel.calculateCGPA(grades);
  }

  // Event APIs
  Future<List<EventModel>> getUpcomingEvents() async {
    await _simulateNetworkDelay();
    return EventModel.getMockEvents();
  }

  Future<List<EventModel>> getTodayEvents() async {
    await _simulateNetworkDelay();
    return EventModel.getTodayEvents();
  }

  Future<EventModel?> getEventDetails(String eventId) async {
    await _simulateNetworkDelay();
    final events = EventModel.getMockEvents();
    try {
      return events.firstWhere((e) => e.id == eventId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerForEvent(String eventId) async {
    await _simulateNetworkDelay();
    return true;
  }

  // Notification APIs
  Future<List<NotificationModel>> getNotifications() async {
    await _simulateNetworkDelay();
    return NotificationModel.getMockNotifications();
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    await _simulateNetworkDelay();
    return true;
  }

  Future<bool> markAllNotificationsAsRead() async {
    await _simulateNetworkDelay();
    return true;
  }

  // Building/Map APIs
  Future<List<BuildingModel>> getBuildings( String buildinglistId) async {
    await _simulateNetworkDelay();
    return BuildingModel.getMockBuildings();
  }

  Future<BuildingModel?> getBuildingDetails(String buildingId) async {
    await _simulateNetworkDelay();
    final buildings = BuildingModel.getMockBuildings();
    try {
      return buildings.firstWhere((b) => b.id == buildingId);
    } catch (e) {
      return null;
    }
  }

  // Campus APIs
  Future<Map<String, dynamic>> getCampusAnnouncements() async {
    await _simulateNetworkDelay();
    return {
      'success': true,
      'announcements': [
        {'id': 1, 'title': 'Campus Closed for Maintenance', 'date': 'Oct 15'},
        {'id': 2, 'title': 'New Library Hours', 'date': 'Oct 10'},
      ]
    };
  }

  Future<List<Map<String, dynamic>>> getTransportRoutes() async {
    await _simulateNetworkDelay();
    return [
      {'id': 1, 'name': 'Route A - Main Gate to Hostel', 'nextArrival': '5 mins'},
      {'id': 2, 'name': 'Route B - Library to Canteen', 'nextArrival': '3 mins'},
      {'id': 3, 'name': 'Route C - Parking to Block A', 'nextArrival': '8 mins'},
    ];
  }

  Future<Map<String, dynamic>> getFeeDetails() async {
    await _simulateNetworkDelay();
    return {
      'tuition': 5000.0,
      'hostel': 1500.0,
      'mess': 1200.0,
      'total': 7700.0,
      'paid': 7700.0,
      'due': 0.0,
      'status': 'Paid',
    };
  }

  Future<List<Map<String, dynamic>>> getHostelDetails() async {
    await _simulateNetworkDelay();
    return [
      {'block': 'A', 'room': '305', 'floor': 3, 'status': 'Allotted'},
      {'mess': 'North Mess', 'mealPlan': 'Full Board'},
    ];
  }

  Future<List<Map<String, dynamic>>> getHealthRecords() async {
    await _simulateNetworkDelay();
    return [
      {'date': 'Oct 1, 2024', 'type': 'General Checkup', 'doctor': 'Dr. Smith', 'status': 'Completed'},
      {'date': 'Sep 15, 2024', 'type': 'Dental Checkup', 'doctor': 'Dr. Johnson', 'status': 'Completed'},
    ];
  }
}