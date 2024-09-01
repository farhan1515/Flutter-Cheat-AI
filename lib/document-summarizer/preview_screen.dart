import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.file});
  final PlatformFile file;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFfffacd),
      appBar: AppBar(
          backgroundColor: const Color(0xFFfffacd),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Color.fromRGBO(79, 33, 112, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Document Preview",
              style: GoogleFonts.hankenGrotesk(
                  color: const Color.fromRGBO(79, 33, 112, 1))),
          //elevation: 2,
          elevation: 2.0,
          shadowColor: Colors.deepPurpleAccent,
          centerTitle: true
          // elevation: 8.0,
          ),
      body: Center(
        child: _buildPreviewWidget(widget.file),
      ),
    );
  }

  Widget _buildPreviewWidget(PlatformFile file) {
    switch (file.extension) {
      case 'pdf':
        return PDFView(
          filePath: file.path!,
          fitPolicy: FitPolicy.BOTH,
        );
      case 'docx':
        return FutureBuilder(
          future: _readDocxFile(file.path!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error reading file: ${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      case 'txt':
        return FutureBuilder(
          future: _readTextFile(file.path!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error reading file: ${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      default:
        return Center(child: Text('Unsupported file format'));
    }
  }

  Future<String> _readDocxFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final text = docxToText(bytes);
      return text;
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
  }

  Future<String> _readTextFile(String filePath) async {
    try {
      final file = File(filePath);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
  }
}



// import 'dart:io';

// import 'package:docx_to_text/docx_to_text.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PreviewScreen extends StatelessWidget {
//   const PreviewScreen({super.key,required this.file});
//   final PlatformFile file;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: Text("Document Preview"),
//       ),
//       body: Center(
//         child: _buildPreviewWidget(file),
//       ),
//     );
//   }

//   Widget _buildPreviewWidget(PlatformFile file){
//     switch (file.extension){
//       case 'pdf':
//         return PDFView(filePath:file.path!);
//       case 'docx':
//         return FutureBuilder(future: _readDocxFile(file.path!), 
//         builder: (context,snapshot){
             
// if (snapshot.hasData) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SelectableText(
//             snapshot.data!,
//             style: const TextStyle(fontSize: 16.0),
//             textAlign: TextAlign.justify,
//         ), // SelectableText
//     ); // Padding
// } else if (snapshot.hasError) {
//     return Text('Error reading file: ${snapshot.error}');
// }
// return const CircularProgressIndicator();

//         },
        
//         );
//       case 'txt':
//         return FutureBuilder(future: _readTextFile(file.path!), 
//         builder: (context,snapshot){
          
// if (snapshot.hasData) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SelectableText(
//             snapshot.data!,
//             style: const TextStyle(fontSize: 16.0),
//             textAlign: TextAlign.justify,
//         ), // SelectableText
//     ); // Padding
// } else if (snapshot.hasError) {
//     return Text('Error reading file: ${snapshot.error}');
// }
// return const CircularProgressIndicator();
//         },
//         );
//         default:
//            return Text('Unsupported file format ');
//     }
//   }

//   Future<String> _readDocxFile(String filePath) async{
// try {
  

//   final file = File(filePath);
//   final bytes= await file.readAsBytes();
//   final text = docxToText(bytes);
//   return text;

// }catch(e){
//   throw Exception('Error reading file : $e');
// }
// }

// Future<String> _readTextFile(String filePath) async{
// try {
  

//   final file = File(filePath);
//   final contents= await file.readAsString();
//   return contents;
  

// }catch(e){
//   throw Exception('Error reading file : $e');
// }
// }
// }