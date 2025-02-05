import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../services/api_service.dart'; // Import ApiService

class ProfileController with ChangeNotifier {
  String? _name;
  String? _email;
  File? _avatar;
  Position? _position;
  bool _geoLocationEnabled = false;
  bool _notificationsEnabled = false;

  String? get name => _name;
  String? get email => _email;
  File? get avatar => _avatar;
  Position? get position => _position;
  bool get geoLocationEnabled => _geoLocationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;

  final ApiService _apiService = ApiService(); // Use ApiService

  // Load user details from the API
  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      try {

        final response = await _apiService.fetchProfile(); // Call fetchProfile

        if (response['status'] == 'success') {
          final userData = response['data'];
          _name = userData['name'];
          _email = userData['email'];
          notifyListeners();
        } else {
          throw Exception('Failed to load user details');
        }
      } catch (e) {
        print('Error loading user details: $e');
      }
    }
  }

  // Update avatar
  Future<void> updateAvatar(File image) async {
    _avatar = image;
    notifyListeners();
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _avatar = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Set geo location
  void setGeoLocation(Position? position) {
    _position = position;
    _geoLocationEnabled = position != null;
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }
}