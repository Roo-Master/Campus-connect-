import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'User Manual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Campus Connect User Manual',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Smart University Life, All in One App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionCard(
              title: "1. Introduction",
              icon: Icons.info_outline,
              content:
              "Campus Connect is a smart university mobile application designed to improve campus life by integrating academic services, communication tools, identity management, and support services into one platform.",
            ),

            _buildSectionCard(
              title: "2. Purpose of the User Manual",
              icon: Icons.article_outlined,
              content:
              "This manual provides guidance on how to use the Campus Connect mobile application effectively. It explains features, navigation, and troubleshooting steps for all users.",
            ),

            _buildSectionCard(
              title: "3. Intended Users",
              icon: Icons.people_outline,
              content:
              "Campus Connect is designed for:\n\n• Students\n• Lecturers\n• University Administration Staff\n• Support Staff (future enhancement)",
            ),

            _buildExpandableManual(),

            const SizedBox(height: 8),

            // HOW DO I SECTION
            _buildHowDoISection(),

            _buildSectionCard(
              title: "10. Troubleshooting",
              icon: Icons.build_circle_outlined,
              content:
              "• App not opening: Restart your device or reinstall the app.\n\n"
                  "• Login failed: Check your credentials or reset your password.\n\n"
                  "• Notifications not showing: Enable notifications in settings.\n\n"
                  "• Map not loading: Check internet connection and location permissions.\n\n"
                  "• Student ID not verified: Upload a clear image and wait for approval.",
            ),

            _buildSectionCard(
              title: "11. Security and Privacy",
              icon: Icons.security_outlined,
              content:
              "Campus Connect protects users through secure login authentication, password protection, role-based access, verified digital identity, and protected academic records.\n\nUsers should keep their passwords confidential and avoid sharing account details.",
            ),

            _buildSectionCard(
              title: "12. Frequently Asked Questions (FAQs)",
              icon: Icons.quiz_outlined,
              content:
              "Q1: Can I use Campus Connect without internet?\n"
                  "A: Some features may work offline, but most require internet access.\n\n"
                  "Q2: Who can use the app?\n"
                  "A: Students, lecturers, and university administration staff.\n\n"
                  "Q3: What if I forget my password?\n"
                  "A: Use the Forgot Password option on the login page.\n\n"
                  "Q4: Can I view my exam results?\n"
                  "A: Yes, through the Academic Management section.",
            ),

            _buildSectionCard(
              title: "13. Conclusion",
              icon: Icons.check_circle_outline,
              content:
              "Campus Connect is a modern, user-friendly application that improves communication, academic management, safety, and digital campus interaction. It provides a convenient all-in-one solution for the university community.",
            ),

            const SizedBox(height: 24),

            // Footer Contact Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: const [
                  Icon(Icons.contact_support_outlined,
                      size: 36, color: Color(0xFF1565C0)),
                  SizedBox(height: 12),
                  Text(
                    "Need More Help?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "For support, contact the university ICT department or system administrator.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "support@campusconnect.ac.ke",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1565C0), size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildExpandableManual() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          leading: const Icon(Icons.dashboard_customize_outlined,
              color: Color(0xFF1565C0)),
          title: const Text(
            "4 - 9. User Guide Sections",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: const [
            _ManualTile(
              title: "4. System Overview",
              content:
              "Campus Connect is a centralized digital campus assistant that allows users to view academic progress, receive announcements, navigate campus, manage digital identity, and access support services.",
            ),
            _ManualTile(
              title: "5. System Requirements",
              content:
              "Hardware: Smartphone/tablet, camera, internet access.\nSoftware: Android 8.0+ or iOS 12+.",
            ),
            _ManualTile(
              title: "6. Installing the Application",
              content:
              "Android:\n1. Download the APK or install from Play Store.\n2. Tap Install.\n3. Open the app.\n\n"
                  "iOS:\n1. Search Campus Connect in App Store.\n2. Tap Install.\n3. Launch the app.",
            ),
            _ManualTile(
              title: "7. User Registration and Login",
              content:
              "Registration:\n1. Open the app.\n2. Tap Sign Up.\n3. Enter your details.\n4. Tap Create Account.\n\n"
                  "Login:\n1. Enter email/registration number.\n2. Enter password.\n3. Tap Login.",
            ),
            _ManualTile(
              title: "8. Dashboard Overview",
              content:
              "The dashboard provides quick access to profile summary, semester info, academics, notifications, events, and quick actions.",
            ),
            _ManualTile(
              title: "9. Features and How to Use Them",
              content:
              "Includes Academic Management, Notifications, Campus Navigation, Digital Student ID, AI Chat Assistant, and Emergency Services.",
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildHowDoISection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: const Icon(Icons.help_outline, color: Color(0xFF1565C0)),
          title: const Text(
            "How Do I...?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          subtitle: const Text("Step-by-step help for common tasks"),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: const [
            _ManualTile(
              title: "How do I register an account?",
              content:
              "1. Open the Campus Connect app.\n"
                  "2. Tap the 'Sign Up' button.\n"
                  "3. Enter your Full Name.\n"
                  "4. Enter your Registration Number or Staff ID.\n"
                  "5. Enter your Email Address.\n"
                  "6. Create a secure Password.\n"
                  "7. Tap 'Create Account'.\n"
                  "8. Verify your email or phone number if required.",
            ),
            _ManualTile(
              title: "How do I log into the app?",
              content:
              "1. Open the app.\n"
                  "2. Enter your Email Address or Registration Number.\n"
                  "3. Enter your Password.\n"
                  "4. Tap 'Login'.\n"
                  "5. If successful, you will be taken to the Dashboard.",
            ),
            _ManualTile(
              title: "How do I reset my password?",
              content:
              "1. Open the Login screen.\n"
                  "2. Tap 'Forgot Password'.\n"
                  "3. Enter your registered Email Address.\n"
                  "4. Tap 'Submit' or 'Reset Password'.\n"
                  "5. Check your email for reset instructions.\n"
                  "6. Create a new password and log in again.",
            ),
            _ManualTile(
              title: "How do I view my courses and results?",
              content:
              "1. Log into the app.\n"
                  "2. On the Dashboard, tap 'Academics'.\n"
                  "3. Choose 'Courses' to view registered units.\n"
                  "4. Choose 'Results' to view CATs and exam marks.\n"
                  "5. Choose 'Progress' to track academic performance.",
            ),
            _ManualTile(
              title: "How do I check notifications?",
              content:
              "1. Open the app and log in.\n"
                  "2. Tap 'Notifications' from the Dashboard.\n"
                  "3. View the list of recent alerts.\n"
                  "4. Tap any notification to read the full details.",
            ),
            _ManualTile(
              title: "How do I use the campus map?",
              content:
              "1. Open the app.\n"
                  "2. Tap 'Campus Map' on the Dashboard.\n"
                  "3. Use the search bar to type a location (e.g. Library, ICT Lab).\n"
                  "4. Select the building or office.\n"
                  "5. Follow the directions shown on the map.",
            ),
            _ManualTile(
              title: "How do I activate my digital student ID?",
              content:
              "1. Log into the app.\n"
                  "2. Tap 'Student ID'.\n"
                  "3. Upload a clear passport photo or scanned ID image.\n"
                  "4. Confirm your profile details.\n"
                  "5. Tap 'Submit for Verification'.\n"
                  "6. Wait for approval from the administration.\n"
                  "7. Once approved, your digital ID will become active.",
            ),
            _ManualTile(
              title: "How do I use the AI Assistant?",
              content:
              "1. Open the app and log in.\n"
                  "2. Tap 'AI Assistant' from the Dashboard.\n"
                  "3. Type your question in the chat box.\n"
                  "4. Tap send.\n"
                  "5. Wait for the assistant to respond.\n\n"
                  "Example questions:\n"
                  "• Where is the ICT Department?\n"
                  "• How do I register for units?\n"
                  "• When are exams starting?",
            ),
            _ManualTile(
              title: "How do I request emergency help?",
              content:
              "1. Open the app.\n"
                  "2. Tap 'Emergency'.\n"
                  "3. Select the type of help needed:\n"
                  "   • Security\n"
                  "   • Medical\n"
                  "   • Student Support\n"
                  "4. Tap the relevant option to call or request help immediately.",
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualTile extends StatelessWidget {
  final String title;
  final String content;

  const _ManualTile({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}