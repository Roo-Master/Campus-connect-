import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/grade_model.dart';
import '../../widgets/grade_card.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int _selectedSemester = 0;
  final List<String> _semesters = ['All', 'Fall 2024', 'Spring 2024', 'Fall 2023'];

  @override
  Widget build(BuildContext context) {
    final grades = GradeModel.getMockGrades();
    final cgpa = GradeModel.calculateCGPA(grades);
    final performanceData = GradeModel.getPerformanceData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades & Performance'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCGPAHeader(cgpa),
            _buildPerformanceChart(performanceData),
            _buildSemesterFilter(),
            _buildGradesList(grades),
          ],
        ),
      ),
    );
  }

  Widget _buildCGPAHeader(double cgpa) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Current CGPA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cgpa.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('Credits', '85/160'),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStat('Courses', '6/8'),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStat('Grade', 'A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart(List<double> data) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Trend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.asMap().entries.map((entry) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: entry.value >= 9.0
                                ? Colors.green
                                : entry.value >= 8.0
                                ? Colors.blue
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: entry.value * 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'S${entry.key + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _semesters.asMap().entries.map((entry) {
          final isSelected = _selectedSemester == entry.key;
          return GestureDetector(
            onTap: () => setState(() => _selectedSemester = entry.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGradesList(List<GradeModel> grades) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: grades.map((grade) => GradeCard(grade: grade)).toList(),
      ),
    );
  }
}