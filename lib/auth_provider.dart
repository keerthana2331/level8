import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _user;
  bool _isOtpVerified = false;

  String? get user => _user;
  bool get isOtpVerified => _isOtpVerified;

  get isLoggedIn => null;

  void signUp(String email, String password) {
    _user = email;
    notifyListeners();
  }

  void login(String email, String password) {
    _user = email;
    notifyListeners();
  }

  void verifyOtp(String otp) {
    if (otp == '123456') {
      _isOtpVerified = true;
      notifyListeners();
    }
  }

  void resendOtp(String email) {
    // Simulate resending OTP (e.g., calling an API endpoint)
    print('Resending OTP to $email');
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isOtpVerified = false;
    notifyListeners();
  }
}
