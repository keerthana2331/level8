import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _user;
  bool _isOtpVerified = false;

  String? get user => _user;
  bool get isOtpVerified => _isOtpVerified;

  bool get isLoggedIn => _user != null;

  // API URL for login
  final String _loginUrl = 'https://sampleapi.stackmod.info/api/v1/auth/login';

  get canResendOtp => null;

  get countdown => null;

  // Method to simulate user signup
  void signUp(String email, String password) {
    _user = email;
    notifyListeners();
  }

  // Method to handle login
  Future<bool> login(String email, String password) async {
    try {
      // Print the user data before sending to API for debugging purposes
      print('Attempting to login with email: $email and password: $password');
      
      // Sending HTTP POST request to the API
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw 'The request timed out. Please try again.';
      });

      // Check the status code of the response
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If successful, decode the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData.containsKey('token')) {
          final String token = responseData['token'];
          print('Login successful. Token: $token');
          _user = email; // Set the user email upon successful login
          notifyListeners(); // Notify listeners (UI update)
          return true;
        } else {
          print('Login failed: Token not found.');
          return false;
        }
      } else {
        print('Login failed: Unexpected error.');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Method to verify OTP
  void verifyOtp(String otp) {
    if (otp == '4040') {
      _isOtpVerified = true;
      notifyListeners();
    }
  }

  // Method to resend OTP
  void resendOtp(String email) {
    // Simulate resending OTP
    print('Resending OTP to $email');
    notifyListeners();
  }

  // Method to logout
  void logout() {
    _user = null;
    _isOtpVerified = false;
    notifyListeners();
  }
}
