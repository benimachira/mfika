import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/school_notification.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class NotificationProvider with ChangeNotifier {
  List<SchoolNotification> _notifications = [];

  List<SchoolNotification> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    try {
      print('AA');
      final authData = await _getAuthDataFromPrefs();
      final User user = authData['user'];
      final authToken = authData['authToken'];



      var url =Uri.parse('${baseUrl}/notifictions/${user.id}');

      print('AA${url}');

      final response = await http.get(url, headers: {'Authorization': 'Bearer $authToken'});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<SchoolNotification> notifications = jsonResponse.map((notificationJson) => SchoolNotification.fromJson(notificationJson)).toList();
        _notifications = notifications;
        notifyListeners();
      } else {
        throw Exception('Failed to load notifications: HTTP ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load notifications: $error');
    }
  }

  Future<Map<String, dynamic>> _getAuthDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = json.decode(prefs.getString('authData')!);

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }
}