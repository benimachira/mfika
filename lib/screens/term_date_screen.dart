import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_trans/providers/term_holidays_provider.dart';
import '../models/term_date.dart';
import '../models/term_holidays.dart';
import '../providers/term_dates_provider.dart';

class TermDateScreen extends StatefulWidget {
  @override
  _TermDateScreenState createState() => _TermDateScreenState();
}

class _TermDateScreenState extends State<TermDateScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TermDatesProvider>(context, listen: false).fetchTermDate();
    Provider.of<TermHolidaysProvider>(context, listen: false)
        .fetchTermHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term Dates'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Consumer<TermDatesProvider>(
                builder: (ctx, termDatesProvider, _) {
                  if (termDatesProvider.termDate == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  TermDate termDate = termDatesProvider.termDate!;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // Navigate to term holidays screen
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${termDate.name} ${termDate.year}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Start Date:',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${formatDate(termDate.start)}',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'End Date:',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${formatDate(termDate.ends)}',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Consumer<TermHolidaysProvider>(
                builder: (ctx, termHolidaysProvider, _) {
                  if (termHolidaysProvider.termHolidays == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<TermHoliday> holidays = termHolidaysProvider.termHolidays;

                  return Container(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.beach_access_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Term Holidays',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: holidays.length,
                              itemBuilder: (ctx, index) {
                                TermHoliday holiday = holidays[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        holiday.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Start: ${holiday.start}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            'End: ${holiday.ends}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
