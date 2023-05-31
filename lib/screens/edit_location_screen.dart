import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as webserve;

import '../models/child.dart';
import '../models/user.dart';
import '../providers/child_provider.dart';
import '../utils/constants.dart';

class ChangeLocationsScreen extends StatefulWidget {
  int? source_type;
  Child? child;

  ChangeLocationsScreen(int source_type, Child child) {
    this.source_type = source_type;
    this.child = child;
  }

  @override
  _PickupLocationScreenState createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<ChangeLocationsScreen> {
  final _mapController = Completer<GoogleMapController>();
  LatLng? currentPosition;
  LatLng? selectedPickupLocation;
  Set<Marker> _markers = {};
  String? placeName;
  Location location = Location();
  final ChildProvider _childProvider = ChildProvider();




  // Replace with your Google Maps API key
  final String apiKey = 'AIzaSyDiyrRpT1Rg7EUpZCUAKTtdw3jl70UzBAU';
  webserve.GoogleMapsPlaces _places = webserve.GoogleMapsPlaces(
      apiKey: 'AIzaSyDiyrRpT1Rg7EUpZCUAKTtdw3jl70UzBAU');

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  @override
  void dispose() {  super.dispose(); // Call super.dispose() to ensure resources are released
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
              Text('Submiting ...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locData = await location.getLocation();

      setState(() {
        if (widget.source_type == 1) {
          currentPosition = widget.child!.lat != null? LatLng(
            double.parse(widget.child!.lat),
            double.parse(widget.child!.lng),
          ): LatLng(locData.latitude!, locData.longitude!);
        } else {
          currentPosition = widget.child!.lat != null
              ? LatLng(
            double.parse(widget.child!.latDrop),
            double.parse(widget.child!.lngDrop),
          )
              : LatLng(locData.latitude!, locData.longitude!);
        }

        selectedPickupLocation = currentPosition;
      });

      if (selectedPickupLocation != null) {
        _addPickupMarker(selectedPickupLocation!);
      }
    } catch (e) {
      print(e);
    }
  }

  //
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     final locData = await location.getLocation();
  //     setState(() {
  //       if (widget.source_type == 1) {
  //
  //         currentPosition =LatLng(double.parse(widget.child!.lat),
  //                 double.parse(widget.child!.lng));
  //
  //         print('BAAAAA  ${currentPosition} ${widget.source_type}');
  //       } else {
  //         currentPosition = widget.child!.lat != null
  //             ? LatLng(double.parse(widget.child!.latDrop),
  //                 double.parse(widget.child!.lngDrop))
  //             : LatLng(locData.latitude!, locData.longitude!);
  //         print('ABAAAAAB ${currentPosition} ${widget.source_type}');
  //       }
  //
  //       selectedPickupLocation = currentPosition;
  //     });
  //     _addPickupMarker(selectedPickupLocation!);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<String?> getPlaceName(LatLng position) async {
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

  bool isValidCoordinate(double coordinate) {
    return coordinate >= -90 && coordinate <= 90;
  }
  void _addPickupMarker(LatLng position) async {

    print('AAAAF${position}');



    final place = await getPlaceName(position);

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('pickupMarker'),
          position: position,
          draggable: true,
          infoWindow: InfoWindow(title: 'Pick Pickup${position.longitude}'),

          onDragEnd: (newPosition) {
            setState(() {
              selectedPickupLocation = newPosition;
              print('SSSS ${selectedPickupLocation}');
            });
            _addPickupMarker(newPosition);
          },
        ),
      );
      selectedPickupLocation= position;
      placeName = place;
    });

    _animateToLocation(position);
  }

  void _onMapTap(LatLng location) {
    _addPickupMarker(location);
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    webserve.Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.overlay,
      language: "en",
      components: [],
      types: [],
      strictbounds: false,
    );

    if (p != null) {
      webserve.PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      _addPickupMarker(LatLng(lat, lng));
    }
  }

  Future<void> _animateToLocation(LatLng location) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  @override
  Widget build(BuildContext context) {

    print(selectedPickupLocation);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location'),
        actions: [
          InkWell(
            onTap: () {
              _handlePressButton();
            },
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: currentPosition != null
          ? Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) =>
                      _mapController.complete(controller),
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 17,
                  ),
                  markers: _markers,
                  onTap: _onMapTap,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Selected Pickup Location:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            placeName ?? "Not selected",
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                          SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              _showLoggingInDialog();

                              updateLocation(selectedPickupLocation!,
                                      widget.source_type!, widget.child!.id)
                                  .then((value) async{

                                // Fetch the updated children data using the ChildProvider
                                await _childProvider.fetchChildren();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }).catchError((onError) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            child: Text('Save location',
                                style: TextStyle(color: Colors.blue)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
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

  Future<void> updateLocation(
      LatLng selectedPickupLocation, int sourceType, childId) async {
    final authData = await _getAuthDataFromPrefs();
    final User user = authData['user'];
    final authToken = authData['authToken'];



    String url;
    if (sourceType == 1) {
      url = '${baseUrl}/pickup/$childId';
    } else {
      url = '${baseUrl}/dropoff/$childId';
    }

    var data = {
      'lat': selectedPickupLocation.latitude.toString(),
      'lng': selectedPickupLocation.longitude.toString(),
    };

    var dataEncoded = jsonEncode(data);

    print('AAAA $url $data $dataEncoded');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $authToken'},
      body: dataEncoded,
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      print('Location updated successfully ${response.body}');


    } else {
      print(response.body);
      // If the server returns an unsuccessful response code, then throw an exception.
      throw Exception('Failed to update location');
    }
  }
}
