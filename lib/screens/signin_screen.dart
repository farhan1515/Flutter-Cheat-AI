import 'package:flutter/material.dart';
import 'package:flutter_gemini/auth/auth.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
                // You can add a gradient or other background here if needed.
                ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Graphic
                Image.asset(
                  'assets/images/logo-removebg.png',
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.05),

                // Welcome Text
                Text(
                  "Welcome to Cheat AI",
                  style: TextStyle(
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Your AI Assistant",
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),

                // Google Sign-In Button
                if (_isLoading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                else
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final user = await signInWithGoogle();

                        if (user != null) {
                          Get.offNamed('/ai'); // Use GetX for navigation
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: Image.asset(
                        'assets/images/google-icon.png', // Ensure you have this asset
                        height: screenHeight * 0.05,
                      ),
                      label: Text(
                        'Sign In with Google',
                        style: TextStyle(fontSize: screenHeight * 0.020),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
