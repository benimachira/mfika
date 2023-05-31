import 'package:flutter/material.dart';

// API URLs
//const String baseUrl = 'https://econsultant.walk-awesome.com/api';

const String baseUrl = 'https://mfika.projtrac.co.ke/api';

const String attendanceApi = '$baseUrl/attendance';
const String busLocationApi = '$baseUrl/bus_location';
const String childApi = '$baseUrl/child';
const String invoiceApi = '$baseUrl/invoice';
const String termDatesApi = '$baseUrl/term_dates';
const String termEventsApi = '$baseUrl/term_events';
const String termTripsApi = '$baseUrl/term_trips';

// Colors
const Color primaryColor = Color(0xFF6200EE);
const Color secondaryColor = Color(0xFF03DAC6);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color errorColor = Color(0xFFB00020);

// Text Styles
const TextStyle headingTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subheadingTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16.0,
);
