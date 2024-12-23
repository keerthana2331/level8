import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_model.dart';

// Function to login the user and return the access token
Future<String?> loginUser(Loguser loginUser) async {
  const String url = 'https://sampleapi.stackmod.info/api/v1/auth/login';

  try {
    print('Initiating login request...');
    print('Request URL: $url');
    print('Request body: ${jsonEncode(loginUser.toJson())}');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginUser.toJson()),
    ).timeout(Duration(seconds: 20), onTimeout: () {
      throw 'The request timed out. Please try again.';
    });

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check if the response contains the 'accessToken'
      if (responseData.containsKey('accessToken')) {
        final String accessToken = responseData['accessToken'];

        // Save the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', accessToken);
        print('Login successful. Token saved.');

        return accessToken; // Return the token to be used later
      } else {
        print('Login failed: Token not found in response.');
        return null;
      }
    } else if (response.statusCode == 401) {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      String errorMessage = errorResponse['message'] ?? 'Invalid credentials.';
      print('Error: $errorMessage');
      return null;
    } else {
      print('Login failed: Unexpected error. Response status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during login: $e');
    return null;
  }
}

// Function to retrieve the authorization headers with the stored token
Future<Map<String, String>> getAuthHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');

  if (token != null && token.isNotEmpty) {
    // Token found, returning authorization headers
    print('Auth token found: $token');
    return {'Authorization': 'Bearer $token'};
  } else {
    // Token not found, handle accordingly (e.g., prompt user to log in)
    print('No auth token found.');
    return {}; // Returning empty map means no Authorization header
  }
}

// Example: Using the token in an API request to fetch user profile
Future<void> fetchUserProfile() async {
  try {
    final headers = await getAuthHeaders();

    if (headers.isNotEmpty) {
      final response = await http.get(
        Uri.parse('https://sampleapi.stackmod.info/api/v1/user/profile'),
        headers: headers, // Add the authorization header
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw 'The request timed out. Please try again.';
      });

      if (response.statusCode == 200) {
        print('Profile data: ${response.body}');
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } else {
      print('No auth token found. Please log in.');
    }
  } catch (e) {
    print('Error fetching profile: $e');
  }
}
