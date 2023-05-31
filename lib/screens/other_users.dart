import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/other_users.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class MyUsersScreen extends StatefulWidget {
  @override
  _TermDateScreenState createState() => _TermDateScreenState();
}

class _TermDateScreenState extends State<MyUsersScreen> {
  @override
  void initState() {
    super.initState();

  }


  Future<Map<String, dynamic>> _getAuthDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = json.decode(prefs.getString('authData')!);

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }

  Future<List<OtherUsers>> fetchFees() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    // Replace the URL below with the actual API endpoint
    final response = await http.get(Uri.parse('${baseUrl}/other-parent/${user.id}'), headers: headers,);

    if (response.statusCode == 200) {

      print('GHATA  ${response.body} ${user}');
      List<dynamic> jsonResponse = jsonDecode(response.body);

      //  Map<String, dynamic> jsonResponse = raw_jsonResponse[0]; // This line is changed

      print(jsonResponse);
      List<OtherUsers> termHolidays = jsonResponse.map((holidayJson) => OtherUsers.fromJson(holidayJson)).toList();

      // _fees = fees;
      // notifyListeners();
      return termHolidays;
    } else {
      throw Exception('Failed to load fees data');
    }
  }

  Uint8List? base_image(String imageDataUrl) {
    List<String> splitData = imageDataUrl.split(',');

    if (splitData.length == 2) {
      String imageDataType = splitData[0]; // contains "data:image/png;base64"
      String base64Image = splitData[1]; // contains the actual base64 image data
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
    return Scaffold(
      appBar: AppBar(
        title: Text('My users'),
      ),
      body: Container(child: FutureBuilder<List<OtherUsers>>(
          future: fetchFees(),
          builder: (contex, snapshot) {


            if (snapshot.hasData) {
             List <OtherUsers> data_model = snapshot.data!;

             return ListView.builder(
               itemCount: data_model.length,
               itemBuilder: (context, index) {
                 OtherUsers otherUsers = data_model[index];
                 print(otherUsers.avatar);
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Card(
                     child: Container(
                       padding: EdgeInsets.all(16),
                       child:Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('${otherUsers.name}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                           SizedBox(height: 4,),
                           Text('Phone No: ${otherUsers.phoneNum}',style: TextStyle(fontSize: 13)),
                           SizedBox(height: 2,),
                           Text('User type: ${otherUsers.userType}',style: TextStyle(fontSize: 12,color: Colors.grey[600],)),
                         ],
                       )


                     ),
                   ),
                 );
               },
             );
            } else if (snapshot.hasError) {
               print(snapshot.error);
              return Center(
                child: Text('Error'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );

            }
          }),),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            await Navigator.of(context).pushNamed('/add_user');
            setState(() {

            });
          },
          tooltip: 'Add user',
          child: const Icon(Icons.add),
        )
    );
  }

  String formatDate(DateTime date) {
    String outputFormat = 'MMM d, yyyy';
    try {
      final outputDateFormat = DateFormat(outputFormat);
      return outputDateFormat.format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
