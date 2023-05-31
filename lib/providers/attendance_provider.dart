// attendance_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_report.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AttendanceProvider with ChangeNotifier {
  List<AttendanceReport> _attendanceReports = [];

  List<AttendanceReport> get attendanceReports => _attendanceReports;

  Future<void> fetchAttendanceReports() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/attendance-data/${user.id}'), headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AttendanceReport> attendanceReports = jsonResponse.map((reportJson) => AttendanceReport.fromJson(reportJson)).toList();
      _attendanceReports = attendanceReports;
      notifyListeners();
    } else {
      throw Exception('Failed to load attendance reports data');
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
