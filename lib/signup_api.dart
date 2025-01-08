// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leveleight/sign_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> signupUser(User user) async {
  const String url = 'https://sampleapi.stackmod.info/api/v1/auth/signup';
  try {
    // Debugging: Print the request details
    print('Initiating signup request...');
    print('Request URL: $url');
    print('Request Headers: {"Content-Type": "application/json"}');
    print('Request Body: ${jsonEncode(user.toJson())}');
    final response = await http
        .post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    )
        .timeout(
      Duration(seconds: 20),
      onTimeout: () {
        throw 'The request timed out. Please try again.';
      },
    );
    // Debugging: Print the response details
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('token')) {
        final String token = responseData['token'];
        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        // Debugging: Confirm token storage
        print('Token received and saved to SharedPreferences');
        return token;
      }
      return 'Signup successful! No token found in the response.';
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String errorMessage =
          responseData['error'] ?? 'An unexpected error occurred.';
      return 'Signup failed: $errorMessage';
    }
  } catch (e) {
    // Catching any exceptions and handling them properly
    print('Error during signup: $e');
    return 'An error occurred during signup. Please try again.';
  }
}
