import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../providers/auth_provider.dart';

class VehicleLocationScreen extends StatefulWidget {
  @override
  _VehicleLocationScreenState createState() => _VehicleLocationScreenState();
}

class _VehicleLocationScreenState extends State<VehicleLocationScreen> {
  final List<String> notifications = [];
  IOWebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  void _connectToWebSocket() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    channel = IOWebSocketChannel.connect('ws://localhost:8080');
    channel!.stream.listen(
          (message) {
        setState(() {
          notifications.add(message);
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );

    // Send the user ID to the WebSocket server
    final String channelId = 'notifications-schoolapp';
    final String eventName = 'VehicleLocation';
    final String key = '05d822d3f46eb0987d53';

    channel!.sink.add(
      json.encode({
        'channel': channelId,
        'event': eventName,
        'key': key,
        'userId': user.id,
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Location Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
