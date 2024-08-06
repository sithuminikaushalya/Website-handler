import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gold_rate.dart';

class ApiService {
  final String baseUrl = 'http://localhost/wordpress/wp-json/daily-updater/v1';

  Future<List<GoldRate>> fetchGoldRates() async {
    final response = await http.get(Uri.parse('$baseUrl/details'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['details'];
      return data.map((json) => GoldRate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load gold rates');
    }
  }

  Future<void> addGoldRate(GoldRate goldRate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(goldRate.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add gold rate');
    }
  }

  Future<void> updateGoldRate(GoldRate goldRate) async {
    final response = await http.put(
      Uri.parse('$baseUrl/details/${goldRate.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(goldRate.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update gold rate');
    }
  }

  Future<void> deleteGoldRate(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/details/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete gold rate');
    }
  }
}
