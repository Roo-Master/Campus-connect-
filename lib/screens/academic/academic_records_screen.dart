import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../models/grade_model.dart';

class AcademicRecordsScreen extends StatelessWidget {
  const AcademicRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grades = GradeModel.getMockGrades();
    final cgpa = GradeModel.calculateCGPA(grades);

    // Group grades by semester + year
    Map<String, List<GradeModel>> groupedGrades = {};

    for (var grade in grades) {
      final key = "${grade.semester} ${grade.academicYear}";
      if (!groupedGrades.containsKey(key)) {
        groupedGrades[key] = [];
      }
      groupedGrades[key]!.add(grade);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Records"),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCGPACard(cgpa),
            const SizedBox(height: 16),
            ...groupedGrades.entries.map(
              (entry) => _buildSemesterSection(entry.key, entry.value),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // CGPA CARD
  Widget _buildCGPACard(double cgpa) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Current CGPA",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cgpa.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SEMESTER SECTION
  Widget _buildSemesterSection(String title, List<GradeModel> grades) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...grades.map((grade) => _buildGradeTile(grade)),
            ],
          ),
        ),
      ),
    );
  }

  // GRADE TILE
  Widget _buildGradeTile(GradeModel grade) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: grade.gradeColor.withOpacity(0.15),
        child: Text(
          grade.courseCode.substring(0, 2),
          style: TextStyle(
            color: grade.gradeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        grade.courseName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${grade.courseCode} • ${grade.credit} Credits\n"
        "Internal: ${grade.internalMarks}  |  External: ${grade.externalMarks}",
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: grade.gradeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grade.grade,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            grade.gradePoint.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
