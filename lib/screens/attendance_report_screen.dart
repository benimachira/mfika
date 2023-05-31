import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_trans/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/attendance_report.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/child.dart';
import '../models/user.dart';

class AttendanceReportScreen extends StatefulWidget {
  Child? child;

  AttendanceReportScreen(Child child) {
    this.child = child;
  }

  @override
  _AttendanceCalendarScreenState createState() =>
      _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceReportScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future<AttendanceReport> fetchAttendanceReports() async {
    final authData = await _getAuthDataFromPrefs();
    final authToken = authData['authToken'];

    final response = await http.get(


        Uri.parse('${baseUrl}/attendance-data/${widget.child!.id}'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);
      print('GGGGAAA ${jsonResponse}');
      AttendanceReport attendanceReport =
      AttendanceReport.fromJson(jsonResponse);

      print('GGGGAAAB ${jsonResponse}');

      // List<AttendanceReport> attendanceReports =
      //     List<dynamic>.from(jsonResponse)
      //         .map((json) =>
      //             AttendanceReport.fromJson(json as Map<String, dynamic>))
      //         .toList();

      return attendanceReport;
    } else {
      print('GGGGAAA }');
      print('ADAA Z');
      throw Exception('Failed to load attendance reports');
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

  Map<DateTime, List<Absence>> createEvents(AttendanceReport reports) {
    Map<DateTime, List<Absence>> events = {};


      for (var flagOff in reports.flagOff) {
        DateTime date =
            DateTime(flagOff.date.year, flagOff.date.month, flagOff.date.day);
        if (!events.containsKey(date)) {
          events[date] = [];
        }
        events[date]!.add(flagOff);
      }


    return events;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
      ),
      body: FutureBuilder<AttendanceReport>(
        future: fetchAttendanceReports(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            // Error handling
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            final attendance = snapshot.data!;
            final events = createEvents(attendance);

            int absentDaysInCurrentMonth = attendance.flagOff
                .where((absence) => absence.date.month == _focusedDay.month)
                .length;

            print('GGA AD ${events}');

            int totalDaysInCurrentMonth =
                DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;

            return Stack(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: (day) {
                    print('aAA ${day}');
                    return events[day] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    DateTime date = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                    if (!isSameDay(_selectedDay, date)) {
                      // If the selected day has an event (absence), show the bottom sheet.
                      var selectedDayEvents = events[date];
                      _showBottomSheet(context, selectedDayEvents!.first);
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      DateTime date = DateTime(
                          day.year, day.month, day.day); // strip time component
                      DateTime today = DateTime.now();

                      if (isSameDay(date, today) && events[date] != null) {
                        // This day is today and has events, show it with a red background
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (events[date] != null) {
                        // This day has events, show it with a red background
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        // No events, show a standard day cell
                        return Center(child: Text(day.day.toString()));
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(((totalDaysInCurrentMonth - absentDaysInCurrentMonth) / totalDaysInCurrentMonth) * 100).round()}% attendance this month',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Absence absence) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Absence Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Date: ',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(absence.date),
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Reason: ',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        absence.reason,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class AttendanceReport {
  final String name;
  final String grade;
  final int numOfDaysAbsent;
  final List<Absence> flagOff;

  AttendanceReport({
    required this.name,
    required this.grade,
    required this.numOfDaysAbsent,
    required this.flagOff,
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      name: json['attendance']['name'],
      grade: json['attendance']['grade'],
      numOfDaysAbsent: json['attendance']['NumOfDaysAbsent'],
      flagOff: List<Absence>.from(
          json['flagoffs'].map((flagOff) => Absence.fromJson(flagOff))),
    );
  }
}

class Absence {
  final int id;
  final int parentId;
  final int studentId;
  final String reason;
  final String time;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Absence({
    required this.id,
    required this.parentId,
    required this.studentId,
    required this.reason,
    required this.time,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      parentId: json['parent_id'],
      studentId: json['student_id'],
      reason: json['reason'],
      time: json['time'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
