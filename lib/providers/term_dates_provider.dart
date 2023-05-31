import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/term_date.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class TermDatesProvider with ChangeNotifier {
  TermDate? _termDate;

  TermDate? get termDate => _termDate;

  // Get term date by ID
  TermDate? getTermDateById(int id) {
    if (_termDate != null && _termDate!.id == id) {
      return _termDate;
    }
    return null;
  }

  Future<void> fetchTermDate() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/term'),headers: {'Authorization': 'Bearer $authToken'},);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      TermDate termDate = TermDate.fromJson(jsonResponse);
      _termDate = termDate;
      notifyListeners();
    } else {
      throw Exception('Failed to load term date data');
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
