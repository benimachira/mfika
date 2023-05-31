// term_trips_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/term_trip.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class TermTripsProvider with ChangeNotifier {
  List<SchoolTrip> _schoolTrips = [];

  List<SchoolTrip> get schoolTrips => _schoolTrips;

  List<SchoolTrip> get tripsWithGrade =>
      _schoolTrips.where((trip) => trip.tripsWithGrade.isNotEmpty).toList();

  List<SchoolTrip> get generalTrips =>
      _schoolTrips.where((trip) => trip.general.isNotEmpty).toList();


}
