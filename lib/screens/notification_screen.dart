import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/school_notification.dart';
import '../providers/notification_provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<SchoolNotification>> fetchNotifications() async {
    try {
      print('AA');
      final authData = await _getAuthDataFromPrefs();
      final User user = authData['user'];
      final authToken = authData['authToken'];

      var url = Uri.parse('${baseUrl}/notifictions/${user.id}');

      print('AA${url}');

      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $authToken'});

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<SchoolNotification> notifications = jsonResponse
            .map((notificationJson) =>
                SchoolNotification.fromJson(notificationJson))
            .toList();
        return notifications;
      } else {
        throw Exception(
            'Failed to load notifications: HTTP ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load notifications: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<SchoolNotification>>(
        future: fetchNotifications(),
        builder: (ctx, snapshot) {
          if(snapshot.hasData){
            List<SchoolNotification> notifications =
            snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (ctx, index) {
                SchoolNotification notification = notifications[index];
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index+1}. ",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.data.haeder ?? "N/A",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            notification.data.body ?? "N/A",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            date_changer(notification.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Divider(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }else if (snapshot.hasError){
            return Center(
              child: Text('Error'),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        }
      ),

    );
  }

  date_changer(dateTimeString) {
    var dateTime1 = DateFormat('yyyy-MM-dd').parse(dateTimeString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime1);
    return formatted;
    print(formatted); // something like 2013-04-20
  }
}
