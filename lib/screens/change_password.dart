import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _currentPassword;
  late String _newPassword;
  late String _confirmPassword;

  // Create two boolean state variables for each text field
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[700]),
      fillColor: Colors.black.withOpacity(0.2),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), // Adding the border here
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newPassword = value!;
                  },
                ),
                SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), // Adding the border here
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmText = !_obscureConfirmText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmPassword = value!;
                  },
                ),
                SizedBox(height: 64),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Verify the new password and confirm password are the same
                        if (_newPassword != _confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'New password and confirm password do not match'),
                            ),
                          );
                          return;
                        }

                        bool passwordChanged =
                            await changePassword(_newPassword);

                        if (passwordChanged) {
                          // if password changed successfully, pop out from the current screen
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text('Change Password'),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getAuthDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = json.decode(prefs.getString('authData')!);

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }

  Future<bool> changePassword(String password) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    _showLoggingInDialog();

    // If everything is valid, send the data to the server
    Map<String, dynamic> passwordData = {
      'email': user.email,
      'password': password,
    };

    // Replace the URL below with the actual API endpoint
    final response = await http.post(
      Uri.parse('${baseUrl}/change-password'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(passwordData),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Password changed successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return true;
    } else {
      print(response.body);
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to change password'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // First pop: Close the dialog
                  Navigator.of(context).pop();
                  // Second pop: Navigate back to the previous screen
                  Navigator.of(context).pop();

                },
              ),
            ],
          );
        },
      );
      return false;
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
              Text('Submitting, please wait...'),
            ],
          ),
        );
      },
    );
  }
}
