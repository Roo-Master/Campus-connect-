import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // Date Formatting
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime time, {String format = 'hh:mm a'}) {
    return DateFormat(format).format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  // Phone Number Formatting
  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  // Grade Calculations
  static String calculateGrade(double percentage) {
    if (percentage >= 90) return 'O';
    if (percentage >= 80) return 'A+';
    if (percentage >= 70) return 'A';
    if (percentage >= 60) return 'B+';
    if (percentage >= 50) return 'B';
    if (percentage >= 40) return 'C';
    return 'F';
  }

  static double calculateGradePoint(String grade) {
    switch (grade) {
      case 'O':
        return 10.0;
      case 'A+':
        return 9.0;
      case 'A':
        return 8.0;
      case 'B+':
        return 7.0;
      case 'B':
        return 6.0;
      case 'C':
        return 5.0;
      default:
        return 0.0;
    }
  }

  // Validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateRequired(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field is required';
    }
    return null;
  }

  // Color Helpers
  static Color getGradeColor(double gradePoint) {
    if (gradePoint >= 9.0) return Colors.green;
    if (gradePoint >= 7.0) return Colors.blue;
    if (gradePoint >= 5.0) return Colors.orange;
    return Colors.red;
  }

  static Color getEventColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.amberAccent;
      case 'career':
        return Colors.green;
      case 'cultural':
        return Colors.purple;
      case 'sports':
        return Colors.orange;
      case 'social':
        return Colors.pink;
      case 'Scheduler':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // String Helpers
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  // Time Helpers
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // File Size Formatting
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    final suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (bytes).floor();
    final place = (bytes / 1024).floor();
    if (place >= suffixes.length) return 'Too large';
    return '${i.toString()} ${suffixes[place]}';
  }
}