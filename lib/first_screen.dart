import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient with Circular Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6A11CB).withOpacity(0.9),
                  Color(0xFF2575FC).withOpacity(0.9),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 400,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo or Title
                    Text(
                      'ShoppingCart',
                      style: GoogleFonts.orbitron(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ).animate()
                      .fadeIn(duration: Duration(milliseconds: 800))
                      .slideY(begin: -0.5, end: 0),

                    SizedBox(height: 40),

                    // Signup Button
                    _buildGlassButton(
                      context,
                      text: 'Sign Up',
                      icon: IconlyBold.add_user,
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFFA726),
                      ],
                    ).animate()
                      .fadeIn(duration: Duration(milliseconds: 600))
                      .scaleXY(begin: 0.8, end: 1, duration: Duration(milliseconds: 400)),

                    SizedBox(height: 20),

                    // Login Button
                    _buildGlassButton(
                      context,
                      text: 'Log In',
                      icon: IconlyBold.login,
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF2196F3),
                      ],
                    ).animate()
                      .fadeIn(duration: Duration(milliseconds: 600), delay: Duration(milliseconds: 200))
                      .scaleXY(begin: 0.8, end: 1, duration: Duration(milliseconds: 400), delay: Duration(milliseconds: 200)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required List<Color> colors,
  }) {
    return Container(
      width: 300,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 15),
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}