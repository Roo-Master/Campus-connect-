import 'package:flutter/material.dart';

class EventModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final String building;
  final String organizer;
  final String organizerContact;
  final int capacity;
  int registeredCount;
  final String imageUrl;
  final Color color;
  final bool isMandatory;
  final List<String> tags;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.building,
    required this.organizer,
    required this.organizerContact,
    required this.capacity,
    required this.registeredCount,
    required this.imageUrl,
    required this.color,
    required this.isMandatory,
    required this.tags,
  });

  // Getters
  int get spotsLeft => capacity - registeredCount;
  bool get isFull => registeredCount >= capacity;

  // Get icon based on event category
  IconData get typeIcon {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school;
      case 'career':
        return Icons.work;
      case 'cultural':
        return Icons.palette;
      case 'sports':
        return Icons.sports_soccer;
      case 'social':
        return Icons.groups;
      case 'workshop':
        return Icons.build;
      case 'seminar':
        return Icons.mic;
      case 'conference':
        return Icons.people;
      case 'hackathon':
        return Icons.computer;
      case 'guest lecture':
        return Icons.record_voice_over;
      case 'exam':
        return Icons.assignment;
      case 'meeting':
        return Icons.meeting_room;
      case 'club':
        return Icons.group;
      case 'festival':
        return Icons.celebration;
      case 'sports':
        return Icons.fitness_center;
      default:
        return Icons.event;
    }
  }

  // Get icon based on event type (alternative getter)
  IconData get icon {
    return typeIcon;
  }

  // Get display color (with fallback)
  Color get displayColor {
    return color;
  }

  // Get formatted date
  String get formattedDate {
    return date;
  }

  // Get formatted time range
  String get timeRange {
    return '$startTime - $endTime';
  }

  // Get registration status
  String get registrationStatus {
    if (isFull) return 'Full';
    if (spotsLeft < 10) return 'Almost Full';
    return 'Open';
  }

  // Get registration status color
  Color get registrationStatusColor {
    if (isFull) return Colors.red;
    if (spotsLeft < 10) return Colors.orange;
    return Colors.green;
  }

  // Check if event is upcoming
  bool get isUpcoming {
    // Add your date comparison logic here
    return true;
  }

  // Get event duration in hours (approximate)
  int get durationHours {
    // Parse time strings and calculate duration
    // This is a simplified version
    return 2; // Default 2 hours
  }

  // Copy with method for updating properties
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? date,
    String? startTime,
    String? endTime,
    String? location,
    String? building,
    String? organizer,
    String? organizerContact,
    int? capacity,
    int? registeredCount,
    String? imageUrl,
    Color? color,
    bool? isMandatory,
    List<String>? tags,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      building: building ?? this.building,
      organizer: organizer ?? this.organizer,
      organizerContact: organizerContact ?? this.organizerContact,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      isMandatory: isMandatory ?? this.isMandatory,
      tags: tags ?? this.tags,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'building': building,
      'organizer': organizer,
      'organizerContact': organizerContact,
      'capacity': capacity,
      'registeredCount': registeredCount,
      'imageUrl': imageUrl,
      'color': color.value,
      'isMandatory': isMandatory,
      'tags': tags,
    };
  }

  // Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: json['location'] as String,
      building: json['building'] as String,
      organizer: json['organizer'] as String,
      organizerContact: json['organizerContact'] as String,
      capacity: json['capacity'] as int,
      registeredCount: json['registeredCount'] as int,
      imageUrl: json['imageUrl'] as String,
      color: Color(json['color'] as int),
      isMandatory: json['isMandatory'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  // Equatable comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // String representation
  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, category: $category)';
  }

  // Mock Data
  static List<EventModel> getMockEvents() {
    return [
      EventModel(
        id: 'evt001',
        title: 'Tech Fest 2026',
        description: 'Annual technology festival featuring hackathons, tech talks, and innovation showcases.',
        category: 'Academic',
        date: 'Oct 15, 2026',
        startTime: '9:00 AM',
        endTime: '6:00 PM',
        location: 'Main Auditorium',
        building: 'Central Block',
        organizer: 'Computer Science Department',
        organizerContact: 'cs@campus.edu',
        capacity: 500,
        registeredCount: 423,
        imageUrl: '',
        color: Colors.blue,
        isMandatory: false,
        tags: ['Hackathon', 'Innovation', 'Networking'],
      ),
      EventModel(
        id: 'evt002',
        title: 'Career Fair 2026',
        description: 'Meet recruiters from top companies. Bring your resume and dress professionally.',
        category: 'Career',
        date: 'Oct 18, 2026',
        startTime: '10:00 AM',
        endTime: '4:00 PM',
        location: 'Sports Complex',
        building: 'Recreation Block',
        organizer: 'Career Services Center',
        organizerContact: 'careers@campus.edu',
        capacity: 1000,
        registeredCount: 756,
        imageUrl: '',
        color: Colors.green,
        isMandatory: false,
        tags: ['Jobs', 'Internships', 'Recruitment'],
      ),
      EventModel(
        id: 'evt003',
        title: 'Guest Lecture: AI in Healthcare',
        description: 'Distinguished speaker Dr. Robert Chen will discuss the future of AI in healthcare.',
        category: 'Guest Lecture',
        date: 'Oct 20, 2026',
        startTime: '2:00 PM',
        endTime: '4:00 PM',
        location: 'Room 301',
        building: 'Engineering Block A',
        organizer: 'AI Research Club',
        organizerContact: 'ai.club@campus.edu',
        capacity: 150,
        registeredCount: 98,
        imageUrl: '',
        color: Colors.purple,
        isMandatory: false,
        tags: ['AI', 'Healthcare', 'Research'],
      ),
      EventModel(
        id: 'evt004',
        title: 'Mid-Semester Exam Briefing',
        description: 'Mandatory briefing session for all students regarding mid-semester examination schedules.',
        category: 'Exam',
        date: 'Oct 22, 2026',
        startTime: '11:00 AM',
        endTime: '12:30 PM',
        location: 'Room 101',
        building: 'Main Block',
        organizer: 'Examination Office',
        organizerContact: 'exams@campus.edu',
        capacity: 300,
        registeredCount: 289,
        imageUrl: '',
        color: Colors.red,
        isMandatory: true,
        tags: ['Exams', 'Important', 'Mandatory'],
      ),
      EventModel(
        id: 'evt005',
        title: 'Cultural Night',
        description: 'Annual cultural celebration featuring performances from student groups.',
        category: 'Cultural',
        date: 'Oct 25, 2026',
        startTime: '6:00 PM',
        endTime: '10:00 PM',
        location: 'Open Air Theater',
        building: 'Cultural Block',
        organizer: 'Student Council',
        organizerContact: 'student.council@campus.edu',
        capacity: 800,
        registeredCount: 512,
        imageUrl: '',
        color: Colors.orange,
        isMandatory: false,
        tags: ['Cultural', 'Music', 'Food'],
      ),
      EventModel(
        id: 'evt006',
        title: 'Hackathon 2026',
        description: '24-hour coding competition. Form teams and build innovative solutions.',
        category: 'Hackathon',
        date: 'Nov 1, 2026',
        startTime: '10:00 AM',
        endTime: '10:00 AM (Next Day)',
        location: 'Innovation Hub',
        building: 'Tech Park',
        organizer: 'Coding Club',
        organizerContact: 'coding@campus.edu',
        capacity: 200,
        registeredCount: 180,
        imageUrl: '',
        color: Colors.indigo,
        isMandatory: false,
        tags: ['Coding', 'Competition', 'Prize'],
      ),
      EventModel(
        id: 'evt007',
        title: 'Annual Sports Meet',
        description: 'Inter-college sports competition including athletics, basketball, and more.',
        category: 'Sports',
        date: 'Nov 5, 2026',
        startTime: '8:00 AM',
        endTime: '6:00 PM',
        location: 'Sports Stadium',
        building: 'Sports Complex',
        organizer: 'Sports Department',
        organizerContact: 'sports@campus.edu',
        capacity: 500,
        registeredCount: 320,
        imageUrl: '',
        color: Colors.teal,
        isMandatory: false,
        tags: ['Sports', 'Athletics', 'Competition'],
      ),
      EventModel(
        id: 'evt008',
        title: 'Alumni Meet 2026',
        description: 'Reconnect with fellow alumni and network with current students.',
        category: 'Social',
        date: 'Nov 10, 2026',
        startTime: '4:00 PM',
        endTime: '8:00 PM',
        location: 'Grand Hall',
        building: 'Admin Block',
        organizer: 'Alumni Association',
        organizerContact: 'alumni@campus.edu',
        capacity: 300,
        registeredCount: 150,
        imageUrl: '',
        color: Colors.pink,
        isMandatory: false,
        tags: ['Alumni', 'Networking', 'Reunion'],
      ),
    ];
  }

  // Get events by category
  static List<EventModel> getEventsByCategory(String category) {
    return getMockEvents()
        .where((event) => event.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get upcoming events
  static List<EventModel> getUpcomingEvents() {
    return getMockEvents().take(5).toList();
  }

  // Get today's events
  static List<EventModel> getTodayEvents() {
    return getMockEvents().take(2).toList();
  }

  // Get mandatory events
  static List<EventModel> getMandatoryEvents() {
    return getMockEvents().where((event) => event.isMandatory).toList();
  }

  // Get popular events (80%+ registered)
  static List<EventModel> getPopularEvents() {
    return getMockEvents()
        .where((event) => event.registeredCount / event.capacity >= 0.8)
        .toList();
  }
}