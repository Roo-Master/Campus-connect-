import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect/services/api_service.dart';
import 'package:campus_connect/models/grade_model.dart';

void main() {
  late ApiService apiService;

  setUp(() {
    apiService = ApiService();
  });

  group('ApiService Tests', () {

    test('getAvailableCourses returns mock data', () async {
      final courses = await apiService.getAvailableCourses();

      expect(courses, isNotEmpty);
      expect(courses.length, 4);
    });

    test('getEnrolledCourses returns mock data', () async {
      final courses = await apiService.getEnrolledCourses();

      expect(courses, isNotEmpty);
    });

    test('getUpcomingEvents returns mock data', () async {
      final events = await apiService.getUpcomingEvents();

      expect(events, isNotEmpty);
    });

    test('getGrades returns mock data', () async {
      final grades = await apiService.getGrades();

      expect(grades, isNotEmpty);
    });

    test('calculateCGPA returns correct value', () async {
      final grades = await apiService.getGrades();

      final cgpa = GradeModel.calculateCGPA(grades);

      expect(cgpa, greaterThan(0));
      expect(cgpa, lessThanOrEqualTo(10));
    });

  });
}