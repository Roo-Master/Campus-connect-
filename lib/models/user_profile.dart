class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String studentId;
  final String department;
  final String? program;
  final String? course;
  final String? year;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.studentId,
    required this.department,
    this.program,
    this.course,
    this.year,
  });

  String get fullName => '$firstName $lastName';

  String get initials => '${firstName[0] ?? ''}${lastName[0] ?? ''}';
}