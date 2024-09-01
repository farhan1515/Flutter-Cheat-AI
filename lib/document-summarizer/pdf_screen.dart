import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gemini/api/summary_service.dart';
import 'package:flutter_gemini/document-summarizer/preview_screen.dart';
import 'package:flutter_gemini/document-summarizer/summary_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class PdfScreen extends StatefulWidget {
  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final SummaryService _summaryService = SummaryService();
  PlatformFile? file;
  double summaryLength = 0.5;
  double detailLevel = 2;

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  

   @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3423774690631144/1220611814', // Replace with your actual ad unit ID
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
    return Scaffold(
      backgroundColor: const Color(0xFFe0f7fa),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 2,
          shadowColor: Colors.grey[200],
          child: AppBar(
            backgroundColor: Color(0xFFe0f7fa),
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Color.fromRGBO(79, 33, 112, 1),
              ),
               onPressed: _showInterstitialAd,
            ),
            title: Text("Document Summarizer",
                style: GoogleFonts.hankenGrotesk(
                    color: const Color.fromRGBO(79, 33, 112, 1))),
            elevation: 2,

            centerTitle: true,
            // backgroundColor: const Color.fromARGB(255, 191, 168, 232),
            // actions: [
            //   IconButton(
            //       onPressed: () async {
            //         // await signOut();
            //       },
            //       icon: Icon(Icons.logout)),
            // ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Unlock the Power of Summarization (.pdf,.docx,.txt)",
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(79, 33, 112, 1),
                  ),
                ),
                SizedBox(height: 10),
                // Text(
                //   "Easily summarize your documents with our AI-powered tool",
                //   style: GoogleFonts.hankenGrotesk(
                //     fontSize: 18,
                //     color: Color.fromRGBO(79, 33, 112, 1),
                //   ),
                // ),
                // SizedBox(height: 20),
                Lottie.asset('assets/lottie/document.json', height: 200),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 134, 72, 241),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      "Select File",
                      style: GoogleFonts.hankenGrotesk(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (file != null) ...[
                  selectedFile(context),
                  const SizedBox(height: 20),
                  summaryLevelSlider(),
                  const SizedBox(height: 20),
                  detailLevelSlider(),
                  const SizedBox(height: 20),
                  summarizeButton(context),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton summarizeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (file != null && file!.bytes != null) {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Color(0xFFfffacd),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/lottie/loading.json', height: 150),
                        const SizedBox(height: 20),
                        Text(
                          "Generating summary, please wait...",
                          style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              color: const Color.fromRGBO(79, 33, 112, 1)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            final summary = await _summaryService.summarizeDocument(
              file!,
              summaryLength,
              detailLevel.toInt(),
            );

            Navigator.of(context).pop(); // Close the loading dialog

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryScreen(
                    summary: summary,
                    filename: file!.name,
                  ),
                ),
              );
            }
          } catch (e) {
            Navigator.of(context).pop(); // Close the loading dialog
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File bytes are null.')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 134, 72, 241),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Summarize',
          style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Column summaryLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Summary Length',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(
                summaryLength.toStringAsPrecision(2),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              backgroundColor: Colors.deepPurple[100],
            ),
          ],
        ),
        Slider(
          min: 0.1,
          max: 1,
          value: summaryLength,
          label: summaryLength.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              summaryLength = value;
            });
          },
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }

  Column detailLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Detail Level',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(
                detailLevel.toStringAsPrecision(2),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              backgroundColor: Colors.deepPurple[100],
            ),
          ],
        ),
        Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: detailLevel,
          label: detailLevel.toStringAsPrecision(2),
          onChanged: (double value) {
            setState(() {
              detailLevel = value;
            });
          },
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }

  Row selectedFile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Selected File: ${file!.name}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(file: file!),
              ),
            );
          },
          child: const Text(
            'Preview',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              file = null;
            });
          },
          icon: const Icon(Icons.cancel, color: Colors.red),
        ),
      ],
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );
    if (result != null) {
      setState(() {
        file = result.files.single;
      });
      if (file!.path != null) {
        final bytes = await File(file!.path!).readAsBytes();
        setState(() {
          file = PlatformFile(
            name: file!.name,
            size: file!.size,
            bytes: bytes,
            path: file!.path,
          );
        });
      }
    }
  }
}



