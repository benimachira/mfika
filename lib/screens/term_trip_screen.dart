import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_trans/screens/trip_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child.dart';
import '../models/term_trip.dart';
import '../models/user.dart';
import '../providers/term_trips_provider.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class TermTripScreen extends StatefulWidget {
  final Child child;

  TermTripScreen(this.child);

  @override
  _TermTripScreenState createState() => _TermTripScreenState();
}

class _TermTripScreenState extends State<TermTripScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'General Trips'),
            Tab(text: 'Trips With Grade'),
          ],
        ),
      ),
      body: FutureBuilder<SchoolTrip>(
        future: fetchSchoolTrips(),
        builder: (context, snapshot) {
          print('AAAA7 ${snapshot.data}');
          if (snapshot.hasData) {
            SchoolTrip trip = snapshot.data!;
            List<General> _tripsWithGrade = trip.tripsWithGrade;
            List<General> _generalTrips = trip.general;


            return TabBarView(
              controller: _tabController,
              children: [
                _buildTripsList(_generalTrips),
                _buildTripsList(_tripsWithGrade),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('No data available on trips'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTripsList(List<General> schoolTrips) {
    return ListView.builder(
      itemCount: schoolTrips.length,
      itemBuilder: (context, index) {
        General schoolTrip = schoolTrips[index];

        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         TripDetailScreen(
            //           trips: ,
            //         ),
            //   ),
            // );
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schoolTrip.tripName,
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2,),
                    Text(
                      'Date: ${schoolTrip.tripDate}',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Destination: ${schoolTrip.destinationName[0]}',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Dept. ${schoolTrip.departureTime}',
                            style: TextStyle(fontSize: 12,color: Colors.green),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Return: ${schoolTrip.returnTime}",
                            style: TextStyle(fontSize: 12,color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<SchoolTrip> fetchSchoolTrips() async {

    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(
      Uri.parse('${baseUrl}/school-trips/${widget.child.id}'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      //print(jsonResponse);
      SchoolTrip schoolTrips = SchoolTrip.fromJson(jsonResponse);

      print('SSSSA${schoolTrips.name}');
      return schoolTrips;
    } else {

      throw Exception('Failed to load school trips data');
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
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
