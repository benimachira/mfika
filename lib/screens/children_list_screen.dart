import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/child.dart';
import '../models/user.dart';
import '../providers/child_provider.dart';
import '../widgets/custom_drawer.dart';
import 'child_screen.dart';
import 'colors.dart';

class ChildrenListScreen extends StatefulWidget {
  final User user;

  ChildrenListScreen({required this.user});

  @override
  _ChildrenListScreenState createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
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

  Uint8List? base_image(String imageDataUrl) {
    List<String> splitData = imageDataUrl.split(',');

    if (splitData.length == 2) {
      String imageDataType = splitData[0]; // contains "data:image/png;base64"
      String base64Image = splitData[1]; // contains the actual base64 image data
      Uint8List bytes = base64Decode(base64Image);

      return bytes;

      print(base64Image); // This will print just the base64 image data
    } else {
      return null;
      print("Invalid image data URL.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(widget.user),
      appBar: AppBar(
        title: Text('M-Fika'),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
              Navigator.of(context).pushNamed('/notification_screen');
            },
          ),
        ],
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
                          builder: (ctx) =>
                              ChildScreen(
                                child: child,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: base_image(child.image??'') != null
                            ? CircleAvatar(
                          radius: 24,
                          backgroundImage: MemoryImage(
                              base_image(child.image)!), // Replace with the actual child image
                        )
                            : CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              'image!'), // Replace with the actual child image
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
                            'Adm No: ${child.admission_num}',
                            style: TextStyle(fontSize: 13, fontFamily: 'Roboto',color: Colors.grey[700]),
                          ),
                          Text(
                            'Grade: ${child.grade}',
                            style:
                            TextStyle(fontSize: 13, fontFamily: 'Roboto', color: Colors.grey[700]),
                          ),

                        ],
                      ),
                      trailing: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    ChildScreen(
                                      child: child,
                                    ),
                              ),
                            );
                          }, child: Icon(Icons.arrow_forward)),
                    ),
                  ),);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
