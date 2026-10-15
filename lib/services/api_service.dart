
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<String>> fetchDocumentTypes() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/document-types'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load documents. Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      dynamic rawData;

      if (decoded is List) {
        rawData = decoded;
      } else if (decoded is Map<String, dynamic>) {
        rawData = decoded['data'];
      }

      if (rawData is! List) {
        throw Exception('Invalid document data from server');
      }

      final documents = rawData
          .map<String?>((item) {
            if (item is String) {
              return item;
            }

            if (item is Map<String, dynamic> &&
                item['name'] != null) {
              return item['name'].toString();
            }

            return null;
          })
          .whereType<String>()
          .where((name) => name.trim().isNotEmpty)
          .toSet()
          .toList();

      return documents;
    } catch (e) {
      throw Exception('Unable to load document types: $e');
    }
  }
}
