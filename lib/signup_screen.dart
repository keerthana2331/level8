// ignore_for_file: prefer_const_constructors, unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:leveleight/signup_api.dart';
import 'package:email_validator/email_validator.dart';
import 'sign_model.dart';

class SignupScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? validateFirstName(String? value) => value == null || value.isEmpty
      ? 'Please enter your first name'
      : value.length < 2
          ? 'Name must be at least 2 characters'
          : null;

  String? validateEmail(String? value) => value == null || value.isEmpty
      ? 'Please enter your email'
      : !EmailValidator.validate(value)
          ? 'Please enter a valid email'
          : null;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]')))
      return 'Password must contain at least one uppercase letter';
    if (!value.contains(RegExp(r'[0-9]')))
      return 'Password must contain at least one number';
    return null;
  }

  String? validatePhone(String? value) => value == null || value.isEmpty
      ? 'Please enter your phone number'
      : !RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)
          ? 'Please enter a valid phone number'
          : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E1F6D),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    buildInputForm(),
                    SizedBox(height: 24),
                    buildSignUpButton(context),
                    SizedBox(height: 12),
                    buildBackToHomeButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            style: TextStyle(color: Colors.white),
            decoration:
                buildInputDecoration('First Name', Icons.person_outline),
            validator: validateFirstName,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            style: TextStyle(color: Colors.white),
            decoration: buildInputDecoration('Email', Icons.email_outlined),
            validator: validateEmail,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            decoration: buildInputDecoration('Password', Icons.lock_outline),
            validator: validatePassword,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration:
                buildInputDecoration('Phone Number', Icons.phone_outlined),
            validator: validatePhone,
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF6448FE)),
      ),
      filled: true,
      fillColor: Color(0xFF363636),
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            String? responseMessage = await signupUser(User(
              fullname: firstNameController.text,
              email: emailController.text,
              password: passwordController.text,
              phone: phoneController.text,
            ));

            if (responseMessage == "Number already exists") {
              showErrorSnackBar(context,
                  "Phone number already exists. Please use a different number.");
            } else {
              showSuccessSnackBar(context, responseMessage!);
              Navigator.pushNamed(context, '/otp',
                  arguments: emailController.text);
            }
          } catch (e) {
            showErrorSnackBar(context, 'Signup failed: $e');
          }
        } else {
          showErrorSnackBar(context, 'Please correct the errors in the form.');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6448FE),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildBackToHomeButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      child: Text(
        'Back to Home',
        style: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
