import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import 'other_users.dart';

class UserProfileScreen extends StatelessWidget {
  Uint8List? base_image(String imageDataUrl) {
    List<String> splitData = imageDataUrl.split(',');

    if (splitData.length == 2) {
      String imageDataType = splitData[0]; // contains "data:image/png;base64"
      String base64Image =
          splitData[1]; // contains the actual base64 image data
      Uint8List bytes = base64Decode(base64Image);

      return bytes;

      print(base64Image); // This will print just the base64 image data
    } else {
      return null;
      print("Invalid image data URL.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final theme = Theme.of(context);
    var image = base_image(user.avatar);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 24,
                        backgroundImage: MemoryImage(
                            image!), // Replace with the actual child image
                      )
                    : CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                            'image!'), // Replace with the actual child image
                      ),
                SizedBox(width: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      user.email ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                    ),
                    Text(
                      user.phoneNum ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 48),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        // Navigate to edit profile screen

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyUsersScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_add,
                              size: 22,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text('Add Users',
                                    style: TextStyle(fontSize: 14))),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Divider(),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        // Navigate to settings screen
                        Navigator.of(context).pushNamed('/change_password');
                      },
                      child: Container(
                        height: 45,
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_open,
                              size: 22,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text('Change password',
                                    style: TextStyle(fontSize: 14))),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Divider(),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout()
                            .then((value) {
                          RestartWidget.restartApp(context);
                        });
                      },
                      child: Container(
                        height: 45,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 22,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text('Logout',
                                    style: TextStyle(fontSize: 14))),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(BuildContext context, String? value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodyText1?.color,
            ),
          ),
        ],
      ),
    );
  }
}
