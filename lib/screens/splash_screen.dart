import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_trans/providers/auth_provider.dart';
import 'children_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAuthData();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  Future<void> _loadAuthData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.loadAuthData();
      Timer(Duration(seconds: 3), _navigateToNextScreen);
    } catch (error) {
      print('Error loading auth data: $error');
    }
  }

  void _navigateToNextScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChildrenListScreen(user: authProvider.user,),
        ),
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/intro_slider');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/mfika_logo.png', // Replace with your logo image path
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
