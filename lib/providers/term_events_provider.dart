import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/term_event.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class TermEventsProvider with ChangeNotifier {
  List<TermEvent> _termEvents = [];

  List<TermEvent> get termEvents => _termEvents;

  Future<void> fetchTermEvents() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/events'), headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<TermEvent> termEvents = jsonResponse.map((eventJson) => TermEvent.fromJson(eventJson)).toList();
      _termEvents = termEvents;
      notifyListeners();
    } else {
      throw Exception('Failed to load term events data');
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
