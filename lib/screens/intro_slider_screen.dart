import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroScreenCustomLayoutState createState() => IntroScreenCustomLayoutState();
}

class IntroScreenCustomLayoutState extends State<IntroSliderScreen> {
  late Function goToTab;

  Color primaryColor = const Color(0xffffcc5c);
  Color secondColor = const Color(0xff3da4ab);

  void onDonePress() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void onTabChangeCompleted(index) {
    log("onTabChangeCompleted, index: $index");

  }

  Widget renderNextBtn() {
    return Text('Next',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey[800]),);
  }

  Widget renderDoneBtn() {
    return Text('Finish',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey[800]),);
  }

  Widget renderSkipBtn() {
    return Text('Skip',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey[800]),);
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.white),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  List<Widget> generateListCustomTabs() {
    return [
      createCustomTab(
        title: 'Welcome',
        description: 'Welcome to M-Fika Parent\'s Application',
        imagePath: 'assets/images/mfika_logo.png',
        id: 1,
      ),
      createCustomTab(
        title: 'Find Bus Routes',
        description:
        'Easily find the best bus routes for your child\'s school.',
        imagePath: 'assets/images/bus_routes.jpg',
        id: 2,
      ),
      createCustomTab(
        title: 'Real-time Tracking',
        description:
        'Track your child\'s bus in real-time to ensure their safety.',
        imagePath: 'assets/images/route.jpg',
        id: 3,
      ),
      createCustomTab(
        title: 'Notifications',
        description:
        'Receive notifications about bus arrival times and delays.',
        imagePath: 'assets/images/notifications.png',
        id: 3,
      ),
    ];
  }

  Widget createCustomTab({
    required String title,
    required String description,
    required String imagePath,
    required int id,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: <Widget>[
          id==1? SizedBox(height: MediaQuery.of(context).size.height/8):Container(),
          Image.asset(
            imagePath,
            fit: BoxFit.cover,

          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      // Skip button
      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Indicator
      indicatorConfig: const IndicatorConfig(
        colorIndicator: Colors.blue,
        sizeIndicator: 6.0,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),

      // Custom tabs
      listCustomTabs: generateListCustomTabs(),
      backgroundColorAllTabs: Colors.white,
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: const BouncingScrollPhysics(),
      onTabChangeCompleted: onTabChangeCompleted,
    );
  }
}