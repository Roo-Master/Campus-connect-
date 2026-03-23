import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/screens/dashboard/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import '../../ai/ai_chat_screen.dart';
import '../../config/theme.dart';
import '../../models/course_model.dart';
import '../../models/event_model.dart';
import '../../models/grade_model.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../academic/courses_screen.dart';
import '../academic/grades_screen.dart';
import '../emergency/emergency_screen.dart';
import '../events/events_screen.dart';
import '../map/campus_map_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/help_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/settings_screen.dart';
import '../services/fees_screen.dart';
import '../services/hostel_screen.dart';
import '../services/profile_services.dart';
import '../services/transport_screen.dart';
import 'quick_actions_widget.dart';
import '../academic/my_scheduler_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const EventsTab(),
    const MapTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  get userModel => null;


  @override
  Widget build(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context);
    final notificationService = Provider.of<NotificationService>(context);

    final userProfile = profileService.userProfile;
    final user = profileService.user;

    final horizontalPadding =
        MediaQuery.of(context).size.width < 600 ? 16.0 : 24.0;
    final verticalPadding =
        MediaQuery.of(context).size.width < 600 ? 20.0 : 30.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/kisii.jpg',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text('Kisii University'),
          ],
        ),
        foregroundColor: Colors.white,
        actions: [
          Consumer<NotificationService>(
            builder: (context, notificationService, _) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationsScreen()),
                      );
                    },
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  if (notificationService.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${notificationService.unreadCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(verticalPadding),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuickActionsWidget(
                    onActionTap: (action) {
                      final role = user?.role ?? '';
                      _handleActionTap(action,
                          userRole: role, context: context);
                    },
                  ),
                ),
                _buildUpcomingEvents(horizontalPadding),
                const SizedBox(height: 24),
                _buildMyCourses(horizontalPadding),
                const SizedBox(height: 24),
                _buildAcademicProgress(horizontalPadding),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double verticalPadding) {
    return Consumer<ProfileService>(
      builder: (context, profileService, _) {
        final userProfile = profileService.userProfile;

        if (userProfile == null) {
          return const SizedBox(height: 160);
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Container(
            height: 180,
            padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    userProfile.initials,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ${userProfile.firstName}!',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${userProfile.program} • ${userProfile.year}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Student ID: ${userProfile.studentId}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleActionTap(String action,
      {required BuildContext context, required String userRole}) {
    bool isClassRep = userRole.toLowerCase() == 'class rep';

    switch (action) {
      case 'courses':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CoursesScreen()));
        break;

      case 'grades':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const GradesScreen()));
        break;
      case 'fees':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FeesScreen(
                userModel: userModel, user: userModel, term: '', // Pass UserModel directly
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 'transport':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TransportScreen()));
        break;

      case 'emergency':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EmergencyScreen()));
        break;
      case 'events':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const EventsScreen()));
        break;
      case 'hostel':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HostelScreen()));

      case 'scheduler':
        if (isClassRep) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ScheduleScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "🚫 ACCESS DENIED! Only Class Rep can view the scheduler."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        break;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final profileService = Provider.of<ProfileService>(context);
    final user = profileService.user;

    final authService = Provider.of<AuthService>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<ProfileService>(
            builder: (context, profileService, _) {
              final user = profileService.user;
              final profile = profileService.userProfile;

              final name = profile?.firstName ?? user?.fullName ?? "";
              final email = user?.email ?? "";
              final initials = profile?.initials ?? user?.initials ?? "";

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  email,
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF42A5F5),
                        Color(0xFF1E88E5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blueAccent),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.green),
            title: const Text('My Schedule'),
            onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (_) => const MySchedulerScreen())
           );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology_alt,
                size: 28, color: Colors.deepPurple),
            title: const Text('AI Chat Bot'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AiChatScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.brown),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Logout'),
                    )
                  ],
                ),
              );

              if (shouldLogout == true) {
                await authService.logout();

                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  _buildUpcomingEvents(double horizontalPadding) {
    final events = EventModel.getMockEvents().take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...events.map((event) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: event.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(event.typeIcon, color: event.color),
                  ),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${event.date} • ${event.startTime}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              )),
        ],
      ),
    );
  }

  _buildMyCourses(double horizontalPadding) {
    final courses = CourseModel.getEnrolledCourses();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...courses.map((course) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: course.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        course.code.substring(0, 2),
                        style: TextStyle(
                          color: course.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(course.name),
                  subtitle: Text(course.schedule),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              )),
        ],
      ),
    );
  }

  _buildAcademicProgress(double horizontalPadding) {
    final grades = GradeModel.getMockGrades();
    final cgpa = GradeModel.calculateCGPA(grades);
    final progress = (grades.length / 8) * 100;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Academic Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          cgpa.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          'Current CGPA',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${grades.length}/8',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondary,
                          ),
                        ),
                        Text(
                          'Courses Completed',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${progress.toStringAsFixed(0)}% degree completion',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const EventsScreen();
  }
}

class EmergencyTab extends StatelessWidget {
  const EmergencyTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const EmergencyScreen();
  }
}

class MapTab extends StatelessWidget {
  const MapTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const CampusMapScreen();
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}