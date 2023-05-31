import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:school_trans/models/user.dart';

import '../screens/colors.dart';

class CustomDrawer extends StatelessWidget {
  User? user;

  CustomDrawer(User user) {
    this.user = user;
  }

  Uint8List? base_image(String imageDataUrl) {
    List<String> splitData = imageDataUrl.split(',');

    if (splitData.length == 2) {
      String imageDataType = splitData[0]; // contains "data:image/png;base64"
      String base64Image = splitData[1]; // contains the actual base64 image data
      Uint8List bytes = base64Decode(base64Image);

      return bytes;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = base_image(user!.avatar);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(

                  decoration: BoxDecoration(
                    color: primaryColorA,
                  ),
                  accountName: Text(
                    '${user!.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail:
                  Text('${user!.email}', style: TextStyle(fontSize: 14)),
                  currentAccountPicture: image != null
                      ? CircleAvatar(
                    radius: 24,
                    backgroundImage: MemoryImage(image),
                  )
                      : CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('image!'),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline, color: primaryColorA),
                  title: Text('My Account', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/user_profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: primaryColorA),
                  title: Text('Term Dates', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/term_date');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event, color: primaryColorA),
                  title: Text('Term Events', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/term_event');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: primaryColorA),
                  title: Text('Notifications', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/notification_screen');
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Image.asset(
                'assets/images/mfika_logo.png',
                width: 90.0,
                height: 90.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
