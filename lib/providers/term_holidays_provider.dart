// term_holidays_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/term_holidays.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class TermHolidaysProvider with ChangeNotifier {
  List<TermHoliday> _termHolidays = [];

  List<TermHoliday> get termHolidays => _termHolidays;

  Future<void> fetchTermHolidays() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/holidays'), headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<TermHoliday> termHolidays = jsonResponse.map((holidayJson) => TermHoliday.fromJson(holidayJson)).toList();
      _termHolidays = termHolidays;
      notifyListeners();
    } else {
      throw Exception('Failed to load term holidays data');
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
