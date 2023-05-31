import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/term_event.dart';
import '../providers/term_events_provider.dart';
import 'package:intl/intl.dart';


class TermEventScreen extends StatefulWidget {
  @override
  _TermEventsScreenState createState() => _TermEventsScreenState();
}

class _TermEventsScreenState extends State<TermEventScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TermEventsProvider>(context, listen: false)
          .fetchTermEvents()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  date_changer(dateTimeString) {

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTimeString);
    return formatted;
    print(formatted); // something like 2013-04-20
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term Events'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<TermEventsProvider>(
        builder: (ctx, termEventsProvider, _) {
          List<TermEvent> termEvents = termEventsProvider.termEvents;
          return ListView.builder(
            itemCount: termEvents.length,
            itemBuilder: (ctx, index) {
              TermEvent termEvent = termEvents[index];
              return Card(
                margin: EdgeInsets.all(16),
                child: ListTile(
                  title: Text(
                    termEvent.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Year ${termEvent.year} Term ${termEvent.termId}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'From: ${date_changer(termEvent.start)}',
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(

                            child: Text(
                              'To: ${date_changer(termEvent.ends)}',
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'Start time: ${_formatDate(termEvent.startTime)}',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            'End: time${_formatDate(termEvent.endTime)}',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                      SizedBox(height: 8),
                    ],
                  )
                  ,
                ),
              );
            },
          );
        },
      ),
    );
  }


  String _formatDate(String timeString) {
    try {
      final timeParts = timeString.split(':');
      if (timeParts.length == 3) {
        return '${timeParts[0]}:${timeParts[1]}';
      }
      return timeString;
    } catch (e) {
      return 'Invalid time';
    }
  }

}
