// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:ir_app/contstants.dart';

// class ApiService2 {
//   static Future<List<dynamic>?> searchSecond(String id, String query) async {
//     try {
//       print('http://$serverIp:8000/SearchApi/$id/$query');
//       print("post method search 2");
//       String baseUrl = 'http://$serverIp:8001/SecondSearchApi/$id/$query';
//       final response = await http.post(Uri.parse(baseUrl), headers: {
//         'accept': 'application/json',
//       });
//       print('$baseUrl');
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         final List<dynamic> body = jsonDecode(response.body);
//         return body;
//       }
//     } catch (e) {
//       return null;
//     }
//   }
// }


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ir_app/contstants.dart';

class ApiService2 {
  static Future<List<dynamic>?> searchSecond(String id, String query) async {
    try {
      
      print('http://$serverIp:8001/SecondSearchApi/$id/$query');
      print("post method search 2");
      final response = await http.post(
        Uri.parse('http://$serverIp:8001/SecondSearchApi/$id/$query'),
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
