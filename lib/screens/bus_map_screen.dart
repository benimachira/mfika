import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:pusher_client/pusher_client.dart';
import 'package:school_trans/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_webservice/directions.dart' as direction;

import '../models/child.dart';
import '../models/dailytrips.dart';
import '../models/user.dart';
import '../models/vehicle_coordinates.dart';
import 'colors.dart';

class BusMapScreen extends StatefulWidget {
  final Child child;
  final DataModel data_model;

  BusMapScreen(this.child, this.data_model);

  @override
  _BusMapScreenState createState() => _BusMapScreenState();
}

class _BusMapScreenState extends State<BusMapScreen> {
  final _mapController = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  BitmapDescriptor? _busIcon;

  LatLng? _sourcePosition;
  LatLng? _destPosition;
  PusherClient? pusher;

  @override
  void dispose() {
    pusher != null ? pusher!.disconnect() : () {};
    super.dispose(); // Call super.dispose() to ensure resources are released
  }

  void initializePusher(bus_id) async {
    print('SSSS${bus_id}');
    pusher = PusherClient(

      '05d822d3f46eb0987d53',
      PusherOptions(cluster: 'ap2', encrypted: true),
    );

    await pusher!.connect();

    Channel channel = pusher!.subscribe('notifications-schoolapp.${bus_id}');
    channel.bind('App\\Events\\VehicleLocation', (event) {
      print(event!.data);
      Map data = jsonDecode(event.data!);
      var latitude = data['lat'];
      var longitude = data['lng'];

      print(latitude);


     _updateBusLocation(double.parse(latitude), double.parse(longitude));
      // Show notification when an event is received
      //showNotification('New Message Notification', event!.data!);
    });
  }

  @override

  void initState() {
    super.initState();
    _destPosition = LatLng(
        double.parse(widget.data_model.studentHomeCoordinates.latitude),
        double.parse(widget.data_model.studentHomeCoordinates.longitude));

    _sourcePosition = LatLng(
        double.parse(widget.data_model.schoolLocation.latitude),
        double.parse(widget.data_model.schoolLocation.longitude));

    initializePusher(widget.data_model.trip.vehicleId);


    _initialize();
  }

  void _updateBusLocation(double latitude, double longitude) {
    if (mounted) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == 'busSourceMarker');
        _markers.add(Marker(
          markerId: MarkerId('busSourceMarker'),
          position: LatLng(latitude, longitude),
          icon: _busIcon!,
        ));
      });
    }
  }



  Future<void> _initialize() async {
    await loadBusIcon(10.0, 10.0).then((value) {
      _setupMarkers();
      _setupPolylines();
    });
  }

  Future<void> loadBusIcon(double width, double height) async {
    try {
      final ByteData? imageData =
      await rootBundle.load('assets/images/bus_icon.png');
      if (imageData == null) {
        // Handle the case when image data is null
        return;
      }
      final Uint8List byteData = imageData.buffer.asUint8List();

      final ui.Codec codec = await ui.instantiateImageCodec(byteData,
          targetWidth: 64, targetHeight: 64, allowUpscaling: true);
      if (codec == null) {
        // Handle the case when the codec is null
        return;
      }
      final ui.FrameInfo? frameInfo = await codec.getNextFrame();
      if (frameInfo == null) {
        // Handle the case when the frame info is null
        return;
      }

      final ui.Image image = frameInfo.image;
      final ByteData? pngByteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      if (pngByteData == null) {
        // Handle the case when the png byte data is null
        return;
      }

      if (mounted) {
        setState(() {
          _busIcon =
              BitmapDescriptor.fromBytes(pngByteData.buffer.asUint8List());
          _setupMarkers();
        });
      }
    } catch (e) {
      // Handle any other exceptions or errors
      print('Error loading bus icon: $e');
    }
  }

  void _setupMarkers() {
    if (mounted) {
      setState(() {
        if (_busIcon != null) {
          _markers.add(Marker(
              markerId: MarkerId('busSourceMarker'),
              position: _sourcePosition ?? LatLng(0, 0),
              icon: _busIcon!));
        } else {
          print('bus icon is null');
        }

        _markers.add(Marker(
            markerId: MarkerId('sourceMarker'),
            position: _sourcePosition ?? LatLng(0, 0)));

        _markers.add(Marker(
            markerId: MarkerId('destMarker'),
            position: _destPosition ?? LatLng(0, 0)));
      });
    }
  }

  void _setupPolylines() async {
    if (mounted) {
      setState(() {
        _polylines.clear(); // Clear existing polylines

        if (_sourcePosition != null && _destPosition != null) {
          // Create instance of the Google Maps Directions API
          final directions = direction.GoogleMapsDirections(apiKey: 'AIzaSyDiyrRpT1Rg7EUpZCUAKTtdw3jl70UzBAU');

          // Request directions from source to destination
          directions
              .directionsWithLocation(
            direction.Location(
              lat: _sourcePosition!.latitude,
              lng: _sourcePosition!.longitude,
            ),
            direction.Location(
              lat: _destPosition!.latitude,
              lng: _destPosition!.longitude,
            ),
          )
              .then((response) {
            if (response.isOkay) {
              // Decode the encoded points of the polyline
              final points = PolylinePoints()
                  .decodePolyline(response.routes.first.overviewPolyline.points);

              if (points.isNotEmpty) {
                // Create a list of LatLng from the points
                final List<LatLng> polylineCoordinates =
                points.map((point) => LatLng(point.latitude, point.longitude)).toList();

                setState(() {
                  _polylines.add(Polyline(
                    polylineId: PolylineId('route'),
                    points: polylineCoordinates,
                    width: 4,
                    color: Colors.blue,
                  ));
                });

              }
            }
          }).catchError((error) {
            print('Error fetching directions: $error');
          });
        }
      });
    }
  }


  Widget _buildTripCard(BusData data_model) {
    Bus? bus;
    if (isAM()) {
      bus = data_model.amBus;
    } else {
      bus = data_model.pmBus;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('${widget.child.firstName} ${widget.child.lastName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 8,
            ),
            Text('Title: ${bus.vehicle.title}', style: TextStyle(fontSize: 15)),
            Text('Bus No: ${bus.vehicle.plateNum}',
                style: TextStyle(fontSize: 14,color: secondaryColorA)),
            Divider(),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                  InkWell(
                    onTap: () {
                      launchDialer(bus!.driver.phoneNum);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Driver:',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4,
                        ),
                        Text('${bus.driver.name}',
                            style: TextStyle(fontSize: 13)),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              size: 18,
                              color: secondaryColorA,
                            ),
                            Text('${bus.driver.phoneNum}',
                                style: TextStyle(
                                    fontSize: 13, color: secondaryColorA)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  InkWell(
                    onTap: () {
                      launchDialer(bus!.attendant.phoneNumber);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Attendant:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4,
                        ),
                        Text('${bus.attendant.name}',
                            style: TextStyle(fontSize: 13)),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              size: 18,
                              color: secondaryColorA,
                            ),
                            Text('${bus.attendant.phoneNumber}',
                                style: TextStyle(
                                    fontSize: 13, color: secondaryColorA)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Tracking'),
      ),
      body: Stack(

        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _sourcePosition!,
              zoom: 17,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            markers: _markers,
            polylines: _polylines,
          ),
          FutureBuilder<BusData>(
              future: fetchStudentDailyInfo(widget.child.id),
              builder: (contex, snapshot) {
                if (snapshot.hasData) {
                  BusData data_model = snapshot.data!;

                  return Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: _buildTripCard(data_model),
                  );
                } else if (snapshot.hasError) {
                  //  print(snapshot.error);
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child:Center(
                      child: Text('Error'),
                    ),
                  );
                } else {
                  return Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child:Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                }
              })
        ],
      ),
    );
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

  Future<DataModel> fetch_bus_location() async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];

    final response = await http.get(
      Uri.parse('${baseUrl}/vehiclecoord/${widget.child.id}'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      DataModel termDate = DataModel.fromJson(jsonResponse);

      return termDate;
    } else {
      throw Exception('Failed to load term date data');
    }
  }

  Future<BusData> fetchStudentDailyInfo(int childId) async {

    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];
    print('GGGG ${childId}');
    // Replace the URL below with the actual API endpoint
    final response = await http.get(
      Uri.parse('${baseUrl}/trips/$childId'),
      headers: {'Authorization': 'Bearer $authToken'},
    );


    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);


      BusData studentDailyInfo = BusData.fromJson(jsonResponse);
      return studentDailyInfo;
    } else {
      throw Exception('Failed to load daily trips');
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

  bool isAM() {
    DateTime now = DateTime.now();
    String currentTime = DateFormat('hh:mm a').format(now);
    bool isAM = currentTime.endsWith('AM');
    return isAM;
  }
}
