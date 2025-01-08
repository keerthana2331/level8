// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:leveleight/auth_provider.dart';

import 'package:leveleight/first_screen.dart';
import 'package:leveleight/home_screen.dart';
import 'package:leveleight/login_screen.dart';
import 'package:leveleight/otpverification_screen.dart';
import 'package:leveleight/signup_screen.dart';
import 'package:leveleight/verfication_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(), 
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Flow',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: authProvider.isAuthenticated
          ? '/home'
          : '/', 
      routes: {
        '/': (context) =>
            ShoppingHomePage(), 
        '/signup': (context) => SignupScreen(), 
        '/login': (context) => LoginScreen(), 
        '/otp': (context) => OTPScreen(), 
        '/home': (context) => HomeScreen(),
        '/verify': (context) => VerificationPage(), 
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          final email =
              settings.arguments as String; 
          return MaterialPageRoute(
            builder: (context) => RegisterPage(email: email), 
          );
        }
      
        return null; 
      },
     
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              UnknownPage(), 
        );
      },
    );
  }
}


class RegisterPage extends StatelessWidget {
  final String email;
  RegisterPage({required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Text(
            "Registering with email: $email"), 
      ),
    );
  }
}


class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Not Found"),
      ),
      body: Center(
        child: Text("404 - Page not found!"),
      ),
    );
  }
}
