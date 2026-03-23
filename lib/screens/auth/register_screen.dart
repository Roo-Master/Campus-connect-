import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/user_profile.dart';
import '../profile/profile_screen.dart';
import '../services/profile_services.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _courseController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  String _selectedUserType = 'Student';
  String? _selectedYear = 'Year 1';
  String? _selectedProgram = 'Degree';

  final List<String> _userTypes = ['Student', 'Faculty', 'Staff' ,'Class_Representative'];
  final List<String> _years = ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'];
  final List<String> _programs = [
    'Certificate',
    'Diploma',
    'Degree',
    'Masters',
    'Ph.D',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showErrorSnackBar("You must accept the Terms and Privacy Policy");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user profile
      final userProfile = UserProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        studentId: _studentIdController.text.trim(),
        department: _departmentController.text.trim(),
        course: _courseController.text.trim(),
        program: _selectedProgram,
        year: _selectedYear,
      );

      // Save profile using Provider
      Provider.of<ProfileService>(context, listen: false)
          .updateUserProfile(userProfile);

      setState(() {
        _isLoading = false;
      });

      // Navigate to profile screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );

    } catch (e) {

      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar("Registration failed. Try again.");
    }
  }
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Registration Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Your profile has been created successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Go to Login'),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using Campus Connect, you agree to the following terms:\n\n'
                '1. You will use the app only for legitimate academic and campus-related purposes.\n\n'
                '2. You will not share your account credentials with others.\n\n'
                '3. You will respect the privacy and confidentiality of other users.\n\n'
                '4. You will not post or share inappropriate content.\n\n'
                '5. The university reserves the right to suspend or terminate accounts that violate these terms.\n\n'
                '6. All data is subject to university privacy policies.\n\n'
                '7. You agree to receive notifications related to campus activities.\n\n'
                '8. The app is provided "as is" without warranties.\n\n'
                'Last updated: October 2024',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Campus Connect is committed to protecting your privacy.\n\n'
                'Information We Collect:\n'
                '- Personal information (name, email, student ID)\n'
                '- Academic records and grades\n'
                '- Location data for campus services\n'
                '- Usage data and analytics\n\n'
                'How We Use Your Information:\n'
                '- To provide academic services\n'
                '- To send campus notifications\n'
                '- To improve our services\n'
                '- For authentication and security\n\n'
                'Data Protection:\n'
                '- All data is encrypted in transit and at rest\n'
                '- We do not sell your data to third parties\n'
                '- You can request data deletion at any time\n\n'
                'Contact: privacy@campus.edu\n\n'
                'Last updated: October 2024',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join Campus Connect to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),

                // User Type Selection
                const Text(
                  'I am a',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildUserTypeSelector(),
                const SizedBox(height: 24),

                // Personal Information
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 12),
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 24),

                // Academic/Professional Information
                _buildSectionTitle(
                    _selectedUserType == 'Student' ? 'Academic Information' : 'Professional Information'),
                const SizedBox(height: 12),
                _buildStudentIdField(),
                const SizedBox(height: 16),
                _buildDepartmentField(),
                if (_selectedUserType == 'Student') ...[
                  const SizedBox(height: 16),
                  _buildProgramAndYearFields(),
                    const SizedBox(height: 16),
                    _buildCourseFields(),
                  ],
                if(_selectedUserType == 'Faculty' || _selectedUserType == 'Staff')...
                [
                  const SizedBox(height: 16),
                  _buildDepartmentField(),
                ],
                if(_selectedUserType == 'Class_Representative')...[
                  const SizedBox(height: 16),
                  _buildProgramAndYearFields(),
                    const SizedBox(height: 16),
                    _buildCourseFields(),
                  ],
                const SizedBox(height: 24),

                // Password Section
                _buildSectionTitle('Password'),
                const SizedBox(height: 12),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),

                // Terms and Conditions
                _buildTermsCheckbox(),
                const SizedBox(height: 24),

                // Register Button
                _buildRegisterButton(),
                const SizedBox(height: 24),

                // Login Link
                _buildLoginLink(),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Row(
      children: _userTypes.map((type) {
        final isSelected = _selectedUserType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedUserType = type),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getUserTypeIcon(type),
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getUserTypeIcon(String type) {
    switch (type) {
      case 'Student':
        return Icons.school;
      case 'Faculty':
        return Icons.person;
      case 'Staff':
        return Icons.work;
        case 'Class_Representative':
          return Icons.group;
      default:
        return Icons.person;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.primary,
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email_outlined),
        hintText: 'your.email@university.edu',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: Icon(Icons.phone_outlined),
        hintText: '+1 234 567 8900',
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        if (value.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildStudentIdField() {
    return TextFormField(
      controller: _studentIdController,
      decoration: InputDecoration(
        labelText: _selectedUserType == 'Student' ? 'Student ID' : 'Employee ID',
        prefixIcon: const Icon(Icons.badge_outlined),
        hintText: _selectedUserType == 'Student' ? 'IN16/00000/01' : 'EMP001',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ID is required';
        }
        return null;
      },
    );
  }

  Widget _buildDepartmentField() {
    return TextFormField(
      controller: _departmentController,
      decoration: const InputDecoration(
        labelText: 'Department',
        prefixIcon: Icon(Icons.business_outlined),
        hintText: 'Computer Science',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Department is required';
        }
        return null;
      },
    );
  }

  Widget _buildProgramAndYearFields() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedProgram,
            decoration: const InputDecoration(
              labelText: 'Program',
              prefixIcon: Icon(Icons.school_outlined),
            ),
            hint: const Text('Select Program'),
            items: _programs.map((program) {
              return DropdownMenuItem(
                value: program,
                child: Text(program),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedProgram = value),
            validator: (value) {
              if (value == null) {
                return 'Program is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _selectedYear,
            decoration: const InputDecoration(
              labelText: 'Year',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            hint: const Text('Select Year'),
            items: _years.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text(year),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedYear = value),
            validator: (value) {
              if (value == null) {
                return 'Year is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ...continuing from _buildPasswordField

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, and number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock_reset_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      obscureText: _obscureConfirmPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
          activeColor: AppTheme.primary,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: TextStyle(color: Colors.grey.shade600),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showTermsOfService();
                      },
                  ),
                  const TextSpan(
                    text: ' and ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showPrivacyPolicy();
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Center(
      // ← Centers the button horizontally
      child: SizedBox(
        width: 200,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            disabledBackgroundColor: AppTheme.primary.withOpacity(0.6),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCourseFields() {
    return TextFormField(
      controller: _courseController,
      decoration: const InputDecoration(
        labelText: 'Course',
        prefixIcon: Icon(Icons.subject_outlined),
        hintText: 'Software Engineering',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Course is required';
        }
        return null;
      },
    );
  }
}

