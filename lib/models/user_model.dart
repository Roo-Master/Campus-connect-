import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? studentId;
  String? department;
  String? program;
  String? course;
  int? year;
  String? role; // 'student', 'faculty', 'admin'
  String? profileImage;
  String? phoneNumber;
  String? address;
  String? emergencyContact;
  bool? isHosteller;
  String? hostelBlock;
  String? roomNumber;
  double? gpa;
  int? completedCredits;
  int? totalCredits;
  bool isLoggedIn = false;

  // Getters
  String get fullName => '$firstName $lastName';
  String get initials => '${firstName?[0] ?? ''}${lastName?[0] ?? ''}';

  // Mock User Data
  void loadMockUser() {
    id = 'user_001';
    email = 'register@example.com';
    firstName = 'Roomaster';
    lastName = 'Register';
    studentId = 'IN16/00000/01';
    department = ' Computer Science';
    program = 'B.Tech';
    course = 'Software Engineering';
    year = 3;
    role = 'student';
    profileImage = null;
    phoneNumber = '+1 234 567 8900';
    address = '123 University Lane, Campus City';
    emergencyContact = '+1 987 654 3210';
    isHosteller = true;
    hostelBlock = 'Block A';
    roomNumber = '305';
    gpa = 3.75;
    completedCredits = 85;
    totalCredits = 160;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    id = null;
    email = null;
    firstName = null;
    lastName = null;
    isLoggedIn = false;
    notifyListeners();
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? studentId,
    String? department,
    String? program,
    String? course,
    int? year,
    String? role,
    String? profileImage,
    String? phoneNumber,
    String? address,
    String? emergencyContact,
    bool? isHosteller,
    String? hostelBlock,
    String? roomNumber,
    double? gpa,
    int? completedCredits,
    int? totalCredits,
    bool? isLoggedIn,
  }) {
    return UserModel()
      ..id = id ?? this.id
      ..email = email ?? this.email
      ..firstName = firstName ?? this.firstName
      ..lastName = lastName ?? this.lastName
      ..studentId = studentId ?? this.studentId
      ..department = department ?? this.department
      ..program = program ?? this.program
      ..course = course ?? this.course
      ..year = year ?? this.year
      ..role = role ?? this.role
      ..profileImage = profileImage ?? this.profileImage
      ..phoneNumber = phoneNumber ?? this.phoneNumber
      ..address = address ?? this.address
      ..emergencyContact = emergencyContact ?? this.emergencyContact
      ..isHosteller = isHosteller ?? this.isHosteller
      ..hostelBlock = hostelBlock ?? this.hostelBlock
      ..roomNumber = roomNumber ?? this.roomNumber
      ..gpa = gpa ?? this.gpa
      ..completedCredits = completedCredits ?? this.completedCredits
      ..totalCredits = totalCredits ?? this.totalCredits
      ..isLoggedIn = isLoggedIn ?? this.isLoggedIn;
  }
}