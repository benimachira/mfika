import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:school_trans/utils/constants.dart';
import '../models/child.dart';
import '../models/fees.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class FeeReportScreen extends StatefulWidget {
  Child? child;


  FeeReportScreen(Child child) {
    this.child = child;
  }

  @override
  _FeeReportScreenState createState() => _FeeReportScreenState();
}

class _FeeReportScreenState extends State<FeeReportScreen> {
  PusherClient? pusher;
  Future<Fees> fetchFees() async {
    final authData = await _getAuthDataFromPrefs();
    final authToken = authData['authToken'];

    var url = '${baseUrl}/paid-fees/${widget.child!.id}';

    // Replace the URL below with the actual API endpoint
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    print(url);

    if (response.statusCode == 200) {
      List<dynamic> raw_jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> jsonResponse = raw_jsonResponse[0];
      Fees fees = Fees.fromJson(jsonResponse);
      print('AAAA ${jsonResponse}');
      return fees;
    } else {
      throw Exception('Failed to load fees data');
    }
  }

  date_changer(dateTimeString) {
    // var dateTime1 = DateFormat('yyyy-MM-dd').parse(dateTimeString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTimeString);
    return formatted;
    print(formatted); // something like 2013-04-20
  }

  // void initializePusher() async {
  //   pusher = PusherClient(
  //     '05d822d3f46eb0987d53',
  //     PusherOptions(cluster: 'ap2', encrypted: true),
  //   );
  //
  //   await pusher!.connect();
  //
  //   Channel channel = pusher!.subscribe('notifications-schoolapp.${widget}');
  //   channel.bind('App\\Events\\NewMessageNotification', (event) {
  //     // Show notification when an event is received
  //     //showNotification('New Message Notification', event!.data!);
  //   });
  // }
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
        title: Text('Fee Report'),
      ),
      body: FutureBuilder<Fees>(
        future: fetchFees(), // replace '2' with your actual student ID
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.toString() ==
                'RangeError (index): Invalid value: Valid value range is empty: 0') {
              return Center(
                  child: Text('No Fee report provided for this child'));
            }
            return Center(child: Text('Error'));
          } else if (snapshot.hasData) {
            Fees fees = snapshot.data!;
            FeeStructure feeStructure = fees.feeStatement!.feeStructure!;
            FeePayment feePayment = fees.feeStatement!.feePayments!.first;

            return ListView(
              children: [
                // FeeStructure Card
                Card(
                  margin: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(
                      'Fee Structure Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Amount: ${feeStructure.amount}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Year: ${feeStructure.year}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Term: ${feeStructure.term}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                // FeePayment Card
                Card(
                  margin: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(
                      'Receipt No: ${feePayment.receiptNumber}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Amount Paid: ${feePayment.amountPaid}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Payment Method: ${feePayment.paymentMethod}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Date Paid: ${date_changer(feePayment.datePaid)}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred! ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
