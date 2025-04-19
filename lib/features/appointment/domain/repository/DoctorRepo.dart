import 'dart:convert';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorRepo {
  Future<List<DoctorModel>> fetchDoctors() async {
    // const String token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiOTc3NWE4MjctNjZjMC00OTdiLTk4YTQtNzIwZjQ1YjE5MzAwIiwicm9sZSI6InVzZXIiLCJlbWFpbCI6InRhcnVuZXNvZmZpY2lhbEBnbWFpbC5jb20iLCJleHAiOjE3NDE2MzA0OTZ9.dTsoSOetbLB4p48KrAyfwQkIQaJA5-Xoj8J6KaDGDfw"; // Replace with your actual token

    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token'); // Retrieve token from storage
    }

    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('https://10.0.2.2:8443/user/doctors'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("fetchDoctors - Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          List<dynamic> data = json.decode(response.body);
          return data.map((json) => DoctorModel.fromJson(json)).toList();
        } catch (jsonError) {
          print("Error parsing JSON: $jsonError");
          throw Exception("Failed to parse doctors data");
        }
      } else {
        print("fetchDoctors - Error: ${response.body}");
        throw Exception(
            "Failed to load doctors: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("fetchDoctors - Exception: $e");
      throw Exception("An error occurred while fetching doctors: $e");
    }
  }
}
