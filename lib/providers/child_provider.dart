import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class ChildProvider with ChangeNotifier {
  List<Child> _children = [];

  ChildProvider();

  List<Child> get children => _children;

  // Get child by ID
  Child getChildById(int id) {
    return _children.firstWhere((child) => child.id == id);
  }

  Future<Map<String, dynamic>> _getAuthDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = json.decode(prefs.getString('authData')!);

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }

  Future<void> fetchChildren() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];
    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };


    final response = await http.get(
      Uri.parse('$baseUrl/children/${user.id}'),
      headers: headers,
    );

    if (response.statusCode == 200) {

      List<dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List<Child> children =
      jsonResponse.map((childData) => Child.fromJson(childData)).toList();
      _children = children;
      notifyListeners();
    } else {
      print(response.body);
      throw Exception('Failed to load children data');
    }
  }

}
