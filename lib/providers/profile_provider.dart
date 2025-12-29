import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "Your Name";
  String _image = "https://via.placeholder.com/150";

  String get name => _name;
  String get image => _image;

  final String _uid;

  ProfileProvider()
      : _uid = FirebaseAuth.instance.currentUser!.uid {
    loadProfile();
  }

  /// 🔹 Generate user-based keys
  String get _nameKey => 'profile_name_$_uid';
  String get _imageKey => 'profile_image_$_uid';

  /// 🔹 Load profile for CURRENT USER
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString(_nameKey) ?? _name;
    _image = prefs.getString(_imageKey) ?? _image;

    notifyListeners();
  }

  /// 🔹 Update profile for CURRENT USER
  Future<void> updateProfile(String name, String image) async {
    _name = name;
    _image = image;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_imageKey, image);

    notifyListeners();
  }

  /// 🔹 Clear profile ONLY for current user (optional)
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_imageKey);

    _name = "Your Name";
    _image = "https://via.placeholder.com/150";

    notifyListeners();
  }
}
