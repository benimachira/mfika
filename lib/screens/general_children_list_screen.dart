import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_trans/screens/term_trip_screen.dart';
import '../models/child.dart';
import '../providers/child_provider.dart';
import 'child_screen.dart';

class GeneralChildrenListScreen extends StatefulWidget {
  GeneralChildrenListScreen();

  @override
  _ChildrenListScreenState createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<GeneralChildrenListScreen> {
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      _fetchChildren();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchChildren() async {
    try {
      Provider.of<ChildProvider>(context, listen: false).fetchChildren();
    } catch (e) {
      print('Error fetching children: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Term Trips Children'),
      ),
      body: Consumer<ChildProvider>(
        builder: (ctx, childProvider, _) {
          if (childProvider.children.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Child> children = childProvider.children;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (ctx, index) {
                  final child = children[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => TermTripScreen(
                            child,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(child.image ??
                              ''), // Replace with the actual child image
                        ),
                        title: Text(
                          '${child.firstName} ${child.lastName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            // Text(
                            //   'Fee Bal: 1000',
                            //   style: TextStyle(
                            //       fontSize: 13,
                            //       color: Colors.blue,
                            //       fontFamily: 'Roboto'),
                            // ),
                            Text(
                              'Grade: ${child.grade}',
                              style:
                                  TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => TermTripScreen(
                                    child,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.directions_bus,color: Colors.green,)),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
