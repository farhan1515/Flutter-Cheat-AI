
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_gemini/auth/auth.dart'; // Make sure to import your auth.dart file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Check user authentication after animation
    Future.delayed(Duration(seconds: 4), () {
      checkUserAndNavigate();
    });
  }

  Future<void> checkUserAndNavigate() async {
    final user = await getCurrentUser();
    if (user != null) {
      Get.offNamed('/ai');
    } else {
      Get.offNamed('/signin');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 10,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  'assets/images/logo-removebg.png',
                  width: screenWidth * 0.5,
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Your Daily AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}