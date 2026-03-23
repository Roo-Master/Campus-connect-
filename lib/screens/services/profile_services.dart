import 'package:campus_connect/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';

class ProfileService with ChangeNotifier {
  UserProfile? _userProfile;

  UserModel? _user;

  UserModel? get user => _user;

  UserProfile? get userProfile => _userProfile;

  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners(); // 🔥 This triggers UI updates in all listeners
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }

  void updateUser(UserModel updatedUser) {
     _user = updatedUser;
    notifyListeners();
  }

}