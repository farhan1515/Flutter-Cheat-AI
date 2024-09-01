import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3423774690631144/1220611814', // Replace with your Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded) {
      Future.delayed(const Duration(seconds: 1), () {
        _interstitialAd?.show();
      });
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double coverHeight = 280;
    final double profileHeight = 144;
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(screenHeight, screenWidth, top, bottom),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildContent() => Column(
        children: [
          SizedBox(height: 8),
          Text("Greetings dev's 👋 I am",
              style: GoogleFonts.hankenGrotesk(fontSize: 22)),
          SizedBox(height: 8),
          Text("Mohammed Farhan Anwar",
              style: GoogleFonts.hankenGrotesk(fontSize: 22)),
          SizedBox(height: 8),
          Text("Flutter Developer",
              style: GoogleFonts.hankenGrotesk(fontSize: 22)),
          SizedBox(height: 20),
          Text("Let's Get Connected",
              style: GoogleFonts.hankenGrotesk(fontSize: 22)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialIcon(
                  FontAwesomeIcons.github, "https://github.com/farhan1515"),
              SizedBox(width: 12),
              buildSocialIcon(FontAwesomeIcons.linkedin,
                  "https://www.linkedin.com/in/mohammed-farhan-anwar-b7a626256/"),
              SizedBox(width: 12),
              buildSocialIcon(FontAwesomeIcons.medium,
                  "https://medium.com/@farhananwar784"),
            ],
          ),
        ],
      );

  Widget buildSocialIcon(IconData icon, String url) => CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Material(
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              try {
                await _launchURL(url);
              } catch (e) {
                print('Error launching URL: $e');
              }
            },
            child: Center(child: Icon(icon, size: 36)),
          ),
        ),
      );

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildTop(
      double screenHeight, double screenWidth, double top, double bottom) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage(screenHeight)),
        Positioned(
            top: top,
            left: screenWidth / 2 - screenWidth * 0.15,
            child: buildProfileImage(screenWidth)),
      ],
    );
  }

  Widget buildCoverImage(double screenHeight) => Container(
        child: Image.asset('assets/images/coding1.jpg',
            width: double.infinity,
            height: screenHeight * 0.3,
            fit: BoxFit.cover),
      );

  Widget buildProfileImage(double screenWidth) => CircleAvatar(
        backgroundImage: AssetImage('assets/images/mypic.jpg'),
        radius: screenWidth * 0.15,
      );
}

void main() {
  runApp(MaterialApp(home: AboutMeScreen()));
}
