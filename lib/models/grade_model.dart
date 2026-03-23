import 'package:flutter/material.dart';

class GradeModel with ChangeNotifier {
  final String id;
  final String courseId;
  final String courseCode;
  final String courseName;
  final double credit;
  final double internalMarks;
  final double externalMarks;
  final double totalMarks;
  final String grade;
  final double gradePoint;
  final String semester;
  final String academicYear;

  GradeModel({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.credit,
    required this.internalMarks,
    required this.externalMarks,
    required this.totalMarks,
    required this.grade,
    required this.gradePoint,
    required this.semester,
    required this.academicYear,
  });

  // Calculate CGPA
  static double calculateCGPA(List<GradeModel> grades) {
    if (grades.isEmpty) return 0.0;
    double totalPoints = 0;
    double totalCredits = 0;
    for (var grade in grades) {
      totalPoints += grade.gradePoint * grade.credit;
      totalCredits += grade.credit;
    }
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  // Get grade color
  Color get gradeColor {
    if (gradePoint >= 9.0) return Colors.green;
    if (gradePoint >= 7.0) return Colors.blue;
    if (gradePoint >= 5.0) return Colors.orange;
    return Colors.red;
  }

  // Mock Data
  static List<GradeModel> getMockGrades() {
    return [
      // Current Semester (In Progress)
      GradeModel(
        id: 'g001',
        courseId: 'cs301',
        courseCode: 'CS301',
        courseName: 'Data Structures & Algorithms',
        credit: 4,
        internalMarks: 85,
        externalMarks: 0,
        totalMarks: 85,
        grade: 'A',
        gradePoint: 9.0,
        semester: 'Fall',
        academicYear: '2024',
      ),
      GradeModel(
        id: 'g002',
        courseId: 'cs302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        credit: 3,
        internalMarks: 78,
        externalMarks: 0,
        totalMarks: 78,
        grade: 'B+',
        gradePoint: 8.0,
        semester: 'Fall',
        academicYear: '2024',
      ),
      // Previous Semester
      GradeModel(
        id: 'g003',
        courseId: 'cs201',
        courseCode: 'CS201',
        courseName: 'Object Oriented Programming',
        credit: 4,
        internalMarks: 92,
        externalMarks: 88,
        totalMarks: 180,
        grade: 'O',
        gradePoint: 10.0,
        semester: 'Spring',
        academicYear: '2024',
      ),
      GradeModel(
        id: 'g004',
        courseId: 'cs202',
        courseCode: 'CS202',
        courseName: 'Digital Logic Design',
        credit: 3,
        internalMarks: 75,
        externalMarks: 82,
        totalMarks: 157,
        grade: 'A',
        gradePoint: 9.0,
        semester: 'Spring',
        academicYear: '2024',
      ),
      GradeModel(
        id: 'g005',
        courseId: 'mth201',
        courseCode: 'MTH201',
        courseName: 'Discrete Mathematics',
        credit: 4,
        internalMarks: 88,
        externalMarks: 90,
        totalMarks: 178,
        grade: 'O',
        gradePoint: 10.0,
        semester: 'Spring',
        academicYear: '2024',
      ),
      GradeModel(
        id: 'g006',
        courseId: 'cs205',
        courseCode: 'CS205',
        courseName: 'Computer Organization',
        credit: 3,
        internalMarks: 70,
        externalMarks: 75,
        totalMarks: 145,
        grade: 'B+',
        gradePoint: 8.0,
        semester: 'Spring',
        academicYear: '2024',
      ),
    ];
  }

  // Performance data for charts
  static List<double> getPerformanceData() {
    return [8.5, 9.0, 8.8, 9.2, 9.0, 8.8]; // Last 6 semesters
  }
}