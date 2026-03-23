import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  final UserModel _user = UserModel();
  bool _isLoading = false;
  String? _error;

  UserModel get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user.isLoggedIn;

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication
      if (email.isNotEmpty && password.isNotEmpty) {
        _user.loadMockUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login with SSO
  Future<bool> loginWithSSO() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _user.loadMockUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _user.logout();
    _isLoading = false;
    notifyListeners();
  }

  // Check if user is logged in (restore session)
  Future<bool> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    // Simulate checking stored token
    await Future.delayed(const Duration(milliseconds: 500));

    // For demo, auto-login
    _user.loadMockUser();

    _isLoading = false;
    notifyListeners();
    return true;
  }
}