import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late NativeAd _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3423774690631144/9215486053',
      request: AdRequest(),
      nativeTemplateStyle:
          NativeTemplateStyle(templateType: TemplateType.medium),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (_, __) {
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return _isAdLoaded
        ? Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.03),
            child: Container(
              alignment: Alignment.center,
              child: AdWidget(ad: _nativeAd),
              height: screenHeight *
                  0.09, // Adjust height as neededize.height.toDouble(), // Adjust height as needed
              width: double.infinity,
            ),
          )
        : SizedBox(height: 100); // Placeholder when ad is not loaded
  }
}
