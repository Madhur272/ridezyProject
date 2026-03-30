import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const baseUrl = "http://192.168.1.13:4009"; // Android emulator 10.0.2.2:4009

  static Future createRide(Map data) async {

    final res = await http.post(
      Uri.parse("$baseUrl/ride/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

}