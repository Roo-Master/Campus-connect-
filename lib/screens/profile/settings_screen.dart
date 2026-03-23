import 'package:campus_connect/screens/auth/forget_password_screen.dart';
import 'package:campus_connect/screens/profile/privacy_policy_screen.dart';
import 'package:campus_connect/screens/profile/termsof_service_screen.dart';
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../auth/login_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  bool _locationEnabled = true;
  bool _emailNotificationsEnabled = true;
  String _selectedAcademicYear = '2024-2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ---------------- ACCOUNT ----------------
            _buildSectionHeader('Account'),
            // Reset Password
            _buildNavigationSettingacc(
              Icons.lock_reset,
              'Reset Password',
              onTap: () {
                // Navigate to ResetPasswordScreen (create this screen)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                );
              },
            ),
            // Logout
            _buildNavigationSettingacc(
              Icons.logout,
              'Logout',
              onTap: () {
                _confirmActionacc(
                  context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  isDestructive: true,
                  onConfirm: () {
                    // Perform logout logic here
                    print('User logged out');
                    // Example: Navigate to LoginScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                );
              },
            ),
            _buildToggleSetting(
              Icons.notifications,
              'Push Notifications',
              'Receive important updates and alerts',
              _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
            ),
            _buildToggleSetting(
              Icons.fingerprint,
              'Biometric Login',
              'Use fingerprint or face to login',
              _biometricEnabled,
                  (value) => setState(() => _biometricEnabled = value),
            ),
            _buildToggleSetting(
              Icons.location_on,
              'Location Services',
              'Enable for campus navigation',
              _locationEnabled,
                  (value) => setState(() => _locationEnabled = value),
            ),
            const Divider(),

            /// ---------------- APPEARANCE ----------------
            _buildSectionHeader('Appearance'),
            _buildToggleSetting(
              Icons.dark_mode,
              'Dark Mode',
              'Switch to dark theme',
              _darkModeEnabled,
                  (value) => setState(() => _darkModeEnabled = value),
            ),
            const Divider(),

            /// ---------------- PREFERENCES ----------------
            _buildSectionHeader('Preferences'),
            _buildLanguageSetting(context),
            /// ------------Academic Year--------------
            _buildNavigationSetting(
              Icons.calendar_today,
              'Academic Calendar',
              _selectedAcademicYear,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    final years = [
                      '2022-2023 ' ' Past Academic Year', '2023-2024 ' ' Past Academic Year',
                      '2024-2025 ' ' Past Academic Year', '2025-2026 ' ' Current Academic Year',
                      '2026-2027 ' ' Future Academic Year',
                      '2027-2028 '' Future Academic Year',
                      '2028-2029 ' ' Future Academic Year',
                      '2029-2030 '  ' Future Academic Year',
                      '2030-2031 ' ' Future Academic Year',
                      '2031-2032 ' ' Future Academic Year',
                      '2032-2033 ' ' Future Academic Year',
                      '2033-2034 ' ' Future Academic Year',
                      '2034-2035 '  ' Future Academic Year',
                      '2035-2036 '' Future Academic Year',
                      '2036-2037 ' ' Future Academic Year',
                      '2037-2038 ' ' Future Academic Year',
                      '2038-2039 ' ' Future Academic Year',
                      '2039-2040 ' ' Future Academic Year',
                      '2040-2041 ' ' Future Academic Year',
                      '2041-2042 ' ' Future Academic Year',
                      '2042-2043 ' ' Future Academic Year',
                      '2043-2044 ' ' Future Academic Year',
                      '2044-2045 ' ' Future Academic Year',
                      '2045-2046 ' ' Future Academic Year',
                      '2046-2047 ' ' Future Academic Year',
                      '2047-2048 ' ' Future Academic Year',
                      '2048-2049 ' ' Future Academic Year',
                      '2049-2050 ' ' Future Academic Year',
                      '2050-2051 ' ' Future Academic Year',
                      '2051-2052 ' ' Future Academic Year',
                      '2052-2053 ' ' Future Academic Year',
                      '2053-2054 ' ' Future Academic Year',
                      '2054-2055 ' ' Future Academic Year',
                      '2055-2056 ' ' Future Academic Year',
                      '2056-2057 ' ' Future Academic Year',
                      '2057-2058 ' ' Future Academic Year',
                      '2058-2059 ' ' Future Academic Year',
                      '2059-2060 ' ' Future Academic Year',
                      '2060-2061 ' ' Future Academic Year',
                      '2061-2062 ' ' Future Academic Year',
                      '2062-2063 ' ' Future Academic Year',
                      '2063-2064 ' ' Future Academic Year',

                    ];

                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5, // Half screen
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Select Academic Year',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: years.length,
                              separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final year = years[index];
                                return ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: Text(year),
                                  onTap: () {
                                    setState(() {
                                      _selectedAcademicYear = year;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            /// ---------------- NOTIFICATIONS ----------------
            _buildToggleSettings(
              Icons.email,
              'Email Notifications',
              'Receive email updates and alerts',
              _emailNotificationsEnabled,
                  (value) => setState(() => _emailNotificationsEnabled = value),
            ),
            const Divider(),

            /// ---------------- SUPPORT ----------------
            _buildSectionHeader('Support'),
            _buildNavigationSettings(
              Icons.help,
              'Help Center',
              '',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),

            _buildNavigationSetting(
              Icons.privacy_tip,
              'Privacy Policy',
              '',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),

            _buildNavigationSetting(
              Icons.description,
              'Terms of Service',
              '',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                );
              },
            ),

            _buildNavigationSetting(
              Icons.info,
              'About',
              'Version 1.0.0',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            const Divider(),

            /// ---------------- DATA ----------------
            _buildSectionHeader('Data'),
            _buildNavigationSetting(
              Icons.download,
              'Download My Data',
              '',
              onTap: () => _confirmAction(
                title: 'Download My Data',
                message:
                'Are you sure you want to download all your data?',
                onConfirm: () async {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Downloading data...'),
                        ],
                      ),
                    ),
                  );

                  // Simulate deletion or call your API
                  await Future.delayed(const Duration(seconds: 2));

                  // Close the loading dialog
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your data has downloaded successfully')),
                  );

                  // Optional: Navigate user out (e.g., to login screen)
                  // Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
            _buildNavigationSetting(
              Icons.delete_forever,
              'Delete My Account',
              '',
              onTap: () => _confirmAction(
                title: 'Delete My Account',
                message:
                'This action is permanent and cannot be undone. Are you sure you want to delete your account?',
                isDestructive: true,
                onConfirm: () async {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Deleting account...'),
                        ],
                      ),
                    ),
                  );

                  // Simulate deletion or call your API
                  await Future.delayed(const Duration(seconds: 2));

                  // Close the loading dialog
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully')),
                  );

                  // Optional: Navigate user out (e.g., to login screen)
                  // Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ================= SECTION HEADER =================
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 14,
        ),
      ),
    );
  }

  /// ================= TOGGLE =================
  Widget _buildToggleSetting(
      IconData icon,
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  /// ================= NAVIGATION TILE =================
  Widget _buildNavigationSetting(
      IconData icon,
      String title,
      String value, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  /// ================= CONFIRM DIALOG =================
  void _confirmAction({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : Colors.blue,
            ),
            child: Text(isDestructive ? 'Delete' : 'Confirm'),
          ),
        ],
      ),
    );
  }

  /// ================= LANGUAGE BOTTOM SHEET =================
  Widget _buildLanguageSetting(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.primary),
      title: const Text('Language'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            final languages = [
              'English',
              'Kiswahili',
              'French',
              'Spanish',
              'Portuguese'
            ];

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: languages
                    .map(
                      (lang) => ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(lang),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}
Widget _buildNavigationSettings(
    IconData icon,
    String title,
    String value, {
      VoidCallback? onTap, // optional onTap
    }) {
  return ListTile(
    leading: Icon(icon, color: AppTheme.primary),
    title: Text(title),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value.isNotEmpty)
          Text(
            value,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
    onTap: onTap ?? () {}, // default empty function if not provided
  );
}

Widget _buildToggleSettings(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    ) {
  return SwitchListTile(
    secondary: Icon(icon, color: AppTheme.primary),
    title: Text(title),
    subtitle: Text(subtitle),
    value: value,
    onChanged: onChanged,
  );
}

Widget _buildNavigationSettingacc(IconData icon, String title, {VoidCallback? onTap, String? value}) {
  return ListTile(
    leading: Icon(icon, color: AppTheme.primary),
    title: Text(title),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null && value.isNotEmpty)
          Text(
            value,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
    onTap: onTap,
  );
}
void _confirmActionacc(
    BuildContext context, {
      required String title,
      required String message,
      required VoidCallback onConfirm,
      bool isDestructive = false,
    }) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? Colors.red : Colors.blue,
          ),
          child: Text(isDestructive ? 'Logout' : 'Confirm'),
        ),
      ],
    ),
  );
}