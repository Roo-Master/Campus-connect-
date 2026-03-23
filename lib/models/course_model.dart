import 'package:flutter/material.dart';

class CourseModel with ChangeNotifier {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final String instructorEmail;
  final String description;
  final int credits;
  final int totalstudents;
  final String schedule;
  final String location;
  final String building;
  final List<String> prerequisites;
  final List<String> syllabus;
  final String examDate;
  final String examTime;
  final String examLocation;
  final Color color;

  CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.instructor,
    required this.instructorEmail,
    required this.description,
    required this.credits,
    required this.totalstudents,
    required this.schedule,
    required this.location,
    required this.building,
    required this.prerequisites,
    required this.syllabus,
    required this.examDate,
    required this.examTime,
    required this.examLocation,
    this.color = Colors.blue,
  });

  // Mock Data
  static List<CourseModel> getMockCourses() {
    return [
      CourseModel(
        id: 'cs301',
        code: 'CS301',
        name: 'Data Structures & Algorithms',
        instructor: 'Dr. Sarah Smith',
        instructorEmail: 's.smith@campus.edu',
        description: 'Advanced study of data structures and algorithms including trees, graphs, sorting, and searching.',
        credits: 4,
        totalstudents: 120,
        schedule: 'Mon, Wed, Fri - 10:00 AM',
        location: 'Room 201',
        building: 'Engineering Block B',
        prerequisites: ['CS201', 'MATH101'],
        syllabus: ['Arrays & Linked Lists', 'Stacks & Queues', 'Trees', 'Graphs', 'Dynamic Programming'],
        examDate: 'Dec 15, 2024',
        examTime: '9:00 AM - 12:00 PM',
        examLocation: 'Main Auditorium',
        color: Colors.blue,
      ),
      CourseModel(
        id: 'cs302',
        code: 'CS302',
        name: 'Database Management Systems',
        instructor: 'Prof. Michael Brown',
        instructorEmail: 'm.brown@campus.edu',
        description: 'Introduction to database design, SQL, normalization, and transaction management.',
        credits: 3,
        totalstudents: 120,
        schedule: 'Tue, Thu - 2:00 PM',
        location: 'Lab 105',
        building: 'Engineering Block B',
        prerequisites: ['CS201'],
        syllabus: ['ER Diagrams', 'SQL', 'Normalization', 'Transactions', 'NoSQL'],
        examDate: 'Dec 18, 2024',
        examTime: '2:00 PM - 5:00 PM',
        examLocation: 'Room 301',
        color: Colors.green,
      ),
      CourseModel(
        id: 'cs303',
        code: 'CS303',
        name: 'Operating Systems',
        instructor: 'Dr. Emily Chen',
        instructorEmail: 'e.chen@campus.edu',
        description: 'Study of operating system concepts including processes, threads, memory management, and file systems.',
        credits: 4,
        totalstudents: 120,
        schedule: 'Mon, Wed - 3:00 PM',
        location: 'Room 401',
        building: 'Engineering Block A',
        prerequisites: ['CS202', 'CS205'],
        syllabus: ['Processes & Threads', 'Scheduling', 'Memory Management', 'File Systems', 'Security'],
        examDate: 'Dec 20, 2024',
        examTime: '9:00 AM - 12:00 PM',
        examLocation: 'Main Auditorium',
        color: Colors.purple,
      ),
      CourseModel(
        id: 'cs304',
        code: 'CS304',
        name: 'Computer Networks',
        instructor: 'Prof. David Wilson',
        instructorEmail: 'd.wilson@campus.edu',
        description: 'Comprehensive study of computer networking protocols, TCP/IP model, and network security.',
        credits: 3,
        totalstudents: 200,
        schedule: 'Fri - 11:00 AM',
        location: 'Room 202',
        building: 'Engineering Block A',
        prerequisites: ['CS202'],
        syllabus: ['OSI Model', 'TCP/IP', 'Routing', 'Network Security', 'Wireless Networks'],
        examDate: 'Dec 22, 2024',
        examTime: '2:00 PM - 5:00 PM',
        examLocation: 'Room 150',
        color: Colors.orange,
      ),
    ];
  }

  // Enrolled courses for current user
  static List<CourseModel> getEnrolledCourses() {
    return [
      CourseModel(
        id: 'cs301',
        code: 'CS301',
        name: 'Data Structures & Algorithms',
        instructor: 'Dr. Sarah Smith',
        instructorEmail: 's.smith@campus.edu',
        description: 'Advanced study of data structures and algorithms.',
        credits: 4,
        totalstudents: 60,
        schedule: 'Mon, Wed, Fri - 10:00 AM',
        location: 'Room 201',
        building: 'Engineering Block B',
        prerequisites: [],
        syllabus: [],
        examDate: 'Dec 15, 2024',
        examTime: '9:00 AM - 12:00 PM',
        examLocation: 'Main Auditorium',
        color: Colors.blue,
      ),
      CourseModel(
        id: 'cs302',
        code: 'CS302',
        name: 'Database Management Systems',
        instructor: 'Prof. Michael Brown',
        instructorEmail: 'm.brown@campus.edu',
        description: 'Introduction to database design and SQL.',
        credits: 3,
        totalstudents: 50,
        schedule: 'Tue, Thu - 2:00 PM',
        location: 'Lab 105',
        building: 'Engineering Block B',
        prerequisites: [],
        syllabus: [],
        examDate: 'Dec 18, 2024',
        examTime: '2:00 PM - 5:00 PM',
        examLocation: 'Room 301',
        color: Colors.green,
      ),
    ];
  }
}