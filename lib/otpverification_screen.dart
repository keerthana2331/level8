import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class OTPScreen extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to $email'),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.verifyOtp(_otpController.text);

                if (authProvider.isOtpVerified) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid OTP')),
                  );
                }
              },
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.resendOtp(email); // Calls the refresh token logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('A new OTP has been sent to $email')),
                );
              },
              style: ElevatedButton.styleFrom(iconColor: Colors.grey),
              child: Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
