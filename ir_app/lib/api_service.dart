import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ir_app/contstants.dart';

class ApiService {
  static Future<List<dynamic>?> search(String id, String query) async {
    try {
      print('http://$serverIp:8000/SearchApi/$id/$query');
      print("post method search 1");
      final response = await http.post(
        Uri.parse('http://$serverIp:8000/SearchApi/$id/$query'),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body;
      } else {
        throw Exception('Failed to call search API');
      }
    } catch (e) {
      return null;
    }
  }
}
