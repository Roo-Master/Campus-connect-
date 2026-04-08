import 'package:campus_connect/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/config/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../academic/academic_records_screen.dart';
import '../services/profile_services.dart';
import 'edit_profile_screen.dart';
import 'id_card_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileService>(context).userProfile;
    final authService = Provider.of<AuthService>(context);
    final user = Provider.of<UserModel>(context);

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('No profile found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _navigateToSettingsScreen(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(profile),
              const SizedBox(height: 24),
              _buildAcademicStats(profile),
              const SizedBox(height: 24),
              _buildProfileMenu(context, user),
              const SizedBox(height: 16),
              _buildPersonalInfo(profile),
              const SizedBox(height: 24),
              _buildLogoutButton(context, authService),
            ],
          ),
        ),
      ),
    );
  }

  // PROFILE HEADER
  Widget _buildProfileHeader(UserProfile user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              "${user.firstName[0] ?? ""}${user.lastName[0] ?? ""}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${user.firstName ?? ""} ${user.lastName ?? ""}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${user.program ?? ""} • ${user.department ?? ""}",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "ID: ${user.studentId ?? ""}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

// ACADEMIC STATS
  Widget _buildAcademicStats(UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Phone layout
              if (constraints.maxWidth < 400) {
                return Column(
                  children: [
                    _buildStatColumn(user.year ?? "-", "Year"),
                    const SizedBox(height: 12),
                    _buildStatColumn(user.program ?? "-", "Program"),
                    const SizedBox(height: 12),
                    _buildStatColumn(user.department ?? "-", "Department"),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildStatColumn(user.course ?? "-", "Course"),
                  ],
                );
              }

              // Tablet / large screen layout
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(user.year ?? "-", "Year"),
                  _buildStatColumn(user.program ?? "-", "Program"),
                  _buildStatColumn(user.department ?? "-", "Department"),
                  _buildStatColumn(user.course ?? "-", "Course"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // PROFILE MENU
  Widget _buildProfileMenu(BuildContext context, UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(Icons.person, "Edit Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(user: user),
              ),
            );
          }),
          const Divider(),
          _buildMenuItem(Icons.school, "Academic Records", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AcademicRecordsScreen(),
              ),
            );
          }),
          const Divider(),
          _buildMenuItem(Icons.credit_card, "ID Card", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IdCardScreen(),
              ),
            );
          }),
          const Divider(),
          _buildMenuItem(Icons.library_books, "Library Account", () {}),
        ],
      ),
    );
  }

  // PERSONAL INFO
  Widget _buildPersonalInfo(UserProfile user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(Icons.email, "Email: ${user.email ?? ""}", () {}),
          const Divider(),
          _buildMenuItem(Icons.phone, "Phone: ${user.phone ?? ""}", () {}),
          const Divider(),
          _buildMenuItem(
              Icons.business, "Department: ${user.department ?? ""}", () {}),

          const Divider(),
          _buildMenuItem(
              Icons.subject_outlined, "Course: ${user.course ?? ""}", () {}),
        ],
      ),
    );
  }

  // LOGOUT BUTTON
  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () async {
            await authService.logout();

            if (context.mounted) {
              Navigator.pushReplacementNamed(context, "/login");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // STAT COLUMN
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        Text(label),
      ],
    );
  }

  // MENU ITEM
  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // NAVIGATION
  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}
