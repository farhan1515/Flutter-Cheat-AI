import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/Ai-image/custom_btn.dart';
import 'package:flutter_gemini/Ai-image/image_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  late Size mq;
  final _c = ImageController();

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3423774690631144/1220611814', // Replace with your actual ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          Navigator.of(context).pop();
          _loadInterstitialAd(); // Load the next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          Navigator.of(context).pop();
          _loadInterstitialAd(); // Load the next ad
        },
      );
      _interstitialAd!.show();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 167, 244),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 2.0,
          shadowColor: Colors.black,
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 232, 167, 244),
            leading: IconButton(
              icon: const Icon(Icons.chevron_left,
                  color: Color.fromRGBO(79, 33, 112, 1)),
              onPressed: _showInterstitialAd,
            ),
            title: Center(
              child: Text("AI ArtBuddy",
                  style: GoogleFonts.hankenGrotesk(
                      color: const Color.fromRGBO(79, 33, 112, 1))),
            ),
            actions: [
              Obx(
                () => _c.status.value == Status.complete
                    ? IconButton(
                        padding: const EdgeInsets.only(right: 7),
                        onPressed: _c.ShareImage,
                        icon: const Icon(Icons.share_rounded,
                            color: Colors.black),
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() => _c.status.value == Status.complete
          ? Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: FloatingActionButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _c.downloadImage();
                },
                backgroundColor: Colors.purple.shade600,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Icon(
                  Icons.save_alt_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            )
          : const SizedBox()),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: mq.height * .02,
          bottom: mq.height * .1,
          left: mq.width * .04,
          right: mq.width * .04,
        ),
        children: [
          TextFormField(
            controller: _c.textC,
            textAlign: TextAlign.center,
            minLines: 2,
            maxLines: null,
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText:
                  'Think of something amazing\nType here & watch it come to life! ✨ 😃',
              hintStyle: const TextStyle(
                  fontSize: 14.5, color: Colors.white, letterSpacing: 1.2),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.purple.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.purple.shade600,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.purple.shade300,
                ),
              ),
            ),
          ),
          Container(
            height: mq.height * .5,
            child: Obx(() => _aiImage()),
          ),
          Obx(() => _c.imageList.isEmpty
              ? const SizedBox()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(bottom: mq.height * .03),
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 10,
                    children: _c.imageList
                        .map((e) => InkWell(
                              onTap: () {
                                _c.url.value = e;
                              },
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: CachedNetworkImage(
                                  imageUrl: e,
                                  height: 100,
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )),
          CustomBtn(
            onTap: _c.createAIImage,
            text: 'Magic✨',
          )
        ],
      ),
    );
  }

  Widget _aiImage() {
    switch (_c.status.value) {
      case Status.none:
        return Lottie.asset('assets/lottie/think.json',
            height: mq.height * 0.2);
      case Status.complete:
        return _c.imageBytes != null
            ? Image.memory(_c.imageBytes!)
            : const Icon(Icons.error);
      case Status.loading:
        return Lottie.asset('assets/lottie/loading.json',
            height: mq.height * 0.2, width: mq.width * 0.2);
      default:
        return Container();
    }
  }
}
