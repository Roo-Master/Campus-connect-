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

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
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

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void signAttendance(int index) {
    final session = attendanceSessions[index];

    if (session["status"] == "Closed") {
      _showSnackBar("Attendance session is closed.", Colors.red);
      return;
    }

    if (session["signed"] == true) {
      _showSnackBar("You have already signed this attendance.", Colors.orange);
      return;
    }

    setState(() {
      attendanceSessions[index]["signed"] = true;
      attendanceSessions[index]["attendanceStatus"] = "Present";
    });

    _showSnackBar("Attendance signed successfully! ✅", Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
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

        // Professional empty state instead of loader
        if (currentUser == null) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: _buildAppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.how_to_reg_outlined,
                      size: 64,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Loading your profile...",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait while we fetch your details",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: _buildAppBar(),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(currentUser),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 24),
                ),
                _buildAttendanceTitle(),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 16),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildAttendanceCard(index),
                    childCount: attendanceSessions.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 100),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.how_to_reg, size: 20),
                SizedBox(width: 6),
                Text("Attendance"),
              ],
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? "Student Name",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                _buildInfoChip("ID: ${user.studentId ?? ''}", Icons.badge),
                _buildInfoChip("Programme: ${user.program ?? ''}", Icons.school),
                _buildInfoChip("Department: ${user.department ?? ''}", Icons.business),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTitle() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(Icons.event_available, color: Colors.blue, size: 28),
            SizedBox(width: 12),
            Text(
              "Attendance Sessions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(int index) {
    final session = attendanceSessions[index];
    final isOpen = session["status"] == "Open" && session["signed"] == false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unit Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session["unit"],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(session["status"]).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          session["status"] == "Open"
                              ? Icons.circle
                              : Icons.cancel,
                          size: 16,
                          color: getStatusColor(session["status"]),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          session["status"],
                          style: TextStyle(
                            color: getStatusColor(session["status"]),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Details Grid
              _buildDetailRow(
                Icons.person_outline,
                "Lecturer",
                session["lecturer"],
              ),
              _buildDetailRow(
                Icons.location_on_outlined,
                "Venue",
                session["venue"],
              ),
              _buildDetailRow(
                Icons.calendar_today,
                "Date",
                session["date"],
              ),
              _buildDetailRow(
                Icons.access_time,
                "Time",
                session["time"],
              ),

              const SizedBox(height: 24),

              // Status Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: getStatusColor(session["attendanceStatus"])
                      .withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: getStatusColor(session["attendanceStatus"])
                        .withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      session["attendanceStatus"] == "Present"
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: getStatusColor(session["attendanceStatus"]),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Status: ${session["attendanceStatus"]}",
                      style: TextStyle(
                        color: getStatusColor(session["attendanceStatus"]),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isOpen ? () => signAttendance(index) : null,
                  icon: isOpen
                      ? const Icon(Icons.check_circle, size: 20)
                      : const Icon(Icons.check_circle, size: 20),
                  label: Text(
                    session["signed"] == true
                        ? "Attendance Signed"
                        : isOpen
                            ? "Sign Attendance Now"
                            : "Session Closed",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOpen ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    elevation: isOpen ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}