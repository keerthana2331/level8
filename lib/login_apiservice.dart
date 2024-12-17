import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_model.dart';

Future<String?> loginUser(Loguser loginUser) async {
  const String url = 'https://sampleapi.stackmod.info/api/v1/auth/login';

  try {
    print('Initiating login request...');

    // Send POST request to the server
    final response = await http
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(loginUser.toJson()),
        )
        .timeout(Duration(seconds: 20), onTimeout: () {
          throw 'The request timed out. Please try again.';
        });

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Check the response status
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // If token exists, save it to SharedPreferences
      if (responseData.containsKey('token')) {
        final String token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        print('Login successful. Token saved.');
        return token;
      } else {
        return 'Login failed: Token not found in response.';
      }
    } else if (response.statusCode == 401) {
      // Unauthorized: Invalid username or password
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      String errorMessage = errorResponse['error'] ?? 'Invalid credentials.';
      print('Error: $errorMessage');
      return errorMessage;
    } else {
      // Handle other errors
      return 'Login failed: Unexpected error. Please try again.';
    }
  } catch (e) {
    print('Error during login: $e');
    return 'An error occurred: $e';
  }
}
