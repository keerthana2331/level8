import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leveleight/sign_model.dart';  // Assuming you have a User model in this file
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> signupUser(User user) async {
  const String url = 'https://sampleapi.stackmod.info/api/v1/auth/signup';

  try {
    // Log the request details
    print('Initiating signup request...');
    print('Request URL: $url');
    print('Request Headers: {"Content-Type": "application/json"}');
    print('Request Body: ${jsonEncode(user.toJson())}');

    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()), // Serialize User object to JSON
    ).timeout(Duration(seconds: 20), onTimeout: () {
      throw 'The request timed out. Please try again.';
    });

    // Log response details
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse successful signup response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check for the token in the response
      if (responseData.containsKey('token')) {
        final String token = responseData['token'];
        print('Token received: $token');

        // Save the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        print('Token saved to SharedPreferences');

        return token; 
      }

      return 'Signup successful! No token found in the response.';
    } else {
      // Parse error response from the backend
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String errorMessage = responseData['error'] ?? 'An unexpected error occurred.';
      return 'Signup failed: $errorMessage';
    }
  } catch (e) {
    // Log any exceptions and rethrow a user-friendly message
    print('Error during signup: $e');
    throw 'An error occurred during signup. Please try again.';
  }
}
