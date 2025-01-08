// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:leveleight/sign_model.dart';
import 'package:leveleight/signup_api.dart';
import 'package:email_validator/email_validator.dart';

class SignupScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade800,
              Colors.blue.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 40),
                    buildFormFields(),
                    const SizedBox(height: 32),
                    buildSignupButton(context),
                    buildBackButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: 50,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please fill in the details below',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget buildFormFields() {
    return Column(
      children: [
        buildTextField(
          controller: firstNameController,
          labelText: 'Full Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        buildTextField(
          controller: emailController,
          labelText: 'Email Address',
          icon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        buildTextField(
          controller: passwordController,
          labelText: 'Password',
          icon: Icons.lock_outline,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!value.contains(RegExp(r'[A-Z]'))) {
              return 'Password must contain at least one uppercase letter';
            }
            if (!value.contains(RegExp(r'[0-9]'))) {
              return 'Password must contain at least one number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        buildTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (!RegExp(r'^\+?[\d\s-]{7,15}$').hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          errorStyle: const TextStyle(color: Colors.orange),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => handleSignup(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
      child: Text(
        'Back to Home',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 16,
        ),
      ),
    );
  }

  void handleSignup(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        String? responseMessage = await signupUser(User(
          fullname: firstNameController.text,
          email: emailController.text,
          password: passwordController.text,
          phone: phoneController.text,
        ));
        if (responseMessage == "Number already exists") {
          showSnackBar(
            context,
            "Phone number already exists. Please use a different number.",
            Colors.orange,
          );
        } else {
          showSnackBar(context, responseMessage!, Colors.green);
          Navigator.pushNamed(
            context,
            '/verify',
            arguments: emailController.text,
          );
        }
      } catch (e) {
        showSnackBar(context, 'Signup failed: $e', Colors.red);
      }
    } else {
      showSnackBar(
        context,
        'Please correct the errors in the form.',
        Colors.orange,
      );
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}