import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'auth_provider.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  int _countdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_countdown == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOtp(BuildContext context, String email) {
    final otp = getOtp();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(otp);

    if (authProvider.isOtpVerified) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify OTP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            size: 80,
                            color: Color(0xFF1E3C72),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3C72),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Enter the OTP sent to',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3C72),
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              4,
                              (index) => SizedBox(
                                width: 55,
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF1E3C72)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF1E3C72), width: 2),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 3) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => _verifyOtp(context, email),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1E3C72),
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Verify & Proceed',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: _canResend
                                ? () {
                                    final authProvider =
                                        Provider.of<AuthProvider>(context, listen: false);
                                    authProvider.resendOtp(email);
                                    setState(() {
                                      _countdown = 30;
                                      _canResend = false;
                                    });
                                    startTimer();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('A new OTP has been sent to $email'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              _canResend
                                  ? 'Resend OTP'
                                  : 'Resend OTP in $_countdown seconds',
                              style: TextStyle(
                                color: _canResend ? Color(0xFF1E3C72) : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
