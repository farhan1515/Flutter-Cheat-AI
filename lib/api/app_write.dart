
import 'package:appwrite/appwrite.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('66c0ffc30003500b20d3')
        .setSelfSigned(status: true);
  }

  static Future<String> getImageApiKey() async {
    try {
      final document = await _database.getDocument(
        databaseId: 'MyDatabase',
        collectionId: 'ApiKey',
        documentId: 'stabilityApiKey',
      );

      final apiKey = document.data['apiKey'] as String?;
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key is null or empty in the database");
      }

      return apiKey;
    } catch (e) {
      print('Error fetching API key: $e');
      rethrow;
    }
  }

  static Future<String> getChatApiKey() async {
    try {
      final document = await _database.getDocument(
        databaseId: 'MyDatabase',
        collectionId: 'ApiKey',
        documentId: 'chatApiKey',
      );

      final apiKey = document.data['apiKey'] as String?;
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key is null or empty in the database");
      }

      return apiKey;
    } catch (e) {
      print('Error fetching API key: $e');
      rethrow;
    }
  }
}
