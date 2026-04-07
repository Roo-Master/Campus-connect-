import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import 'profile_services.dart';

class AttendanceScreen extends StatefulWidget {
  final UserModel? user;

  const AttendanceScreen({super.key, this.user});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String, dynamic>> attendanceSessions = [
    {
      "unit": "CSC 220 - Data Structures",
      "lecturer": "Mr. Ondigo",
      "venue": "LH 3",
      "date": "07 Apr 2026",
      "time": "8:00 AM - 10:00 AM",
      "status": "Open",
      "signed": false,
      "attendanceStatus": "Not Signed"
    },
    {
      "unit": "BIT 210 - Database Systems",
      "lecturer": "Ms. Moraa",
      "venue": "Lab 2",
      "date": "07 Apr 2026",
      "time": "11:00 AM - 1:00 PM",
      "status": "Open",
      "signed": false,
      "attendanceStatus": "Not Signed"
    },
    {
      "unit": "MAT 121 - Discrete Mathematics",
      "lecturer": "Dr. Nyabuto",
      "venue": "Room B12",
      "date": "06 Apr 2026",
      "time": "2:00 PM - 4:00 PM",
      "status": "Closed",
      "signed": true,
      "attendanceStatus": "Present"
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void signAttendance(int index) {
    final session = attendanceSessions[index];

    if (session["status"] == "Closed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance session is closed."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (session["signed"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have already signed this attendance."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      attendanceSessions[index]["signed"] = true;
      attendanceSessions[index]["attendanceStatus"] = "Present";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Attendance signed successfully."),
        backgroundColor: Colors.green,
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Open":
        return Colors.green;
      case "Closed":
        return Colors.red;
      case "Present":
        return Colors.green;
      case "Late":
        return Colors.orange;
      case "Absent":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        final currentUser = widget.user ?? profileService.user;

        if (currentUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Attendance"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.how_to_reg,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Reg No: ${currentUser.studentId ?? ''}"),
                            Text("Programme: ${currentUser.program ?? ''}"),
                            Text("Department: ${currentUser.department ?? ''}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      Icon(Icons.event_available, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Available Attendance Sessions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// ATTENDANCE LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceSessions.length,
                  itemBuilder: (context, index) {
                    final session = attendanceSessions[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// UNIT TITLE
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session["unit"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(session["status"])
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  session["status"],
                                  style: TextStyle(
                                    color: getStatusColor(session["status"]),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// DETAILS
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Lecturer: ${session["lecturer"]}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Venue: ${session["venue"]}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Date: ${session["date"]}"),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("Time: ${session["time"]}"),
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// ATTENDANCE STATUS
                          Row(
                            children: [
                              const Text(
                                "Attendance Status: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                session["attendanceStatus"],
                                style: TextStyle(
                                  color: getStatusColor(
                                    session["attendanceStatus"],
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: session["signed"] == true ||
                                      session["status"] == "Closed"
                                  ? null
                                  : () => signAttendance(index),
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text(
                                session["signed"] == true
                                    ? "Attendance Signed"
                                    : "Sign Attendance",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}