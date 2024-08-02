import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://localhost/wordpress/wp-json/daily-updater/v1';

// Fetch details from the API
Future<List<Map<String, dynamic>>> fetchDetails() async {
  final response = await http.get(Uri.parse('$apiUrl/details'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['details']);
  } else {
    throw Exception('Failed to load details');
  }
}

// Add new detail to the API
Future<void> addDetail(Map<String, dynamic> detail) async {
  final response = await http.post(
    Uri.parse('$apiUrl/update'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'type': detail['type'] ?? '',
      'category': detail['category'] ?? '',
      'name': detail['name'] ?? '',
      'value': detail['value'] ?? '',
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add detail');
  }
}

// Update existing detail in the API
Future<void> updateDetail(int id, Map<String, dynamic> detail) async {
  final response = await http.put(
    Uri.parse('$apiUrl/details/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'type': detail['type'] ?? '',
      'category': detail['category'] ?? '',
      'name': detail['name'] ?? '',
      'value': detail['value'] ?? '',
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update detail');
  }
}

// Delete detail from the API
Future<void> deleteDetail(int id) async {
  final response = await http.delete(
    Uri.parse('$apiUrl/details/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete detail');
  }
}
