// ignore_for_file: avoid_print, unused_field, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_declarations
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class VerificationService {
  static Future<bool> verifyUser(String? email) async {
    if (email == null || email.isEmpty) {
      print('Invalid email input');
      return false;
    }
    try {
      final uri = Uri.parse(
          'https://sampleapi.stackmod.info/api/v1/auth/otp?email=$email');
      final response = await http.get(uri);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'otp send successfully') {
          print('OTP sent successfully for email: $email');
          return true;
        } else {
          print('Server response message: ${data['message']}');
        }
      } else {
        print('Failed to verify email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error verifying email: $e');
    }
    return false;
  }
}
class AuthProvider with ChangeNotifier {
  String? _user;
  bool _isOtpVerified = false;
  String? _sessionId;
  String? get user => _user;
  bool get isOtpVerified => _isOtpVerified;
  bool get isLoggedIn => _user != null;
  final String _loginUrl = 'https://sampleapi.stackmod.info/api/v1/auth/login';
  final String _verifyTokenUrl =
      'https://sampleapi.stackmod.info/api/v1/auth/otp';
  AuthProvider() {
    _loadUserData();
  }
  bool get isAuthenticated => _user != null;
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _user = prefs.getString('user');
    _sessionId = prefs.getString('sessionId');
    final String? token = prefs.getString('authToken');
    if (token != null) {
      print('Token loaded from SharedPreferences: $token');
      _verifyToken(token);
    } else {
      print('Token not found in SharedPreferences');
    }
    notifyListeners();
  }
  Future<void> _verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse(_verifyTokenUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw 'The request timed out. Please try again.';
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        _user = 'Authenticated User';
        print('Token verified successfully');
      } else {
        print('Token verification failed');
        logout();
      }
    } catch (e) {
      print('Error during token verification: $e');
    }
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw 'The request timed out. Please try again.';
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Check if the response contains the required tokens
        if (responseData.containsKey('token') &&
            responseData.containsKey('sessionId')) {
          final String token = responseData['token'];
          _sessionId = responseData['sessionId'];
          // Store the token and session ID in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('sessionId', _sessionId!);
          _user = email;
          notifyListeners(); // Notify listeners to update the UI
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
  // This function demonstrates how to use the stored token in subsequent API calls.
  Future<http.Response> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs
          .getString('authToken'); // Retrieve the token from SharedPreferences
      if (token == null) {
        throw 'No token found';
      }
      final response = await http.get(
        Uri.parse('https://sampleapi.stackmod.ino/api/v1/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Include the token in the Authorization header
        },
      );
      return response;
    } catch (e) {
      print('Error during fetching user data: $e');
      throw 'Failed to fetch data';
    }
  }
  Future<void> verifyOtp(String otp, String email) async {
    try {
      // Verify user exists using VerificationService
      final bool userExists = await VerificationService.verifyUser(email);
      final String _verifyOtpUrl =
          'https://sampleapi.stackmod.info/api/v1/auth/otp';
      if (!userExists) {
        print('User verification failed');
        _isOtpVerified = false;
        notifyListeners();
        return;
      }
      // Parse the OTP to an integer
      int otpNumber;
      try {
        otpNumber = int.parse(otp);
      } catch (e) {
        print('Invalid OTP format: OTP must be a valid number');
        _isOtpVerified = false;
        notifyListeners();
        return;
      }
      // If user exists and OTP is valid, proceed with OTP verification
      final Map<String, String> requestBody = {
        'email': email,
        'otp': otpNumber.toString(),
      };
      final response = await http
          .post(
        Uri.parse(_verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          return http.Response('Request timed out', 408);
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Check for success based on 'success' key or 'message' value
        if (responseData.containsKey('success') &&
            responseData['success'] == true) {
          _isOtpVerified = true;
          print('OTP verification successful');
        } else if (responseData.containsKey('message') &&
            responseData['message'] == 'otp verified successfully') {
          _isOtpVerified = true;
          print('OTP verification successful based on message');
        } else {
          _isOtpVerified = false;
          final message =
              responseData['message'] ?? 'Unexpected response format';
          print('OTP verification failed: $message');
        }
      } else {
        _isOtpVerified = false;
        print('Failed to verify OTP. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _isOtpVerified = false;
      print('Error during OTP verification: $e');
    }
    notifyListeners();
  }
  void logout() {
    _user = null;
    _isOtpVerified = false;
    _sessionId = null;
    _clearPreferences();
  }
  Future<void> _clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Logged out and preferences cleared');
    notifyListeners();
  }
}