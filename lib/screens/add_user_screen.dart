import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;


class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _firstName;
  String? _secondName;
  late String _lastName;
  late String _email;
  late String _phoneNumber;
  late String _idNumber;
  String? _userType; // Add this line to store the selected user type


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
        title: Text('Add New User'),
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
                  decoration: buildInputDecoration('First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value!;
                  },
                ),
                SizedBox(height: 32),
                TextFormField(
                  decoration: buildInputDecoration('Second Name'),
                  onSaved: (value) {
                    _secondName = value;
                  },
                ),
                SizedBox(height: 32),
                TextFormField(
                  decoration: buildInputDecoration('Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value!;
                  },
                ),
                SizedBox(height: 32),
              TextFormField(
                decoration: buildInputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
                SizedBox(height: 32),
                TextFormField(
                  decoration: buildInputDecoration('Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    // Regular expression pattern for a valid phone number
                    String pattern = r'^(?:\+?)(?:[0-9]\s?){6,14}[0-9]$';
                    RegExp regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    // Check the length of the phone number (excluding the country code)
                    String phoneNumber = value.startsWith('0') ? value.substring(1) : value;
                    if (phoneNumber.length < 9 || phoneNumber.length > 15) {
                      return 'Phone number should be between 10 and 15 digits';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value!.startsWith('0')) {
                      _phoneNumber = '+254${value.substring(1)}';
                    } else {
                      _phoneNumber = '+254${value}';
                    }

                  },
                ),

                SizedBox(height: 32),
                TextFormField(
                  decoration: buildInputDecoration('Id Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Id Number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _idNumber = value!;
                  },
                ),
                SizedBox(height: 64),

                SizedBox(height: 32),
                DropdownButtonFormField<String>(
                  decoration: buildInputDecoration('User Type'),
                  value: _userType,
                  items: ['parent two', 'other'].map((userType) {
                    return DropdownMenuItem(
                      value: userType,
                      child: Text(userType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _userType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a user type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Map<String,dynamic> userData ={
                          'name':'$_firstName $_secondName $_lastName',
                          'email':'$_email',
                          'second_name':_firstName,
                          'last_name':_secondName,
                          'first_name':_lastName,
                          'user_type': _userType,
                          'id_num':'$_idNumber',
                          'phone_num':'$_phoneNumber',
                        };

                        addUser(userData);  // Add this line to send the user data

                      }
                    },
                    child: Text('Add User'),
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

    _showLoggingInDialog();

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }
  Future<void> addUser(Map<String, dynamic> userData) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.post(
      Uri.parse('${baseUrl}/add-user/${user.id}'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {

      print(response.body);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User added successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      print(response.body);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add user'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // First pop: Close the dialog
                  Navigator.of(context).pop();



                },
              ),
            ],
          );
        },
      );
    }
  }

// Function to validate email format
  bool _isValidEmail(String email) {
    // Regular expression pattern to match email format
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
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
              Text('Submitting. please wait...'),
            ],
          ),
        );
      },
    );
  }
}
