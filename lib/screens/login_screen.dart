import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;


import '../services/api_service.dart';
import '../utils/constants.dart';
import 'children_list_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _showLoggingInDialog();

      try {
        final response = await login(_email, _password);

        if (response?['success']) {
          Provider.of<AuthProvider>(context, listen: false).setAuthData(
            response?['user'] as User,
            response?['access_token'],
          );
          Navigator.of(context).pop(); // Close the logging in dialog

          print('AAA');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ChildrenListScreen(user: response?['user'] as User,),
            ),
          );
          print('BBB');
         // Navigator.of(context).pop(); // Close the logging in dialog
          //Navigator.of(context).pushReplacementNamed('/home');
        } else {
          print(response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response?['message']}')),
          );
        }
      } finally {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(); // Close the logging in dialog only if it's still open
        }
      }
    }
  }



  void _showLoggingInDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 100),
              Image.asset('assets/images/mfika_logo.png', height: 100, width: 100),
              SizedBox(height: 16),
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 48),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
              SizedBox(height: 32),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black.withOpacity(0.2),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
              SizedBox(height: 64),
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Login'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/change_password');
                },
                child: Text('Forgot Password?'),
                style: TextButton.styleFrom(),
              ),
            ],
          ),
        ),
      ),

    );
  }
  // Future<Map<String,dynamic>?> login(String email, String password) async {
  //
  //
  //   var user_object = jsonEncode({'email': email, 'password': password});
  //
  //
  //   final Map<String, dynamic>? jsonResponse={};
  //   var url = '${baseUrl}/login';
  //
  //   print('AAAv ${user_object} ${url} ');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json;charset=UTF-8',
  //     'Charset': 'utf-8'
  //   };
  //
  //   // Replace the URL below with the actual API endpoint
  //   final response = await http.post(Uri.parse(url),body: user_object,headers:headers);
  //
  //
  //   print('HHHH ${response.statusCode}');
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponseh = json.decode(response.body);
  //
  //     print('HHHA ${response.body}');
  //
  //     jsonResponse?['success'] = true;
  //     jsonResponse?['user'] = User.fromJson(jsonResponseh['user']);
  //   } else {
  //     jsonResponse?['success'] = false;
  //   }
  //
  //   return jsonResponse;
  //
  // }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    var user_object = jsonEncode({'email': email, 'password': password});
    print('AAAv ${user_object} ${baseUrl} ');

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/login'),
        body: user_object,
        headers: headers,
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('HHHH ${response.body}');

      if (response.statusCode == 200) {
        jsonResponse['success'] = true;
        jsonResponse['user'] = User.fromJson(jsonResponse['user']);
      } else {
        jsonResponse['success'] = false;
      }

      return jsonResponse;
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-profile'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
