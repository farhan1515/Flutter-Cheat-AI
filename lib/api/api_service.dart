import 'dart:convert';

import 'package:http/http.dart';

class ApiService {
  

  //static String imageapikey= '';
}

class APIs {
  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res =
          await get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      final data = jsonDecode(res.body);

      //
      return List.from(data['images']).map((e) => e['src'].toString()).toList();
    } catch (e) {
      print('searchAiImagesE: $e');
      return [];
    }
  }
}
