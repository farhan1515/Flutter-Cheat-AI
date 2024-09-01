import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/api/app_write.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdf_text/flutter_pdf_text.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';

class SummaryService {

  final String modelName = 'gemini-pro';

Future<String> summarizeDocument(PlatformFile file, double summaryLength, int detailLevel) async {
  try {
    if (file.path == null) {
      throw Exception('File path is null');
    }
    
    final fileBytes = await File(file.path!).readAsBytes();
    final fileExtension = file.extension?.toLowerCase();

    if (fileExtension == null) {
      throw Exception('File extension is null');
    }

    final documentContent = await processDocument(fileBytes, fileExtension);

    final prompt = "Summarize the following text and keep the summary within ${summaryLength * 100}% of the original text length. Adjust the level of detail based on the provided detail level ($detailLevel):\n\n$documentContent";
 final apiKey = await AppWrite.getChatApiKey();
   final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1/models/$modelName:generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey, // Use this instead of 'Authorization'
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['candidates'][0]['content']['parts'][0]['text'] ?? 'No summary available';
    } else {
      throw Exception('Failed to generate summary: ${response.body}');
    }
  } catch (e) {
    print('Error summarizing document: $e');
    throw Exception('Error summarizing document: $e');
  }
}

  Future<String> processDocument(Uint8List fileBytes, String fileExtension) async {
    switch (fileExtension) {
      case 'pdf':
        return await processPdf(fileBytes);
      case 'docx':
        return await processWord(fileBytes);
      case 'txt':
        return await processText(fileBytes);
      default:
        throw Exception('Unsupported file format');
    }
  }

  Future<String> processPdf(Uint8List fileBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp.pdf');
      await tempFile.writeAsBytes(fileBytes);

      final pdfDoc = await PDFDoc.fromPath(tempFile.path);
      final text = await pdfDoc.text;

      await tempFile.delete();
      return text;
    } catch (e) {
      throw Exception('Error processing PDF: $e');
    }
  }

  Future<String> processWord(Uint8List fileBytes) async {
    try {
      final text = docxToText(fileBytes);
      return text;
    } catch (e) {
      throw Exception('Error processing Word file: $e');
    }
  }

  Future<String> processText(Uint8List fileBytes) async {
    return String.fromCharCodes(fileBytes);
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_gemini/api/api_client.dart';
// class SummaryService {
//     final ApiClient _apiClient = ApiClient();
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     Future<String> summarizeDocument(
//         PlatformFile file,
//         double summaryLength,
//         int detailLevel,
//     ) async {
//         final summary = await _apiClient.summarizeDocument(
//             file.path!,
//             summaryLength,
//             detailLevel,
//         );
//         return summary;
//     }
//     Future<void> storeSummary(String summary, String filename) async {
//        await firestore.collection('users').doc(auth.currentUser!.uid).collection('summaries').add({
//   'filename': filename,
//   'summary': summary,
// });

//     }

   
// Stream<QuerySnapshot<Map<String, dynamic>>> fetchSummaries() {
//     return firestore
//         .collection('users')
//         .doc(auth.currentUser!.uid)
//         .collection('summaries')
//         .snapshots();
// }
// void deleteSummary(String docId) {
//     firestore
//         .collection('users')
//         .doc(auth.currentUser!.uid)
//         .collection('summaries')
//         .doc(docId)
//         .delete();
// }
// }
