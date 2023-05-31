import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:school_trans/providers/attendance_provider.dart';
import 'package:school_trans/providers/auth_provider.dart';
import 'package:school_trans/providers/bus_location_provider.dart';
import 'package:school_trans/providers/child_provider.dart';
import 'package:school_trans/providers/invoice_provider.dart';
import 'package:school_trans/providers/notification_provider.dart';
import 'package:school_trans/providers/term_dates_provider.dart';
import 'package:school_trans/providers/term_events_provider.dart';
import 'package:school_trans/providers/term_trips_provider.dart';
import 'package:school_trans/providers/token_provider.dart';
import 'package:school_trans/providers/user_provider.dart';
import 'package:school_trans/screens/add_user_screen.dart';
import 'package:school_trans/screens/change_password.dart';
import 'package:school_trans/screens/colors.dart';
import 'package:school_trans/screens/general_children_list_screen.dart';
import 'package:school_trans/screens/intro_slider_screen.dart';
import 'package:school_trans/screens/invoice_screen.dart';
import 'package:school_trans/screens/login_screen.dart';
import 'package:school_trans/screens/notification_screen.dart';
import 'package:school_trans/screens/splash_screen.dart';
import 'package:school_trans/screens/term_date_screen.dart';
import 'package:school_trans/screens/term_event_screen.dart';
import 'package:school_trans/screens/user_profile.dart';
import 'package:school_trans/providers/FeeProvider.dart';
import 'package:school_trans/providers/term_holidays_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PusherClient? pusher;
  static const headingTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryColorA,
  );

  static const subheadingTextStyle = TextStyle(
    fontSize: 16,
    color: primaryColorA,
  );

  static const bodyTextStyle = TextStyle(
    fontSize: 14,
    color: primaryColorA,
  );

  final ThemeData theme = ThemeData();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initializeLocalNotifications();
    initializePusher();
  }

  void initializeLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'New_Message_Notification',
      'NewMessageNotification',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  void initializePusher() async {
    pusher = PusherClient(
      '05d822d3f46eb0987d53',
      PusherOptions(cluster: 'ap2', encrypted: true),
    );

    await pusher!.connect();

    Channel channel = pusher!.subscribe('notifications-schoolapp');
    channel.bind('App\\Events\\NewMessageNotification', (event) {
      // Show notification when an event is received
      showNotification('New Message Notification', event!.data!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => BusLocationProvider()),
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => TermDatesProvider()),
        ChangeNotifierProvider(create: (_) => TermEventsProvider()),
        ChangeNotifierProvider(create: (_) => TermTripsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TermHolidaysProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Transport App',
        theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(
            primary: primaryColorA,
            secondary: secondaryColorA,
            background: backgroundColorA,
            error: errorColorA,
          ),
          textTheme: TextTheme(
            displayLarge: headingTextStyle,
            displayMedium: subheadingTextStyle,
            bodyLarge: bodyTextStyle,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => SplashScreen(),
          '/intro_slider': (ctx) => IntroSliderScreen(),
          '/login': (ctx) => LoginScreen(),
          '/user_profile': (ctx) => UserProfileScreen(),
          '/invoice': (context) => InvoiceScreen(),
          '/term_date': (context) => TermDateScreen(),
          '/term_event': (context) => TermEventScreen(),
          '/general_children': (context) => GeneralChildrenListScreen(),
          '/notification_screen': (ctx) => NotificationScreen(),
          '/add_user': (ctx) => AddUserScreen(),
          '/change_password': (ctx) => ChangePasswordScreen(),
        },
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
