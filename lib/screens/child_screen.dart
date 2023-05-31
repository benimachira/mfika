import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:school_trans/screens/fee_report_screen.dart';
import 'package:school_trans/screens/term_trip_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/child.dart';
import '../models/dailytrips.dart';
import '../models/user.dart';
import '../models/vehicle_coordinates.dart';
import '../utils/constants.dart';
import 'attendance_report_screen.dart';
import 'package:http/http.dart' as http;

import 'bus_map_screen.dart';
import 'colors.dart';
import 'edit_location_screen.dart';

class ChildScreen extends StatefulWidget {
  final Child child;

  ChildScreen({required this.child});

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {


  String apiKey = 'AIzaSyDiyrRpT1Rg7EUpZCUAKTtdw3jl70UzBAU';

  @override
  void initState() {
    super.initState();
   // initializePusher(widget.child.vehicleId);
  }

  @override
  void dispose() {
    super.dispose(); // Call super.dispose() to ensure resources are released
  }


  Future<Map<String, dynamic>> _getAuthDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = json.decode(prefs.getString('authData')!);

    return {
      'user': User.fromJson(authData['user']),
      'authToken': authData['access_token'],
    };
  }

  Future<DataModel> fetch_bus_location() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };


    // Replace the URL below with the actual API endpoint
    final response = await http.get(
      Uri.parse('${baseUrl}/vehiclecoord/${widget.child.id}'),
      headers:headers,
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      //print('MAAAA ${jsonResponse}');

      DataModel termDate = DataModel.fromJson(jsonResponse);

      return termDate;
    } else {
      throw Exception('Failed to load term date data');
    }
  }

  Widget buildSection(String title, List<Widget> content) {
    return ExpansionTile(
      title: Text(title),
      children: content,
    );
  }

  double? safeStringToDouble(String? str) {
    try {
      print('DDDD ${double.parse(str ?? '')}');
      return double.parse(str ?? '');
    } catch (e) {
      return null;
    }
  }

  Future<BusData> fetchStudentDailyInfo(int childId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    // Replace the URL below with the actual API endpoint
    final response = await http.get(
      Uri.parse('${baseUrl}/trips/$childId'),

      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      //print('GGGDDD ${jsonResponse}');
      BusData studentDailyInfo = BusData.fromJson(jsonResponse);
      return studentDailyInfo;
    } else {
      throw Exception('Failed to load daily trips');
    }
  }

  @override
  Widget build(BuildContext context) {

    var image = base_image(widget.child.image??'');
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.child.firstName} ${widget.child.lastName}'),
      ),
      body: FutureBuilder<Child?>(
          future: fetchChildren(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);

              return Center(
                child: Text('Error'),
              );
            } else if (snapshot.hasData) {
              final Child child = snapshot.data!;
              var lat_ = child.lat;
              var lng_ = child.lng;

              var lat2_ = child.latDrop;
              var lng2_ = child.lngDrop;

              print('GGG ${child.lat}');
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [



                      Center(
                        child: image != null
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
                      ),
                      SizedBox(height: 16),
                      Text(
                        child.firstName + ' ' + child.lastName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Adm No: ${child.admission_num}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      ),

                      Text(
                        'Grade: ${child.grade}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      ),

                      SizedBox(height: 16),

                      FutureBuilder<DataModel>(
                        future: fetch_bus_location(),
                        builder: (contex, snapshot) {
                        //  print('MAAAA2 ${snapshot.data}');

                          if (snapshot.hasData) {
                            DataModel data_model = snapshot.data!;

                            return OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        BusMapScreen(child, data_model),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.directions_bus,
                                color: secondaryColorA,
                                size: 18,
                              ),
                              label: Text('Track',
                                  style: TextStyle(color: primaryLightColorA)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryLightColorA),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            //  print(snapshot.error);
                            return Center(
                              child: Text('Error'),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      AttendanceReportScreen(child),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.assignment_outlined,
                              color: secondaryColorA,
                              size: 18,
                            ),
                            label: Text('Attendance',
                                style: TextStyle(color: primaryLightColorA)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryLightColorA),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => FeeReportScreen(child),
                                ),
                              );

                              //  Navigator.of(context).pushNamed('/fee_report');
                            },
                            icon: Icon(
                              Icons.file_copy_outlined,
                              color: secondaryColorA,
                              size: 18,
                            ),
                            label: Text('Fees Report',
                                style: TextStyle(color: primaryLightColorA)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryLightColorA),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Add other widgets for the rest of the sections
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              markAbsent(child, context);
                            },
                            icon: Icon(
                              Icons.flag_outlined,
                              color: secondaryColorA,
                              size: 18,
                            ),
                            label: Text('Mark Absent',
                                style: TextStyle(color: primaryLightColorA)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryLightColorA),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => TermTripScreen(
                                    child,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: secondaryColorA,
                              size: 18,
                            ),
                            label: Text('School Trips',
                                style: TextStyle(color: primaryLightColorA)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryLightColorA),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Drop off and pick up locations',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          ChangeLocationsScreen(1, child),
                                    ),
                                  );
                                  setState(() {
                                    // Update the necessary state here
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pick up',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700]),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        (safeStringToDouble(lat_) != null &&
                                                safeStringToDouble(lng_) !=
                                                    null)
                                            ? FutureBuilder<String?>(
                                                future: getPlaceName(LatLng(
                                                    safeStringToDouble(lat_)!,
                                                    safeStringToDouble(lng_)!)),
                                                builder: (context, snapshot) {
                                                  print(
                                                      'FFFFs ${snapshot.data}');
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "Error: ${snapshot.error}");
                                                  } else {
                                                    return Expanded(
                                                      child: Text(
                                                        '${snapshot.data??'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                secondaryColorA),
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            : Text("Select location"),
                                        Expanded(child: Text('')),
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Divider(),
                              InkWell(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          ChangeLocationsScreen(2, child),
                                    ),
                                  );
                                  setState(() {
                                    // Update the necessary state here
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Drop off',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700]),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        (safeStringToDouble(lat2_) != null &&
                                                safeStringToDouble(lng2_) !=
                                                    null)
                                            ? FutureBuilder<String?>(
                                                future: getPlaceName(LatLng(
                                                    safeStringToDouble(lat2_)!,
                                                    safeStringToDouble(
                                                        lng2_)!)),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        "Error: ${snapshot.error}");
                                                  } else {
                                                    return Flexible(
                                                      child: Text(
                                                        '${snapshot.data??'N/A'}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                secondaryColorA),
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            : Text("Select location"),
                                        Expanded(child: Text('')),
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: FutureBuilder<BusData>(
                            future: fetchStudentDailyInfo(child.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final busData = snapshot.data;

                                return ListView.builder(
                                  itemCount: 2,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  // Assuming you always have two expandables (amBus and pmBus)
                                  itemBuilder: (context, index) {
                                    // Determine the expandable bus based on the index
                                    final bus = index == 0
                                        ? busData!.amBus
                                        : busData!.pmBus;


                                    var image_driver = base_image(bus.driver.image??'');
                                    var image_attendant = base_image(bus.attendant.image??'');

                                    return ExpansionTile(
                                      title: Text(
                                          index == 0 ? 'AM Bus' : 'PM Bus'),
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Bus information',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            'Title: ${bus.vehicle.title}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Number plate: ${bus.vehicle.plateNum}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Driver',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Center(
                                                  child: image_driver != null
                                                      ? CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: MemoryImage(
                                                        image_driver!), // Replace with the actual child image
                                                  )
                                                      : CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: NetworkImage(
                                                        'image!'), // Replace with the actual child image
                                                  ),
                                                ),

                                                // CircleAvatar(
                                                //   radius: 20,
                                                //   backgroundImage:
                                                //       MemoryImage(!),
                                                // ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '${bus.driver.name}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.call,
                                                          size: 16,
                                                          color:
                                                              secondaryColorA,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          '${bus.driver.phoneNum}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Attendant',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Center(
                                                  child: image_attendant != null
                                                      ? CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: MemoryImage(
                                                        image_attendant!), // Replace with the actual child image
                                                  )
                                                      : CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: NetworkImage(
                                                        'image!'), // Replace with the actual child image
                                                  ),
                                                ),
                                                // CircleAvatar(
                                                //   radius: 20,
                                                //   backgroundImage:
                                                //       MemoryImage(base_image(bus.attendant.avatar)!),
                                                // ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '${bus.attendant.name}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.call,
                                                          size: 16,
                                                          color:
                                                              secondaryColorA,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          '${bus.attendant.phoneNumber}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Add more ListTile widgets for other properties you want to display
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<Attendant> fetchAttendant(int driverId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    print('Fetching driver data for id: ${driverId}');

    final response = await http.get(
      Uri.parse('${baseUrl}/driver-info/$driverId'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Attendant driver = Attendant.fromJson(jsonResponse['attendant']);

      print('Driver: ${driver}');

      return driver;
    } else {
      throw Exception('Failed to load driver data');
    }
  }

  Future<Driver> fetchDriver(int driverId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    print('Fetching driver data for id: ${driverId}');

    final response = await http.get(
      Uri.parse('${baseUrl}/driver-info/$driverId'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Driver driver = Driver.fromJson(jsonResponse['driver']);

      print('Driver: ${driver}');

      return driver;
    } else {
      throw Exception('Failed to load driver data');
    }
  }

  Future<Bus> fetchStudentDailyTrips(int studentId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    print('Fetching daily trips for student id: ${studentId}');

    final response = await http.get(
      Uri.parse('${baseUrl}/trips/$studentId'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Bus dailyTrip = Bus.fromJson(jsonResponse['student_daily_trips']);

      print('Student Daily Trip: ${dailyTrip}');

      return dailyTrip;
    } else {
      throw Exception('Failed to load student daily trips data');
    }
  }

  void _showLoggingInDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Submitting in...'),
            ],
          ),
        );
      },
    );
  }

  Future mark_as_absent(int driverId, reason) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    print('Fetching driver data for id: ${driverId}');
    Navigator.pop(context);
    _showLoggingInDialog(context);
    String am_pm = isAM() ? 'am' : "pm";

    final response = await http.post(
      Uri.parse('${baseUrl}/flagoff/$driverId'),
      headers: {'Authorization': 'Bearer $authToken'},
      body: {'reason': reason, 'time': am_pm},
    );

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.body}"),
        duration: Duration(milliseconds: 600),
      ));
    } else {
      throw Exception('Failed to load driver data');
    }
  }

  bool isAM() {
    DateTime now = DateTime.now();
    String currentTime = DateFormat('hh:mm a').format(now);
    bool isAM = currentTime.endsWith('AM');
    return isAM;
  }

  Uint8List? base_image(String imageDataUrl) {
    String image_url =imageDataUrl??"";

    List<String> splitData = image_url.split(',');

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

  void launchDialer(String phoneNumber) async {
    String dialUrl = "tel:$phoneNumber";
    final uri = Uri.parse(dialUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $dialUrl';
    }
  }

  void markAbsent(Child child, context) async {
    final prefs = await SharedPreferences.getInstance();
    final _reasons = ['Sick', 'Family Emergency', 'Other'];
    String _selectedReason = _reasons.first;
    String _otherReason = '';

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mark ${child.firstName} ${child.lastName} as absent',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Reason for child\'s absence',
                    style: TextStyle(fontSize: 16,),
                  ),
                  SizedBox(height: 32),
                  DropdownButton<String>(
                    value: _selectedReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value!;
                        // if (_selectedReason != 'Other') {
                        //   _otherReason = '';
                        // }
                      });
                    },
                    items: _reasons
                        .map(
                          (reason) => DropdownMenuItem(
                            value: reason,
                            child: Text(reason),
                          ),
                        )
                        .toList(),
                    isExpanded: true,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 1,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 32),
                  if (_selectedReason == 'Other')
                    Column(
                      children: [
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter other reason',
                            hintText: 'Specify the reason for absence',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _otherReason = value;
                            });
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () async {
                      // Update the child's attendance status
                      // ... your existing code ...

                      //_selectedReason
                      mark_as_absent(child.id, _selectedReason);
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> getPlaceName(position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].length > 0) {
        return data['results'][0]['formatted_address'];
      }
    }
    return null;
  }

  Future<Child> fetchChildren() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    final response = await http.get(
      Uri.parse('$baseUrl/child/${widget.child.id}'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        Child _child = Child.fromJson(jsonResponse[0]);
        return _child;
      } else {
        throw Exception('No child found');
      }
    } else {
      throw Exception('Failed to load children data');
    }
  }
}
