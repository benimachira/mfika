import 'package:flutter/material.dart';

import '../models/term_trip.dart';

class TripDetailScreen extends StatelessWidget {
  final List<General> trips;

  TripDetailScreen({required this.trips});


  @override
  Widget build(BuildContext context) {
    print(trips);

    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          General tripItem = trips[index];
          return InkWell(
            onTap: () {
              // Handle trip item tap, e.g. navigate to another screen
            },
            child: Card(
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripItem.tripName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      'Destination: ${tripItem.destinationName}',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Cost: \$${tripItem.price}',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Grade: ${tripItem.grade}',
                      style: TextStyle(fontSize: 13),
                    ),

                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Start: ${tripItem.departureTime}',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 5),
                        SizedBox(width: 32,),
                        Text(
                          'End: ${tripItem.returnTime}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
