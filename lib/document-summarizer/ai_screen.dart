import 'package:flutter/material.dart';
import 'package:flutter_gemini/auth/auth.dart';
import 'package:flutter_gemini/document-summarizer/about_me_screen.dart';
import 'package:flutter_gemini/document-summarizer/feedback_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Ai-image/my_dailog.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  _AiScreenState createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _drawerSlideAnimation;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  final String adUnitId = "ca-app-pub-3423774690631144/3615842881";
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(_animationController);
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {},
        ),
        request: AdRequest());

    _bannerAd.load();
  }

  void _toggleDrawer() {
    setState(() {
      if (_isDrawerOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-removebg.png',
              height: screenHeight * 0.06,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              'Cheat AI',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 8.0,
        shadowColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, I'm Cheat,\nYour AI assistant.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "What can I help you with today?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenHeight * 0.02,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Expanded(
                  child: ListView(
                    children: [
                      _buildFeatureCard(
                        context,
                        Colors.blueAccent,
                        'assets/lottie/chat_ai.json',
                        "Chat with AI",
                        screenWidth,
                        screenHeight,
                        () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      _buildFeatureCard(
                        context,
                        Colors.cyan,
                        'assets/lottie/think.json',
                        "Create Images with AI",
                        screenWidth,
                        screenHeight,
                        () {
                          Navigator.pushNamed(context, '/createImages');
                        },
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      _buildFeatureCard(
                        context,
                        Colors.purpleAccent,
                        'assets/lottie/document.json',
                        "Summarize Documents, (.pdf,.docx,.txt)",
                        screenWidth,
                        screenHeight,
                        () {
                          Navigator.pushNamed(context, '/summarizeDocuments');
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
              ],
            ),
          ),
          SlideTransition(
            position: _drawerSlideAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, bottom: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildDrawer(context, screenWidth, screenHeight),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isAdLoaded
          ? Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.07),
              child: Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            )
          : SizedBox(),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    Color color,
    String lottieAsset,
    String text,
    double screenWidth,
    double screenHeight,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                children: [
                  Container(
                    width: screenHeight * 0.06,
                    height: screenHeight * 0.07,
                    child: Lottie.asset(lottieAsset, fit: BoxFit.cover),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  Container(
                    width:
                        screenWidth * 0.5, // Ensure text fits without overflow
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: text.contains(
                                "Summarize Documents, (.pdf,.docx,.txt)")
                            ? screenHeight *
                                0.020 // Adjust the font size for this specific text
                            : screenHeight * 0.022,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.04),
              child: Icon(Icons.chevron_right_outlined,
                  size: screenHeight * 0.04, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    final url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.techmindinnovations15.cheat_ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDrawer(
      BuildContext context, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.75,
      color: const Color(0xFFE3D1F4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: const Color(0xFFE3D1F4),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.04,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(width: screenWidth * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Techie',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(79, 33, 112, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 2, color: Colors.purple[300]),
          ListTile(
            leading: Text(
              '🧑‍💻',
              style: TextStyle(fontSize: screenHeight * 0.025),
            ),
            title: Text(
              'About me',
              style: GoogleFonts.hankenGrotesk(
                  fontSize: screenHeight * 0.025,
                  color: const Color.fromRGBO(79, 33, 112, 1)),
              // style: TextStyle(
              //     fontSize: screenHeight * 0.025,
              //     color: Color.fromRGBO(79, 33, 112, 1))
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutMeScreen()),
              );
            },
          ),
          Divider(thickness: 2, color: Colors.purple[300]),
          ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.deepPurple,
            ),
            title: Text('Share',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    color: Color.fromRGBO(79, 33, 112, 1))),
            onTap: () {
              Share.share(
                'Check out this awesome app: Cheat AI ! Download it from the Play Store: https://play.google.com/store/apps/details?id=com.techmindinnovations15.cheat_ai',
                subject: 'Check out this app!',
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback_outlined, color: Colors.deepPurple),
            title: Text('Feedback',
                style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    color: Color.fromRGBO(79, 33, 112, 1))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star_border_rounded,
              size: screenHeight * 0.038,
              color: Colors.deepPurple,
            ),
            title: Text('Rate App✨',
                style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    color: Color.fromRGBO(79, 33, 112, 1))),
            onTap: _launchURL,
          ),
          Divider(thickness: 2, color: Colors.purple[300]),
          ListTile(
            leading:
                const Icon(Icons.logout_outlined, color: Colors.deepPurple),
            title: Text('Log Out',
                style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    color: const Color.fromRGBO(79, 33, 112, 1))),
            onTap: () async {
              try {
                // Show loading dialog while signing out
                MyDialog.showLoadingDialog();

                // Perform sign out
                await signOut();

                // Close the loading dialog
                Get.back();

                // Navigate back to login screen or show a confirmation message
                Get.snackbar("Success", "Logged out successfully!");

                // Optionally, navigate to a login screen or main page after logout
                Navigator.pushReplacementNamed(context, '/signin');
              } catch (e) {
                Get.back();
                Get.snackbar("Error", "Failed to log out: $e");
              }
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Made with ❤️ in India for the World!",
                style: TextStyle(
                    fontSize: screenHeight * 0.02, color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
