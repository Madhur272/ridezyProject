// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {

//   static const baseUrl = "http://192.168.1.13"; // Android emulator 10.0.2.2:4009

//   static Future createRide(Map data) async {

//     final res = await http.post(
//       Uri.parse("$baseUrl:4009/ride/create"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return jsonDecode(res.body);
//   }

//   static Future respondToRide(Map data) async {

//   final res = await http.post(
//     Uri.parse("$baseUrl:4008/driver/respond"),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode(data),
//   );

//   return jsonDecode(res.body);
// }

// }

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {

  static String get baseUrl {

    // Replace with deployed backend later

    if (Platform.isAndroid) {
      return "http://10.0.2.2:4002";
    }
  
    return "http://localhost:4002";
  }

  static Future createRide(Map data) async {

    final response = await http.post(
      Uri.parse("$baseUrl/ride/create"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  static Future completeRide(Map data) async {

    // Replace with blockchain integrated backend later

    final response = await http.post(
      Uri.parse("$baseUrl/ride/complete"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  static Future respondToRide(Map data) async {

    // Replace with live driver service later

    final response = await http.post(
      Uri.parse("$baseUrl/driver/respond"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }
}