import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _accessToken;

  User get user => _user??User(
    id: 123,
    name: "John Smith",
    email: "john.smith@example.com",
    userType: "customer",
    phoneNum: "+1 555-555-5555",
    staffNum: null,
    idNum: "AB123456",
    passwordChanged: true,
    usingApp: true,
    grade: null,
    avatar: "https://example.com/avatar.jpg",
    darkMode: false,
    messengerColor: '#',
  );
  String get accessToken => _accessToken!;

  bool get isAuthenticated => _user != null && _accessToken != null;

  // Add this getter
  bool get isLoggedIn => _accessToken != null;

  Future<void> setAuthData(User user, String accessToken) async {
    _user = user;
    _accessToken = accessToken;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authData', json.encode({
      'user': user.toJson(),
      'access_token': accessToken,
    }));

    notifyListeners();
  }

  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('authData');

    if (authData != null) {
      final decodedAuthData = json.decode(authData) as Map<String, dynamic>;
      _user = User.fromJson(decodedAuthData['user']);
      _accessToken = decodedAuthData['access_token'];
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _accessToken = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authData');
    notifyListeners();
  }
}
