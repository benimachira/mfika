import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/fees.dart'; // import the Fees model
import '../utils/constants.dart';

class FeeProvider with ChangeNotifier {
  Fees? _fees;

  Fees? get fees => _fees;

  // Get fees by Student ID
  Fees? getFeesByStudentId(int id) {
    if (_fees != null && _fees!.feeStatement?.feeStructure?.student == id) {
      return _fees;
    }
    return null;
  }

  Future<void> fetchFees(int studentId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/paid-fees/$studentId'), headers: {'Authorization': 'Bearer $authToken'},);

    if (response.statusCode == 200) {
      print('GHATA   ${response.body}');

      List<dynamic> raw_jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> jsonResponse = raw_jsonResponse[0]; // This line is changed
      Fees fees = Fees.fromJson(jsonResponse);
      _fees = fees;
      notifyListeners();
    } else {
      throw Exception('Failed to load fees data');
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
