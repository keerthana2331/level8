import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leveleight/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> loginUser(Loguser loginUser) async {
  const String url = 'https://sampleapi.stackmod.info/api/v1/auth/login';

  try {
    // Log the request details
    print('Initiating login request...');
    print('Request URL: $url');
    print('Request Headers: {"Content-Type": "application/json"}');
    print('Request Body: ${jsonEncode(loginUser.toJson())}');

    // Make the HTTP POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginUser.toJson()), // Serialize LoginUser object to JSON
    );

    // Log response details
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse successful login response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check for the token in the response
      if (responseData.containsKey('token')) {
        final String token = responseData['token'];
        print('Token received: $token');

        // Save the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        print('Token saved to SharedPreferences');

        return token; // Return the token if needed
      }

      return 'Login successful! No token found in the response.';
    } else {
      // Parse error response from the backend
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String errorMessage = responseData['error'] ?? 'An unexpected error occurred.';
      return 'Login failed: $errorMessage';
    }
  } catch (e) {
    // Log any exceptions and rethrow a user-friendly message
    print('Error during login: $e');
    throw 'An error occurred during login. Please try again.';
  }
}
